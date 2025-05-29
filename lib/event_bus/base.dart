import 'package:flutter/cupertino.dart';
import 'core.dart';

/// 事件控制器基类，继承自 GetxController，自动管理事件订阅
abstract class BaseEventLogic extends GetxController {
  final List<Worker> _subscriptions = [];

  @mustCallSuper
  @override
  onInit() {
    super.onInit();
    initEventSubscription();
  }

  /// 子类实现：事件映射 {事件名: 处理函数}
  Map<String, EventHandler> registerEvents();

  /// 初始化自动订阅
  void initEventSubscription() {
    final events = registerEvents();
    final bus = EventBus.to;
    events.forEach((eventType, handler) {
      final sub = bus.on(eventType, handler);
      if (sub != null) {
        _subscriptions.add(sub);
      }
    });
  }

  /// 取消订阅
  @override
  void onClose() {
    for (var sub in _subscriptions) {
      sub.dispose();
    }
    _subscriptions.clear();
    super.onClose();
  }

  /// 统一发事件接口
  void emitEvent(String eventType, [dynamic payload]) {
    EventBus.to.emit(Event(eventType, payload));
  }
}
