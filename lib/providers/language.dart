import 'package:flutter/cupertino.dart';

class LocaleController extends ChangeNotifier {
  String waveLocale = 'pl';

  setWaveLocale(String locale) {
    waveLocale = locale;
    notifyListeners();
  }
}
