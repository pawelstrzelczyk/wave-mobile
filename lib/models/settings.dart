import 'package:flutter/material.dart';

class WaveTheme {
  final String name;
  final ThemeMode mode;
  final Color primaryColor;
  final Icon icon;

  WaveTheme(
    this.name,
    this.mode,
    this.primaryColor,
    this.icon,
  );
}

class WaveLocale {
  final String name;
  final String shortName;
  final String longName;
  final String unicodeFlag;

  WaveLocale(
    this.name,
    this.shortName,
    this.longName,
    this.unicodeFlag,
  );
}
