/// 事件模型
class Event {
  final String type;
  final dynamic data;

  Event(this.type, [this.data]);
}

typedef EventHandler = void Function(Event);
