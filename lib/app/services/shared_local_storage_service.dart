import 'package:shared_preferences/shared_preferences.dart';

import 'local_storage_interface.dart';

class SharedLocalStorageService implements ILocalStorage {
  @override
  Future<String?> get(String key) async {
    final shared = await SharedPreferences.getInstance();
    var result = shared.getString(key);
    return result;
  }

  @override
  Future put(String key, dynamic value) async {
    final shared = await SharedPreferences.getInstance();
    if (value is String) {
      shared.setString(key, value);
    }
    if (value is bool) {
      shared.setBool(key, value);
    }
    if (value is int) {
      shared.setInt(key, value);
    }
  }

  @override
  Future remove(String key) async {
    final shared = await SharedPreferences.getInstance();
    shared.remove(key);
  }
}
