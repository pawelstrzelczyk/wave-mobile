import 'package:flutter/material.dart';
import 'package:wave/services/aad.dart';

enum LoginState { waiting, logging, logged, failed }

class LoginController extends ChangeNotifier {
  LoginState loginState = LoginState.waiting;
  AADService aadService = AADService();

  Future<void> login() async {
    loginState = LoginState.logging;
    notifyListeners();
    if (await aadService.login()) {
      loginState = LoginState.logged;
      notifyListeners();
    } else {
      loginState = LoginState.failed;
      notifyListeners();
    }
  }

  Future<void> logout(String logoutMessage) async {
    await aadService.logout(logoutMessage);
    loginState = LoginState.waiting;
    notifyListeners();
  }
}
