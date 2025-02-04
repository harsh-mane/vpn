import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:vpn_basic_project/helpers/ad_helper.dart';
import 'package:vpn_basic_project/helpers/pref.dart';
import 'package:vpn_basic_project/screens/splash_screen.dart';

//for doing dynamic calculation we creating MediaQuery object and accessing it throughout the application
late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //enter full screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  await Firebase.initializeApp();

  await Pref.initializeHive();
  await AdHelper.initAds();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SecureSphere',
      home: const SplashScreen(),

      //
      theme:
          ThemeData(appBarTheme: const AppBarTheme(centerTitle: true, elevation: 2)),
      themeMode: Pref.isDarkMode ? ThemeMode.dark : ThemeMode.light,

//dark theme
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 2)),
      debugShowCheckedModeBanner: false,
    );
  }
}

extension AppTheme on ThemeData {
  Color get lightText => Pref.isDarkMode ? Colors.white70 : Colors.black54;
  Color get bottomNav => Pref.isDarkMode ? Colors.white12 : Colors.blue;
}
