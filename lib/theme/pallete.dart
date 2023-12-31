import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class Pallete {
  // Colors
  static const blackColor = Color.fromRGBO(1, 1, 1, 1); // primary color
  static const greyColor = Color.fromRGBO(26, 39, 45, 1); // secondary color
  static const drawerColor = Color.fromRGBO(18, 18, 18, 1);
  static const whiteColor = Colors.white;
  static var redColor = Colors.red.shade500;
  static var blueColor = Colors.blue.shade300;

  // Themes
  static var darkModeAppTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: blackColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: drawerColor,
      iconTheme: IconThemeData(
        color: whiteColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: drawerColor,
    ),
    primaryColor: redColor,
    // useMaterial3: true,
    navigationDrawerTheme:
        const NavigationDrawerThemeData(backgroundColor: drawerColor),
    // backgroundColor:
    //     drawerColor, // will be used as alternative background color
  );

  static var lightModeAppTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: whiteColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(
        color: blackColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: whiteColor,
    ),
    primaryColor: redColor,
    navigationDrawerTheme:
        const NavigationDrawerThemeData(backgroundColor: drawerColor),

    // backgroundColor: whiteColor,
  );
}

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeMode _themeMode;
  ThemeNotifier({ThemeMode themeMode = ThemeMode.dark})
      : _themeMode = themeMode,
        super(Pallete.darkModeAppTheme) {
    getTheme();
  }

  void getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final theme = prefs.getString('theme');

    if (theme == 'light') {
      _themeMode = ThemeMode.light;

      state = Pallete.lightModeAppTheme;
    } else {
      _themeMode = ThemeMode.dark;

      state = Pallete.darkModeAppTheme;
    }
  }

  ThemeMode get mode => _themeMode;

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;

      state = Pallete.lightModeAppTheme;
      prefs.setString("theme", "light");
    } else {
      _themeMode = ThemeMode.dark;

      state = Pallete.darkModeAppTheme;
      prefs.setString("theme", "dark");
    }

    // getTheme();
  }
}
