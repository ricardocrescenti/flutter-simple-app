import 'package:localstorage/localstorage.dart';

abstract class SimpleLocalStorage {
  LocalStorage _localStorage;
  LocalStorage get localStorage => _localStorage;

  Future<bool> initializeCache({String fileName}) {
    _localStorage = new LocalStorage('cache_' + (fileName == null || fileName.isEmpty ? this.runtimeType.toString() : fileName) + '.json', null, {});
    return _localStorage.ready;
  }
}