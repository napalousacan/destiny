
import 'package:cached_network_image/cached_network_image.dart';
import 'package:destiny/controllers/appcontroller.dart';
import 'package:destiny/views/detailreplayscreen.dart';
import 'package:destiny/views/homescreen.dart';
import 'package:destiny/views/menuscreen.dart';
import 'package:destiny/views/playlist_youtube.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jiffy/jiffy.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_api/youtube_api.dart';

import '../constants.dart';
import 'ad_helper.dart';

class ReplayScreen extends StatefulWidget {
   ReplayScreen({Key? key}) : super(key: key);

  @override
  State<ReplayScreen> createState() => _ReplayScreenState();
}

class _ReplayScreenState extends State<ReplayScreen>  with AutomaticKeepAliveClientMixin<ReplayScreen>{
  final AppDetailsController c = Get.put(AppDetailsController());
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  final logger=Logger();
  late YoutubeAPI ytApi;
  late YoutubeAPI ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  bool isLoading = true;
  bool isLoadingPlaylist = true;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

   InterstitialAd? _interstitialAd;

   bool _isInterstitialAdReady = false;
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  Future<void> callAPI() async {
    print('UI callled');
    await Jiffy.locale("fr");
    ytResult = await ytApi.channel(c.AppDetailsList[0].appYoutubeUid);
    logger.i(ytResult[0].title);
    setState(() {
      print('UI Updated');
      isLoading = false;
      callAPIPlaylist();
    });
  }

  Future<void> callAPIPlaylist() async {
    print('UI callled');
    await Jiffy.locale("fr");
    ytResultPlaylist = await ytApiPlaylist.playlist(c.AppDetailsList[0].appYoutubeUid);
    logger.i(ytResultPlaylist.length);
    setState(() {
      print('UI Updated');
      //logger.i(ytResultPlaylist[0].title);
      logger.i('napal',ytResultPlaylist[0].id);
      //logger.i(ytResultPlaylist.length);
      isLoadingPlaylist = false;
    });
  }

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

     WidgetsBinding.instance
         ?.addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
     ytApi = new YoutubeAPI(c.AppDetailsList[0].appGoogleApikey, maxResults: 50, type: "video");
     //logger.i(ytResult);
     ytApiPlaylist =
     new YoutubeAPI(c.AppDetailsList[0].appGoogleApikey, maxResults: 50, type: "playlist");
     //logger.i(ytApiPlaylist);
     callAPI();
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
    Get.to(MenuScreen());
    if(_isInterstitialAdReady){
      _interstitialAd?.show();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //logger.i(c.Allemissions.length);
    return WillPopScope(
      onWillPop:_onBackPressed,
      child:
          c.AppDetailsList[0].appDataToload=="vod"?
      Scaffold(
        key: _scaffoldKey,
       /* appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Image.asset('assets/images/logodestiny.png',
            width: 130,
          ),
          backgroundColor: Colors.white,
        ),*/
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
      ) ///
      ///
      ///
      :Scaffold(
            key: _scaffoldKey,
            /* appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Image.asset('assets/images/logodestiny.png',
            width: 130,
          ),
          backgroundColor: Colors.white,
        ),*/
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
                                "Playlist",
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
                            isLoadingPlaylist?
                            Center(
                              child: Text(
                                "No playlists for the moment...",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "CeraPro",
                                    fontWeight:
                                    FontWeight.bold),
                              ),
                              //child: CircularProgressIndicator(),
                            ):
                                      GridView.builder(
                                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 200,
                                              childAspectRatio: 3 / 2,
                                              crossAxisSpacing: 14,
                                              mainAxisSpacing: 14),
                                          itemCount: ytResultPlaylist.length,
                                          itemBuilder: (BuildContext ctx, index) {
                                            return GestureDetector(
                                              onTap: (){
                                                Get.to(PlaylistScreen(title: ytResultPlaylist[index].id,));
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Get.to(PlaylistScreen(title: ytResultPlaylist[index].id,));
                                                      },
                                                      child: Stack(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(4),
                                                            child: CachedNetworkImage(
                                                              height: 110,
                                                              width: 180,
                                                              imageUrl: ytResultPlaylist[index].thumbnail["medium"]["url"],
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
                                                    Text(ytResultPlaylist[index].title,style: TextStyle(
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
