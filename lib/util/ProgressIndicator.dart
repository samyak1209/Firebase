import 'package:flutter/material.dart';

class ProgressHelper {
  static displayProgressDialog(BuildContext context) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (BuildContext context, _, __) {
          return new Container(
            child: Center(
              child: CircularProgressIndicator(

                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          );
        }));
  }

  static closeProgressDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}