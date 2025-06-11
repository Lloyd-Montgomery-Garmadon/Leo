import 'package:leo/core.dart';
import 'model.dart';

class UserListController extends BaseListLogic<UserModel> {
  @override
  Future<List<UserModel>> loadListData(int page, int pageSize) async {
    await Future.delayed(const Duration(seconds: 1)); // 模拟网络延迟
    // 模拟返回分页数据，每页10条
    // if (page > 3) return []; // 模拟只有3页数据
    Log.d('d$page');
    Log.i('i$page');
    Log.w('w$page');
    Log.e('e$page');
    Log.t('t$page');
    Log.wtf('wtf$page');
    return List.generate(
      10,
      (index) => UserModel(
        name: '用户 ${index + 1 + (page - 1) * 10}',
        age: 18 + (index % 10),
      ),
    );
  }

  @override
  Map<String, EventHandler> registerEvents() {
    return {};
  }
}
