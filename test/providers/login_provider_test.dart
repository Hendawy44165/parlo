import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parlo/core/models/response_model.dart';
import 'package:parlo/features/auth/providers/login_provider.dart';
import 'package:parlo/features/auth/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late LoginNotifier loginNotifier;
  late MockAuthService mockAuthService;
  late MockUserCredential mockUserCredential;

  setUp(() {
    mockAuthService = MockAuthService();
    mockUserCredential = MockUserCredential();
    loginNotifier = LoginNotifier(service: mockAuthService);
  });

  tearDown(() {
    loginNotifier.emailController.dispose();
    loginNotifier.passwordController.dispose();
  });

  group('login', () {
    test('should return error when email format is invalid', () async {
      // Arrange
      loginNotifier.emailController.text = 'invalid-email';
      loginNotifier.passwordController.text = 'ValidPassword123!';

      // Act
      await loginNotifier.login();

      // Assert
      expect(loginNotifier.state, isA<AsyncError>());
      expect((loginNotifier.state as AsyncError).error, 'Invalid email format');
    });

    test('should return error when email is empty', () async {
      // Arrange
      loginNotifier.emailController.text = '';
      loginNotifier.passwordController.text = 'ValidPassword123!';

      // Act
      await loginNotifier.login();

      // Assert
      expect(loginNotifier.state, isA<AsyncError>());
      expect((loginNotifier.state as AsyncError).error, 'Invalid email format');
    });

    test('should return error when password is empty', () async {
      // Arrange
      loginNotifier.emailController.text = 'valid@email.com';
      loginNotifier.passwordController.text = '';

      // Act
      await loginNotifier.login();

      // Assert
      expect(loginNotifier.state, isA<AsyncError>());
      expect(
        (loginNotifier.state as AsyncError).error,
        'Invalid password format',
      );
    });

    test(
      'should return error when password is missing uppercase letter',
      () async {
        // Arrange
        loginNotifier.emailController.text = 'valid@email.com';
        loginNotifier.passwordController.text = 'password123!';

        // Act
        await loginNotifier.login();

        // Assert
        expect(loginNotifier.state, isA<AsyncError>());
        expect(
          (loginNotifier.state as AsyncError).error,
          'Invalid password format',
        );
      },
    );

    test(
      'should return error when password is missing lowercase letter',
      () async {
        // Arrange
        loginNotifier.emailController.text = 'valid@email.com';
        loginNotifier.passwordController.text = 'PASSWORD123!';

        // Act
        await loginNotifier.login();

        // Assert
        expect(loginNotifier.state, isA<AsyncError>());
        expect(
          (loginNotifier.state as AsyncError).error,
          'Invalid password format',
        );
      },
    );

    test('should return error when password is missing number', () async {
      // Arrange
      loginNotifier.emailController.text = 'valid@email.com';
      loginNotifier.passwordController.text = 'Password!';

      // Act
      await loginNotifier.login();

      // Assert
      expect(loginNotifier.state, isA<AsyncError>());
      expect(
        (loginNotifier.state as AsyncError).error,
        'Invalid password format',
      );
    });

    test('should return error when password is too short', () async {
      // Arrange
      loginNotifier.emailController.text = 'valid@email.com';
      loginNotifier.passwordController.text = 'Pass1!';

      // Act
      await loginNotifier.login();

      // Assert
      expect(loginNotifier.state, isA<AsyncError>());
      expect(
        (loginNotifier.state as AsyncError).error,
        'Invalid password format',
      );
    });

    test('should return success when credentials are valid', () async {
      // Arrange
      loginNotifier.emailController.text = 'valid@email.com';
      loginNotifier.passwordController.text = 'ValidPassword123!';

      when(
        () => mockAuthService.login(
          email: 'valid@email.com',
          password: 'ValidPassword123!',
        ),
      ).thenAnswer((_) async => ResponseModel.success(mockUserCredential));

      // Act
      await loginNotifier.login();

      // Assert
      expect(loginNotifier.state, isA<AsyncData>());
      expect(loginNotifier.state.value, equals(mockUserCredential));
    });

    test('should return error when auth service fails', () async {
      // Arrange
      loginNotifier.emailController.text = 'valid@email.com';
      loginNotifier.passwordController.text = 'ValidPassword123!';

      when(
        () => mockAuthService.login(
          email: 'valid@email.com',
          password: 'ValidPassword123!',
        ),
      ).thenAnswer((_) async => ResponseModel.failure(500, 'Network error'));

      // Act
      await loginNotifier.login();

      // Assert
      expect(loginNotifier.state, isA<AsyncError>());
      expect((loginNotifier.state as AsyncError).error, 'Network error');
    });

    test('should not proceed if already loading', () async {
      // Arrange
      loginNotifier.state = const AsyncLoading();
      loginNotifier.emailController.text = 'valid@email.com';
      loginNotifier.passwordController.text = 'ValidPassword123!';

      // Act
      await loginNotifier.login();

      // Assert
      expect(loginNotifier.state, isA<AsyncLoading>());
      verifyNever(
        () => mockAuthService.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    });
  });

  group('signinWithGoogle', () {
    test('should return success when Google sign-in succeeds', () async {
      // Arrange
      when(
        () => mockAuthService.signInWithGoogle(),
      ).thenAnswer((_) async => ResponseModel.success(mockUserCredential));

      // Act
      await loginNotifier.signinWithGoogle();

      // Assert
      expect(loginNotifier.state, isA<AsyncData>());
      expect(loginNotifier.state.value, equals(mockUserCredential));
    });

    test('should return error when Google sign-in fails', () async {
      // Arrange
      when(
        () => mockAuthService.signInWithGoogle(),
      ).thenAnswer((_) async => ResponseModel.failure(500, 'Network error'));

      // Act
      await loginNotifier.signinWithGoogle();

      // Assert
      expect(loginNotifier.state, isA<AsyncError>());
      expect((loginNotifier.state as AsyncError).error, 'Network error');
    });

    test('should not proceed if already loading', () async {
      // Arrange
      loginNotifier.state = const AsyncLoading();

      // Act
      await loginNotifier.signinWithGoogle();

      // Assert
      expect(loginNotifier.state, isA<AsyncLoading>());
      verifyNever(() => mockAuthService.signInWithGoogle());
    });
  });

  test(
    'getLoginProvider should create LoginNotifier with provided service',
    () {
      // Arrange
      final container = ProviderContainer();
      final provider = getLoginProvider(mockAuthService);

      // Act
      final notifier = container.read(provider.notifier);

      // Assert
      expect(notifier, isA<LoginNotifier>());
    },
  );
}
