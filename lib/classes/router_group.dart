import 'package:flutter/material.dart';
import 'package:simple_app/simple_app.dart';

class RouterGroup extends RouterPattern {
  final List<RouterPattern> routes;

  RouterGroup(String name, {
    @required this.routes
  }) : super(name);
}