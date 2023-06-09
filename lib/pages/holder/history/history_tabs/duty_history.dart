import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wave/components/duty_list.dart';
import 'package:wave/providers/duty_history.dart';
import 'package:wave/services/api.dart';
import 'package:wave/extensions/context.dart';

import 'package:wave/components/material_components/custom_modal_bottom_sheet.dart';

class DutyHistory extends StatefulWidget {
  const DutyHistory({super.key});

  @override
  State<StatefulWidget> createState() => DutyHistoryState();
}

class DutyHistoryState extends State<DutyHistory> {
  late ScrollController scrollController;
  Future<void>? getPastDuties;
  onScrollUpdated() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      final DutyHistoryController dutyHistoryController =
          Provider.of<DutyHistoryController>(context, listen: false);
      dutyHistoryController.page += 1;
      setState(() {
        getPastDuties = dutyHistoryController.getPastDuties();
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final DutyHistoryController dutyHistoryController =
        Provider.of<DutyHistoryController>(context, listen: false);
    dutyHistoryController.duties.clear();
    scrollController = ScrollController();
    dutyHistoryController.limit = 10;
    dutyHistoryController.page = 0;
    getPastDuties = dutyHistoryController.getPastDuties();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(() {
        onScrollUpdated();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DutyHistoryController>(
      builder: (context, dutyHistory, child) {
        SortType? localSortType = dutyHistory.sortType;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.sort_outlined,
                    color: context.textTheme.bodySmall!.color,
                  ),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () async {
                    await customModalBottomSheetForSorting(
                      context,
                      context.translated.sortDuties,
                      localSortType,
                      dutyHistory.setSortType,
                      () async {
                        dutyHistory.duties.clear();
                        dutyHistory.page = 0;
                        setState(() {
                          getPastDuties = dutyHistory.getPastDuties();
                        });
                      },
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  dutyHistory.duties.clear();
                  dutyHistory.page = 0;
                  setState(() {
                    getPastDuties = dutyHistory.getPastDuties();
                  });
                },
                child: FutureBuilder<void>(
                  future: getPastDuties,
                  builder: (context, snapshot) => pastDutiesListBuilder(
                    scrollController,
                    dutyHistory.duties,
                    snapshot.connectionState,
                    null,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
