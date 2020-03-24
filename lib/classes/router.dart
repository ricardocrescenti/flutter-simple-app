import 'package:flutter/material.dart';
import 'package:simple_app/simple_app.dart';

typedef RouteValidation = bool Function(BuildContext context);
typedef RouteBuilder = Widget Function(BuildContext context);

class Router extends RouterPattern {
  final List<RouteValidation> canPush;
  final List<RouteValidation> canPop;
  final RouteBuilder builder;

  Router(String name, {
    this.canPush,
    this.canPop,
    @required this.builder
  }) : super(name);
}