import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parlo/features/api_keys_manager/data/datasources/api_keys_datasource.dart';
import 'package:parlo/features/api_keys_manager/data/models/api_keys_model.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late ApiKeysLocalDataSource dataSource;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    dataSource = ApiKeysLocalDataSource(mockSecureStorage);
  });

  group('ApiKeysLocalDataSource', () {
    const tApiKeyModel = ApiKeyModel(
      id: '1',
      name: 'Test Key',
      key: 'test_key',
      isSelected: false,
    );
    final tApiKeysList = [tApiKeyModel];
    final tApiKeysJson = json.encode([tApiKeyModel.toJson()]);

    group('getAllApiKeys', () {
      test('should return an empty list when no keys are stored', () async {
        // Arrange
        when(() => mockSecureStorage.containsKey(key: any(named: 'key')))
            .thenAnswer((_) async => false);
        // Act
        final result = await dataSource.getAllApiKeys();
        // Assert
        expect(result, isEmpty);
      });

      test('should return list of ApiKeyModel when keys are stored', () async {
        // Arrange
        when(() => mockSecureStorage.containsKey(key: any(named: 'key')))
            .thenAnswer((_) async => true);
        when(() => mockSecureStorage.read(key: any(named: 'key')))
            .thenAnswer((_) async => tApiKeysJson);
        // Act
        final result = await dataSource.getAllApiKeys();
        // Assert
        expect(result.first.id, tApiKeysList.first.id);
      });
    });

    group('saveApiKeys', () {
      test('should call FlutterSecureStorage.write with the correct data', () async {
        // Arrange
        when(() => mockSecureStorage.write(key: any(named: 'key'), value: any(named: 'value')))
            .thenAnswer((_) async => {});
        // Act
        await dataSource.saveApiKeys(tApiKeysList);
        // Assert
        verify(() => mockSecureStorage.write(key: 'api_keys', value: tApiKeysJson)).called(1);
      });
    });
  });
}
