bool isValidEmail(String email) {
  final RegExp emailRegex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  return emailRegex.hasMatch(email);
}

bool isValidPassword(String password) {
  final RegExp passwordRegex = RegExp(r'^.{6,}$');
  return passwordRegex.hasMatch(password);
}
