import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simple_app/classes/inherited_app.dart';
import 'package:simple_app/simple_app.dart';
import 'package:simple_app/widgets/splash_screen/splash_screen.dart';

class StandardApp extends StatefulWidget {
  final String title;
  final Widget logo;
  final Locale locale;
  final Iterable<Locale> supportedLocales;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final ThemeData theme;
  final SplashScreenPage Function() splash;
  final Future<String> Function(BuildContext context) load;
  final String defaultRoute;
  final List<RouterPattern> routes;

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

  static pushRoute(BuildContext context, String route) {
    return Navigator.of(context).pushNamed(route);
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
        onGenerateRoute: _onGenerateRoute
      )
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings routeSettings) {
    Router router = _routes[routeSettings.name];   
    if (router == null) {
      //TODO: Implementar a rota inválida
      return null;
    }

    //TODO: Implementar o canPush e canPop
    return MaterialPageRoute(builder: router.builder);
  }
}