import 'package:flutter/material.dart';
import 'package:wave/extensions/context.dart';

///Widget navigating to patrol/duty form after double-click
class ActionBox extends StatelessWidget {
  final String actionTitle;
  final String actionDescription;
  final Color colorTop;
  final Color colorBottom;
  final IconData icon;
  const ActionBox(
      {Key? key,
      required this.actionTitle,
      required this.actionDescription,
      required this.icon,
      required this.colorTop,
      required this.colorBottom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.width * 0.4,
      width: context.width * 0.4,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(12.0),
        ),
        gradient: LinearGradient(
          colors: [
            colorTop.withOpacity(0.7),
            colorBottom.withOpacity(0.7),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: context.textTheme.bodyLarge!.color,
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    actionTitle,
                    style: context.textTheme.bodyMedium,
                  ),
                  Text(
                    actionDescription,
                    style: context.textTheme.displaySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
