import 'package:flutter/material.dart';
import 'package:leo/core.dart';

import 'logic.dart';

class WebSocketTestPage extends StatelessWidget {
  WebSocketTestPage({super.key});

  final WebSocketTestLogic logic = Get.put(WebSocketTestLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${logic.connectionStatus}'),
              Text('${logic.message}'),
            ],
          ),
        ),
      ),
    );
  }
}
