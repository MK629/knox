import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class WorkerBee {
  static const String hiveBoxName = 'preferences';

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  static Future<Box> openBox() async {
    return await Hive.openBox(hiveBoxName);
  }

  static Future<void> addOrUpdateItem(String key, Object item) async {
    final box = await openBox();
    await box.put(key, item);
  }

  static Future<dynamic> getItem(String key) async {
    final box = await openBox();
    return box.get(key);
  }

  static Future<void> deleteItem(String key) async {
    final box = await openBox();
    await box.delete(key);
  }

  static Future<Map<dynamic, dynamic>> getAllItems() async {
    final box = await openBox();
    return box.toMap();
  }

  static Future<void> clearBox() async {
    final box = await openBox();
    await box.clear();
  }
}
