import 'package:flutter/material.dart';
import 'package:wave/components/status_box/status_box.dart';
import 'package:wave/extensions/context.dart';

///Content for [StatusBox] when user is idle
class NothingToShowContent extends StatelessWidget {
  const NothingToShowContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            context.translated.nothingToShowTitle,
            style: context.textTheme.bodyMedium,
          ),
          Text(
            context.translated.nothingToShowMessage,
            style: context.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
