import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:simple_app/simple_app.dart';

class GraphQLClient {
  final ApiServicePattern apiService;
  final String routePath;

  final Map<String, GraphQLSchema> schemas = {};

  GraphQLClient({
    @required this.apiService,
    this.routePath,
  });

  GraphQLSchema addSchema(String name, List<Object> fields) {
    GraphQLSchema graphQLSchema = GraphQLSchema(this, name, fields: fields);
    schemas[name] = graphQLSchema;
    return graphQLSchema;
  }

  Future<T> query<T>(String queryName, {String schemaName, Map<String, dynamic> args, T Function(dynamic data) convertion, ApiCacheCallback cache}) async {
    Response response;

    if (convertion == null) {
      convertion = (data) => data;
    }

    Future<Response> futureResponse = _post(GraphQLJsonBuilder
      .query(queryName)
      .addArgs(args)
      .addFields(schemas[schemaName ?? queryName].graphQLFields()));

    if (cache != null) {
      assert(apiService.localStorage != null, 'You can be initialize cache');
      await apiService.localStorage.ready;

      dynamic localCache = apiService.localStorage.getItem(cache.name);
      if (localCache != null) {
        response = await apiService.onResponse(Response(
          data: localCache
        ));
      }

      futureResponse.then((response) {
        apiService.localStorage.setItem(cache.name, (response.data is DefaultApiResponseModel ? response.data.toJson() : response.data));
        if (localCache != null) {
          cache.onGetData(convertion(response.data));
        }
      });
    }

    if (response == null) {
      response = await futureResponse;
    }

    return convertion(response.data);
  }

  Future<T> mutation<T>(String mutationName, {@required String schemaName, Map<String, dynamic> args, T Function(dynamic data) convertion, String cacheName}) async {
    Response response = await _post(GraphQLJsonBuilder
      .mutation(mutationName)
      .addArgs(args)
      .addFields(schemas[schemaName ?? mutationName].graphQLFields()));

    if (cacheName != null && cacheName.isNotEmpty) {
      assert(apiService.localStorage != null, 'You can be initialize cache');
      await apiService.localStorage.ready;
      apiService.localStorage.setItem(cacheName, (response.data is DefaultApiResponseModel ? response.data.toJson() : response.data));
    }

    return (convertion == null ? response.data : convertion(response.data));
  }

  Future<Response<T>> _post<T>(GraphQLJsonBuilder jsonBuilder) async {
    Map data = jsonBuilder.toJson();

    Response response = await apiService.dio.post('graphql', data: data);
    response.data.data = (response.data.data.length > 0 ? response.data.data[jsonBuilder.resolverName] : null);
    
    return response;
  }
}