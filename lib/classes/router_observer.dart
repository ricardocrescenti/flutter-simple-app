import 'package:flutter/material.dart';

class RouterObserver extends NavigatorObserver {
  Function(Route route, Route previousRoute) onChangeMainRoute;

  RouterObserver(this.onChangeMainRoute);

  @override
  void didPush(Route route, Route previousRoute) {
    if (previousRoute == null) {
      this.onChangeMainRoute(route, previousRoute);
    }
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    this.onChangeMainRoute(newRoute, oldRoute);
  }
}