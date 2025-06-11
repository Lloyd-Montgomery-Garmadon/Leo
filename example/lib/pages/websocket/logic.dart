import 'package:leo/core.dart';
import 'package:leo/network/websocket/base.dart';

class WebSocketTestLogic extends BaseEventLogic with BaseWebSocketMixin {
  final RxString message = ''.obs;

  @override
  Map<String, EventHandler> registerEvents() {
    return {};
  }

  @override
  Map<String, Map<String, WsCallback>> registerSocketListeners() => {
    'chat': {'message': (data) => message.value = data.toString()},
    'system': {'update': (data) => Log.d('系统更新通知: $data')},
  };

  @override
  String get wsUrl => 'ws://192.168.31.163:7788';

  @override
  int get maxReconnectAttempts => 3;
}
