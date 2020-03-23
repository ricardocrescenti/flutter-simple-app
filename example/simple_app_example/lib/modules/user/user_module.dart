import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';
import 'package:simple_app_example/pages/test_page/test_page.dart';

class UserModule extends Module {

  @override
  initialize(BuildContext context) async {
    await Future.delayed(Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return TestPage('Home');
  }
}