import 'dart:async';
import 'package:parlo/core/enums/codes_enum.dart';
import 'package:parlo/core/models/response_model.dart';
import 'package:parlo/core/services/error_handling_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //! Constants
  static final anonkey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN0cGZwc2Fzb3llZ3R5Y2dncGZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgwMjMzMDMsImV4cCI6MjA3MzU5OTMwM30.5-N1R5S7n7MmbxHGlVwi5murYKXa10sCByNOXV7IEYU";
  static final supabaseUrl = "https://ctpfpsasoyegtycggpfk.supabase.co";

  //! Getters
  Stream<AuthState> get onAuthStateChange => _supabase.auth.onAuthStateChange;
  Session? get currentSession => _supabase.auth.currentSession;
  User? get currentUser => _supabase.auth.currentUser;
  String? get currentUserId => _supabase.auth.currentUser?.id;
  bool get isSignedIn => currentSession != null;
  GoogleSignInAccount? get currentGoogleUser => _currentGoogleUser;

  //! Methods
  Future<ResponseModel<void>> signInWithGoogle() async {
    const webClientId = '954144225523-45b2ak2gqf27rc3gtrt3hsrlo65qcilh.apps.googleusercontent.com';

    try {
      await GoogleSignIn.instance.initialize(serverClientId: webClientId);
      final googleUser = await GoogleSignIn.instance.authenticate();

      final idToken = googleUser.authentication.idToken;
      if (idToken == null) {
        return ResponseModel.failure(
          Codes.googleIdTokenMissing,
          ErrorHandlingService.getMessage(Codes.googleIdTokenMissing),
        );
      }

      final authorization = await googleUser.authorizationClient.authorizeScopes(['email', 'profile']);
      final accessToken = authorization.accessToken;

      final response = await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      return ResponseModel.success(null);
    } on AuthException catch (e) {
      final code = ErrorHandlingService.getErrorCode(e.code!);
      return ResponseModel.failure(code, ErrorHandlingService.getMessage(code));
    } catch (e) {
      return ResponseModel.failure(Codes.googleSignInFailed, ErrorHandlingService.getMessage(Codes.googleSignInFailed));
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
      return ResponseModel.success("Sign-up successful. Please verify your email.");
    } on AuthException catch (e) {
      final code = ErrorHandlingService.getErrorCode(e.code!);
      return ResponseModel.failure(code, ErrorHandlingService.getMessage(code));
    } catch (e) {
      return ResponseModel.failure(Codes.unknown, ErrorHandlingService.getMessage(Codes.unknown));
    }
  }

  Future<ResponseModel> login({required String email, required String password}) async {
    try {
      final AuthResponse supabaseResponse = await _supabase.auth.signInWithPassword(email: email, password: password);
      if (supabaseResponse.user == null) {
        return ResponseModel.failure(Codes.userNotFound, ErrorHandlingService.getMessage(Codes.userNotFound));
      }
      return ResponseModel.success(supabaseResponse.user);
    } on AuthException catch (e) {
      final code = ErrorHandlingService.getErrorCode(e.code!);
      return ResponseModel.failure(code, ErrorHandlingService.getMessage(code));
    } catch (e) {
      return ResponseModel.failure(Codes.unknown, ErrorHandlingService.getMessage(Codes.unknown));
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
      final code = ErrorHandlingService.getErrorCode(e.code!);
      return ResponseModel.failure(code, ErrorHandlingService.getMessage(code));
    } catch (e) {
      return ResponseModel.failure(Codes.unknown, ErrorHandlingService.getMessage(Codes.unknown));
    }
  }

  Future<ResponseModel<String>> resetPassword(String email) async {
    try {
      final isEmailRegistered = await _isEmailRegistered(email);
      if (!isEmailRegistered) {
        return ResponseModel.failure(Codes.userNotFound, ErrorHandlingService.getMessage(Codes.userNotFound));
      }
      await _supabase.auth.resetPasswordForEmail(email);
      return ResponseModel.success("Reset password sent to $email");
    } on AuthException catch (e) {
      final code = ErrorHandlingService.getErrorCode(e.code!);
      return ResponseModel.failure(code, ErrorHandlingService.getMessage(code));
    } catch (e) {
      return ResponseModel.failure(Codes.unknown, ErrorHandlingService.getMessage(Codes.unknown));
    }
  }

  Future<ResponseModel> verifyOtpCode(String email, String otp) async {
    final supabase = Supabase.instance.client;

    try {
      final res = await supabase.auth.verifyOTP(type: OtpType.recovery, token: otp, email: email);
      if (res.session != null) {
        return ResponseModel.success(null);
      } else {
        return ResponseModel.failure(Codes.otpExpired, ErrorHandlingService.getMessage(Codes.otpExpired));
      }
    } on AuthException catch (e) {
      final code = ErrorHandlingService.getErrorCode(e.code!);
      return ResponseModel.failure(code, ErrorHandlingService.getMessage(code));
    } catch (e) {
      return ResponseModel.failure(Codes.unknown, ErrorHandlingService.getMessage(Codes.unknown));
    }
  }

  Future<ResponseModel> updatePassword(String newPassword) async {
    try {
      final UserResponse user = await _supabase.auth.updateUser(UserAttributes(password: newPassword));

      return ResponseModel.success(user);
    } on AuthException catch (e) {
      final code = ErrorHandlingService.getErrorCode(e.code!);
      return ResponseModel.failure(code, ErrorHandlingService.getMessage(code));
    } catch (e) {
      return ResponseModel.failure(Codes.unknown, ErrorHandlingService.getMessage(Codes.unknown));
    }
  }

  Future<ResponseModel> verifyAccount({required String email, required String token}) async {
    throw UnimplementedError();
  }

  Future<ResponseModel> deleteAccount() async {
    throw UnimplementedError();
  }

  Future<void> resendEmailConfirmation(String email) async {
    try {
      await _supabase.auth.resend(type: OtpType.signup, email: email);
    } catch (e) {
      throw AuthException('Failed to resend email confirmation: $e');
    }
  }

  Future<bool> _isEmailRegistered(String email) async {
    final response = await _supabase.from('users').select('email').eq('email', email).maybeSingle();

    return response == null ? false : true;
  }

  //! Private Variables
  final SupabaseClient _supabase = Supabase.instance.client;
  GoogleSignInAccount? _currentGoogleUser;

  //! Singleton
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();
}
