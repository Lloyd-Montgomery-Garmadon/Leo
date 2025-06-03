import 'package:leo/core.dart';

class MyController extends BaseEventLogic {
  final message = '等待事件...'.obs;

  @override
  Map<String, EventHandler> registerEvents() {
    return {
      'say_hello': (event) {
        message.value = '收到 hello：${event.data}';
      },
      'say_goodbye': (event) {
        message.value = '收到 goodbye：${event.data}';
      },
    };
  }

  // 发送hello事件
  void sendHello() {
    // 发送say_hello事件，参数为'你好'
    emitEvent('say_hello', '你好');
  }

  void sendGoodbye() {
    emitEvent('say_goodbye', '再见');
  }
}