import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

int? personId, tripId, expenseId;

Future<DateTime?> selectDateGlobal(BuildContext context, DateTime? selectedDate,
    DateTime firstDate, DateTime lastDate) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    firstDate: firstDate,
    lastDate: lastDate,
    initialDate: selectedDate ?? firstDate,
  );
  if (picked != null) {
    return picked;
  } else {
    return selectedDate;
  }
}

buildErrorDialog(
    {required BuildContext context,
    required String title,
    required String contant}) {
  Widget okButton = TextButton(
    child: Text("OK",
        style: TextStyle(
            color: Colors.black,
            decorationColor: Colors.black,
            fontFamily: 'poppins')),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog

  if (Platform.isAndroid) {
    AlertDialog alert = AlertDialog(
      title: Text(title,
          style: TextStyle(
              color: Colors.black,
              decorationColor: Colors.black,
              fontFamily: 'poppins')),
      content: Text(contant,
          style: TextStyle(
              color: Colors.black,
              decorationColor: Colors.black,
              fontFamily: 'poppins')),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  if (Platform.isIOS) {
    CupertinoAlertDialog cupertinoAlertDialog = CupertinoAlertDialog(
      title: Text(title,
          style: TextStyle(
              color: Colors.black,
              decorationColor: Colors.black,
              fontFamily: 'poppins')),
      content: Text(contant,
          style: TextStyle(
              color: Colors.black,
              decorationColor: Colors.black,
              fontFamily: 'poppins')),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return cupertinoAlertDialog;
      },
    );
  }
  // show the dialog
}
