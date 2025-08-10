import 'package:ayur_scoliosis_management/models/auth/app_user.dart';
import 'package:ayur_scoliosis_management/providers/auth/auth.dart';
import 'package:ayur_scoliosis_management/providers/profile/profile_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile.g.dart';

@riverpod
class Profile extends _$Profile {
  @override
  Future<AppUser> build() async {
    ref.watch(authProvider);
    final service = ref.watch(profileServiceProvider);
    final profile = await service.getProfile();
    return profile;
  }
}
