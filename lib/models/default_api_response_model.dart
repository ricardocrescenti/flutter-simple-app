import 'dart:convert';

import 'package:dio/dio.dart';

class DefaultApiResponseModel {
  dynamic data;
  List<dynamic> errors;
  dynamic info;
  int status;

  operator [](String fieldName) => data[fieldName];

  DefaultApiResponseModel.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }

    this.data = json['data'];
    this.errors = json['errors'];
    this.info = json['info'];
    this.status = json['status'];
  }

  DefaultApiResponseModel.fromError(DioError error) {
    this.errors = [error];
  }
}