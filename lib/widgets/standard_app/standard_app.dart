import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info/package_info.dart';
import 'package:simple_app/classes/app_bar_config.dart';
import 'package:simple_app/classes/inherited_app.dart';
import 'package:simple_app/simple_app.dart';
import 'package:simple_app/widgets/splash_screen/splash_screen.dart';
import 'package:flutter/services.dart' show rootBundle;

Map<String, Map> _configs = {};
Future<Map<String, Map>> _futureLoadConfig;

class StandardApp extends StatefulWidget {
  final String Function(BuildContext context) title;
  final Widget logo;
  final Locale locale;
  /// [Locale('en', 'US')]
  final Iterable<Locale> supportedLocales;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final ThemeMode themeMode;
  final ThemeData theme;
  final ThemeData darkTheme;
  final AppBarConfig Function(BuildContext context) appBarConfig;
  final SplashScreenPage Function() splash;
  final Future<String> Function(BuildContext context) load;
  final String defaultRoute;
  /// lista os json files with configurations
  final List<String> configFiles;

  // static Route _mainRoute;
  // static Route get mainRoute => _mainRoute;

  static Future<PackageInfo> packageInfo = PackageInfo.fromPlatform();

  Future<Map<String, Map>> get configFilesLoaded {
    return _futureLoadConfig;
  }

  StandardApp({
    @required this.title,
    this.logo,
    this.locale,
    @required this.supportedLocales,
    this.localizationsDelegates,
    this.themeMode = ThemeMode.system,
    this.theme,
    this.darkTheme,
    this.appBarConfig,
    this.splash,
    this.load,
    this.defaultRoute,
    this.configFiles
  });

  @override
  State<StatefulWidget> createState() => _StandardApp();

  static StandardApp of(BuildContext context) {
    InheritedApp inheritedApp = context.dependOnInheritedWidgetOfExactType<InheritedApp>();
    return (inheritedApp != null ? inheritedApp.app : null);
  }

  // static navigateToMainRoute(BuildContext context, String mainRoute) {
  //   Navigator.of(context, rootNavigator: true).popUntil((route) {
  //     return route.isFirst;
  //   });
  //   if (mainRoute != StandardApp.mainRoute.settings.name) {
  //     Navigator.of(context, rootNavigator: true).pushReplacementNamed(mainRoute);
  //   }
  // }

  static Map config(String configName) {
    return _configs[configName];
  }

  static AppBar defaultAppBar(BuildContext context, {
    Widget leading,
    bool automaticallyImplyLeading = true,
    Widget title,
    List<Widget> actions,
    Widget flexibleSpace,
    PreferredSizeWidget bottom,
    double elevation,
    ShapeBorder shape,
    Color backgroundColor,
    Brightness brightness,
    IconThemeData iconTheme,
    IconThemeData actionsIconTheme,
    TextTheme textTheme,
    bool primary = true,
    bool centerTitle,
    double titleSpacing = NavigationToolbar.kMiddleSpacing,
    double toolbarOpacity = 1.0,
    double bottomOpacity = 1.0,
  }) {
    AppBarConfig appBarConfig = of(context).appBarConfig(context);
    return AppBar(
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading ?? appBarConfig?.automaticallyImplyLeading,
      title: title,
      actions: actions,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      elevation: elevation ?? appBarConfig?.elevation,
      shape: shape ?? appBarConfig?.shape,
      backgroundColor: backgroundColor ?? appBarConfig?.backgroundColor,
      brightness: brightness ?? appBarConfig?.brightness,
      iconTheme: iconTheme ?? appBarConfig?.iconTheme,
      actionsIconTheme: actionsIconTheme ?? appBarConfig?.actionsIconTheme,
      textTheme: textTheme ?? appBarConfig?.textTheme,
      primary: primary,
      centerTitle: centerTitle ?? appBarConfig?.centerTitle,
      titleSpacing: titleSpacing ?? appBarConfig?.titleSpacing,
      toolbarOpacity: toolbarOpacity ?? appBarConfig?.toolbarOpacity,
      bottomOpacity: bottomOpacity ?? appBarConfig?.bottomOpacity,
    );
  }

  static SliverAppBar defaultSliverAppBar(BuildContext context, {
    Widget leading,
    bool automaticallyImplyLeading = true,
    Widget title,
    List<Widget> actions,
    Widget flexibleSpace,
    PreferredSizeWidget bottom,
    double elevation,
    ShapeBorder shape,
    Color shadowColor,
    bool forceElevated = false,
    Color backgroundColor,
    Brightness brightness,
    IconThemeData iconTheme,
    IconThemeData actionsIconTheme,
    TextTheme textTheme,
    bool primary = true,
    bool centerTitle,
    bool excludeHeaderSemantics = false,
    double titleSpacing = NavigationToolbar.kMiddleSpacing,
    double collapsedHeight,
    double expandedHeight,
    bool floating = false,
    bool pinned = false,
    bool snap = false,
    bool stretch = false,
    double stretchTriggerOffset = 100.0,
    AsyncCallback onStretchTrigger,
    double toolbarHeight = kToolbarHeight,
    double leadingWidth,
  }) {
    AppBarConfig appBarConfig = of(context).appBarConfig(context);
    return SliverAppBar(
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading ?? appBarConfig?.automaticallyImplyLeading,
      title: title,
      actions: actions,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      elevation: elevation ?? appBarConfig?.elevation,
      shape: shape ?? appBarConfig?.shape,
      shadowColor: shadowColor,
      forceElevated: forceElevated,
      backgroundColor: backgroundColor ?? appBarConfig?.backgroundColor,
      brightness: brightness ?? appBarConfig?.brightness,
      iconTheme: iconTheme ?? appBarConfig?.iconTheme,
      actionsIconTheme: actionsIconTheme ?? appBarConfig?.actionsIconTheme,
      textTheme: textTheme ?? appBarConfig?.textTheme,
      primary: primary,
      centerTitle: centerTitle ?? appBarConfig?.centerTitle,
      excludeHeaderSemantics: excludeHeaderSemantics,
      titleSpacing: titleSpacing ?? appBarConfig?.titleSpacing,
      collapsedHeight: collapsedHeight,
      expandedHeight: expandedHeight,
      floating: floating,
      pinned: pinned,
      snap: snap,
      stretch: stretch,
      stretchTriggerOffset: stretchTriggerOffset,
      onStretchTrigger: onStretchTrigger,
      toolbarHeight: toolbarHeight,
      leadingWidth: leadingWidth
    );
  }
}

class _StandardApp extends State<StandardApp> {
  @override
  void initState() {
    super.initState();
    _futureLoadConfig = _loadConfigFiles(widget.configFiles);
  }

  @override
  Widget build(BuildContext context) {
    return InheritedApp(
      app: this.widget,
      child: MaterialApp(
        onGenerateTitle: widget.title,
        locale: widget.locale,
        supportedLocales: widget.supportedLocales,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ]..addAll(widget.localizationsDelegates ?? []),
        themeMode: widget.themeMode,
        theme: widget.theme,
        darkTheme: widget.darkTheme,
        home: (this.widget.splash != null 
          ? this.widget.splash()
          : SplashScreenPage()),
        onGenerateRoute: Module.onGenerateRoute,
        // navigatorObservers: [RouterObserver(
        //   onPush: (route, previousRoute) { if (previousRoute == null) _onChangeMainRoute(route); },
        //   onReplace: (newRoute, previousRoute) => _onChangeMainRoute(newRoute)
        // )],
      )
    );
  }

  // _onChangeMainRoute(Route route) {
  //   StandardApp._mainRoute = route;
  // }

  Future<Map<String, Map>> _loadConfigFiles(List<String> configFiles) async {
    for (String configFile in widget.configFiles ?? []) {
      
      String fileName = configFile.substring(0, configFile.lastIndexOf('.')).split('/').last;
      String fileText = await rootBundle.loadString(configFile);
      _configs[fileName] = jsonDecode(fileText);
      
    }
    return _configs;
  }
}