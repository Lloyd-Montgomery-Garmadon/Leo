import 'package:dio/dio.dart';
import 'package:leo/core.dart';

class NetworkConfig {
  static late String _baseUrl;
  static late Dio? _dio;

  static Duration connectTimeout = const Duration(seconds: 10);
  static Duration receiveTimeout = const Duration(seconds: 10);
  static Duration sendTimeout = const Duration(seconds: 10);

  static String get baseUrl => _baseUrl;

  static Dio get dio {
    assert(_dio != null, 'NetworkConfig 未初始化，请先调用 NetworkConfig.init(baseUrl)');
    return _dio!;
  }

  static void init(String? url) {
    if (StrUtil.isNotEmpty(url)) {
      _baseUrl = url!;
      Log.d('NetworkConfig 初始化成功，baseUrl: $baseUrl');
      _dio = Dio(
        BaseOptions(
          baseUrl: NetworkConfig.baseUrl,
          connectTimeout: NetworkConfig.connectTimeout,
          receiveTimeout: NetworkConfig.receiveTimeout,
          headers: {'Content-Type': 'application/json'},
        ),
      );
    }
  }
}
