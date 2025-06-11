import 'package:flutter/material.dart';
import 'package:leo/core.dart';
import 'model.dart';
import 'logic.dart';
class UserListPage extends BaseListWidget<UserModel, UserListController> {
  UserListPage({super.key})
      : super(controllerBuilder: () => UserListController());

  @override
  Widget buildList(BuildContext context, List<UserModel> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final user = list[index];
        return ListTile(
          title: Text(user.name),
          subtitle: Text('年龄: ${user.age}'),
        );
      },
    );
  }
}
