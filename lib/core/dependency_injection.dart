import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:parlo/features/api_keys_manager/data/datasources/api_keys_datasource.dart';
import 'package:parlo/features/api_keys_manager/data/repositories/api_keys_repository.dart';
import 'package:parlo/features/auth/logic/services/auth_service.dart';
import 'package:parlo/features/api_keys_manager/logic/services/api_keys_service.dart';
import 'package:parlo/features/chat/data/datasources/offline_chat_room_datasource.dart';
import 'package:parlo/features/chat/data/datasources/online_chat_entries_datasource.dart';
import 'package:parlo/features/chat/data/datasources/online_chat_room_datasource.dart';
import 'package:parlo/features/chat/data/repositories/chat_entry_repository.dart';
import 'package:parlo/features/chat/data/repositories/chat_room_repository.dart';
import 'package:parlo/features/chat/logic/services/chat_room_service.dart';
import 'package:parlo/features/chat/logic/services/chat_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  //! Core
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  //! DataSources
  getIt.registerLazySingleton<ApiKeysLocalDataSource>(
    () => ApiKeysLocalDataSource(getIt<FlutterSecureStorage>()),
  );
  getIt.registerLazySingleton<OnlineChatEntriesDataSource>(
    () => OnlineChatEntriesDataSource(supabase: Supabase.instance),
  );
  getIt.registerLazySingleton<OnlineChatRoomDatasource>(
    () => OnlineChatRoomDatasource(),
  );
  getIt.registerLazySingleton<OfflineChatRoomDatasource>(
    () => OfflineChatRoomDatasource(),
  );

  //! Repositories
  getIt.registerLazySingleton<ApiKeysRepository>(
    () => ApiKeysRepository(getIt<ApiKeysLocalDataSource>()),
  );
  getIt.registerLazySingleton<ChatEntryRepository>(
    () => ChatEntryRepository(
      onlineDataSource: getIt<OnlineChatEntriesDataSource>(),
      supabase: Supabase.instance.client,
    ),
  );
  getIt.registerLazySingleton<ChatRoomRepository>(
    () => ChatRoomRepository(
      onlineDataSource: getIt<OnlineChatRoomDatasource>(),
      offlineDataSource: getIt<OfflineChatRoomDatasource>(),
      supabase: Supabase.instance.client,
    ),
  );

  //! Services
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<ApiKeysService>(
    () => ApiKeysService(getIt<ApiKeysRepository>()),
  );
  getIt.registerLazySingleton<ChatService>(
    () => ChatService(chatEntryRepository: getIt<ChatEntryRepository>()),
  );
  getIt.registerLazySingleton<ChatRoomService>(
    () => ChatRoomService(
      chatRoomRepository: getIt<ChatRoomRepository>(),
      supabase: Supabase.instance.client,
    ),
  );
}
