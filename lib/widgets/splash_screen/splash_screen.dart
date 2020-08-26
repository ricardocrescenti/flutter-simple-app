import 'package:flutter/material.dart';
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

    if (this.logo != null) {
      childs.add(this.logo);
    } else if (standardApp.logo != null) {
      childs.add(standardApp.logo);
    }

    childs.add(Padding(
      padding: EdgeInsets.only(top: (childs.length > 0 ? 10 : 0)),
      child: (this.title != null 
        ? this.title
        : Text(standardApp.title(context), style: themeData.textTheme.bodyText1.copyWith(color: (Theme.of(context).brightness == Brightness.dark ? null : Theme.of(context).primaryTextTheme.headline6.color))))));

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