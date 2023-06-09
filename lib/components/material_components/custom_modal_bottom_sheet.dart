import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wave/extensions/context.dart';

import 'package:wave/services/api.dart';

customModalBottomSheetForSorting(
  BuildContext context,
  String modalTitle,
  SortType? localSortType,
  Function(SortType) setSortType,
  AsyncCallback onSortApplied,
) async {
  showModalBottomSheet(
    useRootNavigator: true,
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return BottomSheet(
          enableDrag: false,
          onClosing: () {},
          builder: (context) => Container(
            padding: const EdgeInsets.only(
              top: 16.0,
              bottom: 80.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  modalTitle,
                  style: context.textTheme.bodyMedium,
                ),
                const Divider(
                  color: Colors.white,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Text(
                        context.translated.startDate,
                        textAlign: TextAlign.center,
                        style: context.theme.textTheme.bodySmall,
                      ),
                      RadioListTile<SortType>(
                        title: Text(context.translated.newestFirst),
                        value: SortType.desc,
                        groupValue: localSortType,
                        onChanged: (SortType? value) {
                          setState(
                            () {
                              setSortType(value ?? SortType.desc);
                              localSortType = value;
                            },
                          );
                        },
                        controlAffinity: ListTileControlAffinity.trailing,
                      ),
                      RadioListTile<SortType>(
                        title: Text(context.translated.oldestFirst),
                        value: SortType.asc,
                        groupValue: localSortType,
                        onChanged: (SortType? value) {
                          setState(
                            () {
                              setSortType(value ?? SortType.desc);
                              localSortType = value;
                            },
                          );
                        },
                        controlAffinity: ListTileControlAffinity.trailing,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                          BorderSide(
                            width: 1.0,
                            color: context.theme.canvasColor,
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all(
                          Size(
                            MediaQuery.of(context).size.width * 0.4,
                            48,
                          ),
                        ),
                      ),
                      onPressed: () {
                        context.router.pop();
                      },
                      child: Text(
                        context.translated.cancel,
                        style: context.theme.textTheme.bodyMedium,
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          context.theme.canvasColor,
                        ),
                        minimumSize: MaterialStateProperty.all(
                          Size(
                            MediaQuery.of(context).size.width * 0.4,
                            48,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        final navigator = context.router;
                        await onSortApplied();
                        navigator.pop();
                      },
                      child: Text(
                        context.translated.apply,
                        style: context.theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    ),
  );
}
