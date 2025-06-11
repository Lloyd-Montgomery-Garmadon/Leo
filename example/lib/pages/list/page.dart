import 'package:flutter/material.dart';
import 'view.dart';
class ListTestPage extends StatelessWidget {
  const ListTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('用户列表')),
      body: UserListPage(),
    );
  }
}