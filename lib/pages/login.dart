import 'dart:developer';
import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';
import 'package:wave/auto_router.gr.dart';
import 'package:wave/components/custom_ui_constants/button_container_decoration.dart';
import 'package:wave/providers/device_info.dart';
import 'package:wave/providers/login.dart';
import 'package:wave/extensions/context.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    checkUpdateAvailable();
    Provider.of<DeviceInfoController>(context, listen: false).getDeviceInfo();
    checkLoggedIn();
  }

  @override
  void dispose() {
    super.dispose();
  }

  checkUpdateAvailable() async {
    try {
      AppUpdateInfo appUpdateInfo = await InAppUpdate.checkForUpdate();
      if (appUpdateInfo.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        AppUpdateResult appUpdateResult =
            await InAppUpdate.performImmediateUpdate();
        setState(() {
          context.showSnackBar(appUpdateResult.toString());
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  checkLoggedIn() async {
    final loginController =
        Provider.of<LoginController>(context, listen: false);
    if (await loginController.aadService.oauth.getAccessToken() != null) {
      if (context.mounted) await context.router.push(const HolderRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Consumer<LoginController>(
        builder: (context, loginController, child) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(64.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          width: context.width * 0.6,
                          height: context.width * 0.6,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/wave-playstore.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Column(
                          children: [
                            Container(
                              transform:
                                  Matrix4.translationValues(0.0, -30.0, 0.0),
                              width: context.width * 0.6,
                              height: context.width * 0.6 / 2.6470588,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child:
                                    Image.asset('assets/images/logo_umww.png'),
                              ),
                            ),
                            Container(
                              transform:
                                  Matrix4.translationValues(0.0, -30.0, 0.0),
                              padding: const EdgeInsets.only(top: 12.0),
                              width: context.width * 0.6,
                              child: Text(
                                context.translated.fundingInformation,
                                style: context.textTheme.displaySmall,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Container(
                          width: context.width * 0.6,
                          height: 64,
                          decoration: CustomContainerGradientDecoration(
                            const Color(0xff005695),
                            const Color(0xff082d65),
                          ).getCustomButtonDecoration,
                          child: ElevatedButton(
                            onPressed: () async {
                              await loginController.login();
                              if (mounted) {
                                if (loginController.loginState ==
                                    LoginState.logged) {
                                  await context.router
                                      .push(const HolderRoute());
                                }
                              }
                            },
                            child: Center(
                              child: Text(
                                context.translated.signInButton,
                                style: context.textTheme.labelMedium,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              loginController.loginState == LoginState.logging
                  ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text(
                              context.translated.signInInfo,
                            ),
                          ],
                        ),
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
}
