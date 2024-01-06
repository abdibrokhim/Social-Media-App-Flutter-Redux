import 'package:flutter/material.dart';

void showConfirmationDialog({
  required BuildContext context,
  required String confirmationText,
  required String rightButtonName,
  required VoidCallback rightButtonAction,
  required String leftButtonName,
  required VoidCallback leftButtonAction,
  Color? rightButtonColor,
  Color? leftButtonColor,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Action'),
        content: Text(confirmationText),
        actions: <Widget>[
          TextButton(
            onPressed: leftButtonAction,
            child: Text(
              leftButtonName,
              style: TextStyle(
                color: leftButtonColor ?? Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: rightButtonAction,
            child: Text(
              rightButtonName, 
              style: TextStyle(
                color: rightButtonColor ?? Colors.red,
              )
            ),
          ),
        ],
      );
    },
  );
}