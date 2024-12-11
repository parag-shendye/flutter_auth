// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/auth_credentials.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;
  final SharedPreferences preferences;

  AuthRepositoryImpl({required this.dio, required this.preferences});

  @override
  Future<String?> login(AuthCredentials credentials) async {
    try {
      final response =
          await dio.post('/login/access-token', data: credentials.toJson());

      if (response.statusCode == 200) {
        final token = response.data['access_token'];
        await preferences.setString('auth_token', token);
        return token;
      }

      return null;
    } on DioException catch (e) {
      print('Login failed: ${e.message}');
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await preferences.remove('auth_token');
  }

  @override
  Future<String?> getCurrentToken() async {
    return preferences.getString('auth_token');
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await getCurrentToken();
    return token != null;
  }
}
