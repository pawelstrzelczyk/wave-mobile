import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wave/auto_router.gr.dart';
import 'package:wave/components/action_box.dart';
import 'package:wave/components/custom_ui_constants/button_container_decoration.dart';
import 'package:wave/components/custom_ui_constants/colors.dart';
import 'package:wave/components/custom_ui_constants/icons.dart';
import 'package:wave/components/status_box/status_box.dart';
import 'package:wave/extensions/context.dart';
import 'package:wave/providers/aad_user.dart';
import 'package:wave/providers/duty_form.dart';
import 'package:wave/providers/geolocator.dart';
import 'package:wave/providers/patrol_form.dart';
import 'package:wave/providers/status.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    final UserController userController =
        Provider.of<UserController>(context, listen: false);
    userController.getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wave',
          style: TextStyle(
            fontSize: 48,
            color: context.textTheme.bodySmall!.color,
          ),
        ),
        flexibleSpace: Container(
          decoration: CustomContainerGradientDecoration(
            const Color(0xff005f8e),
            const Color(0xff14213D).withOpacity(0),
          ).getCustomAppBarDecoration,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(context.height * .03),
          child: SizedBox(
            width: context.width,
            height: context.height * .08,
            child: Selector<UserController, dartz.Tuple2<String?, String?>>(
              selector: (_, user) => dartz.Tuple2(
                user.username,
                user.email,
              ),
              builder: (context, user, _) {
                return Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.value1.toString(),
                        style: context.textTheme.displaySmall,
                      ),
                      Text(
                        user.value2.toString(),
                        style: context.textTheme.displaySmall,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        titleSpacing: 50,
        toolbarHeight: context.height * 0.2,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final StatusController statusController =
              Provider.of<StatusController>(context, listen: false);
          final GeolocatorController geolocatorController =
              Provider.of<GeolocatorController>(context, listen: false);
          await statusController.getStatus();
          if (statusController.activeStatus == UserStatus.patrol) {
            await geolocatorController.getAccuracy();
            geolocatorController.getMqttState();
          }
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(parent: null),
          padding: const EdgeInsets.all(24),
          child: Consumer3<StatusController, DutyFormController,
              PatrolFormController>(
            builder: (context, status, dutyForm, patrolForm, child) {
              if (status.activeStatus == UserStatus.idle) {
                patrolForm.enabled = true;
                dutyForm.enabled = true;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      context.translated.currentStatus,
                      style: TextStyle(
                        color: context.textTheme.bodyMedium!.color,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (status.activeStatus == UserStatus.duty) {
                        dutyForm.isPlanning = false;
                        dutyForm.futureDuty = null;
                        dutyForm.disableFields();
                        context.router.push(DutyRouter());
                      } else if (status.activeStatus == UserStatus.patrol) {
                        patrolForm.disableFields();
                        context.router.push(const PatrolRouter());
                      }
                    },
                    child: const StatusBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      context.translated.reportStatus,
                      style: TextStyle(
                        color: context.textTheme.bodyMedium!.color,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onDoubleTap: status.activeStatus != UserStatus.idle
                            ? () {
                                context.showSnackBar(
                                  context.translated.youHaveActiveStatus,
                                );
                              }
                            : () {
                                context.router.push(const PatrolRouter());
                              },
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                          onPressed: status.activeStatus != UserStatus.idle
                              ? null
                              : () {
                                  Fluttertoast.showToast(
                                    msg: context
                                        .translated.doubleClickToStartPatrol,
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    textColor: Colors.white,
                                  );
                                },
                          child: ActionBox(
                            actionTitle: context.translated.patrolTitle,
                            actionDescription:
                                context.translated.patrolDescription,
                            colorTop: status.activeStatus != UserStatus.idle
                                ? context.theme
                                    .extension<WaveThemeExtention>()!
                                    .nothingToDisplayTopColor!
                                : context.theme
                                    .extension<WaveThemeExtention>()!
                                    .patrolTopBlueColor!,
                            colorBottom: status.activeStatus != UserStatus.idle
                                ? context.theme
                                    .extension<WaveThemeExtention>()!
                                    .nothingToDisplayBottomColor!
                                : context.theme
                                    .extension<WaveThemeExtention>()!
                                    .patrolBottomBlueColor!,
                            icon: WaveIcons().patrolIcon,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onDoubleTap: status.activeStatus != UserStatus.idle
                            ? () {
                                context.showSnackBar(
                                  context.translated.youHaveActiveStatus,
                                );
                              }
                            : () {
                                dutyForm.futureDuty = null;
                                dutyForm.isPlanning = false;
                                context.router.push(DutyRouter());
                              },
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                          onPressed: status.activeStatus != UserStatus.idle
                              ? null
                              : () {
                                  Fluttertoast.showToast(
                                    msg: context
                                        .translated.doubleClickToStartDuty,
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    textColor: Colors.white,
                                  );
                                },
                          child: ActionBox(
                            actionTitle: context.translated.dutyTitle,
                            actionDescription:
                                context.translated.dutyDescription,
                            colorTop: status.activeStatus != UserStatus.idle
                                ? context.theme
                                    .extension<WaveThemeExtention>()!
                                    .nothingToDisplayTopColor!
                                : context.theme
                                    .extension<WaveThemeExtention>()!
                                    .greenTopColor!,
                            colorBottom: status.activeStatus != UserStatus.idle
                                ? context.theme
                                    .extension<WaveThemeExtention>()!
                                    .nothingToDisplayBottomColor!
                                : context.theme
                                    .extension<WaveThemeExtention>()!
                                    .greenBottomColor!,
                            icon: WaveIcons().dutyIcon,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
