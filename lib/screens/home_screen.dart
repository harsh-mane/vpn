import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/controllers/home_controller.dart';
import 'package:vpn_basic_project/helpers/ad_helper.dart';
import 'package:vpn_basic_project/helpers/pref.dart';
import 'package:vpn_basic_project/main.dart';
import 'package:vpn_basic_project/models/vpn_status.dart';
import 'package:vpn_basic_project/screens/location_screen.dart';
import 'package:vpn_basic_project/screens/network_test_screen.dart';
import 'package:vpn_basic_project/widgets/count_down_timer.dart';
import 'package:vpn_basic_project/widgets/home_card.dart';
import 'package:vpn_basic_project/widgets/watch_ad_dialogue.dart';
import '../services/vpn_engine.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    ///Add listener to update vpn state
    VpnEngine.vpnStageSnapshot().listen((event) {
      _controller.vpnState.value = event;
    });

    return Scaffold(
      //appBar
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.home),
        title: const Text('SecureSphere'),
        actions: [
          IconButton(
              onPressed: () {
                Get.dialog(WatchAdDialogue(
                  onComplete: () {    AdHelper.showRewardedAd(onComplete: () {Get.changeThemeMode(
                    Pref.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                Pref.isDarkMode = !Pref.isDarkMode;});},
                ));
              },
              icon: const Icon(
                Icons.brightness_3_outlined,
              )),
          IconButton(
              padding: const EdgeInsets.only(right: 8),
              onPressed: () => Get.to(() => const NetworkTestScreen()),
              icon: const Icon(
                Icons.info_outline,
              )),
        ],
      ),

      bottomNavigationBar: _changeLocation(context),
      //body
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        //vpn Button
        Obx(() => _vpnButton()),

        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //country flag
              HomeCard(
                  title: _controller.vpn.value.CountryLong.isEmpty
                      ? "Country"
                      : _controller.vpn.value.CountryLong,
                  subTitle: "Free",
                  icon: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    child: _controller.vpn.value.CountryLong.isEmpty
                        ? const Icon(
                            Icons.vpn_lock_rounded,
                            size: 30,
                            color: Colors.white,
                          )
                        : null,
                    backgroundImage: _controller.vpn.value.CountryLong.isEmpty
                        ? null
                        : AssetImage(
                            'assets/flags/${_controller.vpn.value.CountryShort.toLowerCase()}.png'),
                  )),

              //ping time
              HomeCard(
                  title: _controller.vpn.value.CountryLong.isEmpty
                      ? '100 ms'
                      : '${_controller.vpn.value.Ping} ms',
                  subTitle: "PING",
                  icon: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.amber,
                      child: Icon(
                        Icons.equalizer_sharp,
                        color: Colors.white,
                        size: 30,
                      ))),
            ],
          ),
        ),

        StreamBuilder<VpnStatus?>(
          initialData: VpnStatus(),
          stream: VpnEngine.vpnStatusSnapshot(),
          builder: (context, snapshot) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Download
              HomeCard(
                  title: "${snapshot.data?.byteIn ?? "0 kbps"}",
                  subTitle: "Download",
                  icon: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.lightGreen,
                      child: Icon(
                        Icons.arrow_downward_outlined,
                        size: 30,
                        color: Colors.white,
                      ))),

//Upload
              HomeCard(
                  title: "${snapshot.data?.byteOut ?? "0 kbps"}",
                  subTitle: "Upload",
                  icon: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.arrow_upward_outlined,
                        color: Colors.white,
                        size: 30,
                      ))),
            ],
          ),
        ),
      ]),
    );
  }

//VPN button
  Widget _vpnButton() => Column(
        children: [
          //button
          Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                _controller.connectToVpn();
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _controller.getButtonColor),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _controller.getButtonColor),
                  child: Container(
                    width: mq.height * .14,
                    height: mq.height * .14,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _controller.getButtonColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Icon
                        const Icon(
                          Icons.power_settings_new_rounded,
                          size: 28,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 4),
                        //Text
                        Text(
                          _controller.getButtonText,
                          style: const TextStyle(
                              fontSize: 12.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          Container(
            margin:
                EdgeInsets.only(top: mq.height * .015, bottom: mq.height * .02),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(15)),
            child: Text(
              _controller.vpnState.value == VpnEngine.vpnDisconnected
                  ? 'Not Connected'
                  : _controller.vpnState.replaceAll('_', ' ').toUpperCase(),
              style: const TextStyle(
                fontSize: 12.5,
                color: Colors.white,
              ),
            ),
          ),
          //Count Down Timer
          Obx(
            () => CountDownTimer(
              startTimer: _controller.vpnState.value == VpnEngine.vpnConnected,
            ),
          ),
        ],
      );

//Bottom Nav to change location
  Widget _changeLocation(BuildContext context) => SafeArea(
        child: Semantics(
          button: true,
          child: InkWell(
            onTap: () => Get.to(() => LocationScreen()),
            child: Container(
                color: Theme.of(context).bottomNav,
                padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
                height: 60,
                child: const Row(
                  children: [
                    Icon(
                      CupertinoIcons.globe,
                      color: Colors.white,
                      size: 28,
                    ),
                    SizedBox(
                      width: 10,
                    ),

                    //text
                    Text(
                      'change location',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    Spacer(),

                    //icon
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Colors.blue,
                        size: 26,
                      ),
                    )
                  ],
                )),
          ),
        ),
      );
}
