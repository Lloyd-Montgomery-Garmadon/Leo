import 'package:flutter/material.dart';
import 'package:leo/event_bus/core.dart';

void main() {
  Get.put(EventBus());
  // 注册业务控制器
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final MyController ctrl = Get.put(MyController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('事件总线示例')),
        body: Center(
          child: Obx(
                () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(ctrl.message.value, style: TextStyle(fontSize: 20)),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: ctrl.sendHello,
                  child: Text('发送 hello 事件'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: ctrl.sendGoodbye,
                  child: Text('发送 goodbye 事件'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
