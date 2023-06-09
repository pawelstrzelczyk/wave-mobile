import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wave/components/material_components/custom_error_dialog.dart';
import 'package:wave/components/custom_ui_constants/button_container_decoration.dart';
import 'package:wave/components/custom_ui_constants/colors.dart';
import 'package:wave/components/custom_ui_constants/icons.dart';
import 'package:wave/components/material_components/custom_alert_dialog.dart';
import 'package:wave/components/status_box/nothing_to_show_content.dart';
import 'package:wave/models/api.dart';
import 'package:wave/providers/geolocator.dart';
import 'package:wave/providers/status.dart';
import 'package:wave/extensions/context.dart';

///Widget displaying current [UserStatus] on HomePage
class StatusBox extends StatefulWidget {
  const StatusBox({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StatusBoxState();
}

class StatusBoxState extends State<StatusBox> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadData();
    }
    super.didChangeAppLifecycleState(state);
  }

  Color statusBoxGradientTopColor(UserStatus status) =>
      status == UserStatus.duty
          ? context.theme
              .extension<WaveThemeExtention>()!
              .greenTopColor!
              .withOpacity(0.7)
          : status == UserStatus.patrol
              ? context.theme
                  .extension<WaveThemeExtention>()!
                  .patrolTopBlueColor!
                  .withOpacity(0.7)
              : context.theme
                  .extension<WaveThemeExtention>()!
                  .nothingToDisplayTopColor!;

  Color statusBoxGradientBottomColor(UserStatus status) =>
      status == UserStatus.duty
          ? const Color(0xff125c06).withOpacity(0.7)
          : status == UserStatus.patrol
              ? context.theme
                  .extension<WaveThemeExtention>()!
                  .patrolBottomBlueColor!
                  .withOpacity(0.7)
              : context.theme
                  .extension<WaveThemeExtention>()!
                  .nothingToDisplayBottomColor!;

  IconData statusIcon(UserStatus status) =>
      status == UserStatus.duty ? WaveIcons().dutyIcon : WaveIcons().patrolIcon;

  Future<dynamic> loadData() async {
    final StatusController statusController =
        Provider.of<StatusController>(context, listen: false);
    final GeolocatorController geolocatorController =
        Provider.of<GeolocatorController>(context, listen: false);
    await statusController.getStatus();
    if (statusController.activeStatus == UserStatus.patrol) {
      geolocatorController.getAccuracy();
      geolocatorController.getMqttState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('status-box'),
      onVisibilityChanged: (info) async {
        if (info.visibleFraction == 1) {
          await loadData();
        }
      },
      child: Consumer2<StatusController, GeolocatorController>(
        builder: (context, status, geolocator, _) => GestureDetector(
          onTap: status.activeDuty?.declaration?.status == 'INACTIVE'
              ? () async {
                  CustomAlertDialog(
                      context.translated.confirmScheduledDutyTitle,
                      context.translated.confirmScheduledDuty,
                      () async {
                        StackRouter navigator = context.router;
                        status.confirmDuty(true).then(
                              (value) => value.fold(
                                (l) => CustomErrorDialog(
                                        context.translated.badRequest,
                                        l.toString())
                                    .showCustomDialog(context),
                                (r) => null,
                              ),
                            );
                        await navigator.pop();
                        await loadData();
                      },
                      context,
                      () async {
                        StackRouter navigator = context.router;
                        status.confirmDuty(false).then(
                              (value) => value.fold(
                                (l) => CustomErrorDialog(
                                        context.translated.badRequest,
                                        l.toString())
                                    .showCustomDialog(context),
                                (r) => null,
                              ),
                            );
                        await navigator.pop();
                        await loadData();
                      }).showCustomDialog();
                }
              : null,
          child: Container(
            width: context.width,
            height: context.height * 0.20,
            decoration: CustomContainerGradientDecoration(
              statusBoxGradientTopColor(status.activeStatus),
              statusBoxGradientBottomColor(status.activeStatus),
            ).getCustomContainerDecoration,
            padding: const EdgeInsets.all(12.0),
            child: status.fetchState == FetchState.fetching
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orangeAccent,
                    ),
                  )
                : status.activeStatus != UserStatus.idle
                    ? status.activeDuty?.declaration?.status != 'INACTIVE'
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              statusBoxHeader(status, context),
                              Flexible(
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    timestampsColumn(context, status),
                                    Flexible(
                                      flex: 3,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: status.activeStatus ==
                                                    UserStatus.patrol
                                                ? locationStatusText(
                                                    geolocator,
                                                    context,
                                                  )
                                                : mobilisationPlaceText(
                                                    status,
                                                    context,
                                                  ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: status.activeStatus ==
                                                    UserStatus.patrol
                                                ? getMqttConnectionStateText(
                                                    geolocator,
                                                    context,
                                                  )
                                                : mobilisationTimeText(
                                                    status,
                                                    context,
                                                  ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                MdiIcons.alertCircleOutline,
                                size: 50,
                                color: Colors.red,
                              ),
                              Text(
                                context.translated.actionRequired,
                                style: context.textTheme.headlineMedium,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  context.translated
                                      .confirmScheduledDutyMessage(
                                    DateFormat(
                                      'HH:mm',
                                      context.translated.localeName,
                                    ).format(status.startTimestamp!),
                                    DateFormat(
                                      'HH:mm',
                                      context.translated.localeName,
                                    ).format(status.endTimestamp!),
                                  ),
                                  style: context.textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          )
                    : const NothingToShowContent(),
          ),
        ),
      ),
    );
  }

  Flexible timestampsColumn(BuildContext context, StatusController status) {
    return Flexible(
      flex: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                DateFormat(
                  'HH:mm',
                  context.translated.localeName,
                ).format(
                  status.startTimestamp!,
                ),
                style: context.theme.textTheme.bodyMedium,
              ),
              Text(
                context.translated.startTime,
                style: context.theme.textTheme.labelSmall,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                DateFormat(
                  'HH:mm',
                  context.translated.localeName,
                ).format(status.endTimestamp!),
                style: context.theme.textTheme.bodyMedium,
              ),
              Text(
                context.translated.endTime,
                style: context.theme.textTheme.labelSmall,
              ),
            ],
          )
        ],
      ),
    );
  }

  Flexible statusBoxHeader(StatusController status, BuildContext context) {
    return Flexible(
      flex: 1,
      child: Row(
        children: [
          Icon(
            statusIcon(status.activeStatus),
            color: context.theme.textTheme.titleMedium!.color,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              status.activeStatus == UserStatus.duty
                  ? context.translated.dutyTitle
                  : context.translated.patrolTitle,
              style: context.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  List<Text> mobilisationPlaceText(
      StatusController status, BuildContext context) {
    return [
      Text(
        status.mobilisationPlace?.name ?? '',
        style: context.theme.textTheme.bodyMedium,
      ),
      Text(
        context.translated.mobilisationPlace,
        style: context.theme.textTheme.labelSmall,
      ),
    ];
  }

  List<Text> getMqttConnectionStateText(
      GeolocatorController geolocator, BuildContext context) {
    return [
      Text(
        geolocator.mqttConnectionState == MqttConnectionState.connected
            ? context.translated.connected
            : geolocator.mqttConnectionState == MqttConnectionState.disconnected
                ? context.translated.disconnected
                : context.translated.other,
        style: context.theme.textTheme.bodyMedium,
      ),
      Text(
        context.translated.synchronisation,
        style: context.theme.textTheme.labelSmall,
      ),
    ];
  }

  List<Text> locationStatusText(
      GeolocatorController geolocator, BuildContext context) {
    return [
      Text(
        geolocator.locationAccuracyStatus == LocationAccuracyStatus.precise
            ? context.translated.precise
            : geolocator.locationAccuracyStatus ==
                    LocationAccuracyStatus.reduced
                ? context.translated.reduced
                : context.translated.unknown,
        style: context.theme.textTheme.bodyMedium,
      ),
      Text(
        context.translated.location,
        style: context.theme.textTheme.labelSmall,
      ),
    ];
  }

  List<Text> mobilisationTimeText(
      StatusController status, BuildContext context) {
    return [
      Text(
        status.mobilisationTime.toString(),
        style: context.theme.textTheme.bodyMedium,
      ),
      Text(
        context.translated.mobilisationTime,
        style: context.theme.textTheme.labelSmall,
      ),
    ];
  }
}
