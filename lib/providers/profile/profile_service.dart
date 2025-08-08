import 'package:ayur_scoliosis_management/core/utils/api.dart';
import 'package:ayur_scoliosis_management/providers/dio/dio.dart';
import 'package:ayur_scoliosis_management/services/profile/profile_service.dart';
import 'package:ayur_scoliosis_management/services/profile/profile_service_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_service.g.dart';

@riverpod
ProfileService profileService(Ref ref) {
  return ProfileServiceImpl(api: Api(), client: ref.watch(dioProvider));
}
