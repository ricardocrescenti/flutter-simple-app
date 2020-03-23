import 'package:dio/dio.dart';
import 'package:simple_app/simple_app.dart';

class GraphQLClient {
  final ApiServicePattern apiService;
  final String routePath;

  Future _futureLoadObjects;
  final Map<String, GraphQLObject> types = {};
  final Map<String, GraphQLObject> queries = {};
  final Map<String, GraphQLObject> mutations = {};

  GraphQLClient({
    this.apiService,
    this.routePath,
  }) {
    _futureLoadObjects = _loadObjects();
  }

  _loadObjects() async {

    /// object structure fields that will be returned for types, queries and mutations
    List<dynamic> typesFields = [
      'name', // object name that will be returned
      {'fields': [
        'name', // field name
        {'type': [
          'name' // type name
        ]}
      ]}
    ];
    List<dynamic> resolverFields = [
      {'fields': [
        'name', // name utilized to query this object
        {'type': [
          //'kind', // return type, (example: LIST)
          {'ofType': [
            //'kind', // 
            'name', // object name that will be returned
          ]}
        ]}
      ]}
    ];
    
    /// create query to request objects
    Map data = GraphQLJsonBuilder.query('__schema')
      .fields([
        {'types': typesFields},
        {'queryType': resolverFields},
        {'mutationType': resolverFields}
      ])
      .toJson();

    /// send request to graphQL
    Response<DefaultApiResponseModel> response = (await apiService.dio.post(routePath, data: data));

    /// load types
    response.data.data['__schema']['types'].forEach((json) {
      if ("Query,Mutation".contains(json['name']) || json['name'].startsWith('_') || json['fields'] == null) {
        return;
      }

      GraphQLObject graphQLObject = GraphQLObject.fromJson(this, json);
      types[graphQLObject.name] = graphQLObject;
    });

    /// load queries
    response.data.data['__schema']['queryType']['fields'].forEach((json) {
      queries[json['name']] = types[json['type']['ofType']['name']];
    });

    // load mutations
    response.data.data['__schema']['mutationType']['fields'].forEach((json) {
      mutations[json['name']] = types[json['type']['ofType']['name']];
    });
  }

  Future<Response<T>> query<T>(String queryName, {Map<String, dynamic> args, List<dynamic> fields}) async {
    if (_futureLoadObjects != null) {
      await _futureLoadObjects;
    }
    
    return await _post(GraphQLJsonBuilder.query(queryName), queries[queryName], args, fields);
  }
  Future<Response<T>> mutation<T>(String mutationName, {Map<String, dynamic> args, List<dynamic> fields}) async {
    if (_futureLoadObjects != null) {
      await _futureLoadObjects;
    }
    
    return await _post(GraphQLJsonBuilder.mutation(mutationName), mutations[mutationName], args, fields);
  }

  Future<Response<T>> _post<T>(GraphQLJsonBuilder graphQLBuilder, GraphQLObject graphQLObject, Map<String, dynamic> args, List<dynamic> fields) async {
    Map data = graphQLBuilder
      .args(args)
      .fields(fields ?? graphQLObject.graphQLFields())
      .toJson();

    return await apiService.dio.post('graphql', data: data);
  }
}