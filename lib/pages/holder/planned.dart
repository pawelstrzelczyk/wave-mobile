import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wave/auto_router.gr.dart';
import 'package:wave/components/last_list_tile.dart';
import 'package:wave/components/material_components/status_page_appbar.dart';
import 'package:wave/extensions/context.dart';
import 'package:wave/providers/duty_form.dart';
import 'package:wave/providers/duty_scheduled.dart';
import 'package:wave/providers/status.dart';
import 'package:wave/services/api.dart';

import 'package:wave/components/future_duties_page/slidable_list_tile.dart';
import 'package:wave/components/material_components/custom_modal_bottom_sheet.dart';

class DutyFuturePage extends StatefulWidget {
  const DutyFuturePage({super.key});

  @override
  State<DutyFuturePage> createState() => _DutyFuturePageState();
}

class _DutyFuturePageState extends State<DutyFuturePage> {
  late ScrollController scrollController;
  Future<void>? getScheduledDuties;
  onScrollUpdated() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      final DutyFutureController dutyHistoryController =
          Provider.of<DutyFutureController>(context, listen: false);
      dutyHistoryController.page += 1;
      await dutyHistoryController.getScheduledDuties();
      setState(() {
        getScheduledDuties = dutyHistoryController.getScheduledDuties();
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
    final DutyFutureController dutyHistoryController =
        Provider.of<DutyFutureController>(context, listen: false);
    dutyHistoryController.duties.clear();
    scrollController = ScrollController();
    dutyHistoryController.limit = 10;
    dutyHistoryController.page = 0;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.addListener(() {
        onScrollUpdated();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WaveAppBar(
        tabs: false,
        title: context.translated.plannedPageTitle,
        icon: MdiIcons.calendarClock,
        topColor: const Color(0xff005F8E),
        bottomColor: const Color(0xfc051f37).withOpacity(0),
        height: context.height * 0.2,
      ),
      body: Consumer2<DutyFormController, DutyFutureController>(
        builder: (context, dutyForm, dutyFuture, child) {
          SortType? localSortType = dutyFuture.sortType;
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
                        dutyFuture.setSortType,
                        () async {
                          dutyFuture.duties.clear();
                          dutyFuture.page = 0;
                          setState(() {
                            getScheduledDuties =
                                dutyFuture.getScheduledDuties();
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                child: VisibilityDetector(
                  key: const Key('futureDutyList'),
                  onVisibilityChanged: (info) {
                    if (info.visibleFraction == 1.0) {
                      dutyFuture.page = 0;
                      dutyFuture.duties.clear();
                      setState(() {
                        getScheduledDuties = dutyFuture.getScheduledDuties();
                      });
                    }
                  },
                  child: RefreshIndicator(
                    onRefresh: () async {
                      dutyFuture.duties.clear();
                      dutyFuture.page = 0;
                      setState(() {
                        getScheduledDuties = dutyFuture.getScheduledDuties();
                      });
                    },
                    child: FutureBuilder(
                      future: getScheduledDuties,
                      builder: (context, snapshot) =>
                          scheduledDutiesListBuilder(
                        scrollController,
                        dutyFuture,
                        snapshot.connectionState,
                        dutyForm,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Consumer2<DutyFormController, StatusController>(
        builder: (context, dutyForm, status, child) => FloatingActionButton(
          onPressed: status.activeStatus == UserStatus.idle
              ? () {
                  dutyForm.futureDuty = null;
                  dutyForm.enabled = true;
                  dutyForm.isPlanning = true;
                  context.router.push(DutyRouterPlanned());
                }
              : () => context.showSnackBar(
                    context.translated.cantPlanDutyWhileActive,
                  ),
          child: const Icon(Icons.add_outlined),
        ),
      ),
    );
  }

  ListView scheduledDutiesListBuilder(
          ScrollController scrollController,
          DutyFutureController dutyFuture,
          ConnectionState connectionState,
          DutyFormController dutyForm) =>
      ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(parent: null),
        shrinkWrap: true,
        controller: scrollController,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          if (index < dutyFuture.duties.length) {
            return slidableFutureDuty(
              dutyFuture.duties,
              dutyForm,
              dutyFuture,
              index,
              context,
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
        itemCount: dutyFuture.duties.length + 1,
      );
}
