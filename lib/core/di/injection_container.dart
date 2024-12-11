import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/authentication/domain/repositories/auth_repository_impl.dart';
import '../../features/authentication/presentation/bloc/auth_bloc.dart';
import '../../features/authentication/services/auth_interceptor.dart';
import '../../features/authentication/services/auth_service.dart';
import '../../shared/network/dio_client.dart';
import '../../shared/network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Connectivity());

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Dio Client
  sl.registerLazySingleton(() => DioClient());

  // Auth Interceptor
  sl.registerFactory(
      () => AuthInterceptor(preferences: sl(), dio: sl<DioClient>().instance));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() =>
      AuthRepositoryImpl(dio: sl<DioClient>().instance, preferences: sl()));

  // Service
  sl.registerLazySingleton(() => AuthenticationService(authRepository: sl()));

  // BLoC
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
}
