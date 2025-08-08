import 'package:ayur_scoliosis_management/core/enums.dart';
import 'package:ayur_scoliosis_management/models/auth/practitioner_register_model.dart';
import 'package:ayur_scoliosis_management/providers/auth/auth_service.dart';
import 'package:ayur_scoliosis_management/providers/dio/dio.dart';
import 'package:ayur_scoliosis_management/services/storage/secure_storage_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  Future<AuthStatus> build() async {
    ref.watch(dioProvider);
    final service = ref.watch(authServiceProvider);
    final isAuthenticated = await service.isAuthenticated();
    return isAuthenticated
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
  }

  Future<void> signIn(String email, String password) async {
    final service = ref.watch(authServiceProvider);
    final token = await service.signInWithEmailAndPassword(email, password);
    SecureStorageService.instance.write(SecureStorageService.tokenKey, token);
    ref.invalidate(dioProvider);
    Future.delayed(const Duration(seconds: 1), () {
      ref.invalidateSelf();
    });
  }

  Future<void> signUp(PractitionerRegisterModel data) async {
    state = const AsyncValue.data(AuthStatus.loading);
    final service = ref.watch(authServiceProvider);
    await service.signUpWithEmailAndPassword(data);
    state = AsyncValue.data(AuthStatus.pendingActivation);
  }

  Future<void> signOut() async {
    final service = ref.watch(authServiceProvider);
    await service.signOut();
    state = AsyncValue.data(AuthStatus.unauthenticated);
  }
}
