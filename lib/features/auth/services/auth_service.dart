class AuthService {
  Stream<String?>? get uidStream => null;

  Future signup({
    required String email,
    required String password,
    required String username,
  }) async {}

  Future signInWithGoogle() async {}
}
