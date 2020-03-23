import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';
import 'package:simple_app/simple_app.dart';
import 'package:simple_app_example/modules/user/user_module.dart';
import 'package:simple_app_example/pages/test_page/test_page.dart';

class AppModule extends Module {

  @override
  List<Inject<Service>> get services => [
    /// relação dos serviços
  ];

  @override
  List<Inject<Module>> get modules => [
    /// relação dos módulos
  ];

  @override
  Widget build(BuildContext context) {
    return StandardApp(
      title: 'Standard App',
      logo: FlutterLogo(size: 100,),
      defaultRoute: 'home', 
      routes: [
        Router('home', builder: (context) => UserModule()),
        Router('one', builder: (context) => TestPage('Page 01')),
        Router('two', builder: (context) => TestPage('Page 02')),
        Router('three', builder: (context) => TestPage('Page 03')),
        Router('four', builder: (context) => TestPage('Page 04')),
      ]);
  }
}