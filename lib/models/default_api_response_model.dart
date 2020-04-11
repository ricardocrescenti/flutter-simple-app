import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DefaultApiResponseModel {
  dynamic data;
  List<DefaultErrorModel> errors;
  dynamic info;
  int status;

  operator [](String fieldName) => data[fieldName];

  DefaultApiResponseModel.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }

    this.data = json['data'];
    this.errors = DefaultErrorModel.fromJson(json['errors']);
    this.info = json['info'];
    this.status = json['status'];
  }

  DefaultApiResponseModel.fromError(DioError error) {
    if (error.response.data['errors'] is List) {
      this.errors = DefaultErrorModel.fromJson(error.response.data['errors']);
    } else {
      this.errors = [DefaultErrorModel(message: error.response.data['errors'])];
    }
  }
}

class DefaultErrorModel {
  final String code;
  final String message;

  DefaultErrorModel({this.code, @required this.message});
  
  static List<DefaultErrorModel> fromJson(List errors) {
    if (errors == null) {
      return [];
    }
    return errors.map<DefaultErrorModel>((item) => DefaultErrorModel.fromError(item)).toList();
  }

  static DefaultErrorModel fromError(Object error) {
    if (error is Map) {
      return DefaultErrorModel(
        code: (error['code'] ?? (error['extensions'] != null ? error['extensions']['code'] : null)),
        message: error['message']);
    } else {
      return DefaultErrorModel(
        message: error);
    }
  }
}