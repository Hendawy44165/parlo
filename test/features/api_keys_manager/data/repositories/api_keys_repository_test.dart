import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parlo/features/api_keys_manager/data/datasources/api_keys_datasource.dart';
import 'package:parlo/features/api_keys_manager/data/models/api_keys_model.dart';
import 'package:parlo/features/api_keys_manager/data/repositories/api_keys_repository.dart';
import 'package:parlo/features/api_keys_manager/logic/entities/api_keys_entity.dart';

class MockApiKeysLocalDataSource extends Mock
    implements ApiKeysLocalDataSource {}

void main() {
  late ApiKeysRepository repository;
  late MockApiKeysLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockApiKeysLocalDataSource();
    repository = ApiKeysRepository(mockDataSource);
  });

  group('ApiKeysRepository', () {
    const tApiKeyEntity = ApiKeyEntity(
      id: '1',
      name: 'Test Key',
      key: 'test_key',
    );
    const tApiKeyModel = ApiKeyModel(
      id: '1',
      name: 'Test Key',
      key: 'test_key',
      isSelected: false,
    );

    group('getAllApiKeys', () {
      test('should return a list of ApiKeyEntity', () async {
        // Arrange
        when(
          () => mockDataSource.getAllApiKeys(),
        ).thenAnswer((_) async => [tApiKeyModel]);
        // Act
        final result = await repository.getAllApiKeys();
        // Assert
        expect(result.first.id, tApiKeyEntity.id);
      });
    });

    group('addNewApiKey', () {
      test('should add a new api key', () async {
        // Arrange
        when(() => mockDataSource.getAllApiKeys()).thenAnswer((_) async => []);
        when(
          () => mockDataSource.saveApiKeys(any()),
        ).thenAnswer((_) async => {});
        // Act
        await repository.addNewApiKey(tApiKeyEntity);
        // Assert
        verify(() => mockDataSource.saveApiKeys(any())).called(1);
      });

      test(
        'should throw an exception when adding a duplicate api key',
        () async {
          // Arrange
          when(
            () => mockDataSource.getAllApiKeys(),
          ).thenAnswer((_) async => [tApiKeyModel]);
          // Act & Assert
          expect(() => repository.addNewApiKey(tApiKeyEntity), throwsException);
        },
      );
    });

    group('deleteApiKey', () {
      test('should delete an existing api key', () async {
        // Arrange
        when(
          () => mockDataSource.getAllApiKeys(),
        ).thenAnswer((_) async => [tApiKeyModel]);
        when(
          () => mockDataSource.saveApiKeys(any()),
        ).thenAnswer((_) async => {});
        // Act
        await repository.deleteApiKey('1');
        // Assert
        verify(() => mockDataSource.saveApiKeys(any())).called(1);
      });

      test(
        'should throw an exception when deleting a non-existent api key',
        () async {
          // Arrange
          when(
            () => mockDataSource.getAllApiKeys(),
          ).thenAnswer((_) async => []);
          // Act & Assert
          expect(() => repository.deleteApiKey('1'), throwsException);
        },
      );
    });
  });
}
