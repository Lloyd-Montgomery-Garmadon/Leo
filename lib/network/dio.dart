import 'package:dio/dio.dart';
import 'config.dart';

class Network {
  /// 可用于访问原始 Dio 实例，如添加拦截器、修改配置等
  static Dio get instance => NetworkConfig.dio;

  /// GET 请求
  static Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return instance.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// POST 请求
  static Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Options? options,
  }) {
    return instance.post<T>(path, data: data, options: options);
  }

  /// PUT 请求
  static Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Options? options,
  }) {
    return instance.put<T>(path, data: data, options: options);
  }

  /// DELETE 请求
  static Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Options? options,
  }) {
    return instance.delete<T>(path, data: data, options: options);
  }
}
