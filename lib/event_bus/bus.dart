import '../log/log.dart';
import 'core.dart';

/// 事件总线，基于 GetxController 实现
class EventBus extends GetxController {
  static EventBus get to => Get.find<EventBus>();

  final Map<String, Rx<Event?>> _eventStreams = {};

  /// 发送事件
  void emit(Event event) {
    if (!_eventStreams.containsKey(event.type)) {
      _eventStreams[event.type] = Rx<Event?>(null);
    }
    Log.d('发出事件:\n事件名：{${event.type}},\n事件数据：{${event.data}}');
    _eventStreams[event.type]!.value = event;
  }

  /// 订阅事件，返回 Worker 用于取消订阅
  Worker? on(String eventType, EventHandler handler) {
    if (!_eventStreams.containsKey(eventType)) {
      _eventStreams[eventType] = Rx<Event?>(null);
    }
    return ever<Event?>(_eventStreams[eventType]!, (event) {
      if (event != null) handler(event);
    });
  }

  /// 取消订阅
  void off(Worker? worker) {
    worker?.dispose();
  }
}
