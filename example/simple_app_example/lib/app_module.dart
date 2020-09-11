import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';
import 'package:simple_app/simple_app.dart';
import 'package:simple_app_example/modules/user/user_module.dart';
import 'package:simple_app_example/pages/test_page/test_page.dart';

class AppModule extends Module {

  @override
  List<InjectService> get services => [
    /// relação dos serviços
  ];

  @override
  List<ModuleRoutePattern> get routes => [
    ModuleRoute('home', builder: (context) => UserModule()),
    ModuleRoute('one', builder: (context) => TestPage('Page 01')),
    ModuleRoute('two', builder: (context) => TestPage('Page 02')),
    ModuleRoute('three', builder: (context) => TestPage('Page 03')),
    ModuleRoute('four', builder: (context) => TestPage('Page 04')),
  ];

  @override
  Widget build(BuildContext context) {
    return StandardApp(
      title: (context) => 'Standard App',
      supportedLocales: [
        Locale('en')
      ],
      logo: FlutterLogo(size: 100,)
    );
  }
}