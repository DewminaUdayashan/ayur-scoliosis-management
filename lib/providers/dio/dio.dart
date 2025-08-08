import 'package:ayur_scoliosis_management/core/utils/api.dart';
import 'package:ayur_scoliosis_management/services/storage/secure_storage_service_impl.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/utils/logger.dart' show Log;

part 'dio.g.dart';

class TokenInterceptor extends QueuedInterceptor {
  TokenInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      options.baseUrl = Api.baseUrl;
      final token = await SecureStorageService.instance.read<String?>(
        SecureStorageService.tokenKey,
        (value) => value,
      );

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      Log.e('Error retrieving token: $e');
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Clear stored tokens on unauthorized error
      SecureStorageService.instance.delete(SecureStorageService.tokenKey);
    }
    super.onError(err, handler);
  }
}

@riverpod
Dio dio(Ref ref) {
  final dio = Dio();
  return dio..interceptors.add(TokenInterceptor());
}
