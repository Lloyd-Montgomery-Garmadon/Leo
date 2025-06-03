import 'package:flutter/material.dart';
import 'package:leo/core.dart';
import './pages/pages.dart';
Future main()async {
  Get.put(EventBus());


  // 注册业务控制器
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseGetMaterialApp(
      baseUrl: 'http://196.168.1.1',
      home: Scaffold(
        appBar: AppBar(title: Text('事件总线示例')),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Get.to(() => PageOne()),
                  child: Text('event'),
                ),
                TextButton(
                  onPressed: () => Get.to(() => PageTwo()),
                  child: Text('list'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
