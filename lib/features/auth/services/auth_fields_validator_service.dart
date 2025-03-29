class AuthFieldsValidatorService {
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    final passwordRegex = RegExp(
      r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  static bool isValidUsername(String username) {
    final usernameRegex = RegExp(r'^(?=.{3,20}$)[a-zA-Z0-9._]+$');
    return usernameRegex.hasMatch(username);
  }
}
