import 'package:flutter/material.dart';
import 'package:leo/core.dart';

class BaseGetMaterialApp extends StatelessWidget {
  final Widget home;
  final String? baseUrl;

  // 全局状态页面组件
  final Widget? loadingWidget;
  final Widget? emptyWidget;
  final Widget Function(BuildContext, String, VoidCallback)? errorBuilder;

  // GetMaterialApp 原始参数（按需添加更多）
  final Key? appKey;
  final GlobalKey<NavigatorState>? navigatorKey;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final Map<String, WidgetBuilder> routes;
  final String? initialRoute;
  final RouteFactory? onGenerateRoute;
  final List<NavigatorObserver> navigatorObservers;
  final Transition? defaultTransition;
  final List<GetPage>? getPages;
  final SmartManagement smartManagement;
  final Bindings? initialBinding;
  final Locale? locale;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode? themeMode;
  final bool debugShowCheckedModeBanner;

  BaseGetMaterialApp({
    super.key,
    required this.home,
    this.loadingWidget,
    this.emptyWidget,
    this.errorBuilder,
    this.baseUrl,

    // 透传的参数
    this.appKey,
    this.navigatorKey,
    this.scaffoldMessengerKey,
    this.routes = const {},
    this.initialRoute,
    this.onGenerateRoute,
    this.navigatorObservers = const [],
    this.defaultTransition,
    this.getPages,
    this.smartManagement = SmartManagement.full,
    this.initialBinding,
    this.locale,
    this.theme,
    this.darkTheme,
    this.themeMode,
    this.debugShowCheckedModeBanner = true,
  }) {
    // 初始化全局状态页面
    GlobalStateWidgets.init(
      loading: loadingWidget,
      empty: emptyWidget,
      error: errorBuilder,
    );
    NetworkConfig.init(baseUrl);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      key: appKey,
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: home,
      routes: routes,
      initialRoute: initialRoute,
      onGenerateRoute: onGenerateRoute,
      navigatorObservers: navigatorObservers,
      defaultTransition: defaultTransition,
      getPages: getPages,
      smartManagement: smartManagement,
      initialBinding: initialBinding,
      locale: locale,
      theme: theme,
      darkTheme: darkTheme,
      themeMode: themeMode ?? ThemeMode.system,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
    );
  }
}
