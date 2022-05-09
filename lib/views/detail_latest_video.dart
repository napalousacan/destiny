
import 'dart:convert';

import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:destiny/controllers/appcontroller.dart';
import 'package:destiny/model/model_video.dart';
import 'package:destiny/model/vodalaune.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class LastestVideo extends StatefulWidget {
  late Vodalauneitem vodalauneitem;
  String url;
  LastestVideo({required this.vodalauneitem,required this.url});

  @override
  State<LastestVideo> createState() => _LastestVideoState();
}

class _LastestVideoState extends State<LastestVideo> {
  YoutubePlayerController _controller=YoutubePlayerController(initialVideoId: "");
  late Vodalauneitem onTap;
  String? urlvod;
  String tvurl = "";
  String linktv = "";
  String tvTitle = "";
  String tvDate="";

  //late String url='https://www.youtube.com/watch?v=o0uBOPNZYJc';

  //late BetterPlayerController playerController;

  GlobalKey _betterPlayerKey = GlobalKey();

  //final AppDetailsController c = Get.put(AppDetailsController());
  final AppDetailsController c = Get.find();
  //final AppDetailsController play_urlc=Get.find();
   VideoPlayerController? _playController;
   BetterPlayerController? _betterPlayerController;
  var betterPlayerConfiguration = BetterPlayerConfiguration(
    autoPlay: true,
    looping: false,
    fullScreenByDefault: false,
    allowedScreenSleep: false,
    autoDetectFullscreenDeviceOrientation:true,
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

  Future<void> getLive() async {
    logger.i(urlvod.toString());
     var client = http.Client();
    var response = await client.get(Uri.parse(urlvod.toString()));
    if(response.statusCode==200){
      var jsonString = ModelVideo.fromJson(json.decode(response.body));
      //jsonString.videourl=json.decode(response.body)['direct_url'];
      logger.i("napal addddddddddddda");
      logger.i(jsonString.videoUrl);
      setState(() {
        ///
        ///
        ///
        ///
        BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          jsonString.videoUrl.toString(),
          liveStream: false,
          asmsTrackNames: ["3G 360p", "SD 480p", "HD 1080p"],
        );
        if (_betterPlayerController != null) {
          _betterPlayerController?.pause();
          _betterPlayerController?.setupDataSource(betterPlayerDataSource);
        } else {
          _betterPlayerController = BetterPlayerController(betterPlayerConfiguration,
              betterPlayerDataSource: betterPlayerDataSource);
        }
        _betterPlayerController?.setBetterPlayerGlobalKey(_betterPlayerKey);

      });
    }
  }

  final logger=Logger();
  @override
  void initState() {
    Wakelock.enable();
    // TODO: implement initState
    onTap=widget.vodalauneitem;
    urlvod=widget.vodalauneitem.feedUrl;
    linktv = widget.vodalauneitem.logo;
    tvTitle=widget.vodalauneitem.title;
    tvDate=widget.vodalauneitem.date;

    if(onTap.type=="vod"){
      getLive();
    } else if(onTap.type=="youtube"){
      urlvod=onTap.videoUrl.split("=")[1];
      _controller = YoutubePlayerController(
          initialVideoId: urlvod.toString(),
          //YoutubePlayer.convertUrlToId(widget.vodalauneitem.videoUrl.replaceAll(" ", "")),
          flags: YoutubePlayerFlags(
            mute: false,
            autoPlay: true,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: true,
          ));
    }
    super.initState();
    //logger.i('STIC');
    //logger.i(widget.url);
    c.fetchAllVodAlaUne(widget.vodalauneitem.relatedItems);
    //logger.i(widget.vodalauneitem.feedUrl);
  }


  @override
  void dispose() {
    //playerController?.dispose();
    _betterPlayerController?.dispose();
    _controller?.dispose();

    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

   @override
   void deactivate() {
     // Pauses video while navigating to next page.
     _controller?.pause();
     super.deactivate();
   }

  @override
  Widget build(BuildContext context) {
    //logger.i(this.widget.vodalauneitem.feedUrl);
    //c.fetchVideoUrl(widget.vodalauneitem.feedUrl);
    //logger.i(c.videorurl.videourl);
    return
      onTap.type=="vod"
          ?
      new Scaffold(
      appBar: AppBar(centerTitle: true,
        elevation: 0,
        title: Image.asset('assets/images/logodest.png',
          width: 130,
        ),
        backgroundColor: Colors.white,),
      body: Container(
        child:Column(
          children: [
            _betterPlayerController != null
                ? AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(
                controller: _betterPlayerController!,
                key: _betterPlayerKey,
              ),
            )
                : Container(),
            Container(
              height: 60,
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: colorPrimary)
              ),
              child: Row(
                children: <Widget>[
                  CachedNetworkImage(
                    width: 80,
                    height: 50,
                    imageUrl: linktv,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset(
                      "assets/images/logodest.png",
                      fit: BoxFit.contain,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/images/logodest.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              child: Text(
                                tvTitle,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "CeraPro",
                                    fontWeight: FontWeight.bold,
                                    color: colorPrimary),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(top: 7),
                              child: Text(
                                tvDate,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "CeraPro",
                                    fontWeight: FontWeight.normal,
                                    color: colorPrimary.withOpacity(0.7)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            /*AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(
                controller: _betterPlayerController,
              ),
            )*/
           /* Container(
              height: 230,
              width: double.infinity,
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressColors: ProgressBarColors(bufferedColor: colorPrimary),
                progressIndicatorColor: colorPrimary,
              ),
            )*/
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 10,),
              margin: EdgeInsets.only(top: 10),
              child: Text(
                "Related videos",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "CeraPro",
                    fontWeight: FontWeight.bold,
                    color: colorPrimary),
              ),
            ),
            Expanded(
              child:
              Obx(() {
                if (c.isLoading.value)
                  return Center(child: CircularProgressIndicator());
                else
                  return
                    ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: c.AllvodAlaUne.value.length,
                        itemBuilder: (context, i) {
                          return Container(
                                margin: EdgeInsets.only(left: 10, right: 5),
                                  child: Container(
                                    width: 180,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap:(){
                                            setState(() {
                                              onTap = c.AllvodAlaUne[i];
                                              urlvod = c.AllvodAlaUne[i].feedUrl;

                                              linktv = c.AllvodAlaUne[i].logo;
                                              tvTitle=c.AllvodAlaUne[i].title;
                                              tvDate=c.AllvodAlaUne[i].date;
                                              logger.i(onTap.type,"click");
                                            });
                                            if (onTap.type == "vod") {
                                              logger.i(urlvod);
                                              getLive();
                                            } else if (onTap.type == "dailymotion") {
                                            } else if (onTap.type == "youtube") {
                                              _controller.load(onTap.videoUrl.split("=")[1]);
                                            } else {
                                              logger.i("here2");
                                            }
                                          },
                                          child: Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width,
                                            height: 130,
                                            //alignment: Alignment.center,
                                            child: new Row(
                                              children: <Widget>[
                                                Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(4),
                                                      child: CachedNetworkImage(
                                                        height: 90,
                                                        width: 100,
                                                        imageUrl: c.AllvodAlaUne.value[i].logo,
                                                        fit: BoxFit.cover,
                                                        placeholder: (context, url) =>
                                                            Image.asset(
                                                              "assets/images/logodest.png",
                                                              fit: BoxFit.contain,
                                                              height: 100,
                                                              width: 100,
                                                            ),
                                                        errorWidget:
                                                            (context, url, error) =>
                                                            Image.asset(
                                                              "assets/images/logodest.png",
                                                              fit: BoxFit.contain,
                                                              height: 100,
                                                              width: 100,
                                                            ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 100,
                                                      width: 100,
                                                      child: Center(
                                                        child: Container(
                                                          child: Image.asset(
                                                            "assets/images/player2.png",
                                                            height: 50,
                                                            width: 50,
                                                            //color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    )

                                                  ],
                                                ),
                                                SizedBox(width: 5,),
                                                Flexible(child: Column(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: [
                                                    Container(
                                                      child:
                                                      Container(
                                                        alignment: Alignment.center,
                                                        //height: 70,
                                                        padding: EdgeInsets.all(10),
                                                        child: Text(
                                                          c.AllvodAlaUne.value[i].title,
                                                          maxLines: 4,
                                                          textAlign: TextAlign.start,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 14.0,
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                              color: colorPrimary),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment: Alignment.centerLeft,
                                                      child:
                                                      Container(
                                                        padding: EdgeInsets.only(
                                                            left: 10,
                                                            right: 10,
                                                            bottom: 15),
                                                        child: Text(
                                                          //rssList[i].pubDate,
                                                          "${c.AllvodAlaUne.value[i]
                                                              .date} à ${c.AllvodAlaUne.value[i]
                                                              .time}",
                                                          maxLines: 1,
                                                          textAlign: TextAlign.start,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 13.0,
                                                              fontWeight: FontWeight
                                                                  .normal,
                                                              color: Colors.black54),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ))
                                              ],
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          height: 0,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                        }
                    );
              }),
            ),
          ],
        ),
      ),
    ):
      new Scaffold(
        appBar: AppBar(centerTitle: true,
          elevation: 0,
          title: Image.asset('assets/images/logodest.png',
            width: 130,
          ),
          backgroundColor: Colors.white,),
        body: Container(
          child:Column(
            children: [
              Container(
              height: 230,
              width: double.infinity,
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressColors: ProgressBarColors(bufferedColor: colorPrimary),
                progressIndicatorColor: colorPrimary,
              ),
            ),
              Container(
                height: 60,
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: colorPrimary)
                ),
                child: Row(
                  children: <Widget>[
                    CachedNetworkImage(
                      width: 80,
                      height: 50,
                      imageUrl: linktv,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                        "assets/images/logodest.png",
                        fit: BoxFit.contain,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/logodest.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                child: Text(
                                  tvTitle,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: "CeraPro",
                                      fontWeight: FontWeight.bold,
                                      color: colorPrimary),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.only(top: 7),
                                child: Text(
                                  tvDate,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: "CeraPro",
                                      fontWeight: FontWeight.normal,
                                      color: colorPrimary.withOpacity(0.7)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
              ,
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 10,),
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "Related videos",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: "CeraPro",
                      fontWeight: FontWeight.bold,
                      color: colorPrimary),
                ),
              ),
              Expanded(
                child:
                Obx(() {
                  if (c.isLoading.value)
                    return Center(child: CircularProgressIndicator());
                  else
                    return
                      ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: c.AllvodAlaUne.value.length,
                          itemBuilder: (context, i) {
                            return Container(
                              margin: EdgeInsets.only(left: 10, right: 5),
                              child: Container(
                                width: 180,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap:(){
                                        setState(() {
                                          onTap = c.AllvodAlaUne[i];
                                          urlvod = c.AllvodAlaUne[i].feedUrl;
                                          linktv = c.AllvodAlaUne[i].logo;
                                          tvTitle=c.AllvodAlaUne[i].title;
                                          tvDate=c.AllvodAlaUne[i].date;
                                          logger.i(onTap.type,"click");
                                        });
                                        if (onTap.type == "vod") {
                                          logger.i(urlvod);
                                          getLive();
                                        } else if (onTap.type == "dailymotion") {
                                        } else if (onTap.type == "youtube") {
                                          _controller.load(onTap.videoUrl.split("=")[1]);
                                        } else {
                                          logger.i("here2");
                                        }
                                      },
                                      child: Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        height: 130,
                                        //alignment: Alignment.center,
                                        child: new Row(
                                          children: <Widget>[
                                            Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(4),
                                                  child: CachedNetworkImage(
                                                    height: 90,
                                                    width: 100,
                                                    imageUrl: c.AllvodAlaUne.value[i].logo,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context, url) =>
                                                        Image.asset(
                                                          "assets/images/logodest.png",
                                                          fit: BoxFit.contain,
                                                          height: 100,
                                                          width: 100,
                                                        ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                        Image.asset(
                                                          "assets/images/logodest.png",
                                                          fit: BoxFit.contain,
                                                          height: 100,
                                                          width: 100,
                                                        ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 100,
                                                  width: 100,
                                                  child: Center(
                                                    child: Container(
                                                      child: Image.asset(
                                                        "assets/images/player.png",
                                                        height: 50,
                                                        width: 50,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                )

                                              ],
                                            ),
                                            SizedBox(width: 5,),
                                            Flexible(child: Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceEvenly,
                                              children: [
                                                Container(
                                                  child:
                                                  Container(
                                                    alignment: Alignment.center,
                                                    //height: 70,
                                                    padding: EdgeInsets.all(10),
                                                    child: Text(
                                                      c.AllvodAlaUne.value[i].title,
                                                      maxLines: 4,
                                                      textAlign: TextAlign.start,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          color: colorPrimary),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.centerLeft,
                                                  child:
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        bottom: 15),
                                                    child: Text(
                                                      //rssList[i].pubDate,
                                                      "${c.AllvodAlaUne.value[i]
                                                          .date} à ${c.AllvodAlaUne.value[i]
                                                          .time}",
                                                      maxLines: 1,
                                                      textAlign: TextAlign.start,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          fontWeight: FontWeight
                                                              .normal,
                                                          color: Colors.black54),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      height: 0,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                      );
                }),
              ),
            ],
          ),
        ),
      );
  }
}
