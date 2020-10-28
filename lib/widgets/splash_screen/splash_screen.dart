import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:simple_app/simple_app.dart';

class SplashScreenPage extends StatefulWidget {
  final int secondsAwait;
  final Widget logo;
  final Widget title;

  SplashScreenPage({
    this.secondsAwait = 3,
    this.logo,
    this.title
  });

  Widget build(BuildContext context) {
    StandardApp standardApp = StandardApp.of(context);
    ThemeData themeData = Theme.of(context);
    
    List<Widget> childs = [];

    if (this.logo != null || standardApp.logo != null) {
      childs.add(Expanded(
        child: this.logo ?? standardApp.logo));
    }

    childs.add(Padding(
      padding: EdgeInsets.symmetric(vertical: (childs.length > 0 ? 15 : 0)),
      child: (this.title != null 
        ? this.title
        : Text(standardApp.title(context), style: Theme.of(context).primaryTextTheme.subtitle2))));
    
    childs.add(Padding(
      padding: EdgeInsets.only(bottom: (childs.length > 0 ? 15 : 0)),
      child: FutureWidget<PackageInfo>(
        load: (context) => StandardApp.packageInfo, 
        awaitWidget: (context) => Container(),
        builder: (context, packageInfo) => Text(packageInfo.version))
      )
    );

    return Scaffold(
      backgroundColor: themeData.colorScheme.primary,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: childs,
        )
      ],),
    );
  }

  @override
  State<StatefulWidget> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  Future _futureLoad;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_futureLoad == null) {
      _futureLoad = _startLoad(context);
    }
  }

  _startLoad(BuildContext context) async {
    StandardApp standardApp = StandardApp.of(context);

    Future<String> futureLoad = (standardApp.load != null
      ? standardApp.load(context)
      : Future.value(standardApp.defaultRoute));
    Future<String> futureSeconds = Future.delayed(Duration(seconds: widget.secondsAwait), () => null);

    Future.wait<String>([futureLoad, futureSeconds]).then((routeName) => Navigator.pushReplacementNamed(context, routeName[0]));
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context);
  }
}