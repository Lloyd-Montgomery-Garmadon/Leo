import 'package:flutter/material.dart';
import 'package:leo/core.dart';
import 'logic.dart';
class EventTestPage extends StatelessWidget {
  EventTestPage({super.key});

  final MyController ctrl = Get.put(MyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('用户列表')),
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
    );
  }
}