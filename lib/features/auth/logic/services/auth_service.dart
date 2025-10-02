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

  //! Constants
  static final anonkey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN0cGZwc2Fzb3llZ3R5Y2dncGZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgwMjMzMDMsImV4cCI6MjA3MzU5OTMwM30.5-N1R5S7n7MmbxHGlVwi5murYKXa10sCByNOXV7IEYU";
  static final supabaseUrl = "https://ctpfpsasoyegtycggpfk.supabase.co";

  //! Getters
  Stream<AuthState> get onAuthStateChange => _supabase.auth.onAuthStateChange;
  Session? get currentSession => _supabase.auth.currentSession;
  User? get currentUser => _supabase.auth.currentUser;
  bool get isSignedIn => currentSession != null;
  GoogleSignInAccount? get currentGoogleUser => _currentGoogleUser;

  //! Methods
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

  Future<ResponseModel<String>> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );
      return ResponseModel.success(
        "Sign-up successful. Please verify your email.",
      );
    } on AuthException catch (e) {
      return ResponseModel.failure(401, e.message);
    } catch (e) {
      return ResponseModel.failure(
        500,
        "Can't sign up with email and password: $e",
      );
    }
  }

  Future<ResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse supabaseResponse = await _supabase.auth
          .signInWithPassword(email: email, password: password);
      if (supabaseResponse.user == null)
        return ResponseModel.failure(
          500,
          "Can't login with email and password",
        );
      return ResponseModel.success(supabaseResponse.user);
    } on AuthException catch (e) {
      return ResponseModel.failure(401, e.message);
    } catch (e) {
      return ResponseModel.failure(
        500,
        "Can't login with email and password: $e",
      );
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

  Future<ResponseModel<void>> signOut() async {
    try {
      // if (_currentGoogleUser != null) {
      //   await _googleSignIn.signOut();
      //   _currentGoogleUser = null;
      // }
      await _supabase.auth.signOut();
      return ResponseModel.success(null);
    } on AuthException catch (e) {
      return ResponseModel.failure(401, e.message);
    } catch (e) {
      return ResponseModel.failure(500, "Failed to sign out: $e");
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

  Future<void> resendEmailConfirmation(String email) async {
    try {
      await _supabase.auth.resend(type: OtpType.signup, email: email);
    } catch (e) {
      throw AuthException('Failed to resend email confirmation: $e');
    }
  }

  Future<ResponseModel> verifyAccount({
    required String email,
    required String token,
  }) async {
    throw UnimplementedError();
  }

  Future<ResponseModel> deleteAccount() async {
    throw UnimplementedError();
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

  //! Private Variables
  final SupabaseClient _supabase = Supabase.instance.client;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleSignInInitialized = false;
  GoogleSignInAccount? _currentGoogleUser;
}
