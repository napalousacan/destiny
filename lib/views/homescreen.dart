//import 'package:better_player/better_player.dart';
import 'dart:async';
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:destiny/controllers/appcontroller.dart';
import 'package:destiny/views/playlist_youtube.dart';
import 'package:destiny/views/replayscreen.dart';
import 'package:destiny/views/replayscreenplus.dart';
import 'package:destiny/views/splashscreen.dart';
import 'package:destiny/views/widget/bottombarwidget.dart';
import 'package:destiny/views/youtube.dart';
import 'package:destiny/views/youtubePlayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jiffy/jiffy.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_api/youtube_api.dart';

import '../constants.dart';
import 'about.dart';
import 'ad_helper.dart';
import 'detail_latest_video.dart';
import 'detailreplayscreen.dart';
//import 'package:hardware_buttons/hardware_buttons.dart';
//import 'package:hardware_buttons/hardware_buttons.dart' as HardwareButtons;

import 'menuscreen.dart';

class HomeScreen extends StatefulWidget {
  //const HomeScreen({required this.api,required this.allData});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  final logger = Logger();
  final AppDetailsController c = Get.find();
  //late BetterPlayerController _betterPlayerController;
  late BetterPlayerController _betterPlayerController;
  late VideoPlayerController _playController;
  //late StreamSubscription<HardwareButtons.HomeButtonEvent> _homeButtonSubscription;
  late String _latestHardwareButtonEvent;
  BannerAd? _bannerAd;
  String? data_url;

  late YoutubeAPI ytApi;
  late YoutubeAPI ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  bool isLoading = true;
  bool isLoadingPlaylist = true;


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

  var betterPlayerConfiguration = BetterPlayerConfiguration(
    autoPlay: true,
    looping: true,
    fullScreenByDefault: false,
    allowedScreenSleep: false,
    //autoDetectFullscreenDeviceOrientation:true,

    translations: [
      BetterPlayerTranslations(
        languageCode: "fr",
        generalDefaultError: "Impossible de lire la vidéo",
        generalNone: "Rien",
        generalDefault: "Défaut",
        generalRetry: "Réessayez",
        playlistLoadingNextVideo: "Chargement de la vidéo suivante",
        controlsNextVideoIn: "Vidéo suivante dans",
        overflowMenuPlaybackSpeed: "Vitesse de lecture",
        overflowMenuSubtitles: "Sous-titres",
        overflowMenuQuality: "Qualité",
        overflowMenuAudioTracks: "Audio",
        qualityAuto: "Auto",
      ),
    ],
    deviceOrientationsAfterFullScreen: [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,

    ],
    //autoDispose: true,
    controlsConfiguration: BetterPlayerControlsConfiguration(
        iconsColor: Colors.white,
        controlBarColor: Colors.black12,
        liveTextColor: Colors.red,
        playIcon: Icons.play_arrow,
        enablePip: true,
        enableFullscreen: true,
        enableSubtitles: false,
        enablePlaybackSpeed: false,
        loadingColor: Colors.white,
        enableSkips: false,
        overflowMenuIconsColor:Colors.white,
        enableRetry: true,
      //enableOverflowMenu: false,
      //backgroundColor: Colors.white
    ),
  );
  //late BetterPlayerController playerController;
  GlobalKey _betterPlayerKey = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    WidgetsFlutterBinding.ensureInitialized();
    MobileAds.instance.initialize();
      var img="https://adweknow.com/wp-content/uploads/2018/02/label.jpg";
      //final AppDetailsController c = Get.find();
      Wakelock.enable();
      data_url=c.playerurl.directUrl;
      //betterPlayerConfiguration;
      _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
      BetterPlayerDataSource dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          data_url.toString(),
          liveStream: true,
          asmsTrackNames: ["3G 360p", "SD 480p", "HD 1080p"],
          /*notificationConfiguration: const BetterPlayerNotificationConfiguration(
            showNotification: true,
            title: "Destiny TV",
            imageUrl:"https://tvestatic.acan.group/walfvod/images/ca099ed98fb1c315f056a54a0fba528a.png",
          )*/
      );
    //_betterPlayerController.isPictureInPictureSupported();
    //_betterPlayerController.enablePictureInPicture(_betterPlayerKey);
      _betterPlayerController.setupDataSource(dataSource)
          .then((response) {
        //isVideoLoading = false;
      })
          .catchError((error) async {
      });
      //_betterPlayerController.setupDataSource(dataSource);
      //_betterPlayerController.setupDataSource(dataSource);
      _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);
    //logger.i("message",c.playerurl.directUrl);

    ///
    ///
    ///
    //_betterPlayerController.retryDataSource();
    _betterPlayerController.addEventsListener((error) => {
      //logger.i(error.betterPlayerEventType,'voir event'),
      if(error.betterPlayerEventType.index==9){
        logger.i(error.betterPlayerEventType.index,"index event"),
        Wakelock.enable(),
        getLive(),
        _betterPlayerController.retryDataSource()
      }
    });




    /*_homeButtonSubscription = HardwareButtons.homeButtonEvents.listen((event) {
      if (MediaQuery.of(context).orientation == Orientation.portrait){
        // is portrait
      }else{
        //logger.i(event,'home button');
        _betterPlayerController.setupDataSource(dataSource);
        Wakelock.enable();
        //_betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);
        _betterPlayerController.enablePictureInPicture(_betterPlayerKey);
        _betterPlayerController.addEventsListener((error) => {
          if(_betterPlayerController.isPlaying()==false){
            logger.i(_betterPlayerController.betterPlayerDataSource,'voir event lecture'),
            //_betterPlayerController.isVideoInitialized(),
            //_betterPlayerController.setupDataSource(dataSource),
            //_betterPlayerController.play()
          }
          else{
          logger.i(_betterPlayerController.betterPlayerDataSource,'voir event napal111111111111111111'),
          },
          logger.i(error.betterPlayerEventType,'voir exit napal2222222222222222222'),
          /*if(_betterPlayerController==null){
            if (Platform.isAndroid) {
          SystemNavigator.pop()
        } else if (Platform.isIOS) {
          exit(0)
          }
          }*/
        });
        setState(() {
          _latestHardwareButtonEvent = 'HOME_BUTTON';
        });
        Wakelock.enable();
      }
    });*/
    super.initState();
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

  Future<void> getLive() async {
    final AppDetailsController cc = Get.put(AppDetailsController());
          data_url=cc.playerurl.directUrl;
          setState(() {
            data_url;
          });
  }

  void getStop(){
    var j=1;
    for (int i = 0; i < 1; i++) {
      break;
    }
  }


  @override
  void dispose() {
    super.dispose();
    Wakelock.enable();
    //_betterPlayerController?.dispose();
    //_homeButtonSubscription?.cancel();
    //logger.i("dispose de ousman","dispose");

    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _bannerAd?.dispose();
  }

  initPlayer(String directUrl){
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      directUrl,
      liveStream: true,
      asmsTrackNames: ["3G 360p", "SD 480p", "HD 1080p"],
      /*notificationConfiguration: BetterPlayerNotificationConfiguration(
            showNotification: true,
            title: tvTitle,
            author: "DMedia",
            imageUrl:tvIcon,
          ),*/
    );
    if (_betterPlayerController != null) {
      _betterPlayerController.pause();
      _betterPlayerController.setupDataSource(betterPlayerDataSource);
    } else {
      _betterPlayerController = BetterPlayerController(betterPlayerConfiguration,
          betterPlayerDataSource: betterPlayerDataSource);
    }
    _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    _betterPlayerController?.dispose();
    Wakelock.enable();
    super.deactivate();
  }


  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return
      c.AppDetailsList[0].appDataToload=="vod"?
      Scaffold(
        body: Column(
          children: [
            _betterPlayerController!=null?
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(
                  controller: _betterPlayerController,
                key: _betterPlayerKey,
              ),
            ):Container(),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset: Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                ),
              child: Row(
                children: [
                   Padding(
                     padding: const EdgeInsets.only(left: 6),
                     child: Icon(Icons.tv,size: 40,),
                   ),
                  SizedBox(width: 30,),
                  Expanded(child: Text(c.Alltvs[0].title,style: TextStyle(
                    fontSize: 15,
                    fontFamily: "CeraPro",
                    fontWeight: FontWeight.bold,
                  ),),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),

    Expanded(
    child: SingleChildScrollView(
        child:
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Container(child: Column(children: [
              Container(
                //margin: EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8,left: 8),
                          child: Text(
                            "Latest videos",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "CeraPro",
                                fontWeight:
                                FontWeight.bold),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if(c.AllvodAlaUne[0].type=="vod"){
                              //c.fetchVideoUrl(c.AllvodAlaUne[0].feedUrl);
                              //logger.i(c.videorurl.videoUrl);
                              //_betterPlayerController.pause();
                              initPlayer(c.playerurl.directUrl);
                              Get.to(LastestVideo(vodalauneitem: c.AllvodAlaUne[0],url: c.videorurl.videoUrl.toString(),));

                            }
                            else if(c.AllvodAlaUne[0].type=="youtube")
                              {
                                //_betterPlayerController.pause();
                                initPlayer(c.playerurl.directUrl);
                                Get.to(LastestVideo(vodalauneitem: c.AllvodAlaUne[0],url: c.AllvodAlaUne[0].videoUrl,));
                              }

                          },
                          child: Container(
                            padding: EdgeInsets.only(right: 8,left: 8),
                            child: Icon(
                              Icons.playlist_add,
                              size: 26,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2,),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 170,
                      //color: Colors.red,
                      child: Obx(() {
                        if (c.isLoading.value)
                          return Center(child: CircularProgressIndicator());
                        else {
                          return
                            ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: c.AllvodAlaUne.length,
                              separatorBuilder: (context, _) =>
                                  SizedBox(width: 8,),
                              itemBuilder: (context, index) =>
                                  GestureDetector(
                                    onTap: (){
                                      if(c.AllvodAlaUne[index].type=="vod"){
                                        logger.i("napalous",c.AllvodAlaUne[index].feedUrl);
                                        //c.fetchVideoUrl(c.AllvodAlaUne[index].feedUrl);
                                        //logger.i(c.videorurl.videoUrl);
                                        //logger.i("napalous1",c.videorurl.videourl);
                                        //_betterPlayerController.pause();
                                        initPlayer(c.playerurl.directUrl);
                                        Get.to(LastestVideo(vodalauneitem: c.AllvodAlaUne[index],url: c.AllvodAlaUne[index].feedUrl,));
                                      }
                                      else if(c.AllvodAlaUne[index].type=="youtube")
                                      {
                                        //_betterPlayerController.pause();
                                        initPlayer(c.playerurl.directUrl);
                                        Get.to(LastestVideo(vodalauneitem: c.AllvodAlaUne[index],url: c.AllvodAlaUne[index].videoUrl,));
                                      }
                                      //Get.to(LastestVideo(vodalauneitem: c.AllvodAlaUne[index],));
                                    },
                                    child: Container(
                                      height: 160,
                                      width: 230,
                                      child: Column(
                                        children: [
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(
                                                    4),
                                                child: CachedNetworkImage(
                                                  height: 130,
                                                  width: 230,
                                                  imageUrl: c.AllvodAlaUne[index].logo,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      Image.asset(
                                                        "assets/images/dest.png",
                                                        fit: BoxFit.contain,
                                                        height: 130,
                                                        width: 230,
                                                      ),
                                                  errorWidget: (context, url,
                                                      error) =>
                                                      Image.asset(
                                                        "assets/images/dest.png",
                                                        fit: BoxFit.contain,
                                                        height: 130,
                                                        width: 230,
                                                      ),
                                                ),
                                              ),
                                              Container(
                                                height: 130,
                                                width: 230,
                                                child: Center(
                                                  child: Container(
                                                    child: Image.asset(
                                                      "assets/images/player2.png",
                                                      height: 100,
                                                      width: 100,
                                                      //color: Colors.orangeAccent,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            c.AllvodAlaUne[index].title.substring(0,25)+'...',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "CeraPro",
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            );
                        }
                      })
                    ),
                    //SizedBox(height: 2,),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8,left: 8,bottom: 3),
                          child: Text(
                            "Programs",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "CeraPro",
                                fontWeight:
                                FontWeight.bold),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(ReplayScreenPlus());
                          },
                          child: Container(
                            padding: EdgeInsets.only(right: 8,left: 8,bottom: 3),
                            child: Icon(
                              Icons.playlist_add,
                              size: 26,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3,),
                    Container(
                      height: 170,
                      //color: Colors.red,
                     child:Obx(() {
                        if(c.isLoading.value)
                          return Center(child: CircularProgressIndicator());
                        else return
                      ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: c.Allemissions.length,
                        separatorBuilder: (context,_) => SizedBox(width: 8,),
                        itemBuilder:(context,index)=>
                            GestureDetector(
                              onTap: (){
                                //_betterPlayerController.pause();
                                initPlayer(c.playerurl.directUrl);
                                Get.to(DetailReplayScreen(title: c.Allemissions[index].title, url: c.Allemissions[index].feedUrl));
                              },
                              child: Container(
                                height: 160,
                                width: 180,
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: CachedNetworkImage(
                                            height: 130,
                                            width: 180,
                                            imageUrl: c.Allemissions[index].logoUrl,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Image.asset(
                                                  "assets/images/dest.png",
                                                  fit: BoxFit.contain,
                                                  height: 130,
                                                  width: 180,
                                                ),
                                            errorWidget: (context, url, error) =>
                                                Image.asset(
                                                  "assets/images/dest.png",
                                                  fit: BoxFit.contain,
                                                  height: 130,
                                                  width: 180,
                                                ),
                                          ),
                                        ),
                                      ],
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
                            ),
                      );
  }),
                    ),
                    //SizedBox(height: 5,),
                  ],
                ),
              ),
              ],),),
            )
    )),
          ],
        ),
      )
          ///
      ///
      ///
      ///
      /// youtube
          :
      Scaffold(
        body: Column(
        children: [
          _betterPlayerController!=null?
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(
              controller: _betterPlayerController,
              key: _betterPlayerKey,
            ),
          ):Container(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(2.0, 2.0), // shadow direction: bottom right
                )
              ],
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Icon(Icons.tv,size: 40,),
                ),
                SizedBox(width: 30,),
                Expanded(child: Text(c.Alltvs[0].title,style: TextStyle(
                  fontSize: 15,
                  fontFamily: "CeraPro",
                  fontWeight: FontWeight.bold,
                ),),
                ),
              ],
            ),
          ),
          SizedBox(height: 15,),
          Expanded(
              child: SingleChildScrollView(
                  child:
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Container(child: Column(children: [
                      Container(
                        //margin: EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 8,left: 8),
                                  child: Text(
                                    "Latest videos",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "CeraPro",
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => YoutubeScreen()),
                                            (Route<dynamic> route) => true);

                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(right: 8,left: 8),
                                    child: Icon(
                                      Icons.playlist_add,
                                      size: 26,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2,),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                                height: 170,
                                //color: Colors.red,
                                child: Obx(() {
                                  if (c.isLoading.value)
                                    return Center(child: CircularProgressIndicator());
                                  else {
                                    return
                                      ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 10,
                                        separatorBuilder: (context, _) =>
                                            SizedBox(width: 8,),
                                        itemBuilder: (context, index) =>
                                            GestureDetector(
                                              onTap: (){
                                                Navigator.of(context).pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) => YoutubeVideoPlayer(
                                                          url: ytResult[index].url,
                                                          title: ytResult[index].title,
                                                          img: ytResult[index].thumbnail['medium']
                                                          ['url'],
                                                          date: Jiffy(ytResult[index].publishedAt,
                                                              "yyyy-MM-ddTHH:mm:ssZ")
                                                              .yMMMMEEEEdjm,
                                                          related: "",
                                                          ytResult: ytResult, videos: [],
                                                        )),
                                                        (Route<dynamic> route) => true);
                                              },
                                              child: Container(
                                                height: 160,
                                                width: 230,
                                                child: Column(
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(
                                                              4),
                                                          child: CachedNetworkImage(
                                                            height: 130,
                                                            width: 230,
                                                            imageUrl: ytResult[index].thumbnail['medium']
                                                            ['url'],
                                                            fit: BoxFit.cover,
                                                            placeholder: (context, url) =>
                                                                Image.asset(
                                                                  "assets/images/dest.png",
                                                                  fit: BoxFit.contain,
                                                                  height: 130,
                                                                  width: 230,
                                                                ),
                                                            errorWidget: (context, url,
                                                                error) =>
                                                                Image.asset(
                                                                  "assets/images/dest.png",
                                                                  fit: BoxFit.contain,
                                                                  height: 130,
                                                                  width: 230,
                                                                ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 130,
                                                          width: 230,
                                                          child: Center(
                                                            child: Container(
                                                              child: Image.asset(
                                                                "assets/images/player2.png",
                                                                height: 70,
                                                                width: 70,
                                                                //color: Colors.black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      ytResult[index].title.substring(0,20)+'...',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: "CeraPro",
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                      );
                                  }
                                })
                            ),
                            //SizedBox(height: 2,),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 8,left: 8,bottom: 3),
                                  child: Text(
                                    "Programs",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "CeraPro",
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(YoutubeScreen());
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(right: 8,left: 8,bottom: 3),
                                    child: Icon(
                                      Icons.playlist_add,
                                      size: 26,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3,),
                            Container(
                              height: 170,
                              //color: Colors.red,
                              child:isLoadingPlaylist? Center(
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
                                  ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:ytResultPlaylist.length,
                                    separatorBuilder: (context,_) => SizedBox(width: 8,),
                                    itemBuilder:(context,index)=>
                                        GestureDetector(
                                          onTap: (){
                                            //_betterPlayerController.pause();
                                            Get.to(PlaylistScreen(title: ytResultPlaylist[index].id,));
                                          },
                                          child: Container(
                                            height: 160,
                                            width: 180,
                                            child: Column(
                                              children: [
                                                Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(4),
                                                      child: CachedNetworkImage(
                                                        height: 130,
                                                        width: 180,
                                                        imageUrl: ytResultPlaylist[index].thumbnail["medium"]["url"],
                                                        fit: BoxFit.cover,
                                                        placeholder: (context, url) =>
                                                            Image.asset(
                                                              "assets/images/dest.png",
                                                              fit: BoxFit.contain,
                                                              height: 130,
                                                              width: 180,
                                                            ),
                                                        errorWidget: (context, url, error) =>
                                                            Image.asset(
                                                              "assets/images/dest.png",
                                                              fit: BoxFit.contain,
                                                              height: 130,
                                                              width: 180,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
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
                                        ),
                                  )
                            ),
                            //SizedBox(height: 5,),
                          ],
                        ),
                      ),
                    ],),),
                  )
              ))
        ])
      );
      //bottomNavigationBar: BottomNavBarFb5(),
  }

  void navigationPage() {
    //Get.to(HomeScreen());
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => MenuScreen(
        )));
  }
}

