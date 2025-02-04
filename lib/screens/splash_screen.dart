import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:vpn_basic_project/main.dart';
import 'package:vpn_basic_project/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//off is equivalent to push replacement
      Get.off(() => HomeScreen());
      //pushreplacement use because user will see once splashscreen and reaches to homescreen user dont want to see again splashscreen
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (_) => HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    //initializing mediaquery for getting device screen size
    mq = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        //app logo
        Positioned(
            left: mq.width * .2,
            top: mq.height * .2,
            width: mq.width * .7,
            child: Image.asset(
              'assets/images/vpn_logo.png',
            )),

        //label
        Positioned(
            width: mq.width,
            bottom: mq.height * .15,
            child: Text(
              'Made in India ',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).lightText, letterSpacing: 1.25, fontSize: 24),
            )),
      ],
    ));
    //stack helps us to positionuing the widget
  }
}
