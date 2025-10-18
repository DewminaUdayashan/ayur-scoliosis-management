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

class PasswordMustChanged extends AppApiException {
  final String tempToken;
  PasswordMustChanged(this.tempToken)
    : super('Password must be changed before proceeding.');
}

class TimeSlotNotAvailable extends AppApiException {
  TimeSlotNotAvailable() : super('The selected time slot is not available.');
}
