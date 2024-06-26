import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CacheService extends GetxService {
  static CacheService instance([String? tag]) => Get.find(tag: tag);
  static CacheService get to => instance();

  final String name;
  final String? path;
  final Map<String, dynamic>? initialData;
  late final GetStorage box;

  CacheService([this.name = 'GetStorage', this.path, this.initialData]);

  Future<CacheService> init() async {
    await GetStorage.init(name);
    box = GetStorage(name, path, initialData);
    return this;
  }

  @override
  void onClose() {
    box.save();
    super.onClose();
  }

  bool has(String key) {
    return box.hasData(key);
  }

  T? read<T>(String key) {
    return box.read<T>(key);
  }

  T readDef<T>(String key, T def) {
    return read<T>(key) ?? def;
  }

  Future<void> write<T>(String key, T value) async {
    return box.write(key, value);
  }

  Future<void> writeIfAbsent<T>(String key, T value) async {
    if (!has(key)) return write(key, value);
  }

  Future<void> remove(String key) async {
    return box.remove(key);
  }
}
