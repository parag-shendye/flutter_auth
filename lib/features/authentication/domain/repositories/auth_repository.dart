import '../../data/models/auth_credentials.dart';

abstract class AuthRepository {
  Future<String?> login(AuthCredentials credentials);
  Future<void> logout();
  Future<String?> getCurrentToken();
  Future<bool> isAuthenticated();
}
