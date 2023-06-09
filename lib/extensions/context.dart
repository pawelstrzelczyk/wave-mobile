import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/wave_localizations.dart';

///[Theme] extentions on [BuildContext]
extension ThemeExtention on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  ThemeData get theme => Theme.of(this);
  Brightness get brightness => Theme.of(this).brightness;
}

///Internationalization extentions on [BuildContext]
extension InternationalizationExtention on BuildContext {
  AppLocalizations get translated => AppLocalizations.of(this)!;
}

///[MediaQuery] extentions on [BuildContext]
extension MediaQueryExtention on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
}

///[ScaffoldMessenger] extentions on [BuildContext]
extension ScaffoldMessengerExtention on BuildContext {
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, style: textTheme.bodySmall),
        backgroundColor: theme.cardColor,
        duration: const Duration(minutes: 1),
        action: SnackBarAction(
          label: translated.ok,
          textColor: textTheme.bodySmall!.color,
          onPressed: () {
            ScaffoldMessenger.of(this).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
