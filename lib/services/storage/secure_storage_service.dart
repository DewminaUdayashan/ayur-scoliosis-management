abstract class SecureStorageServiceBase {
  Future<T?> read<T>(String key, T? Function(String? value) parser);
  Future<void> write(String key, String? value);
  Future<void> delete(String key);
  Future<void> deleteAll();
}
