import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdWidgetContainer extends StatefulWidget {
  @override
  _AdWidgetContainerState createState() => _AdWidgetContainerState();
}

class _AdWidgetContainerState extends State<AdWidgetContainer> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-5088112928883529/4631855782',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Ad failed to load: ${error.message}');
        },
      ),
    );

    _bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isAdLoaded 
        ? Container(
            width: _bannerAd.size.width.toDouble(),
            height: _bannerAd.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd),
          ) 
        : Container(
            width: 320, // Reklam boyutu yüklenene kadar geçici bir boyut
            height: 50,
            color: Colors.grey, // Geçici olarak gri bir kutu
            child: Center(child: CircularProgressIndicator()),
          ),
    );
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }
  
}
