import 'package:flutter/material.dart';

class AlertService {
  static showAlert(String title, String msg, BuildContext context) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: Text(title),
                content: Text(msg),
                actions: <Widget>[
                  TextButton(
                      onPressed: () async {
                        Navigator.pop(context, 'OK');
                      },
                      child: const Text('OK')),
                ]));
  }
}
