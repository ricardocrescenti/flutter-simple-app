import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:simple_app/simple_app.dart';

abstract class AppServicePattern extends Service {
  LocalStorage _localStorage;
  LocalStorage get localStorage => _localStorage;

  AppServicePattern(Module module) : super(module);

  Future<bool> initializeCache({String fileName}) {
    _localStorage = new LocalStorage('cache_' + (fileName == null || fileName.isEmpty ? this.runtimeType.toString() : fileName) + '.json', null, {});
    return _localStorage.ready;
  }

  Future<void> processError(BuildContext context, Object error);
}