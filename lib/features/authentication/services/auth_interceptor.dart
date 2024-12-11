import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferences preferences;
  final Dio dio;

  AuthInterceptor({required this.preferences, required this.dio});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = preferences.getString('auth_token');

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final newToken = await _refreshToken();

        if (newToken != null) {
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        }
      } catch (e) {
        preferences.remove('auth_token');
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  Future<String?> _refreshToken() async {
    try {
      final response = await dio.post('/refresh-token');

      if (response.statusCode == 200) {
        final newToken = response.data['token'];
        await preferences.setString('auth_token', newToken);
        return newToken;
      }

      return null;
    } catch (e) {
      print('Token refresh failed: $e');
      return null;
    }
  }
}
