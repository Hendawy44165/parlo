import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parlo/core/di.dart';
import 'package:parlo/core/models/response_model.dart';
import 'package:parlo/core/themes/text.dart';
import 'package:parlo/features/auth/screens/login_screen.dart';
import 'package:parlo/features/auth/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

class MockUserCredential extends Mock implements UserCredential {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

// Mock Navigation
class FakeRoute extends Fake implements Route {}

void main() {
  late MockAuthService mockAuthService;
  late MockUserCredential mockUserCredential;
  late MockNavigatorObserver navigatorObserver;

  setUpAll(() {
    // Register Route for mocking navigation
    registerFallbackValue(FakeRoute());

    // Setup test dependencies
    mockAuthService = MockAuthService();
    mockUserCredential = MockUserCredential();
    navigatorObserver = MockNavigatorObserver();

    // Override production dependencies with test ones
    getIt.registerSingleton<AuthService>(mockAuthService);
  });

  tearDownAll(() {
    getIt.reset();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      child: MaterialApp(
        home: LoginScreen(),
        navigatorObservers: [navigatorObserver],
      ),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('should display all initial UI elements', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Verify logo is displayed
      expect(find.byType(Image), findsOneWidget);

      // Verify header text 'Login' with white32Regular style
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text && widget.style == TextStyleManger.white32Regular,
        ),
        findsOneWidget,
      );

      expect(
        find.text('Sign in to connect and share your voice!'),
        findsOneWidget,
      );

      // Verify input fields
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField && widget.decoration?.hintText == 'Email',
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField && widget.decoration?.hintText == 'Password',
        ),
        findsOneWidget,
      );

      // Verify buttons
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text && widget.style == TextStyleManger.white16Medium,
        ),
        findsOneWidget,
      );
      expect(find.text('Sign in with Google'), findsOneWidget);

      // Verify signup section
      expect(find.text('Don\'t have an Account? '), findsOneWidget);
      expect(find.text('Sign up here'), findsOneWidget);
    });

    testWidgets('should show loading indicator when logging in', (
      tester,
    ) async {
      // Arrange
      when(
        () => mockAuthService.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 1));
        return ResponseModel.success(mockUserCredential);
      });

      await tester.pumpWidget(createWidgetUnderTest());

      // Enter credentials
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, 'Password123!');

      // Tap login button
      await tester.tap(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text && widget.style == TextStyleManger.white16Medium,
        ),
      );
      await tester.pump();

      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete the animation
      await tester.pumpAndSettle();
    });

    testWidgets('should show error message on invalid email', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter invalid email and valid password
      await tester.enterText(find.byType(TextField).first, 'invalid-email');
      await tester.enterText(find.byType(TextField).last, 'ValidPassword123!');

      // Tap login button
      await tester.tap(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text && widget.style == TextStyleManger.white16Medium,
        ),
      );
      await tester.pump();

      // Verify error message
      expect(find.text('Invalid email format'), findsOneWidget);
    });

    testWidgets('should show error message on invalid password', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter valid email and invalid password
      await tester.enterText(find.byType(TextField).first, 'valid@email.com');
      await tester.enterText(find.byType(TextField).last, 'weak');

      // Tap login button
      await tester.tap(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text && widget.style == TextStyleManger.white16Medium,
        ),
      );
      await tester.pump();

      // Verify error message
      expect(find.text('Invalid password format'), findsOneWidget);
    });

    testWidgets('should navigate to voices screen on successful login', (
      tester,
    ) async {
      // Arrange
      when(
        () => mockAuthService.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => ResponseModel.success(mockUserCredential));

      await tester.pumpWidget(createWidgetUnderTest());

      // Enter valid credentials
      await tester.enterText(find.byType(TextField).first, 'valid@email.com');
      await tester.enterText(find.byType(TextField).last, 'ValidPassword123!');

      // Tap login button
      await tester.tap(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text && widget.style == TextStyleManger.white16Medium,
        ),
      );
      verify(
        () => mockAuthService.login(
          email: 'valid@email.com',
          password: any(named: 'password'),
        ),
      ).called(1);

      await tester.pumpAndSettle();

      // Verify navigation
      verify(() => navigatorObserver.didPush(any(), any()));
    });

    testWidgets('should handle Google sign-in flow', (tester) async {
      // Arrange
      when(
        () => mockAuthService.signInWithGoogle(),
      ).thenAnswer((_) async => ResponseModel.success(mockUserCredential));

      await tester.pumpWidget(createWidgetUnderTest());

      // Tap Google sign-in button
      await tester.tap(find.text('Sign in with Google'));
      await tester.pumpAndSettle();

      // Verify navigation
      verify(() => navigatorObserver.didPush(any(), any()));
    });

    testWidgets('should handle Google sign-in failures', (tester) async {
      // Arrange
      when(
        () => mockAuthService.signInWithGoogle(),
      ).thenAnswer((_) async => ResponseModel.failure(500, 'Network error'));

      await tester.pumpWidget(createWidgetUnderTest());

      // Tap Google sign-in button
      await tester.tap(find.text('Sign in with Google'));
      await tester.pumpAndSettle();

      // Verify error message
      expect(find.text('Network error'), findsOneWidget);
    });

    testWidgets('should navigate to signup screen when tapping sign up link', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Tap sign up link
      await tester.tap(find.text('Sign up here'));
      await tester.pumpAndSettle();

      // Verify navigation
      verify(() => navigatorObserver.didPush(any(), any()));
    });

    testWidgets('should show error message on login failure', (tester) async {
      // Arrange
      when(
        () => mockAuthService.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => ResponseModel.failure(401, 'Invalid credentials'),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      // Enter credentials
      await tester.enterText(find.byType(TextField).first, 'valid@email.com');
      await tester.enterText(find.byType(TextField).last, 'ValidPassword123!');

      // Tap login button
      await tester.tap(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text && widget.style == TextStyleManger.white16Medium,
        ),
      );
      await tester.pumpAndSettle();

      // Verify error message
      expect(find.text('Invalid credentials'), findsOneWidget);
    });
  });
}
