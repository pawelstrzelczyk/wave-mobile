import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wave/components/past_patrols_list_builder.dart';
import 'package:wave/providers/patrol_history.dart';
import 'package:wave/services/api.dart';
import 'package:wave/extensions/context.dart';

import 'package:wave/components/material_components/custom_modal_bottom_sheet.dart';

class PatrolHistory extends StatefulWidget {
  const PatrolHistory({super.key});

  @override
  State<PatrolHistory> createState() => PatrolHistoryState();
}

class PatrolHistoryState extends State<PatrolHistory> {
  late ScrollController scrollController;
  Future<void>? getPastPatrols;
  onScrollUpdated() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      final PatrolHistoryController patrolHistoryController =
          Provider.of<PatrolHistoryController>(context, listen: false);
      patrolHistoryController.page += 1;
      setState(() {
        getPastPatrols = patrolHistoryController.getPastPatrols();
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
    final PatrolHistoryController patrolHistoryController =
        Provider.of<PatrolHistoryController>(context, listen: false);
    patrolHistoryController.patrols.clear();
    scrollController = ScrollController();
    patrolHistoryController.limit = 10;
    patrolHistoryController.page = 0;
    getPastPatrols = patrolHistoryController.getPastPatrols();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.addListener(() {
        onScrollUpdated();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PatrolHistoryController>(
      builder: (context, patrolHistory, child) {
        SortType? localSortType = patrolHistory.sortType;
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
                      context.translated.sortPatrols,
                      localSortType,
                      patrolHistory.setSortType,
                      () async {
                        patrolHistory.patrols.clear();
                        patrolHistory.page = 0;
                        setState(() {
                          getPastPatrols = patrolHistory.getPastPatrols();
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
                  patrolHistory.patrols.clear();
                  patrolHistory.page = 0;
                  setState(() {
                    getPastPatrols = patrolHistory.getPastPatrols();
                  });
                },
                child: FutureBuilder(
                  future: getPastPatrols,
                  builder: (context, snapshot) => pastPatrolsListBuilder(
                    scrollController,
                    patrolHistory.patrols,
                    snapshot.connectionState,
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
