import 'package:parlo/core/models/response_model.dart';

class AuthService {
  Stream<String?>? get uidStream => null;

  Future<ResponseModel<void>> signup({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // TODO: Implement Supabase sign up
      return const ResponseModel.success(null);
    } catch (e) {
      // TODO: Replace with proper error handling and codes
      return const ResponseModel.failure(500, 'Failed to sign up.');
    }
  }

  Future<ResponseModel<void>> login({
    required String email,
    required String password,
  }) async {
    try {
      // TODO: Implement Supabase login
      return const ResponseModel.success(null);
    } catch (e) {
      return const ResponseModel.failure(500, 'Failed to login.');
    }
  }

  Future<ResponseModel<void>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      // TODO: Implement Supabase password reset
      return const ResponseModel.success(null);
    } catch (e) {
      return const ResponseModel.failure(500, 'Failed to send reset email.');
    }
  }

  Future<ResponseModel<void>> signInWithGoogle() async {
    try {
      // TODO: Implement Supabase Google sign-in
      return const ResponseModel.success(null);
    } catch (e) {
      return const ResponseModel.failure(500, 'Failed to sign in with Google.');
    }
  }
}
