extension ValidatorExtensions on String {
  /// Validates if the string is a valid email format.
  ///
  /// Returns `true` if the string matches the email pattern, otherwise `false`.
  bool get isValidEmail {
    final emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(emailPattern);
    return regex.hasMatch(this);
  }

  /// Validates if the string is a valid phone number format.
  ///
  /// Returns `true` if the string matches the phone number pattern, otherwise `false`.
  bool get isValidPhoneNumber {
    final phonePattern = r'^\+?[1-9]\d{1,14}$';
    final regex = RegExp(phonePattern);
    return regex.hasMatch(this);
  }

  /// Validates if the string is a strong password.
  ///
  /// A strong password is defined as at least 8 characters long, containing
  /// at least one uppercase letter, one lowercase letter, one digit, and one special character.
  bool get isStrongPassword {
    final passwordPattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    final regex = RegExp(passwordPattern);
    return regex.hasMatch(this);
  }
}
