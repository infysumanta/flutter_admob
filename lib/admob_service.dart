import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobService {
  static String? get bannerAdUnitId {
    return 'ca-app-pub-3940256099942544/6300978111';
  }

  static String? get interstitialAdUnitId {
    return 'ca-app-pub-3940256099942544/1033173712';
  }

  static String? get interstitialVideoAdUnitId {
    return 'ca-app-pub-3940256099942544/8691691433';
  }

  static String? get rewardAdUnitId {
    return 'ca-app-pub-3940256099942544/5224354917';
  }

  static String? get rewardVideoAdUnitId {
    return 'ca-app-pub-3940256099942544/5354046379';
  }

  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint("Ad Loaded"),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint('Ad failed to load: $error');
    },
    onAdOpened: (ad) => debugPrint('Ad opened'),
    onAdClosed: (ad) => debugPrint('Ad closed'),
    onAdClicked: (ad) => debugPrint('Ad clicked'),
  );
}
