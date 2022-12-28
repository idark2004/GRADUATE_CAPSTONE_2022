import 'package:apms_mobile/themes/colors.dart';
import 'package:flutter/material.dart';

Widget popupModel(String title, String context) {
  return const AlertDialog();
}

void errorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
      backgroundColor: red,
      content: Text(message)));
  // action: SnackBarAction(
  //     label: "Dismiss",
  //     textColor: white,
  //     onPressed: () {
  //       ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //     })));
}

void successfulSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
      backgroundColor: green,
      content: Text(message)));
  // action: SnackBarAction(
  //     label: "Dismiss",
  //     textColor: white,
  //     onPressed: () {
  //       ScaffoldMessenger.removeCurrentSnackBar();
  //     });
}

void errorSnackBarWithDismiss(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 5),
      backgroundColor: red,
      content: Text(message),
      action: SnackBarAction(
          label: "Dismiss",
          textColor: white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          })));
}
