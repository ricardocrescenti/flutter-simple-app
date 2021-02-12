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

  @override
  State<StatefulWidget> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  Future _futureLoad;
  Future<PackageInfo> packageInfo;
  
  @override
  void initState() {
    super.initState();
    packageInfo = StandardApp.packageInfo;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_futureLoad == null) {
      _futureLoad = _startLoad(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    StandardApp standardApp = StandardApp.of(context);
    ThemeData themeData = Theme.of(context);
    
    List<Widget> childs = [];

    if (widget.logo != null || standardApp.logo != null) {
      childs.add(Expanded(
        child: widget.logo ?? standardApp.logo));
    }

    childs.add(Padding(
      padding: EdgeInsets.only(top: (childs.length > 0 ? 15 : 0)),
      child: (widget.title != null 
        ? widget.title
        : Text(standardApp.title(context), style: Theme.of(context).primaryTextTheme.subtitle2))));
    
    childs.add(Padding(
      padding: EdgeInsets.only(top: 5, bottom: (childs.length > 0 ? 15 : 0)),
      child: FutureWidget<PackageInfo>(
        future: packageInfo, 
        awaitWidget: (context) => Container(),
        builder: (context, packageInfo) => Text(packageInfo.version, style: Theme.of(context).primaryTextTheme.caption.copyWith(color: Theme.of(context).primaryTextTheme.subtitle2.color), textScaleFactor: 0.7))
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

  _startLoad(BuildContext context) async {
    StandardApp standardApp = StandardApp.of(context);

    Future<String> futureLoad = (standardApp.load != null
      ? standardApp.load(context)
      : Future.value(standardApp.defaultRoute));
    Future<String> futureSeconds = Future.delayed(Duration(seconds: widget.secondsAwait), () => null);

    Future.wait<String>([futureLoad, futureSeconds]).then((routeName) => Navigator.pushReplacementNamed(context, routeName[0]));
  }
}