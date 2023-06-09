import 'package:flutter/material.dart';
import 'package:wave/components/custom_ui_constants/colors.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xfc051f37),
  cardColor: const Color(0xfc12435B),
  extensions: const <ThemeExtension<dynamic>>[WaveThemeExtention.dark],
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xfc051f37),
    brightness: Brightness.dark,
  ),
  // colorScheme: const ColorScheme.dark(
  //   primary: Color(0xfc12435B),
  //   //datepicker headline, timepicker background
  //   surface: Color(0xfc051f37),
  //   onSurface: Color(0xffffffff),
  // ),
  timePickerTheme: const TimePickerThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(30.0),
      ),
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color.fromARGB(255, 255, 154, 21),
  ),
  sliderTheme: const SliderThemeData(
    valueIndicatorTextStyle: TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
  ),
  fontFamily: 'Roboto',
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    iconTheme: IconThemeData(
      color: Colors.white,
      size: 45,
    ),
    scrolledUnderElevation: 0,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xfc051f37),
    modalBackgroundColor: Color(0xfc051f37),
    // modalElevation: 8.0,
    // elevation: 8.0,
  ),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.all(
      const Color.fromARGB(255, 255, 154, 21),
    ),
    overlayColor: MaterialStateProperty.all(
      const Color.fromARGB(255, 255, 154, 21),
    ),
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: Colors.white,
  ),
  tabBarTheme: TabBarTheme(
    overlayColor: MaterialStateProperty.all(
      Colors.white38,
    ),
    indicatorSize: TabBarIndicatorSize.tab,
    indicator: const UnderlineTabIndicator(
      borderSide: BorderSide(
        color: Color(0xfc12435B),
        width: 2,
        style: BorderStyle.solid,
      ),
    ),
  ),
  primaryColorDark: const Color(0xfc051f37),
  dialogTheme: const DialogTheme(
    titleTextStyle: TextStyle(
      color: Colors.white,
    ),
    contentTextStyle: TextStyle(
      color: Colors.white,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all(
        const TextStyle(
          color: Colors.white,
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
    backgroundColor: Color(0xfc12435B),
    splashColor: Color.fromARGB(251, 55, 122, 155),
  ),
  canvasColor: const Color(0xfc12435B),
  highlightColor: Colors.white,
  navigationBarTheme: NavigationBarThemeData(
    labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    labelTextStyle: MaterialStateProperty.all(
      const TextStyle(color: Colors.white, fontSize: 14),
    ),
    iconTheme: MaterialStateProperty.all(
      const IconThemeData(
        color: Colors.white,
        size: 26,
      ),
    ),
    surfaceTintColor: const Color(0xfc051f37),
    backgroundColor: const Color(0xfc051f37),
    indicatorColor: const Color.fromARGB(174, 3, 70, 104),
  ),
  focusColor: Colors.orange,
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
    labelStyle: TextStyle(
      fontWeight: FontWeight.w300,
      color: Colors.grey,
      fontSize: 20,
      letterSpacing: 1.0,
    ),
    errorStyle: TextStyle(
      fontSize: 10,
    ),
    hintStyle: TextStyle(
      fontWeight: FontWeight.w300,
      color: Colors.grey,
      fontSize: 20,
      letterSpacing: 1.0,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 255, 154, 21)),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  ),
  hintColor: Colors.white,
  textTheme: const TextTheme(
    headlineMedium: TextStyle(
      color: Colors.white,
    ),
    // headlineSmall: TextStyle(
    //   color: Colors.white,
    // ),
    headlineLarge: TextStyle(
      color: Colors.white,
    ),
    //values in duration picker
    titleMedium: TextStyle(
      color: Colors.white,
    ),
    titleLarge: TextStyle(
      color: Colors.white,
    ),
    //actions in dialogs
    labelLarge: TextStyle(
      color: Colors.white,
    ),
    //value in duration picker
    displayMedium: TextStyle(
      color: Colors.white,
    ),
    displaySmall: TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    //time picker hour digits
    bodyLarge: TextStyle(
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    labelMedium: TextStyle(
      color: Colors.white,
      fontSize: 25,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
    ),
    displayLarge: TextStyle(
      color: Colors.white,
      fontSize: 28,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
    ),
    labelSmall: TextStyle(
      color: Colors.white,
    ),
  ),
);
