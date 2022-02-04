import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app-colors.dart';

class AppTheme {
  AppTheme(this.context);

  final BuildContext context;

  ThemeData defaultTheme() => ThemeData(
        primaryColor: const Color.fromRGBO(79, 88, 100, 1),
        primaryColorDark: AppColors.blue,
        appBarTheme:
            const AppBarTheme(backgroundColor: Color.fromRGBO(79, 88, 100, 1)),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(AppColors.cinzaEscuro),
                textStyle:
                    MaterialStateProperty.all(const TextStyle(fontSize: 30)))),

        //textTheme:
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: AppColors.accent),
      );
}
