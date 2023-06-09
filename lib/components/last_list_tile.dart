import 'package:flutter/material.dart';
import 'package:wave/extensions/context.dart';

Padding lastListTile(ConnectionState connectionState, BuildContext context) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: connectionState == ConnectionState.waiting
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            )
          : Center(
              child: Text(
                context.translated.noMoreDataText,
                style: context.textTheme.bodySmall,
              ),
            ),
    );
