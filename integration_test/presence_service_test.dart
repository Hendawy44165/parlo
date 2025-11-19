import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parlo/features/auth/logic/services/auth_service.dart';
import 'package:parlo/features/chat/data/models/presence_data_model.dart';
import 'package:parlo/features/chat/logic/services/presence_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: AuthService.supabaseUrl, anonKey: AuthService.anonkey);

  await AuthService().login(email: 'test1@gmail.com', password: 'test_password_1');

  final service1 = PresenceService();
  final service2 = PresenceService();

  final channelName = '';

  group('test join & leave', () {
    test('test join', () {
      final streamResponse1 = service1.subscribe(channelName);

      expect(streamResponse1.isSuccess, true);
      expect(streamResponse1.data, isA<Stream<PresenceDataModel>>());
    });
  });
}
