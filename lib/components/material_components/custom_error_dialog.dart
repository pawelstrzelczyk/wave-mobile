import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wave/extensions/context.dart';

class CustomErrorDialog {
  final String dialogTitle;
  final String dialogMessage;

  CustomErrorDialog(this.dialogTitle, this.dialogMessage, {Key? key});

  Future<void> showCustomDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 32,
          ),
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
                await context.router.pop();
              },
              child: Text(context.translated.ok),
            )
          ],
        );
      },
    );
  }
}
