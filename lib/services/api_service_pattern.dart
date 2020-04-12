import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:simple_app/simple_app.dart';

abstract class ApiServicePattern extends Service {
  String get baseUrl;
  final Dio dio = Dio();

  LocalStorage _localStorage;
  LocalStorage get localStorage => _localStorage;

  GraphQLClient _graphQL;
  GraphQLClient get graphQL => _graphQL;

  ApiServicePattern(Module module) : super(module) {
    _initializeDio();
  }

  _initializeDio() {
    dio.options.baseUrl = baseUrl;
    dio.options.headers.putIfAbsent('Accept', () => 'application/json');
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: this.onRequest,
      onResponse: this.onResponse,
      onError: this.onError,
    ));
  }

  dynamic onRequest(RequestOptions request) async => request;
  dynamic onResponse(Response<dynamic> response) async {
    response.data = DefaultApiResponseModel.fromJson(response.data);
    if (response.data.errors.isNotEmpty) {
      throw response.data;
    }
    return response;
  }
  dynamic onError(DioError error) async {
    if (error.response != null) {
      error.response.data = DefaultApiResponseModel.fromError(error);
    }
    return error;
  }

  Future<bool> initializeCache({String fileName}) {
    _localStorage = new LocalStorage('cache_' + (fileName == null || fileName.isEmpty ? this.runtimeType.toString() : fileName) + '.json', null, {});
    return _localStorage.ready;
  }

  GraphQLClient initializeGraphQL({String routePath = 'graphql'}) {
    _graphQL = GraphQLClient(
      apiService: this,
      routePath: routePath);
    return graphQL;
  }

  processError(BuildContext context, Object error);

  @override
  void dispose() {
    dio.close(force: true);
    super.dispose();
  }
}