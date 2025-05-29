import 'event.dart';
import 'bus.dart';
import 'package:get/get.dart';

mixin EventSubscriberMixin on GetxController {
  final List<Worker> _subscriptions = [];

  /// 子类实现：返回事件订阅映射
  Map<String, EventHandler> registerEvents();

  /// 初始化订阅
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
}
