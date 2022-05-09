
import 'package:cached_network_image/cached_network_image.dart';
import 'package:destiny/controllers/appcontroller.dart';
import 'package:destiny/views/detailreplayscreen.dart';
import 'package:destiny/views/homescreen.dart';
import 'package:destiny/views/menuscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';

import '../constants.dart';
import 'ad_helper.dart';

class ReplayScreenPlus extends StatefulWidget {
  ReplayScreenPlus({Key? key}) : super(key: key);

  @override
  State<ReplayScreenPlus> createState() => _ReplayScreenPlusState();
}

class _ReplayScreenPlusState extends State<ReplayScreenPlus>  with AutomaticKeepAliveClientMixin<ReplayScreenPlus>{
  final AppDetailsController c = Get.put(AppDetailsController());
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  final logger=Logger();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

   InterstitialAd? _interstitialAd;

   bool _isInterstitialAdReady = false;
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

   @override
  void initState() {
    // TODO: implement initState
     WidgetsFlutterBinding.ensureInitialized();
     MobileAds.instance.initialize();
    super.initState();
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          this._interstitialAd = ad;
          _isInterstitialAdReady = true;
        }, onAdFailedToLoad: (LoadAdError error) {
          print("failed to Load Interstitial Ad ${error.message}");
        }));

     _bannerAd = BannerAd(
       // Change Banner Size According to Ur Need
         size: AdSize.mediumRectangle,
         adUnitId: AdHelper.bannerAdUnitId,
         listener: BannerAdListener(onAdLoaded: (_) {
           setState(() {
             _isBannerAdReady = true;
           });
         }, onAdFailedToLoad: (ad, LoadAdError error) {
           print("Failed to Load A Banner Ad${error.message}");
           _isBannerAdReady = false;
           ad.dispose();
         }),
         request: AdRequest())
       ..load();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _interstitialAd?.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  Future<bool> _onBackPressed() async{
    //Get.to(MenuScreen());
    Navigator.of(context).pop();

    if(_isInterstitialAdReady){
      _interstitialAd?.show();
    }
    Get.to(MenuScreen());
    return false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //logger.i(c.Allemissions.length);
    return WillPopScope(
      onWillPop:_onBackPressed,
      child: Scaffold(
        key: _scaffoldKey,
       appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Image.asset('assets/images/logodest.png',
            width: 130,
          ),
          backgroundColor: Colors.white,
        ),
        body: Stack(
          children: [
             CustomScrollView(
              slivers: <Widget>[
            SliverList(
            delegate: SliverChildListDelegate([
              Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 10,),
              margin: EdgeInsets.only(top: 0),
              child: Text(
                "Programs",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "CeraPro",
                    fontWeight: FontWeight.bold,
                    color: colorPrimary),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Stack(
                children: [
                  Container(
                    height: 5,
                    width: 200,
                    color: Colors.grey,
                  ),
                  Container(
                    height: 2,
                    color: Colors.grey,
                    width: 200,
                    alignment: Alignment.bottomCenter,
                  ),
                ],
              ),
            ),
              if (_isBannerAdReady)
                Container(
                  height: 50,
                  width: _bannerAd?.size.width.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
             Padding(
               padding: const EdgeInsets.all(2.0),
               child: Container(
                 height: MediaQuery.of(context).size.height-100,
                 width: MediaQuery.of(context).size.width,
                 child:
               Obx(() {
                 if (c.isLoading.value)
                   return Center(child: CircularProgressIndicator());
                 else
                   return
                     GridView.builder(
                         gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                             maxCrossAxisExtent: 200,
                             childAspectRatio: 3 / 2,
                             crossAxisSpacing: 14,
                             mainAxisSpacing: 14),
                         itemCount: c.Allemissions.length,
                         itemBuilder: (BuildContext ctx, index) {
                           return GestureDetector(
                             onTap: (){
                               Get.to(DetailReplayScreen(title: c.Allemissions[index].title, url: c.Allemissions[index].feedUrl));
                             },
                             child: Container(
                               alignment: Alignment.center,
                               child: Column(
                                 children: [
                                   GestureDetector(
                                     onTap: () {
                                       Get.to(DetailReplayScreen(title: c.Allemissions[index].title, url: c.Allemissions[index].feedUrl));
                                     },
                                     child: Stack(
                                       children: [
                                         ClipRRect(
                                           borderRadius: BorderRadius.circular(4),
                                           child: CachedNetworkImage(
                                             height: 110,
                                             width: 180,
                                             imageUrl: c.Allemissions[index].logoUrl,
                                             fit: BoxFit.cover,
                                             placeholder: (context, url) =>
                                                 Image.asset(
                                                   "assets/images/logodestiny.png",
                                                   fit: BoxFit.contain,
                                                   height: 110,
                                                   width: 180,
                                                 ),
                                             errorWidget: (context, url, error) =>
                                                 Image.asset(
                                                   "assets/images/logodestiny.png",
                                                   fit: BoxFit.contain,
                                                   height: 110,
                                                   width: 180,
                                                 ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                   Text(c.Allemissions[index].title,style: TextStyle(
                                       fontWeight: FontWeight.bold,
                                       fontFamily: "CeraPro",
                                       color: Colors.black
                                   ),
                                     textAlign: TextAlign.center,
                                   ),
                                 ],
                               ),
                             ),
                           );
                         });
               }),
               ),
             )
            ])),
              ],
            ),
      ]
        ),
      ),
    );
  }
}
