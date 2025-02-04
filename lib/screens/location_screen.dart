import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:vpn_basic_project/controllers/location_controller.dart';
import 'package:vpn_basic_project/controllers/native_ad_controller.dart';
import 'package:vpn_basic_project/helpers/ad_helper.dart';

import 'package:vpn_basic_project/main.dart';
import 'package:vpn_basic_project/widgets/vpn_card.dart';

class LocationScreen extends StatelessWidget {
  LocationScreen({super.key});
  //creating object
  //and creating it private this will use only in this class or for this screen only
  final _controller = LocationController();

  final _adController = NativeAdController();
  @override
  Widget build(BuildContext context) {
    if (_controller.vpnList.isEmpty) _controller.getVpnData();
    _adController.ad = AdHelper.loadNativeAd(adController: _adController);
    return Obx(
      () => Scaffold(
        //appBar
        appBar: AppBar(
          title: Text('VPN LOCATION (${_controller.vpnList.length})'),
        ),

        //bottomNavigation
        bottomNavigationBar:
        _adController.ad != null && _adController.AdLoaded.isTrue?
         SafeArea(child: SizedBox(height: 86,child: AdWidget(ad: _adController.ad!))):null,

        //Refresh Button
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10, right: 10),
          child: FloatingActionButton(
            onPressed: () => _controller.getVpnData(),
            child: const Icon(CupertinoIcons.refresh_circled),
          ),
        ),
        body: _controller.isLoading.value
            ? _loadingWidget()
            : _controller.vpnList.isEmpty
                ? _noVPNFound()
                : _vpnData(),
      ),
    );
  }

//instead of ListView() we are using ListView.builder because we have large amount of items
  _vpnData() => ListView.builder(
        itemCount: _controller.vpnList.length - 1,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
            top: mq.height * .015,
            bottom: mq.height * .1,
            left: mq.width * .04,
            right: mq.width * .04),
        itemBuilder: (ctx, i) => VpnCard(vpn: _controller.vpnList[i]),
      );

  //creating seperate function for loading
  _loadingWidget() => SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //lottie animation
            LottieBuilder.asset(
              'assets/lottie/loading_lottie.json',
              width: mq.width * .7,
            ),
            //text
            const Text(
              'Loading VPNs ...',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  //if we dont have any vpn to show
  _noVPNFound() => const Center(
        child: Text(
          'VPNs Not Found !!',
          style: TextStyle(
              fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold),
        ),
      );
}
