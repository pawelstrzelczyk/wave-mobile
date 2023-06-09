import 'package:flutter/material.dart';
import 'package:wave/components/duty_expansion_tile.dart';
import 'package:wave/components/last_list_tile.dart';
import 'package:wave/models/api.dart';
import 'package:wave/providers/duty_form.dart';

ListView pastDutiesListBuilder(
  ScrollController scrollController,
  List<Duty> items,
  ConnectionState connectionState,
  DutyFormController? dutyFormController,
) =>
    ListView.separated(
      shrinkWrap: true,
      controller: scrollController,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        if (index < items.length) {
          return dutyExpansionTile(items, index, context);
        } else {
          return lastListTile(connectionState, context);
        }
      },
      separatorBuilder: (context, index) {
        return const Divider(
          height: 12,
        );
      },
      itemCount: items.length + 1,
    );
