import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:parlo/core/models/response_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

// TODO: get google cloud (OAuth client ID, Secret ID)
class AuthService {
  //! Singleton
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  //! Private Variables
  final SupabaseClient _supabase = Supabase.instance.client;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleSignInInitialized = false;
  GoogleSignInAccount? _currentGoogleUser;
  final StreamController<AuthState> _authStateController =
      StreamController<AuthState>.broadcast();

  //! Constants
  static final anonkey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN0cGZwc2Fzb3llZ3R5Y2dncGZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgwMjMzMDMsImV4cCI6MjA3MzU5OTMwM30.5-N1R5S7n7MmbxHGlVwi5murYKXa10sCByNOXV7IEYU";
  static final supabaseUrl = "https://ctpfpsasoyegtycggpfk.supabase.co";

  //! Getters
  Stream<AuthState> get authStateChanges => _authStateController.stream;
  Stream<AuthState> get onAuthStateChange => _supabase.auth.onAuthStateChange;
  Session? get currentSession => _supabase.auth.currentSession;
  User? get currentUser => _supabase.auth.currentUser;
  bool get isSignedIn => currentSession != null;
  String? get accessToken => currentSession?.accessToken;
  String? get refreshToken => currentSession?.refreshToken;
  GoogleSignInAccount? get currentGoogleUser => _currentGoogleUser;
  bool get isSignedInWithGoogle => _currentGoogleUser != null;
  Map<String, dynamic>? get userMetadata => currentUser?.userMetadata;
  String? get userEmail => currentUser?.email;
  String? get userId => currentUser?.id;
  bool get isEmailConfirmed => currentUser?.emailConfirmedAt != null;

  //! Methods
  Future<void> initialize() async {
    await _initializeGoogleSignIn();

    // Listen to Supabase auth state changes and broadcast them
    _supabase.auth.onAuthStateChange.listen((data) {
      _authStateController.add(data);
    });
  }

  Future<AuthResponse> refreshSession() async {
    try {
      final response = await _supabase.auth.refreshSession();
      return response;
    } catch (e) {
      throw AuthException('Failed to refresh session: $e');
    }
  }

  Future<AuthResponse> signInWithGoogle() async {
    await _ensureGoogleSignInInitialized();

    try {
      // Check if platform supports Google Sign-In authentication
      if (!_googleSignIn.supportsAuthenticate()) {
        if (kIsWeb) {
          throw AuthException(
            'Web platform requires different sign-in flow. Use Google Sign-In button for web.',
          );
        } else {
          throw AuthException('Platform not supported for Google Sign-In');
        }
      }

      // Authenticate with Google and request email and profile scopes
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );

      _currentGoogleUser = googleUser;

      // Get Google authentication tokens
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw AuthException('Failed to get Google ID token');
      }

      // Sign in to Supabase using the Google ID token
      final AuthResponse response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      return response;
    } on GoogleSignInException catch (e) {
      _currentGoogleUser = null;
      throw AuthException(_googleSignInExceptionToMessage(e));
    } catch (e) {
      _currentGoogleUser = null;
      throw AuthException('Google sign-in failed: $e');
    }
  }

  Future<AuthResponse> signUpWithEmailAndPassword({
    required String email,
    required String password,
    Map<String, dynamic>? userData,
  }) async {
    try {
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: userData,
      );

      return response;
    } catch (e) {
      throw AuthException('Sign up failed: $e');
    }
  }

  Future<ResponseModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse supabaseResponse = await _supabase.auth
          .signInWithPassword(email: email, password: password);
      if (supabaseResponse.user == null)
        // TODO: improve status code and message see https://supabase.com/docs/guides/auth/debugging/error-codes#https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/429
        return ResponseModel.failure(
          500,
          "Can't login with email and password",
        );
      return ResponseModel.success(supabaseResponse.user);
    } catch (e) {
      return ResponseModel.failure(500, "Can't login with email and password");
    }
  }

  Future<UserResponse> addPasswordToAccount(String password) async {
    try {
      if (currentUser == null) {
        throw AuthException('No user is currently signed in');
      }

      final UserResponse response = await _supabase.auth.updateUser(
        UserAttributes(password: password),
      );

      return response;
    } catch (e) {
      throw AuthException('Failed to add password: $e');
    }
  }

  Future<void> signOut() async {
    try {
      // Sign out from Google if currently signed in with Google
      if (_currentGoogleUser != null) {
        await _googleSignIn.signOut();
        _currentGoogleUser = null;
      }

      // Sign out from Supabase
      await _supabase.auth.signOut();
    } catch (e) {
      throw AuthException('Sign out failed: $e');
    }
  }

  Future<ResponseModel<String>> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return ResponseModel.success("Reset password sent to $email");
    } catch (e) {
      return ResponseModel.failure(500, "Password reset failed: $e");
    }
  }

  Future<UserResponse> updatePassword(String newPassword) async {
    try {
      final UserResponse response = await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      return response;
    } catch (e) {
      throw AuthException('Password update failed: $e');
    }
  }

  Future<UserResponse> updateEmail(String newEmail) async {
    try {
      final UserResponse response = await _supabase.auth.updateUser(
        UserAttributes(email: newEmail),
      );

      return response;
    } catch (e) {
      throw AuthException('Email update failed: $e');
    }
  }

  Future<UserResponse> updateUserMetadata(Map<String, dynamic> data) async {
    try {
      final UserResponse response = await _supabase.auth.updateUser(
        UserAttributes(data: data),
      );

      return response;
    } catch (e) {
      throw AuthException('User metadata update failed: $e');
    }
  }

  Future<void> resendEmailConfirmation(String email) async {
    try {
      await _supabase.auth.resend(type: OtpType.signup, email: email);
    } catch (e) {
      throw AuthException('Failed to resend email confirmation: $e');
    }
  }

  Future<AuthResponse> verifyOTP({
    required String email,
    required String token,
    required OtpType type,
  }) async {
    try {
      final AuthResponse response = await _supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: type,
      );

      return response;
    } catch (e) {
      throw AuthException('OTP verification failed: $e');
    }
  }

  Future<void> signInWithOTP(String email) async {
    try {
      await _supabase.auth.signInWithOtp(email: email);
    } catch (e) {
      throw AuthException('OTP sign-in failed: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      if (currentUser == null) {
        throw AuthException('No user is currently signed in');
      }

      throw UnimplementedError(
        'Account deletion must be implemented on the backend using Supabase Admin API',
      );
    } catch (e) {
      throw AuthException('Account deletion failed: $e');
    }
  }

  Future<String?> getGoogleAccessTokenForScopes(List<String> scopes) async {
    await _ensureGoogleSignInInitialized();

    try {
      final authClient = _googleSignIn.authorizationClient;

      // Try to get existing authorization for the requested scopes
      var authorization = await authClient.authorizationForScopes(scopes);

      // If no existing authorization, request new authorization
      authorization ??= await authClient.authorizeScopes(scopes);

      return authorization.accessToken;
    } catch (e) {
      throw AuthException('Failed to get access token for scopes: $e');
    }
  }

  Future<bool> isEmailRegistered(String email) async {
    try {
      // Attempt to sign in with dummy password to check if email exists
      await _supabase.auth.signInWithPassword(
        email: email,
        password: 'dummy_password_to_check_email',
      );
      return true;
    } catch (e) {
      final errorMessage = e.toString().toLowerCase();
      // If error mentions invalid credentials, email exists but password is wrong
      if (errorMessage.contains('invalid') &&
          errorMessage.contains('credentials')) {
        return true;
      }
      // For other errors (like email not found), assume email doesn't exist
      return false;
    }
  }

  Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize();
      _isGoogleSignInInitialized = true;
    } catch (e) {
      throw AuthException('Failed to initialize Google Sign-In: $e');
    }
  }

  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isGoogleSignInInitialized) {
      await _initializeGoogleSignIn();
    }
  }

  String _googleSignInExceptionToMessage(GoogleSignInException exception) {
    switch (exception.code.name) {
      // TODO: make sure the case is right. i think it should be 'cancelled'
      case 'canceled':
        return 'Sign-in was cancelled. Please try again if you want to continue.';
      case 'interrupted':
        return 'Sign-in was interrupted. Please try again.';
      case 'clientConfigurationError':
        return 'There is a configuration issue with Google Sign-In. Please contact support.';
      case 'providerConfigurationError':
        return 'Google Sign-In is currently unavailable. Please try again later or contact support.';
      case 'uiUnavailable':
        return 'Google Sign-In is currently unavailable. Please try again later or contact support.';
      case 'userMismatch':
        return 'There was an issue with your account. Please sign out and try again.';
      case 'unknownError':
      default:
        return 'An unexpected error occurred during Google Sign-In. Please try again.';
    }
  }

  void dispose() {
    _authStateController.close();
  }
}
