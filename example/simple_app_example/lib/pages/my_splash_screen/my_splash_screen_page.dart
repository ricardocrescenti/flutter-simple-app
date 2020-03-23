import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_app/widgets/splash_screen/splash_screen.dart';

class MySplashScreenPage extends SplashScreenPage {
  // @override
  // Future<String> Function(BuildContext context) get load => super.load;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.yellow
      )
    );
  }
}