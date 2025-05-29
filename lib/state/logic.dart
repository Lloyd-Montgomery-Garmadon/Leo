import '../core.dart';

abstract class BaseStateLogic<T> extends BaseEventLogic {
  /// 当前页面状态
  final Rx<PageState> pageState = PageState.loading.obs;


  /// 页面数据（泛型）
  final Rxn<T> data = Rxn<T>();

  /// 错误信息
  final RxString errorMessage = ''.obs;

  /// 加载数据，子类必须实现
  Future<void> loadData();

  /// 设置状态：加载中
  void setLoading() {
    pageState.value = PageState.loading;
  }

  /// 设置状态：成功
  void setSuccess(T value) {
    data.value = value;
    pageState.value = PageState.success;
  }

  /// 设置状态：空数据
  void setEmpty() {
    pageState.value = PageState.empty;
  }

  /// 设置状态：错误
  void setError(String message) {
    errorMessage.value = message;
    pageState.value = PageState.error;
  }

  /// 初始化时加载数据
  @override
  void onInit() {
    super.onInit();
    loadDataSafely();
  }

  Future<void> loadDataSafely() async {
    try {
      setLoading();
      await loadData();
    } catch (e) {
      setError(e.toString());
    }
  }
}
