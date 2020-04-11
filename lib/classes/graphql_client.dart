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

  Future<Response<T>> query<T>(String queryName, {String schemaName, Map<String, dynamic> args}) async {   
    return await _post(GraphQLJsonBuilder
      .query(queryName)
      .addArgs(args)
      .addFields(schemas[schemaName ?? queryName].graphQLFields()));
  }
  Future<Response<T>> mutation<T>(String mutationName, {@required String schemaName, Map<String, dynamic> args}) async {
    return await _post(GraphQLJsonBuilder
        .mutation(mutationName)
        .addArgs(args)
        .addFields(schemas[schemaName ?? mutationName].graphQLFields()));
  }

  Future<Response<T>> _post<T>(GraphQLJsonBuilder jsonBuilder) async {
    Map data = jsonBuilder.toJson();

    Response response = await apiService.dio.post('graphql', data: data);
    response.data.data = (response.data.data.length > 0 ? response.data.data[jsonBuilder.resolverName] : null);
    
    return response;
  }
}