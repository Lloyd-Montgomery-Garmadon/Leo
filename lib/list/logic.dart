import 'package:easy_refresh/easy_refresh.dart';
import '../core.dart';

abstract class BaseListLogic<T> extends BaseStateLogic<List<T>> {
  /// 分页参数
  int page = 1;
  /// 每页数据量
  int pageSize = 10;
  /// 是否还有更多数据
  bool hasMore = true;

  /// EasyRefresh 控制器
  final EasyRefreshController refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  /// 加载第一页数据（刷新）
  @override
  Future<void> refresh() async {
    page = 1;
    hasMore = true;
    try {
      final list = await loadListData(page);
      if (list.isEmpty) {
        setEmpty();
        refreshController.finishRefresh(IndicatorResult.success);
        return;
      }
      data.value = list;
      setSuccess(list);
      refreshController.finishRefresh(IndicatorResult.success);
      refreshController.resetFooter();
      page++;
    } catch (e) {
      setError(e.toString());
      refreshController.finishRefresh(IndicatorResult.fail);
    }
  }

  /// 加载下一页数据（加载更多）
  Future<void> loadMore() async {
    if (!hasMore) return;
    try {
      final list = await loadListData(page);
      if (list.isEmpty || list.length < pageSize) {
        hasMore = false;
        refreshController.finishLoad(IndicatorResult.noMore);
        return;
      }
      final current = data.value ?? [];
      current.addAll(list);
      data.value = current;
      data.refresh();
      refreshController.finishLoad(IndicatorResult.success);
      page++;
    } catch (e) {
      refreshController.finishLoad(IndicatorResult.fail);
    }
  }

  /// 子类实现：加载指定页码数据
  Future<List<T>> loadListData(int page);

  /// 子类实现：加载第一页数据
  @override
  Future<void> loadData() => refresh();

  /// 释放资源
  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }
}
