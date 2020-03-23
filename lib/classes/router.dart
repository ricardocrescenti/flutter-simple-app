import 'package:flutter/material.dart';

typedef RouteValidation = bool Function(BuildContext context);
typedef RouteBuilder = Widget Function(BuildContext context);

class Router {
  final String name;
  final List<RouteValidation> canPush;
  final List<RouteValidation> canPop;
  final RouteBuilder builder;

  Router(this.name, {
    this.canPush,
    this.canPop,
    @required this.builder
  });
}