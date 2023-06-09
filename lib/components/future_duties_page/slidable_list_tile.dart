import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:wave/components/duty_expansion_tile.dart';
import 'package:wave/extensions/context.dart';

import 'package:wave/auto_router.gr.dart';
import 'package:wave/models/api.dart';
import 'package:wave/providers/duty_form.dart';
import 'package:wave/providers/duty_scheduled.dart';

Slidable slidableFutureDuty(
  List<Duty> items,
  DutyFormController dutyForm,
  DutyFutureController dutyFuture,
  int index,
  BuildContext context,
) =>
    Slidable(
      key: Key(items[index].id ?? ''),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            icon: Icons.edit_outlined,
            backgroundColor: Colors.yellow[800]!,
            foregroundColor: context.textTheme.bodySmall!.color,
            onPressed: (context) {
              dutyForm.isPlanning = true;
              dutyForm.futureDuty = items[index];
              dutyForm.enabled = true;
              context.router.push(DutyRouterPlanned());
            },
          ),
          SlidableAction(
            icon: Icons.delete_forever_outlined,
            backgroundColor: Colors.red,
            foregroundColor: context.textTheme.bodySmall!.color,
            onPressed: (context) async {
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(context.translated.confirmDelete),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        await context.router.pop();
                      },
                      child: Text(context.translated.no),
                    ),
                    TextButton(
                      onPressed: () async {
                        await dutyForm.deleteDuty(items[index].id!);
                        if (context.mounted) await context.router.pop();
                        dutyFuture.duties.remove(items[index]);
                      },
                      child: Text(context.translated.yes),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      child: dutyExpansionTile(items, index, context),
    );
