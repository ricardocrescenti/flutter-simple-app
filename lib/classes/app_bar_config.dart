import 'package:flutter/material.dart';

class AppBarConfig {
  final bool automaticallyImplyLeading;
  final double elevation;
  final ShapeBorder shape;
  final Color backgroundColor;
  final Brightness brightness;
  final IconThemeData iconTheme;
  final IconThemeData actionsIconTheme;
  final TextTheme textTheme;
  final bool centerTitle;
  final double titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;

  AppBarConfig({
    this.automaticallyImplyLeading = true,
    this.elevation,
    this.shape,
    this.backgroundColor,
    this.brightness,
    this.iconTheme,
    this.actionsIconTheme,
    this.textTheme,
    this.centerTitle = true,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0
  });
}