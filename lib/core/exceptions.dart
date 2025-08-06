abstract class AppApiExceptions implements Exception {
  final String message;
  AppApiExceptions(this.message);

  @override
  String toString() {
    return message;
  }
}

class ApiException extends AppApiExceptions {
  ApiException(super.message);
}

class EmailAlreadyRegistered extends AppApiExceptions {
  EmailAlreadyRegistered() : super('A user with this email already exists.');
}
