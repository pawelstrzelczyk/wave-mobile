import 'package:flutter/material.dart';
import 'package:wave/components/custom_ui_constants/colors.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  pageTransitionsTheme: const PageTransitionsTheme(
      builders: {TargetPlatform.iOS: CupertinoPageTransitionsBuilder()}),
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xffc5cad9),
  // splashColor: const Color.fromARGB(249, 48, 121, 218),
  splashColor: const Color.fromARGB(255, 124, 124, 124).withOpacity(0.2),
  cardColor: const Color(0xffb0c3e8),
  extensions: const <ThemeExtension<dynamic>>[WaveThemeExtention.light],
  iconTheme: const IconThemeData(
    color: Colors.black,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color.fromARGB(255, 197, 112, 0),
  ),
  sliderTheme: const SliderThemeData(
    valueIndicatorTextStyle: TextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 216, 220, 243),
    brightness: Brightness.light,
  ),
  timePickerTheme: const TimePickerThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(30.0),
      ),
    ),
  ),
  fontFamily: 'Roboto',
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    iconTheme: IconThemeData(
      color: Colors.black,
      size: 45,
    ),
    scrolledUnderElevation: 0,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color.fromARGB(255, 204, 204, 204),
    modalBackgroundColor: Color.fromARGB(255, 204, 204, 204),
    modalElevation: 8.0,
    elevation: 8.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12.0),
        topRight: Radius.circular(12.0),
      ),
    ),
  ),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.all(
      const Color.fromARGB(255, 197, 112, 0),
    ),
    overlayColor: MaterialStateProperty.all(
      const Color.fromARGB(255, 197, 112, 0),
    ),
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: Colors.black,
  ),
  tabBarTheme: TabBarTheme(
    indicatorSize: TabBarIndicatorSize.tab,
    labelColor: Colors.black,
    indicator: const UnderlineTabIndicator(
      borderSide: BorderSide(
        color: Colors.black,
        width: 2,
        style: BorderStyle.solid,
      ),
    ),
    overlayColor:
        MaterialStateProperty.all(const Color.fromARGB(181, 125, 175, 223)),
  ),
  primaryColorDark: const Color(0xfc051f37),
  dialogTheme: const DialogTheme(
    titleTextStyle: TextStyle(
      color: Colors.black,
    ),
    contentTextStyle: TextStyle(
      color: Colors.black,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all(
        const TextStyle(
          color: Colors.black,
        ),
      ),
      shadowColor: MaterialStateProperty.all(
        Colors.transparent,
      ),
      backgroundColor: MaterialStateProperty.all(
        Colors.transparent,
      ),
      padding: MaterialStateProperty.all(
        EdgeInsets.zero,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all(
        EdgeInsets.zero,
      ),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromARGB(255, 80, 114, 182),
    splashColor: Color.fromARGB(249, 94, 155, 204),
    foregroundColor: Colors.black,
  ),
  canvasColor: const Color.fromARGB(255, 80, 114, 182),
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    labelTextStyle: MaterialStateProperty.all(
      const TextStyle(color: Colors.black, fontSize: 14),
    ),
    iconTheme: MaterialStateProperty.all(
      const IconThemeData(
        color: Colors.black,
        size: 26,
      ),
    ),
    surfaceTintColor: const Color(0xffc5cad9),
    backgroundColor: const Color(0xffc5cad9),
    indicatorColor: const Color.fromARGB(255, 80, 114, 182),
  ),
  focusColor: Colors.orange,
  inputDecorationTheme: InputDecorationTheme(
    border: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
    labelStyle: TextStyle(
      fontWeight: FontWeight.w300,
      color: Colors.grey[800],
      fontSize: 20,
      letterSpacing: 1.0,
    ),
    errorStyle: const TextStyle(
      fontSize: 10,
    ),
    hintStyle: TextStyle(
      fontWeight: FontWeight.w300,
      color: Colors.grey[800],
      fontSize: 20,
      letterSpacing: 1.0,
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 255, 154, 21)),
    ),
    disabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
  ),
  hintColor: Colors.black,
  textTheme: const TextTheme(
    headlineMedium: TextStyle(
      color: Colors.black,
    ),
    // headlineSmall: TextStyle(
    //   color: Colors.white,
    // ),
    headlineLarge: TextStyle(
      color: Colors.black,
    ),
    //values in duration picker
    titleMedium: TextStyle(
      color: Colors.black,
    ),
    titleLarge: TextStyle(
      color: Colors.black,
    ),
    //actions in dialogs
    labelLarge: TextStyle(
      color: Colors.black,
    ),
    //value in duration picker
    displayMedium: TextStyle(
      color: Colors.black,
    ),
    displaySmall: TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    //time picker hour digits
    bodyLarge: TextStyle(
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    labelMedium: TextStyle(
      color: Colors.black,
      fontSize: 25,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
    ),
    displayLarge: TextStyle(
      color: Colors.black,
      fontSize: 28,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
    ),
    labelSmall: TextStyle(
      color: Colors.black,
    ),
  ),
);
