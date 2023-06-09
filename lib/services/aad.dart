import 'dart:developer';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:wave/main.dart';

class AADService {
  static final Config config = Config(
    tenant: dotenv.env['AZURE_AAD_TENANT']!,
    clientId: dotenv.env['AZURE_AAD_CLIENT_ID']!,
    scope: dotenv.env['AZURE_AAD_SCOPE']!,
    redirectUri: 'https://login.live.com/oauth20_desktop.srf',
    navigatorKey: appRouter.navigatorKey,
  );

  final AadOAuth oauth = AadOAuth(config);

  Future<bool> login() async {
    try {
      final loginResult = await oauth.login(refreshIfAvailable: true);
      // loginResult.fold(
      //   (l) => log(l.toString()),
      //   (r) => log(r.toString()),
      // );

      String? accessToken = await oauth.getAccessToken();
      Map<String, dynamic> decodedToken =
          JwtDecoder.decode(accessToken.toString());
      List<dynamic> roles = decodedToken['roles'];
      bool validRole = roles.any((element) => element == 'wave-publisher');
      if (!validRole) {
        return false;
      }

      String? oid = decodedToken['oid'];

      await FirebaseMessaging.instance.subscribeToTopic('wave-$oid');

      return true;
    } catch (e) {
      await Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
      log('login error $e');
      return false;
    }
  }

  Future<void> logout(String logoutMessage) async {
    String? accessToken = await oauth.getAccessToken();
    Map<String, dynamic> decodedToken =
        JwtDecoder.decode(accessToken.toString());
    String? oid = decodedToken['oid'];
    await FirebaseMessaging.instance.unsubscribeFromTopic('wave-$oid');
    await oauth.logout();
    await Fluttertoast.showToast(
      msg: logoutMessage,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
