import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parlo/core/models/response_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;
  AuthService._internal();

  User? get user => _auth.currentUser;

  Stream<String?> get uidStream =>
      _auth.authStateChanges().asyncMap((user) async {
        if (user == null) return null;
        try {
          final idTokenResult = await user.getIdTokenResult(true);
          if (idTokenResult.token == null) return null;
          return user.uid;
        } catch (e) {
          await _auth.signOut();
          return null;
        }
      });

  Future<ResponseModel<UserCredential>> signup({
    required String email,
    required String password,
    required String username,
  }) async {
    if (_auth.currentUser != null) {
      return ResponseModel.failure(
        403,
        'Already logged in as @${_auth.currentUser?.email}',
      );
    }

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(username);

      return ResponseModel.success(userCredential);
    } on FirebaseAuthException catch (e) {
      return ResponseModel.failure(
        e.code.hashCode,
        _getFirebaseAuthErrorMessage(e.code),
      );
    } catch (e) {
      return ResponseModel.failure(
        500,
        'An unexpected error occurred. Please try again.',
      );
    }
  }

  Future<ResponseModel<UserCredential>> login({
    required String email,
    required String password,
  }) async {
    if (_auth.currentUser != null) {
      return ResponseModel.failure(
        403,
        'Already logged in as @${_auth.currentUser?.email}',
      );
    }

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return ResponseModel.success(userCredential);
    } on FirebaseAuthException catch (e) {
      return ResponseModel.failure(
        e.code.hashCode,
        _getFirebaseAuthErrorMessage(e.code),
      );
    } catch (e) {
      return ResponseModel.failure(
        500,
        'An unexpected error occurred. Please try again.',
      );
    }
  }

  Future<ResponseModel<UserCredential>> signInWithGoogle() async {
    if (_auth.currentUser != null) {
      return ResponseModel.failure(
        403,
        'Already logged in as @${_auth.currentUser?.email}',
      );
    }

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return ResponseModel.failure(400, 'Google sign in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Only use idToken for Auth Emulator compatibility
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return ResponseModel.success(userCredential);
    } on FirebaseAuthException catch (e) {
      return ResponseModel.failure(
        e.code.hashCode,
        _getFirebaseAuthErrorMessage(e.code),
      );
    } catch (e) {
      return ResponseModel.failure(
        500,
        'An unexpected error occurred during Google sign in.',
      );
    }
  }

  Future<ResponseModel<void>> signOut() async {
    if (_auth.currentUser == null) {
      return ResponseModel.failure(500, "No user is logged in");
    }

    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      return ResponseModel.success(null);
    } on FirebaseAuthException catch (e) {
      return ResponseModel.failure(
        e.code.hashCode,
        _getFirebaseAuthErrorMessage(e.code),
      );
    } catch (e) {
      return ResponseModel.failure(
        500,
        'Failed to sign out. Please try again.',
      );
    }
  }

  String _getFirebaseAuthErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered. Please use a different email or sign in.';
      case 'invalid-email':
        return 'The email address is invalid. Please enter a valid email.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled. Please contact support.';
      case 'weak-password':
        return 'The password is too weak. Please use a stronger password.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'user-not-found':
        return 'No account found with this email. Please sign up first.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid login credentials. Please try again.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email but different sign-in credentials.';
      case 'invalid-verification-code':
        return 'Invalid verification code. Please try again.';
      case 'invalid-verification-id':
        return 'Invalid verification ID. Please try again.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
