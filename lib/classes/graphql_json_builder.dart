import 'dart:convert';

class GraphQLJsonBuilder {
  final String type;
  final String resolverName;
  final Map<String, Object> _args = {};
  final List<dynamic> _fields = [];

  GraphQLJsonBuilder(this.type, this.resolverName);

  GraphQLJsonBuilder addArg(String name, dynamic value) {
    _args.putIfAbsent(name, () => value);
    return this;
  }
  GraphQLJsonBuilder addArgs(Map<String, dynamic> args) {
    args.forEach((key, value) => addArg(key, value));
    return this;
  }
  GraphQLJsonBuilder addFields(List<dynamic> fields) {
    _fields.addAll(fields);
    return this;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('query', () => this.toString());
    return map;
  }

  String _argsToString() {
    String args = _encodeMap(_args, '[]{}');
    return (args.length > 0 ? '($args)' : '');
  }
  String _fieldsToString() {
    String fields = _encodeList(_fields, '{}');
    // _fields.forEach((field) {
    //   fields += (fields.length > 0 ? ' ' : '') + '$field';
    // });
    
    return fields;
  }

  _encodeMap(Map map, String listSyntax, {bool separeKeyValue = true}) {
    String separatorKeyValue = (separeKeyValue ? ':' : '');
    String encodedMap = "";

    map.forEach((key, value) {
      dynamic encodedValue;
      if (value is List) {
        encodedValue = listSyntax[0] + _encodeList(value, listSyntax) + listSyntax[1];
      } else if (value is Map) {
        encodedValue = '{' + _encodeMap(value, listSyntax, separeKeyValue: separeKeyValue) + '}';
      } else if (value is DateTime) {
        encodedValue = json.encode(value.toIso8601String());
      } else if (value != null) {
        encodedValue = json.encode(value);
      }
      encodedMap += (encodedMap.length > 0 ? ', ' : '') + '$key$separatorKeyValue $encodedValue';
    });
    return encodedMap;
  }
  _encodeList(List list, String listSyntax) {
    String encodedMap = "";
    list.forEach((value) {
      dynamic encodedValue;
      if (value is List) {
        encodedValue = _encodeList(value, listSyntax);
      } else if (value is Map) {
        encodedValue = _encodeMap(value, listSyntax, separeKeyValue: (listSyntax.length > 2));
      } else if (value != null) {
        encodedValue = value;
      }

      if (listSyntax.length > 2) {
        encodedValue = listSyntax[2] + encodedValue + listSyntax[3];
      }
      encodedMap += (encodedMap.length > 0 ? ', ' : '') + '$encodedValue';
    });
    return encodedMap;
  }

  @override
  toString() {
    String args = _argsToString();
    String fields = _fieldsToString();

    return '''$type {$resolverName$args {$fields}}''';
  }

  static GraphQLJsonBuilder query(String resolverName) {
    return GraphQLJsonBuilder('query', resolverName);
  }
  static GraphQLJsonBuilder mutation(String resolverName) {
    return GraphQLJsonBuilder('mutation', resolverName);
  }
}