import 'package:ayur_scoliosis_management/core/utils/api.dart';
import 'package:ayur_scoliosis_management/providers/dio/dio.dart';
import 'package:ayur_scoliosis_management/services/auth/auth_service.dart';
import 'package:ayur_scoliosis_management/services/auth/auth_service_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

@riverpod
AuthService authService(Ref ref) {
  return AuthServiceImpl(api: Api(), client: ref.watch(dioProvider));
}
