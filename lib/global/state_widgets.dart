import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlobalStateWidgets {
  static Widget loadingWidget = Scaffold(
    body: Scaffold(
      body: const Center(child: CircularProgressIndicator()),
    ),
  );
  static Widget emptyWidget = Scaffold(
    body: Center(
      child: Text('暂无数据', style: TextStyle(fontSize: 18.h)),
    ),
  );

  static Widget Function(BuildContext, String, VoidCallback) errorBuilder =
      _defaultErrorBuilder;

  static Widget _defaultErrorBuilder(
    BuildContext context,
    String errorMessage,
    VoidCallback retry,
  ) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('出错了：$errorMessage', style: TextStyle(fontSize: 18.h)),
            SizedBox(height: 10.h),
            ElevatedButton(
              onPressed: retry,
              child: Text('重试', style: TextStyle(fontSize: 18.h)),
            ),
          ],
        ),
      ),
    );
  }

  static void init({
    Widget? loading,
    Widget? empty,
    Widget Function(BuildContext, String, VoidCallback)? error,
  }) {
    if (loading != null) loadingWidget = loading;
    if (empty != null) emptyWidget = empty;
    if (error != null) errorBuilder = error;
  }
}
