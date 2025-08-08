import 'package:ayur_scoliosis_management/core/exceptions.dart'
    show ApiException, EmailAlreadyRegistered, AppApiException;
import 'package:dio/dio.dart';

extension DioExceptionExtension on DioException {
  String get errorMessage {
    if (response?.data is Map<String, dynamic>) {
      final data = response!.data as Map<String, dynamic>;
      final message = data['message'];
      if (message is String) {
        return message;
      }
      if (message is List) {
        return message.first as String;
      }
    }
    return 'An error occurred';
  }

  AppApiException processException() {
    if (response?.statusCode == 409) {
      return EmailAlreadyRegistered();
    }
    return ApiException(errorMessage);
  }
}
