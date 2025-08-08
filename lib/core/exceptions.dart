abstract class AppApiException implements Exception {
  final String message;
  AppApiException(this.message);

  @override
  String toString() {
    return message;
  }
}

class ApiException extends AppApiException {
  ApiException(super.message);
}

class EmailAlreadyRegistered extends AppApiException {
  EmailAlreadyRegistered() : super('A user with this email already exists.');
}
