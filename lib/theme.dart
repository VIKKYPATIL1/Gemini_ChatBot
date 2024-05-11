import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final designtheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color.fromRGBO(17, 33, 45, 1),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    backgroundColor: Color.fromRGBO(37, 55, 69, 1),
    scrolledUnderElevation: 40,
    elevation: 10,
    shadowColor: Color.fromRGBO(155, 168, 171, 1),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color.fromRGBO(37, 55, 69, 1),
    elevation: 10,
    enableFeedback: true,
    showSelectedLabels: true,
    // type: BottomNavigationBarType.shifting,
    selectedIconTheme: IconThemeData(
      color: Color.fromRGBO(204, 208, 207, 1),
      fill: BorderSide.strokeAlignCenter,
      shadows: [
        Shadow(color: Color.fromRGBO(155, 168, 171, 1), blurRadius: 10)
      ],
    ),
  ),
  cardTheme: const CardTheme(
      color: Color.fromRGBO(74, 92, 106, 1),
      elevation: 10,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40))),
      shadowColor: Color.fromRGBO(155, 168, 171, 1)),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      alignment: Alignment.center,
      elevation: MaterialStatePropertyAll(10),
      backgroundColor: MaterialStatePropertyAll(
        Color.fromRGBO(155, 168, 171, 1),
      ),
      fixedSize: MaterialStatePropertyAll(
        Size.fromWidth(200),
      ),
    ),
  ),
);
