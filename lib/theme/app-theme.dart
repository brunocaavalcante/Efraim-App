import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app-colors.dart';

class AppTheme {
  AppTheme(this.context);

  final BuildContext context;

  ThemeData defaultTheme() => ThemeData(
        primaryColor: const Color.fromRGBO(79, 88, 100, 1),
        primaryColorDark: AppColors.accent,
        buttonColor: const Color.fromRGBO(79, 88, 100, 1),
        accentColor: AppColors.accent,
        appBarTheme:
            AppBarTheme(backgroundColor: const Color.fromRGBO(79, 88, 100, 1)),

        //textTheme:
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );
}
