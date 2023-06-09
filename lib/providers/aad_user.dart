import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:wave/services/aad.dart';

class UserController extends ChangeNotifier {
  AADService aadService = AADService();

  String? username;
  String? email;

  getUserData() async {
    String? token = await aadService.oauth.getAccessToken();
    if (token != null) {
      Map<String, dynamic> jsonToken = JwtDecoder.decode(token);
      username = jsonToken['name'];
      email = jsonToken['preferred_username'];
    }
    notifyListeners();
  }
}
