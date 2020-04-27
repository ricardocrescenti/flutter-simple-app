import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simple_app/classes/app_bar_config.dart';
import 'package:simple_app/classes/inherited_app.dart';
import 'package:simple_app/classes/router_observer.dart';
import 'package:simple_app/simple_app.dart';
import 'package:simple_app/widgets/splash_screen/splash_screen.dart';

class StandardApp extends StatefulWidget {
  final String title;
  final Widget logo;
  final Locale locale;
  final Iterable<Locale> supportedLocales;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final ThemeData theme;
  final AppBarConfig Function(BuildContext context) appBarConfig;
  final SplashScreenPage Function() splash;
  final Future<String> Function(BuildContext context) load;
  final String defaultRoute;
  final List<RouterPattern> routes;

  static Route _mainRoute;
  static Route get mainRoute => _mainRoute;

  StandardApp({
    @required this.title,
    this.logo,
    this.locale,
    this.supportedLocales = const [
      Locale('en', 'US')
    ],
    this.localizationsDelegates = const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    this.theme,
    this.appBarConfig,
    this.splash,
    this.load,
    this.defaultRoute,
    @required this.routes
  });

  @override
  State<StatefulWidget> createState() => _StandardApp();

  static StandardApp of(BuildContext context) {
    InheritedApp inheritedApp = context.dependOnInheritedWidgetOfExactType<InheritedApp>();
    return (inheritedApp != null ? inheritedApp.app : null);
  }

  static navigateToMainRoute(BuildContext context, String mainRoute) {
    Navigator.popUntil(context, (route) => route.isFirst);
    if (mainRoute != StandardApp.mainRoute.settings.name) {
      Navigator.pushReplacementNamed(context, mainRoute);
    }
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
}

class _StandardApp extends State<StandardApp> {
  final Map<String, Router> _routes = {};

  @override
  void initState() {
    super.initState();

    _loadRoutes(widget.routes);
  }

  _loadRoutes(List<RouterPattern> routes, {String parentUrl = ''}) {
    routes.forEach((route) {
      if (route is RouterGroup) {
        _loadRoutes(route.routes, parentUrl: parentUrl + (parentUrl.length > 0 && route.name.length > 0 ? '/' : '') + route.name);
      } else {
        _routes[parentUrl + (parentUrl.length > 0 && route.name.length > 0 ? '/' : '') + route.name] = route;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InheritedApp(
      app: this.widget,
      child: MaterialApp(
        title: widget.title,
        locale: widget.locale,
        supportedLocales: widget.supportedLocales,
        localizationsDelegates: widget.localizationsDelegates,
        theme: widget.theme,
        home: (this.widget.splash != null 
          ? this.widget.splash()
          : SplashScreenPage()),
        onGenerateRoute: _onGenerateRoute,
        navigatorObservers: [RouterObserver(_onChangeMainRoute)],
      )
    );
  }

  _onChangeMainRoute(Route route, Route previousRoute) {
    StandardApp._mainRoute = route;
  }

  Route<dynamic> _onGenerateRoute(RouteSettings routeSettings) {
    Router router = _routes[routeSettings.name];   
    if (router == null) {
      //TODO: Implementar a rota inválida
      return null;
    }

    //TODO: Implementar o canPush e canPop
    return MaterialPageRoute(builder: router.builder, settings: routeSettings);
  }
}