import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parlo/features/api_keys_manager/data/repositories/api_keys_repository.dart';
import 'package:parlo/features/api_keys_manager/logic/entities/api_keys_entity.dart';
import 'package:parlo/features/api_keys_manager/logic/services/api_keys_service.dart';

class MockApiKeysRepository extends Mock implements ApiKeysRepository {}

class FakeApiKeyEntity extends Fake implements ApiKeyEntity {}

void main() {
  late ApiKeysService service;
  late MockApiKeysRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeApiKeyEntity());
  });

  setUp(() {
    mockRepository = MockApiKeysRepository();
    service = ApiKeysService(mockRepository);
  });

  group('ApiKeysService', () {
    const tApiKeyEntity = ApiKeyEntity(
      id: '1',
      name: 'Test Key',
      key: 'test_key',
    );

    group('getAllApiKeys', () {
      test('should return a list of ApiKeyEntity on success', () async {
        // Arrange
        when(
          () => mockRepository.getAllApiKeys(),
        ).thenAnswer((_) async => [tApiKeyEntity]);
        // Act
        final result = await service.getAllApiKeys();
        // Assert
        expect(result.data, [tApiKeyEntity]);
      });

      test('should return a failure response on error', () async {
        // Arrange
        when(() => mockRepository.getAllApiKeys()).thenThrow(Exception());
        // Act
        final result = await service.getAllApiKeys();
        // Assert
        expect(result.isFailure, true);
      });
    });

    group('addNewApiKey', () {
      test('should return a success response on success', () async {
        // Arrange
        when(
          () => mockRepository.addNewApiKey(any<ApiKeyEntity>()),
        ).thenAnswer((_) async => {});
        // Act
        final result = await service.addNewApiKey(tApiKeyEntity);
        // Assert
        expect(result.isFailure, false);
      });

      test('should return a failure response on error', () async {
        // Arrange
        when(
          () => mockRepository.addNewApiKey(any<ApiKeyEntity>()),
        ).thenThrow(Exception());
        // Act
        final result = await service.addNewApiKey(tApiKeyEntity);
        // Assert
        expect(result.isFailure, true);
      });
    });

    group('deleteApiKey', () {
      test('should return a success response on success', () async {
        // Arrange
        when(
          () => mockRepository.deleteApiKey(any<String>()),
        ).thenAnswer((_) async => {});
        // Act
        final result = await service.deleteApiKey('1');
        // Assert
        expect(result.isFailure, false);
      });

      test('should return a failure response on error', () async {
        // Arrange
        when(
          () => mockRepository.deleteApiKey(any<String>()),
        ).thenThrow(Exception());
        // Act
        final result = await service.deleteApiKey('1');
        // Assert
        expect(result.isFailure, true);
      });
    });
  });
}
