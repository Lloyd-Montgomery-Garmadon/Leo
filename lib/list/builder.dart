import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import '../core.dart';

abstract class BaseListWidget<T, C extends BaseListLogic<T>>
    extends BaseStateWidget<List<T>, C> {
  /// EasyRefresh 控件的可选参数封装，具体含义如下：
  final EasyRefreshController? controller;

  /// 控制刷新和加载状态的控制器，管理刷新动画和状态。
  final Header? header;

  /// 自定义下拉刷新头部组件，比如 ClassicHeader、BezierCircleHeader 等。
  final Footer? footer;

  /// 自定义上拉加载尾部组件，比如 ClassicFooter、BezierCircleFooter 等。
  final Future<void> Function()? onRefresh;

  /// 下拉刷新触发时调用的异步回调函数。
  final Future<void> Function()? onLoad;

  /// 上拉加载触发时调用的异步回调函数。
  final SpringDescription? spring;

  /// 弹性动画参数，控制下拉或回弹动画的弹性效果。
  final FrictionFactor? frictionFactor;

  /// 摩擦系数，用于控制下拉时手势滑动的阻尼效果。
  final NotRefreshHeader? notRefreshHeader;

  /// 是否禁用刷新头部，当为 true 时，下拉不会触发刷新。
  final NotLoadFooter? notLoadFooter;

  /// 是否禁用加载尾部，当为 true 时，上拉不会触发加载。
  final bool simultaneously;

  /// 是否允许同时触发刷新和加载，默认 false 表示一次只能触发一个操作。
  final bool canRefreshAfterNoMore;

  /// 当没有更多数据时，是否还允许继续下拉刷新。
  final bool canLoadAfterNoMore;

  /// 当没有更多数据时，是否还允许继续上拉加载。
  final bool resetAfterRefresh;

  /// 刷新完成后是否重置加载状态，默认 true。
  final bool refreshOnStart;

  /// 页面启动时是否自动触发一次下拉刷新。
  final Header? refreshOnStartHeader;

  /// 页面启动时自动刷新时使用的头部组件，可以自定义。
  final double callRefreshOverOffset;

  /// 下拉多少像素后触发刷新回调，默认20。
  final double callLoadOverOffset;

  /// 上拉多少像素后触发加载回调，默认20。
  final StackFit fit;

  /// 控制 EasyRefresh 内部子组件的布局模式，默认 StackFit.loose。
  final Clip clipBehavior;

  /// 裁剪行为，决定内容是否被裁剪，默认 Clip.hardEdge。
  final ERScrollBehaviorBuilder? scrollBehaviorBuilder;

  /// 自定义滚动行为构建器，用于修改滚动效果。
  final ScrollController? scrollController;

  /// 滚动控制器，控制内部列表的滚动状态。
  final Axis? triggerAxis;

  /// 触发刷新的滑动轴，默认为垂直方向（Axis.vertical）。

  const BaseListWidget({
    super.key,
    required super.controllerBuilder,
    this.controller,
    this.header,
    this.footer,
    this.onRefresh,
    this.onLoad,
    this.spring,
    this.frictionFactor,
    this.notRefreshHeader,
    this.notLoadFooter,
    this.simultaneously = false,
    this.canRefreshAfterNoMore = false,
    this.canLoadAfterNoMore = false,
    this.resetAfterRefresh = true,
    this.refreshOnStart = false,
    this.refreshOnStartHeader,
    this.callRefreshOverOffset = 20,
    this.callLoadOverOffset = 20,
    this.fit = StackFit.loose,
    this.clipBehavior = Clip.hardEdge,
    this.scrollBehaviorBuilder,
    this.scrollController,
    this.triggerAxis,
  });

  /// 构建分页列表内容（子类实现）
  Widget buildList(BuildContext context, List<T> list);

  @override
  Widget buildState(BuildContext context, List<T> data) {
    final controller = Get.find<C>();
    return EasyRefresh(
      controller: controller.refreshController,
      header: header,
      footer: footer,
      onRefresh: onRefresh ?? controller.refresh,
      onLoad: onLoad ?? (controller.hasMore ? controller.loadMore : null),
      spring: spring,
      frictionFactor: frictionFactor,
      notRefreshHeader: notRefreshHeader,
      notLoadFooter: notLoadFooter,
      simultaneously: simultaneously,
      canRefreshAfterNoMore: canRefreshAfterNoMore,
      canLoadAfterNoMore: canLoadAfterNoMore,
      resetAfterRefresh: resetAfterRefresh,
      refreshOnStart: refreshOnStart,
      refreshOnStartHeader: refreshOnStartHeader,
      callRefreshOverOffset: callRefreshOverOffset,
      callLoadOverOffset: callLoadOverOffset,
      fit: fit,
      clipBehavior: clipBehavior,
      scrollBehaviorBuilder: scrollBehaviorBuilder,
      scrollController: scrollController,
      triggerAxis: triggerAxis,
      child: buildList(context, data),
    );
  }
}
