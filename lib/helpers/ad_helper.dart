import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vpn_basic_project/controllers/native_ad_controller.dart';
import 'package:vpn_basic_project/helpers/my_dialogues.dart';

class AdHelper {
  static Future<void> initAds() async {
    await MobileAds.instance.initialize();
  }

//Interstitial Ad
  static void showInterstitialAd({required VoidCallback onComplete}) {
    MyDialogues.showProgress();
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          ad.fullScreenContentCallback =
              FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
            onComplete();
          });
          Get.back();
          ad.show();
        }, onAdFailedToLoad: (err) {
          Get.back();
          log('failed to load an add:${err.message}');
          onComplete();
        }));
  }

//Native Ad
  static NativeAd loadNativeAd({required NativeAdController adController}) {
    return NativeAd(
        adUnitId: 'ca-app-pub-3940256099942544/2247696110',
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            log('$NativeAd loaded.');
            adController.AdLoaded.value = true;
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            log('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle:
            NativeTemplateStyle(templateType: TemplateType.small))
      ..load();
  }

  static void showRewardedAd({required VoidCallback onComplete}) {
    MyDialogues.showProgress();
    RewardedAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/5224354917',
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
        
          Get.back();

          //reward Listener
          ad.show(
              onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
            onComplete();
          });
        }, onAdFailedToLoad: (err) {
          Get.back();
          log('failed to load an add:${err.message}');
          // onComplete();
        }));
  }
}
