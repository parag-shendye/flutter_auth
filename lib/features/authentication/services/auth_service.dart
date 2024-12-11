import '../data/models/auth_credentials.dart';
import '../domain/repositories/auth_repository.dart';

class AuthenticationService {
  final AuthRepository authRepository;

  AuthenticationService({required this.authRepository});

  Future<bool> login(String username, String password) async {
    final token = await authRepository
        .login(AuthCredentials(username: username, password: password));
    return token != null;
  }

  Future<void> logout() async {
    await authRepository.logout();
  }

  Future<bool> checkAuthStatus() async {
    return await authRepository.isAuthenticated();
  }
}
