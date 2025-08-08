import 'package:ayur_scoliosis_management/core/extensions/dio.dart';
import 'package:ayur_scoliosis_management/core/utils/api.dart';
import 'package:ayur_scoliosis_management/models/auth/app_user.dart';
import 'package:ayur_scoliosis_management/services/profile/profile_service.dart';
import 'package:dio/dio.dart';

class ProfileServiceImpl extends ProfileService {
  ProfileServiceImpl({required this.api, required this.client});
  final Api api;
  final Dio client;

  @override
  Future<AppUser> getProfile() async {
    try {
      final response = await client.get(api.profilePath);
      if (response.statusCode == 200) {
        return AppUser.fromJson(response.data);
      } else {
        throw Exception('Failed to load profile');
      }
    } on DioException catch (e) {
      throw e.processException();
    }
  }

  @override
  Future<void> updateProfile(AppUser profile) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }
}
