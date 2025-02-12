import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdScreen extends StatefulWidget {
  const AdScreen({super.key});

  @override
  _AdScreenState createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {
  // Banner Ad
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  // Rewarded Ad
  RewardedAd? _rewardedAd;
  bool _isRewardedAdLoaded = false;

  // Test Ad Unit IDs (Replace with your own real ad unit IDs)
  final String _bannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111'; // Test banner ad unit ID
  final String _rewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917'; // Test rewarded ad unit ID

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _loadRewardedAd();
  }

  // Load Banner Ad
  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Failed to load banner ad: $error');
        },
      ),
    );
    _bannerAd.load();
  }

  // Load Rewarded Ad
  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          setState(() {
            _rewardedAd = ad;
            _isRewardedAdLoaded = true;
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Failed to load rewarded ad: $error');
        },
      ),
    );
  }

  // Show Rewarded Ad
  void _showRewardedAd() {
    if (_isRewardedAdLoaded) {
      _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('User earned reward: ${reward.amount} ${reward.type}');
          // Implement reward logic here (e.g., giving in-app rewards)
        },
      );
    } else {
      print('Rewarded ad is not loaded yet.');
    }
  }

  @override
  void dispose() {
    // Dispose of the ads when the screen is disposed
    _bannerAd.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banner and Rewarded Ads'),
      ),
      body: Column(
        children: [
          // Banner Ad
          if (_isBannerAdReady)
            Container(
              alignment: Alignment.center,
              child: AdWidget(ad: _bannerAd),
              width: _bannerAd.size.width.toDouble(),
              height: _bannerAd.size.height.toDouble(),
            ),
          const SizedBox(height: 20),
          // Rewarded Ad Button
          ElevatedButton(
            onPressed: _showRewardedAd,
            child: Text(_isRewardedAdLoaded
                ? 'Show Rewarded Ad'
                : 'Loading Rewarded Ad...'),
          ),
        ],
      ),
    );
  }
}
