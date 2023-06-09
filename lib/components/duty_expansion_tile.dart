import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wave/components/custom_ui_constants/colors.dart';
import 'package:wave/extensions/context.dart';
import 'package:wave/models/api.dart';

ExpansionTile dutyExpansionTile(
  List<Duty> items,
  int index,
  BuildContext context,
) =>
    ExpansionTile(
      title: Text(
        items[index].mobilisationPlace!.name!,
        style: context.textTheme.bodyMedium,
      ),
      leading: Container(
        alignment: Alignment.centerLeft,
        width: context.width * 0.2,
        child: Text(
          DateFormat.yMd(context.translated.localeName)
              .format(items[index].declaration!.startTimestamp!),
          style: context.textTheme.bodySmall,
          softWrap: false,
        ),
      ),
      collapsedBackgroundColor: context.theme
          .extension<WaveThemeExtention>()!
          .greenTopColor!
          .withAlpha(160),
      backgroundColor:
          context.theme.extension<WaveThemeExtention>()!.greenTopColor,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            bottom: 12.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                DateFormat.Hm(context.translated.localeName)
                    .format(items[index].declaration!.startTimestamp!),
                style: context.textTheme.bodyMedium,
              ),
              const Icon(Icons.schedule_send_outlined),
              Text(
                DateFormat.Hm(context.translated.localeName)
                    .format(items[index].declaration!.endTimestamp!),
                style: context.textTheme.bodyMedium,
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.departure_board_outlined,
                    ),
                  ),
                  Text(
                    items[index].mobilisationTime.toString(),
                    style: context.theme.textTheme.bodyMedium,
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
