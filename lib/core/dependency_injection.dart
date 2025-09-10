import 'package:get_it/get_it.dart';
import 'package:parlo/features/auth/services/auth_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerLazySingleton<AuthService>(() => AuthService());
}
