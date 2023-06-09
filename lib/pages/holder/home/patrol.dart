import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:wave/components/custom_action_button.dart';
import 'package:wave/components/material_components/custom_error_dialog.dart';
import 'package:wave/components/custom_ui_constants/colors.dart';
import 'package:wave/components/custom_ui_constants/icons.dart';
import 'package:wave/components/map/map.dart';
import 'package:wave/components/map/marker.dart';
import 'package:wave/components/material_components/status_page_appbar.dart';
import 'package:wave/models/api.dart';
import 'package:wave/providers/patrol_form.dart';
import 'package:wave/providers/status.dart';
import 'package:wave/extensions/context.dart';
import 'package:wave/services/geolocator.dart';

enum LocationStatus { updated, nodata }

class PatrolPage extends StatefulWidget {
  const PatrolPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PatrolPageState();
}

class PatrolPageState extends State<PatrolPage> {
  LocationStatus locationStatus = LocationStatus.nodata;
  LocationData? currentLocation;
  late Location locationService = Location();

  late final MapController mapController;
  List<Marker> markers = <Marker>[];
  StreamSubscription<LocationData>? positionStream;
  Stream<ServiceStatus>? serviceStatusStream;
  StreamSubscription<ServiceStatus>? serviceStatusSubscription;
  bool isPermissionGranted = false;
  bool doNotShowAgain = false;
  String? _serviceError = '';

  @override
  void initState() {
    super.initState();
    markers.clear();
    mapController = MapController();
    initLocationService();
  }

  @override
  void didUpdateWidget(covariant PatrolPage oldWidget) {
    oldWidget.createState().dispose();
    super.didUpdateWidget(oldWidget);
  }

  @override
  dispose() {
    serviceStatusSubscription?.cancel();
    positionStream?.cancel();
    super.dispose();
  }

  Future<void> initLocationService() async {
    LocationData? location;
    bool serviceEnabled;
    bool serviceRequestResult;
    try {
      serviceEnabled = await locationService.serviceEnabled();
      serviceStatusStream =
          await GeolocatorService.getInstance().getServiceStatus();

      serviceStatusSubscription =
          serviceStatusStream?.listen((ServiceStatus status) {
        if (mounted) {
          switch (status) {
            case ServiceStatus.disabled:
              setState(() {
                locationStatus = LocationStatus.nodata;
              });
              break;
            case ServiceStatus.enabled:
              setState(() {
                locationStatus = LocationStatus.updated;
              });
              break;
          }
        }
      });
      if (serviceEnabled) {
        PermissionStatus permission = await locationService.requestPermission();
        isPermissionGranted = permission == PermissionStatus.granted;
        if (permission == PermissionStatus.deniedForever) {
          Sentry.captureMessage(
            'Permission denied forever',
            level: SentryLevel.error,
          );
        }
        if (isPermissionGranted) {
          try {
            location = await locationService.getLocation();
          } catch (e) {
            log('$e during getCurrentPosition');
          }
          currentLocation = location;
          positionStream = locationService.onLocationChanged.listen(
            (LocationData result) async {
              if (mounted) {
                setState(
                  () {
                    locationStatus = LocationStatus.updated;
                    currentLocation = result;
                    mapController.moveAndRotate(
                      LatLng(
                        currentLocation!.latitude!,
                        currentLocation!.longitude!,
                      ),
                      16,
                      0,
                    );
                    if (markers.isNotEmpty) {
                      markers.setAll(
                        0,
                        [WaveMapMarker(currentLocation!, context).waveMarker],
                      );
                    } else {
                      markers.add(
                          WaveMapMarker(currentLocation!, context).waveMarker);
                    }
                  },
                );
              }
            },
          );
        }
      } else {
        setState(() {
          locationStatus = LocationStatus.nodata;
        });
        if (!doNotShowAgain) {
          serviceRequestResult = await locationService.requestService();
          if (serviceRequestResult) {
            await initLocationService();
            return;
          } else {
            if (mounted && !doNotShowAgain) {
              await showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  icon: const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 30,
                  ),
                  title: Text(context.translated.locationErrorTitle),
                  content: Text(context.translated.locationErrorContent),
                  actions: [
                    TextButton(
                      child: Text(context.translated.openSettings),
                      onPressed: () async {
                        Geolocator.openLocationSettings().then((value) => value
                            ? log('Location settings opened')
                            : () {
                                log('Location settings not opened');
                                context.showSnackBar(context
                                    .translated.couldNotOpenLocationSettings);
                              });
                        //await dialogContext.router.pop();
                      },
                    ),
                    TextButton(
                      child: Text(context.translated.close),
                      onPressed: () async {
                        dialogContext.router.pop();
                        setState(() {
                          doNotShowAgain = true;
                        });
                      },
                    ),
                    TextButton(
                      child: Text(context.translated.exit),
                      onPressed: () async {
                        await dialogContext.router.pop();
                        if (context.mounted) await context.router.pop();
                        setState(() {
                          doNotShowAgain = true;
                        });
                      },
                    ),
                  ],
                ),
              );
              await initLocationService();
            }
          }
        }
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        _serviceError = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        _serviceError = e.message;
      }
      showDialog(
        context: context,
        builder: (alertDialogContext) => AlertDialog(
          title: Text(_serviceError.toString()),
          actions: [
            TextButton(
              child: const Text('ok'),
              onPressed: () {
                context.router.pop();
              },
            )
          ],
        ),
      );
      location = null;
      setState(() {
        locationStatus = LocationStatus.nodata;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WaveAppBar(
        tabs: false,
        title: context.translated.patrolTitle,
        icon: Icons.navigation_outlined,
        topColor: context.theme
            .extension<WaveThemeExtention>()!
            .patrolTopBlueColor!
            .withOpacity(0.5),
        bottomColor: context.theme.colorScheme.background.withOpacity(0),
        height: context.height * 0.16,
      ),
      body: Consumer2<PatrolFormController, StatusController>(
        builder: (consumerContext, patrolForm, status, child) {
          return Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: WaveMap(
                      mapController: mapController,
                      markers: markers,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: context.width * .1,
                        right: context.width * .1,
                        top: context.height * .03,
                        bottom: context.height * .03,
                      ),
                      child: buildPatrolForm(patrolForm, status, context),
                    ),
                  )
                ],
              ),
              patrolForm.fetchState == FetchState.fetching
                  ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : BackdropFilter(
                      filter: ImageFilter.blur(),
                    ),
            ],
          );
        },
      ),
    );
  }

  FormBuilder buildPatrolForm(PatrolFormController patrolForm,
      StatusController status, BuildContext context) {
    return FormBuilder(
      enabled: patrolForm.enabled,
      key: patrolForm.patrolFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: FormBuilderDateTimePicker(
              name: 'endTime',
              initialValue: status.activePatrol?.declaration.endTimestamp,
              currentDate: DateTime.now(),
              initialTime: TimeOfDay.now(),
              initialDatePickerMode: DatePickerMode.day,
              selectableDayPredicate: (day) {
                return day.isAfter(
                        DateTime.now().subtract(const Duration(days: 1))) &&
                    day.isBefore(DateTime.now().add(const Duration(days: 1)));
              },
              inputType: InputType.both,
              decoration: InputDecoration(
                labelText: context.translated.scheduledEndDate,
              ),
              validator: (value) {
                if (value == null) {
                  return context.translated.enterDateMessage;
                } else if (value.isBefore(DateTime.now())) {
                  return context.translated.endTimeBeforeStartMessageOnCreate;
                }
                return null;
              },
              format: DateFormat(
                'EEEE, HH:mm',
                context.translated.localeName,
              ),
              onChanged: (value) =>
                  patrolForm.patrolFormKey.currentState!.validate(),
              controller: patrolForm.endTimeController,
              focusNode: patrolForm.endTimeFocusNode,
              style: context.textTheme.displayLarge,
            ),
          ),
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  context.translated.deviceLocationStatus,
                  style: context.textTheme.bodySmall,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  locationStatus == LocationStatus.nodata
                      ? context.translated.noLocation
                      : context.translated.okLocation,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: locationStatus == LocationStatus.nodata
                        ? const Color.fromARGB(255, 167, 8, 8)
                        : const Color(0xff00ab11),
                    fontSize: 25,
                  ),
                ),
              ),
            ],
          ),
          if (status.activeStatus != UserStatus.patrol)
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  locationStatus == LocationStatus.updated
                      ? CustomActionButton(
                          externalContext: context,
                          () async {
                            final navigator = context.router;
                            if (patrolForm.patrolFormKey.currentState
                                    ?.saveAndValidate() ??
                                false) {
                              final msg = context.translated
                                  .patrolNotificationMessage(
                                      TimeOfDay.fromDateTime(patrolForm
                                              .patrolFormKey
                                              .currentState!
                                              .fields['endTime']!
                                              .value)
                                          .format(context)
                                          .toString());
                              final title =
                                  context.translated.patrolNotificationTitle;

                              patrolForm.postPatrol(title, msg).then((value) =>
                                  value?.fold(
                                      (l) => CustomErrorDialog(
                                              context.translated.badRequest,
                                              l.toString())
                                          .showCustomDialog(context),
                                      (r) async {
                                    await positionStream?.cancel();
                                    await navigator.pop();
                                    if (patrolForm.fetchState ==
                                        FetchState.fetched) {
                                      await navigator.pop();
                                    }
                                  }));
                            } else {
                              await navigator.pop();
                            }
                          },
                          icon: WaveIcons().sendButtonIcon,
                          text: context.translated.send,
                          dialogTitle: context.translated.confirmPatrol,
                          dialogMessage: context.translated.confirmStart,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            )
          else
            patrolForm.enabled
                ? Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomActionButton(
                          externalContext: context,
                          () async {
                            patrolForm.patrolFormKey.currentState!.reset();
                            patrolForm.disableFields();
                            await context.router.pop();
                          },
                          icon: WaveIcons().cancelButtonIcon,
                          text: context.translated.cancel,
                          dialogTitle: context.translated.cancelSave,
                          dialogMessage: context.translated.cancelChanges,
                        ),
                        CustomActionButton(
                          externalContext: context,
                          () async {
                            if (patrolForm.patrolFormKey.currentState!
                                .validate()) {
                              await positionStream?.cancel();
                              if (context.mounted) context.router.pop();
                              patrolForm.updatePatrol().then(
                                    (value) => value?.fold(
                                      (l) => CustomErrorDialog(
                                              context.translated.badRequest,
                                              l.toString())
                                          .showCustomDialog(context),
                                      (r) async {
                                        if (patrolForm.fetchState ==
                                            FetchState.fetched) {
                                          await context.router.pop();
                                        }
                                      },
                                    ),
                                  );
                            } else {
                              await context.router.pop();
                            }
                          },
                          icon: WaveIcons().saveButtonIcon,
                          text: context.translated.save,
                          dialogTitle: context.translated.confirmSave,
                          dialogMessage: context.translated.confirmChanges,
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomActionButton(
                          externalContext: context,
                          () async {
                            patrolForm.enableFields();
                            await context.router.pop();
                          },
                          icon: WaveIcons().editButtonIcon,
                          text: context.translated.edit,
                          dialogTitle: context.translated.editPatrol,
                          dialogMessage: context.translated.confirmEditPatrol,
                        ),
                        CustomActionButton(
                          externalContext: context,
                          () async {
                            final navigator = context.router;
                            await positionStream?.cancel();
                            await navigator.pop();
                            await patrolForm.finishPatrol();
                            if (patrolForm.fetchState == FetchState.fetched) {
                              await navigator.pop();
                            }
                          },
                          icon: WaveIcons().endButtonIcon,
                          text: context.translated.delete,
                          dialogTitle: context.translated.warning,
                          dialogMessage: context.translated.confirmFinish,
                        ),
                      ],
                    ),
                  ),
        ],
      ),
    );
  }
}
