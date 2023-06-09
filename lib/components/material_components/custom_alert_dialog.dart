import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wave/extensions/context.dart';

///Custom [AlertDialog] shared across the map
class CustomAlertDialog {
  final String dialogTitle;
  final String dialogMessage;
  final AsyncCallback callback;
  final AsyncCallback? cancelCallback;
  final BuildContext context;
  CustomAlertDialog(
    this.dialogTitle,
    this.dialogMessage,
    this.callback,
    this.context,
    this.cancelCallback,
  );

  showCustomDialog() async {
    await showDialog(
      useRootNavigator: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            dialogTitle,
            style: context.textTheme.headlineSmall,
          ),
          content: Text(
            dialogMessage,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await cancelCallback?.call();
              },
              child: Text(context.translated.no),
            ),
            TextButton(
              onPressed: () async {
                await callback.call();
              },
              child: Text(context.translated.yes),
            ),
          ],
        );
      },
    );
  }
}
