import 'package:ayur_scoliosis_management/models/auth/app_user.dart';

abstract class ProfileService {
  Future<AppUser> getProfile();
  Future<void> updateProfile(AppUser profile);
}
