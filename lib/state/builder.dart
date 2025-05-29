import 'package:flutter/material.dart';
import 'package:leo/core.dart';
/// 状态管理
abstract class BaseStateWidget<T, C extends BaseStateLogic<T>>
    extends StatelessWidget {
  final C Function() controllerBuilder;

  const BaseStateWidget({super.key, required this.controllerBuilder});

  /// 构建成功页面
  Widget buildState(BuildContext context, T data);

  /// 可选：加载中页面
  Widget buildLoading(BuildContext context) =>
      const Center(child: CircularProgressIndicator());

  /// 可选：空页面
  Widget buildEmpty(BuildContext context) => const Center(child: Text('暂无数据'));

  /// 可选：错误页面
  Widget buildError(
    BuildContext context,
    String errorMessage,
    VoidCallback retry,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('出错了：$errorMessage'),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: retry, child: const Text('重试')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final C controller = Get.put<C>(controllerBuilder());
    return Obx(() {
      switch (controller.pageState.value) {
        case PageState.loading:
          return buildLoading(context);
        case PageState.empty:
          return buildEmpty(context);
        case PageState.error:
          return buildError(
            context,
            controller.errorMessage.value,
            controller.loadDataSafely,
          );
        case PageState.success:
          final data = controller.data.value as T;
          return buildState(context, data);
      }
    });
  }
}
