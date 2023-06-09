import 'package:flutter/material.dart';

///Colors used in app
class WaveThemeExtention extends ThemeExtension<WaveThemeExtention> {
  const WaveThemeExtention({
    required this.greenTopColor,
    required this.greenBottomColor,
    required this.patrolTopBlueColor,
    required this.patrolBottomBlueColor,
    required this.nothingToDisplayTopColor,
    required this.nothingToDisplayBottomColor,
    required this.darkThemePrimary,
    required this.lighThemePrimary,
  });
  final Color? greenTopColor;
  final Color? greenBottomColor;
  final Color? patrolTopBlueColor;
  final Color? patrolBottomBlueColor;
  final Color? nothingToDisplayTopColor;
  final Color? nothingToDisplayBottomColor;
  final Color? darkThemePrimary;
  final Color? lighThemePrimary;

  @override
  ThemeExtension<WaveThemeExtention> copyWith({
    Color? greenTopColor,
    Color? greenBottomColor,
    Color? patrolTopBlueColor,
    Color? patrolBottomBlueColor,
    Color? nothingToDisplayTopColor,
    Color? nothingToDisplayBottomColor,
    Color? darkThemePrimary,
    Color? lighThemePrimary,
  }) {
    return WaveThemeExtention(
      greenTopColor: greenTopColor ?? this.greenTopColor,
      greenBottomColor: greenBottomColor ?? this.greenBottomColor,
      patrolTopBlueColor: patrolTopBlueColor ?? this.patrolTopBlueColor,
      patrolBottomBlueColor:
          patrolBottomBlueColor ?? this.patrolBottomBlueColor,
      nothingToDisplayTopColor:
          nothingToDisplayTopColor ?? this.nothingToDisplayTopColor,
      nothingToDisplayBottomColor:
          nothingToDisplayBottomColor ?? this.nothingToDisplayBottomColor,
      darkThemePrimary: darkThemePrimary ?? this.darkThemePrimary,
      lighThemePrimary: lighThemePrimary ?? this.lighThemePrimary,
    );
  }

  @override
  ThemeExtension<WaveThemeExtention> lerp(
      ThemeExtension<WaveThemeExtention>? other, double t) {
    if (other is! WaveThemeExtention) return this;
    return WaveThemeExtention(
      greenBottomColor: Color.lerp(greenBottomColor, other.greenBottomColor, t),
      greenTopColor: Color.lerp(greenTopColor, other.greenTopColor, t),
      patrolBottomBlueColor:
          Color.lerp(patrolBottomBlueColor, other.patrolBottomBlueColor, t),
      patrolTopBlueColor:
          Color.lerp(patrolTopBlueColor, other.patrolTopBlueColor, t),
      nothingToDisplayBottomColor: Color.lerp(
          nothingToDisplayBottomColor, other.nothingToDisplayBottomColor, t),
      nothingToDisplayTopColor: Color.lerp(
          nothingToDisplayTopColor, other.nothingToDisplayTopColor, t),
      darkThemePrimary: Color.lerp(darkThemePrimary, other.darkThemePrimary, t),
      lighThemePrimary: Color.lerp(lighThemePrimary, other.lighThemePrimary, t),
    );
  }

  static const dark = WaveThemeExtention(
    greenTopColor: Color(0xff4caf50),
    greenBottomColor: Color(0xff125c06),
    patrolTopBlueColor: Color(0xff0085ff),
    patrolBottomBlueColor: Color(0xff003d75),
    nothingToDisplayTopColor: Color(0xff585858),
    nothingToDisplayBottomColor: Color(0xff303030),
    darkThemePrimary: Color(0xfc051f37),
    lighThemePrimary: Color(0xffb0c3e8),
  );

  static const light = WaveThemeExtention(
    greenTopColor: Color(0xff4CAF50),
    greenBottomColor: Color(0xff125C06),
    patrolTopBlueColor: Color(0xff0085FF),
    patrolBottomBlueColor: Color(0xff003D75),
    nothingToDisplayTopColor: Color(0xffAFAFAF),
    nothingToDisplayBottomColor: Color(0xff444444),
    darkThemePrimary: Color(0xfc051f37),
    lighThemePrimary: Color(0xffb0c3e8),
  );
}
