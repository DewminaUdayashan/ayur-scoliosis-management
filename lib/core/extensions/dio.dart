import 'package:ayur_scoliosis_management/core/exceptions.dart'
    show EmailAlreadyRegistered, ApiException;
import 'package:dio/dio.dart';

extension DioExceptionExtension on DioException {
  String get errorMessage {
    if (response?.data is Map<String, dynamic>) {
      final data = response!.data as Map<String, dynamic>;
      return data['message'] ?? 'An error occurred';
    }
    return 'An error occurred';
  }

  void throwProcessedException() {
    if (response?.statusCode == 409) {
      throw EmailAlreadyRegistered();
    }
    throw ApiException(errorMessage);
  }
}
