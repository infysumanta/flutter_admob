import 'package:flutter/material.dart';
import 'package:flutter_admob/admob_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  num _rewardedScore = 0;
  String _rewardType = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createBannerAd();
    _createInterstitialAd();
    _createRewardedAd();
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdmobService.bannerAdUnitId!,
        listener: AdmobService.bannerAdListener,
        request: const AdRequest())
      ..load();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdmobService.interstitialVideoAdUnitId!,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) => _interstitialAd = ad,
            onAdFailedToLoad: (AdError error) => _interstitialAd = null));
  }

  void _showInterstitialsAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }

    _createInterstitialAd();
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: AdmobService.rewardAdUnitId!,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad) => _rewardedAd = ad,
            onAdFailedToLoad: (error) => _rewardedAd = null));
  }

  void _showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _createRewardedAd();
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _createRewardedAd();
      });
      _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
        print("${reward.amount} ${reward.type}");
        setState(() {
          _rewardType = reward.type;
          // _rewardedScore += reward.amount.toString();
          _rewardedScore++;
        });
      });
      _rewardedAd = null;
    }
    _createRewardedAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter AdMob'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Rewared  $_rewardedScore"),
              ElevatedButton(
                onPressed: _showInterstitialsAd,
                child: Text("Intertials Ads"),
              ),
              ElevatedButton(
                onPressed: _showRewardedAd,
                child: Text("Reward Ads"),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _bannerAd != null
            ? Container(
                height: 50,
                child: AdWidget(ad: _bannerAd!),
              )
            : Container());
  }
}
