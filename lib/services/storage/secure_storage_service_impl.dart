import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'secure_storage_service.dart';

class SecureStorageService extends SecureStorageServiceBase {
  /// Singleton instance of [SecureStorageService].
  SecureStorageService._();

  final storage = const FlutterSecureStorage();

  static SecureStorageServiceBase get instance => SecureStorageService._();

  /// The key used to store the token in secure storage.
  static const tokenKey = '812f33e8-0ee2-11f0-94d3-325096b39f47';

  @override
  Future<void> delete(String key) => storage.delete(key: key);

  @override
  Future<void> deleteAll() async {
    // final all = await storage.readAll();
    // for (final key in all.keys) {
    //   if (key != SecureStorageService.deviceBoundDataKey) {
    //     await storage.delete(key: key);
    //   }
    // }
    await storage.deleteAll();
  }

  @override
  Future<T?> read<T>(String key, T? Function(String? value) parser) =>
      storage.read(key: key).then((value) => parser(value));

  @override
  Future<void> write(String key, String? value) async {
    return await storage.write(key: key, value: value);
  }
}
