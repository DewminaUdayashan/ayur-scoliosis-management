import 'package:ayur_scoliosis_management/core/app_router.dart';
import 'package:ayur_scoliosis_management/core/enums.dart';
import 'package:ayur_scoliosis_management/core/exceptions.dart';
import 'package:ayur_scoliosis_management/models/auth/practitioner_register_model.dart';
import 'package:ayur_scoliosis_management/providers/auth/auth_service.dart';
import 'package:ayur_scoliosis_management/providers/dio/dio.dart';
import 'package:ayur_scoliosis_management/services/storage/secure_storage_service_impl.dart';
import 'package:go_router/go_router.dart';
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
    try {
      final service = ref.watch(authServiceProvider);
      final token = await service.signInWithEmailAndPassword(email, password);
      SecureStorageService.instance.write(SecureStorageService.tokenKey, token);
      SecureStorageService.setTempToken = null;
      ref.invalidate(dioProvider);
      Future.delayed(const Duration(seconds: 1), () {
        ref.invalidateSelf();
      });
    } catch (e) {
      if (e is PasswordMustChanged) {
        SecureStorageService.setTempToken = e.tempToken;
        ref.invalidate(dioProvider);
      }
      rethrow;
    }
  }

  Future<void> signUp(PractitionerRegisterModel data) async {
    state = const AsyncValue.data(AuthStatus.loading);
    final service = ref.watch(authServiceProvider);
    await service.signUpWithEmailAndPassword(data);
    SecureStorageService.setTempToken = null;
    state = AsyncValue.data(AuthStatus.pendingActivation);
  }

  Future<void> signOut() async {
    // final service = ref.watch(authServiceProvider);
    // await service.signOut();
    ref.invalidate(dioProvider);
    SecureStorageService.setTempToken = null;
    await SecureStorageService.instance.deleteAll();
    await SecureStorageService.instance.delete(SecureStorageService.tokenKey);

    navigatorKey.currentContext?.pushReplacement(AppRouter.login);
    state = AsyncValue.data(AuthStatus.unauthenticated);
    ref.invalidateSelf();
  }

  Future<void> setNewPassword(String newPassword) async {
    final service = ref.watch(authServiceProvider);
    final isSuccess = await service.setNewPassword(newPassword);
    if (isSuccess) {
      /// The user has to log in with the new password.
      /// The UI will handle the navigation.
      return;
    } else {
      throw Exception('Failed to set new password');
    }
  }
}
