import 'package:flutter/material.dart';

enum DialogsAction { confirm, cancel }

class AlertDialogs {
  static Future<DialogsAction> confirmCancelDiaglog(
    BuildContext context,
    String title,
    String body,
  ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(title),
          content: Text(body, style: const TextStyle(fontSize: 14),),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(DialogsAction.cancel),
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: Color(0xFFC41A3B), fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(DialogsAction.confirm),
              child: const Text(
                'Confirm',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        );
      },
    );
    return (action != null) ? action : DialogsAction.cancel;
  }
}
