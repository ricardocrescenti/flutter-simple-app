import 'package:dio/dio.dart';
import 'package:simple_app/simple_app.dart';

abstract class ApiServicePattern extends Service {
  String get baseUrl;
  final Dio dio = Dio();

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
  dynamic onResponse(Response<dynamic> response) async => response.data;
  dynamic onError(DioError error) async => error;

  initializeGraphQL({String routePath = 'graphql'}) {
    _graphQL = GraphQLClient(
      apiService: this,
      routePath: routePath);
  }

  @override
  void dispose() {
    dio.close(force: true);
    super.dispose();
  }
}