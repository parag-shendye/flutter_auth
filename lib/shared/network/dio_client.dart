import 'package:dio/dio.dart';
import 'package:flutter_auth/core/config/app_config.dart';

class DioClient {
  final Dio dio;

  DioClient({BaseOptions? options})
      : dio = Dio(options ??
            BaseOptions(
              baseUrl: AppConfig.apiBaseUrl,
              connectTimeout: const Duration(seconds: AppConfig.connectTimeout),
              receiveTimeout: const Duration(seconds: AppConfig.receiveTimeout),
            ));

  Dio get instance => dio;
}
