import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/helpers/ad_helper.dart';
import 'package:vpn_basic_project/helpers/my_dialogues.dart';
import 'package:vpn_basic_project/helpers/pref.dart';
import 'package:vpn_basic_project/models/vpn.dart';
import 'package:vpn_basic_project/models/vpn_config.dart';
import 'package:vpn_basic_project/services/vpn_engine.dart';

class HomeController extends GetxController {
  final Rx<Vpn> vpn = Pref.vpn.obs; //this will load the data in controller

  final vpnState = VpnEngine.vpnDisconnected.obs;

  Future<void> connectToVpn() async {
    if (vpn.value.OpenVPNConfigDataBase64.isEmpty) {
      MyDialogues.info(msg: 'Select a Location by clicking\'Change Location\'');
      return;
    }

    if (vpnState.value == VpnEngine.vpnDisconnected) {
      final data = const Base64Decoder().convert(vpn.value.OpenVPNConfigDataBase64);
      final config = const Utf8Decoder().convert(data);
      final vpnConfig = VpnConfig(
          country: vpn.value.CountryLong,
          username: 'vpn',
          password: 'vpn',
          config: config);
//code to show interstitialAd and then connect to vpn
AdHelper.showInterstitialAd(onComplete: () async {    
    ///Start if stage is disconnected
     await VpnEngine.startVpn(vpnConfig);});
    } else {
      ///Stop if stage is "not" disconnected

      VpnEngine.stopVpn();
    }
  }

//VPN Button color
  Color get getButtonColor {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return Colors.blue;

      case VpnEngine.vpnConnected:
        return Colors.green;

      default:
        return Colors.orange;
    }
  }

  //VPN Button string
  String get getButtonText {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return 'Tap to Connect';

      case VpnEngine.vpnConnected:
        return 'Disconnect';

      default:
        return 'Connecting...';
    }
  }
}
