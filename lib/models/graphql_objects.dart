import 'package:flutter/material.dart';
import 'package:simple_app/simple_app.dart';

class GraphQLObject {
  final GraphQLClient graphQLClient;
  final String name;
  final List<GraphQLField> fields;

  GraphQLObject({
    @required this.graphQLClient,
    @required this.name,
    @required this.fields
  });

  static GraphQLObject fromJson(GraphQLClient graphQLClient, Map<String, dynamic> json) {
    return GraphQLObject(
      graphQLClient: graphQLClient,
      name: json['name'],
      fields: (json['fields'] as List<dynamic>).map<GraphQLField>((item) => GraphQLField.fromJson(item)).where((field) => field.type != null).toList());
  }

  List<dynamic> graphQLFields() {
    List<dynamic> fields = this.fields.map((field) {
      if (graphQLClient.types.containsKey(field.type)) {
        return { field.name: graphQLClient.types[field.type].graphQLFields() };
      } else {
        return field.name;
      }
    }).toList();
    return fields;
  }
}

class GraphQLField {
  final String name;
  final String type;

  GraphQLField({
    @required this.name,
    @required this.type
  });

  static GraphQLField fromJson(Map<String, dynamic> json) {
    return GraphQLField(
      name: json['name'],
      type: json['type']['name']);
  }
}