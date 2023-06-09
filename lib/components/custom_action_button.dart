import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wave/components/custom_ui_constants/button_container_decoration.dart';
import 'package:wave/components/material_components/custom_alert_dialog.dart';
import 'package:wave/extensions/context.dart';

///Generic button widget shared across the app used for triggering REST calls
class CustomActionButton extends StatelessWidget {
  final AsyncCallback callback;
  final IconData icon;
  final String text;
  final String dialogTitle;
  final String dialogMessage;
  final BuildContext externalContext;
  const CustomActionButton(
    this.callback, {
    super.key,
    required this.icon,
    required this.text,
    required this.dialogTitle,
    required this.dialogMessage,
    required this.externalContext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: CustomContainerGradientDecoration(
        context.brightness == Brightness.dark
            ? const Color(0xff005695)
            : const Color.fromARGB(255, 103, 192, 255),
        context.brightness == Brightness.dark
            ? const Color(0xff082d65)
            : const Color.fromARGB(255, 92, 154, 248),
      ).getCustomButtonDecoration,
      height: context.height * .07,
      width: context.width * .36,
      child: ElevatedButton(
        onPressed: () {
          CustomAlertDialog(
            dialogTitle,
            dialogMessage,
            callback,
            externalContext,
            () async {
              context.router.pop();
            },
          ).showCustomDialog();
        },
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: context.textTheme.bodyMedium,
            ),
            Icon(
              icon,
              color: context.theme.iconTheme.color,
            )
          ],
        ),
      ),
    );
  }
}
