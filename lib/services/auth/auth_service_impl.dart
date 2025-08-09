import 'package:ayur_scoliosis_management/core/enums.dart';
import 'package:ayur_scoliosis_management/core/exceptions.dart'
    show EmailAlreadyRegistered, PasswordMustChanged;
import 'package:ayur_scoliosis_management/core/extensions/dio.dart';
import 'package:ayur_scoliosis_management/models/auth/practitioner_register_model.dart';
import 'package:ayur_scoliosis_management/services/auth/auth_service.dart';
import 'package:dio/dio.dart'
    show Dio, DioException, FormData, MultipartFile, Options;

import '../../core/utils/api.dart';

class AuthServiceImpl extends AuthService {
  AuthServiceImpl({required this.api, required this.client});
  final Api api;
  final Dio client;

  @override
  Future<void> signUpWithEmailAndPassword(
    PractitionerRegisterModel data,
  ) async {
    try {
      // Prepare multipart fields
      final formData = FormData.fromMap({
        // Add regular fields
        ...data.toJson(),

        // Attach profile image if available
        if (data.profileImage != null)
          'profileImage': await MultipartFile.fromFile(
            data.profileImage!.path,
            filename: data.profileImage!.path.split('/').last,
          ),

        // Attach clinic image if available
        if (data.clinicImage != null)
          'clinicImage': await MultipartFile.fromFile(
            data.clinicImage!.path,
            filename: data.clinicImage!.path.split('/').last,
          ),
      });

      final response = await client.post(
        api.signUpPractitioner,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200) {
        return;
      }

      if (response.statusCode == 409) {
        throw EmailAlreadyRegistered();
      }
    } on DioException catch (e) {
      throw e.processException();
    }
  }

  @override
  Future<String> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await client.post(
        api.signIn,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['code'] ==
            ApiResponseCode.passwordChangeRequired.code) {
          throw PasswordMustChanged(response.data['temp_access_token']);
        }
        return response.data['access_token'];
      } else {
        throw Exception('Failed to sign in');
      }
    } on DioException catch (e) {
      throw e.processException();
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final response = await client.get(api.authStatus);
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw e.processException();
    }
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<bool> setNewPassword(String newPassword) async {
    try {
      final response = await client.post(
        api.setPassword,
        data: {'password': newPassword},
      );

      if (response.statusCode == 201) {
        return true;
      }
    } on DioException catch (e) {
      throw e.processException();
    }
    return false;
  }
}
