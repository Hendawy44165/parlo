import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:parlo/features/api_keys_manager/data/datasources/api_keys_datasource.dart';
import 'package:parlo/features/api_keys_manager/data/repositories/api_keys_repository.dart';
import 'package:parlo/features/auth/logic/services/auth_service.dart';
import 'package:parlo/features/api_keys_manager/logic/services/api_keys_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  //! Core
  getIt.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());

  //! DataSources
  getIt.registerLazySingleton<ApiKeysLocalDataSource>(
    () => ApiKeysLocalDataSource(getIt<FlutterSecureStorage>()),
  );

  //! Repositories
  getIt.registerLazySingleton<ApiKeysRepository>(
    () => ApiKeysRepository(getIt<ApiKeysLocalDataSource>()),
  );

  //! Services
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<ApiKeysService>(
    () => ApiKeysService(getIt<ApiKeysRepository>()),
  );
}
