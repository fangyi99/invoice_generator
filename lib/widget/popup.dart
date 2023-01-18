import 'package:flutter/material.dart';

class Popup {
  //display when user tries to exit form without saving quotation/invoice
  static Future<bool?> exitDialog(context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Leave form?"),
        content: const Text("Changes you made so far will not be saved."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("CANCEL")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("YES"))
        ],
      )
  );

  //display upon creation/update/deletion
  static void createToastMsg(BuildContext context, String msg, Color? bgColor){
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: bgColor,
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void popAndReturnMsg(BuildContext context, String msg, Color? bgColor){
    Navigator.of(context).pop({"msg": msg, "bgColor": bgColor});
  }

  static void displayReturnedMsg(BuildContext context, String msg, Color? bgColor){
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Text(msg),
          backgroundColor: bgColor
      ));
  }
}