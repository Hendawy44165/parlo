import 'package:get_it/get_it.dart';
import 'package:parlo/features/auth/logic/services/auth_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerLazySingleton<AuthService>(() => AuthService());
}
