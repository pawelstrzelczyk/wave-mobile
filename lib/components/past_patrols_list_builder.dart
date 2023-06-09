import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wave/components/custom_ui_constants/colors.dart';
import 'package:wave/components/last_list_tile.dart';
import 'package:wave/extensions/context.dart';
import 'package:wave/models/api.dart';

ListView pastPatrolsListBuilder(
  ScrollController scrollController,
  List<Patrol> patrols,
  ConnectionState connectionState,
) =>
    ListView.separated(
      shrinkWrap: true,
      controller: scrollController,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        if (index < patrols.length) {
          return ExpansionTile(
            title: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                'Poznań',
                style: context.textTheme.bodyMedium,
              ),
            ),
            leading: Container(
              alignment: Alignment.centerLeft,
              width: context.width * 0.2,
              child: Text(
                DateFormat.yMd(
                  context.translated.localeName,
                ).format(
                  patrols[index].declaration.startTimestamp!,
                ),
                style: context.textTheme.bodySmall,
                softWrap: false,
              ),
            ),
            collapsedBackgroundColor: context.theme
                .extension<WaveThemeExtention>()!
                .patrolTopBlueColor!
                .withAlpha(70),
            backgroundColor: context.theme
                .extension<WaveThemeExtention>()!
                .patrolTopBlueColor!
                .withAlpha(120),
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 12.0, right: 12.0, bottom: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      DateFormat.Hm(
                        context.translated.localeName,
                      ).format(patrols[index].declaration.startTimestamp!),
                      style: context.textTheme.bodyMedium,
                    ),
                    const Icon(Icons.schedule_send_outlined),
                    Text(
                      DateFormat.Hm(
                        context.translated.localeName,
                      ).format(
                        patrols[index].declaration.endTimestamp!,
                      ),
                      style: context.textTheme.bodyMedium,
                    ),
                  ],
                ),
              )
            ],
          );
        } else {
          return lastListTile(connectionState, context);
        }
      },
      separatorBuilder: (context, index) {
        return const Divider(
          height: 12,
        );
      },
      itemCount: patrols.length + 1,
    );
