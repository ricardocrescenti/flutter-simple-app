import 'package:flutter/material.dart';
import 'package:simple_app/widgets/dialogs/await-dialog-widget.dart';
import 'package:simple_app/widgets/dialogs/default-dialog-widget.dart';

class Dialogs {
  static dialog(BuildContext context, Widget title, Widget widget) async  {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: title,
        content: widget,
      )
    );
  }

  static Future<T> showAwait<T>(BuildContext context, String message, Future<T> Function() function) async {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        function()
          .then((onValue) => Navigator.of(context).pop(onValue))
          .catchError((onError) => Navigator.of(context).pop(null));

        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: AwaitDialogWidget(message == null ? 'Aguarde' : message),
        );
      },
    );
  }

  static Future alert(BuildContext context, Widget title, Widget message) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: DefaultDialogWidget(
            title: title, 
            message: message)
        );
      },
    );
  }
  
  static Future error(BuildContext context, Widget title, Widget message) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: DefaultDialogWidget(
            title: title, 
            message: message)
        );
      },
    );
  }
}