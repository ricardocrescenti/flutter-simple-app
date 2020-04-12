import 'package:flutter/material.dart';

typedef CacheDataCallback = void Function(dynamic data);

class ApiCacheCallback {
  final String name;
  final CacheDataCallback onGetData;

  ApiCacheCallback({
    @required this.name,
    @required this.onGetData
  });
}