// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

import '../../core/storage/local_storage.dart';

final class WebLocalStorage implements LocalStorage {
  const WebLocalStorage();

  @override
  String? read(String key) => html.window.localStorage[key];

  @override
  void write(String key, String value) {
    html.window.localStorage[key] = value;
  }

  @override
  void delete(String key) {
    html.window.localStorage.remove(key);
  }
}
