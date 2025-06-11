import 'package:flutter/material.dart';
import 'package:leo/core.dart';
import './pages/pages.dart';

Future main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LeoMaterialApp(
      baseUrl: 'http://192.168.31.163',
      home: Scaffold(
        appBar: AppBar(title: Text('事件总线示例')),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Get.to(() => EventTestPage()),
                  child: Text('event'),
                ),
                TextButton(
                  onPressed: () => Get.to(() => WebSocketTestPage()),
                  child: Text('websocket'),
                ),
                TextButton(
                  onPressed: () => Get.to(() => ListTestPage()),
                  child: Text('list'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
