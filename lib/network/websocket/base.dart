import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import '../../core.dart';

typedef WsCallback = void Function(dynamic data);

mixin BaseWebSocketMixin on BaseEventLogic {
  // 子类必须实现，返回连接的WebSocket地址
  String get wsUrl;

  // 连接状态 RxString，初始为未连接
  final RxString connectionStatus = '未连接'.obs;

  // 心跳间隔和超时时间
  Duration heartbeatInterval = const Duration(seconds: 10);
  Duration heartbeatTimeout = const Duration(seconds: 5);
  int maxMissedPongs = 3; // 最大连续未收到pong次数

  Timer? _heartbeatTimer; // 定时发送ping的定时器
  Timer? _heartbeatTimeoutTimer; // ping发送后等待pong的超时定时器

  int get maxReconnectAttempts; // 最大重连次数，默认5次

  // 当前已尝试重连次数
  int _currentReconnectAttempts = 0;

  /// 待发送消息队列
  final List<dynamic> _sendQueue = [];

  IOWebSocketChannel? _channel;
  StreamSubscription? _subscription;
  bool _isConnected = false;

  // 子类必须返回注册表
  Map<String, Map<String, WsCallback>> registerSocketListeners();

  @override
  void onInit() {
    super.onInit();
    connect();
  }

  /// 连接成功后调用，发送队列中的消息
  void _flushSendQueue() {
    if (_sendQueue.isEmpty) return;

    Log.d('[WebSocket] 连接恢复，开始发送消息队列，消息数: ${_sendQueue.length}');
    for (var data in _sendQueue) {
      _sendInternal(data);
    }
    _sendQueue.clear();
  }

  /// 发送消息的内部实现，不检查连接状态，直接发送
  void _sendInternal(dynamic data) {
    try {
      if (data is String) {
        _channel?.sink.add(data);
      } else {
        _channel?.sink.add(jsonEncode(data));
      }
    } catch (e) {
      Log.d('[WebSocket] 发送消息失败: $e');
      // 如果发送失败，考虑重新加入队列？这里先不处理，避免死循环
    }
  }

  /// 二维回调表： eventType -> subType -> callback
  final Map<String, Map<String, WsCallback>> _listeners = {};

  bool get isConnected => _isConnected;

  /// 连接WebSocket
  Future<void> connect() async {
    if (_isConnected) {
      Log.d('[WebSocket] 已连接，跳过连接流程');
      return;
    }

    try {
      Log.d('[WebSocket] 尝试连接: $wsUrl');
      _channel = IOWebSocketChannel.connect(wsUrl);

      _subscription = _channel!.stream.listen(
        (message) {
          if (!_isConnected) {
            _isConnected = true;
            connectionStatus.value = '连接成功';
            Log.d('[WebSocket] 连接成功，开始注册监听回调');

            final registrations = registerSocketListeners();
            registrations.forEach((eventType, subMap) {
              subMap.forEach((subType, callback) {
                on(eventType, subType, callback);
                Log.d('[WebSocket] 注册监听: [$eventType][$subType]');
              });
            });

            _currentReconnectAttempts = 0; // 重置重连计数
            _flushSendQueue();

            _startHeartbeat(); // 开启心跳检测
          }

          _onMessage(message);
        },
        onError: _onError,
        onDone: _onDone,
        cancelOnError: true,
      );
    } catch (e) {
      Log.e('[WebSocket] 连接失败（同步捕获）: $e');
      connectionStatus.value = '连接失败';
      _isConnected = false;
      _onError(e);
      _tryReconnect();
    }
  }

  void _startHeartbeat() {
    _stopHeartbeat();

    _heartbeatTimer = Timer.periodic(heartbeatInterval, (_) {
      if (!_isConnected) return;

      Log.d('[WebSocket] 发送心跳 ping');
      send({
        'eventType': 'system',
        'subType': 'ping',
        'time': DateTime.now().toIso8601String(),
      });

      // 发送ping后启动超时计时器，5秒内未收到pong则断开重连
      _heartbeatTimeoutTimer?.cancel();
      _heartbeatTimeoutTimer = Timer(heartbeatTimeout, () {
        Log.d('[WebSocket] 5秒内未收到pong，断开重连');
        disconnect();
        _tryReconnect();
      });
    });
  }

  // 停止所有心跳相关定时器
  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimeoutTimer?.cancel();
  }

  /// 断开连接
  Future<void> disconnect() async {
    _stopHeartbeat();
    await _subscription?.cancel();
    await _channel?.sink.close();
    _isConnected = false;
  }

  /// 发送消息，自动转JSON字符串
  /// 发送消息，自动转JSON字符串
  void send(dynamic data) {
    if (!_isConnected || _channel == null) {
      Log.d('[WebSocket] 连接未就绪，消息入队列');
      _sendQueue.add(data);
      return;
    }
    _sendInternal(data);
  }

  /// 注册消息监听
  /// eventType 一级分类，如 "chat"
  /// subType  二级分类，如 "message"
  /// callback 具体回调
  void on(String eventType, String subType, WsCallback callback) {
    _listeners.putIfAbsent(eventType, () => {});
    _listeners[eventType]![subType] = callback;
  }

  /// 注销消息监听
  void off(String eventType, String subType) {
    _listeners[eventType]?.remove(subType);
    if (_listeners[eventType]?.isEmpty ?? false) {
      _listeners.remove(eventType);
    }
  }

  /// 内部处理收到的消息 收到pong后重置计数
  void _onMessage(dynamic message) {
    dynamic data;
    try {
      data = jsonDecode(message);
    } catch (_) {
      data = message;
    }

    if (data is Map<String, dynamic>) {
      final String? eventType = data['eventType'] as String?;
      final String? subType = data['subType'] as String?;

      if (eventType == 'system' && subType == 'pong') {
        _heartbeatTimeoutTimer?.cancel();
        Log.d('[WebSocket] 收到心跳 pong，取消超时计时器');
        return;
      }

      // 其他消息处理...
      final callback = _listeners[eventType]?[subType];
      if (callback != null) {
        callback(data);
        return;
      }
    }

    onUnhandledMessage(data);
  }

  /// 未处理的消息，子类可重写
  void onUnhandledMessage(dynamic data) {
    Log.d('未处理消息: $data');
  }

  /// 错误回调，子类可重写
  void _onError(Object error) {
    connectionStatus.value = '连接错误，正在重连';
    Log.e('[WebSocket] 连接错误: $error');
    _isConnected = false;
    _stopHeartbeat();
    _tryReconnect();
  }

  /// 关闭回调，子类可重写
  void _onDone() {
    Log.d('WebSocket连接关闭');
    _isConnected = false;
    _stopHeartbeat();
    _tryReconnect();
  }

  /// 简单重连机制，5秒后尝试重新连接
  void _tryReconnect() {
    if (_currentReconnectAttempts >= maxReconnectAttempts) {
      connectionStatus.value = '重连失败，停止重连';
      Log.d('[WebSocket] 重连次数达到最大值 ($_currentReconnectAttempts)，停止重连');
      return;
    }

    _currentReconnectAttempts++;
    connectionStatus.value = '第$_currentReconnectAttempts 次重连，等待中';
    // 延迟时间 = min(初始值 * 2^次数, 最大值)
    final delay = Duration(
      seconds: (1 << (_currentReconnectAttempts - 1)).clamp(1, 30),
    );
    Log.d('[WebSocket] 第$_currentReconnectAttempts 次重连，${delay.inSeconds}秒后尝试');

    Future.delayed(delay, () {
      if (!_isConnected) {
        connect();
      }
    });
  }
}
