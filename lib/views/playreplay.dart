import 'dart:convert';

import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:destiny/controllers/appcontroller.dart';
import 'package:destiny/model/model_video.dart';
import 'package:destiny/model/vod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class PlayReplay extends StatefulWidget {
   List<Voditem> voditem=[];
   Voditem vod;
  PlayReplay({required this.voditem,required this.vod});

  @override
  State<PlayReplay> createState() => _PlayReplayState();
}

class _PlayReplayState extends State<PlayReplay> {
   late BetterPlayerController _betterPlayerController;

   late YoutubePlayerController _controller;

   String? url;
   late Voditem onTap;
   String linktv = "";
   String tvTitle = "";
   String tvDate="";

   AppDetailsController c=Get.put(AppDetailsController());
   GlobalKey _betterPlayerKey1 = GlobalKey();
   var betterPlayerConfiguration = BetterPlayerConfiguration(
     autoPlay: true,
     looping: false,
     fullScreenByDefault: false,
     allowedScreenSleep: false,
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
     controlsConfiguration: BetterPlayerControlsConfiguration(
       iconsColor: Colors.white,
       controlBarColor: colorPrimary,
       enablePip: true,
       enableSubtitles: false,
       enablePlaybackSpeed: true,
       loadingColor: colorPrimary,
       enableSkips: false,
       showControls: true,
       enableProgressText: true,
     ),
   );
  final logger=Logger();
   Future<void> getLive() async {
       //c.fetchVideoUrl(url.toString());
       var client = http.Client();
       var response = await client.get(Uri.parse(url.toString()));
       if(response.statusCode==200){
         var jsonString = ModelVideo.fromJson(json.decode(response.body));
       setState(() {
         BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
           BetterPlayerDataSourceType.network,
           jsonString.videoUrl.toString(),
           liveStream: false,
           asmsTrackNames: ["3G 360p", "SD 480p", "HD 1080p"],
         );
         if (_betterPlayerController != null) {
           _betterPlayerController.pause();
           _betterPlayerController.setupDataSource(betterPlayerDataSource);
         } else {
           _betterPlayerController = BetterPlayerController(betterPlayerConfiguration,
               betterPlayerDataSource: betterPlayerDataSource);
         }
         _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey1);
       });
       }
   }
   @override
  void initState() {
    // TODO: implement initState
     onTap=widget.vod;
     url=widget.vod.feedUrl;
     linktv = widget.vod.logo;
     tvTitle=widget.vod.title;
     tvDate=widget.vod.date;
     if(onTap.type=="vod"){
       getLive();
     } else if(onTap.type=="youtube"){
       url=onTap.videoUrl.split("=")[1];
       _controller = YoutubePlayerController(
           initialVideoId: url.toString(),
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
  }

   @override
   void deactivate() {
     // Pauses video while navigating to next page.
     _controller?.pause();
     //playerController?.pause();
     super.deactivate();
   }

   @override
   void dispose() {
     //playerController?.dispose();
     _controller?.dispose();
     //if (playerController != null) playerController.dispose();
     _betterPlayerController?.dispose();
     super.dispose();
   }

  @override
  Widget build(BuildContext context) {

    return onTap.type=="vod"? Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Image.asset('assets/images/logodest.png',
          width: 130,
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child:
          Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: BetterPlayer(
                  controller: _betterPlayerController,
                  key: _betterPlayerKey1,
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
              ),
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
                this.widget.voditem.length==0?
                     Center(child: CircularProgressIndicator()):
                      ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: this.widget.voditem.length,
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
                                          onTap = widget.voditem[i];
                                          url = widget.voditem[i].feedUrl;
                                          linktv = widget.voditem[i].logo;
                                          tvTitle=widget.voditem[i].title;
                                          tvDate=widget.voditem[i].date;
                                          logger.i(onTap.type);
                                        });
                                        if (onTap.type == "vod") {
                                          logger.i(url);
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
                                                    imageUrl: this.widget.voditem[i].logo,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context, url) =>
                                                        Image.asset(
                                                          "assets/images/logodestiny.png",
                                                          fit: BoxFit.contain,
                                                          height: 100,
                                                          width: 100,
                                                        ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                        Image.asset(
                                                          "assets/images/logodestiny.png",
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
                                                      this.widget.voditem[i].title,
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
                                                      "${this.widget.voditem[i]
                                                          .date} à ${this.widget.voditem[i]
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
                      ),
              ),
            ],
          ),
      ),
    ):Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Image.asset('assets/images/logodest.png',
          width: 130,
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child:
        Column(
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
            ),
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
              this.widget.voditem.length==0?
              Center(child: CircularProgressIndicator()):
              ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: this.widget.voditem.length,
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
                                  onTap = widget.voditem[i];
                                  url = widget.voditem[i].feedUrl;
                                  linktv = widget.voditem[i].logo;
                                  tvTitle=widget.voditem[i].title;
                                  tvDate=widget.voditem[i].date;
                                  logger.i(onTap.type);
                                });
                                if (onTap.type == "vod") {
                                  logger.i(url);
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
                                            imageUrl: this.widget.voditem[i].logo,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Image.asset(
                                                  "assets/images/logodestiny.png",
                                                  fit: BoxFit.contain,
                                                  height: 100,
                                                  width: 100,
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                Image.asset(
                                                  "assets/images/logodestiny.png",
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
                                              this.widget.voditem[i].title,
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
                                              "${this.widget.voditem[i]
                                                  .date} à ${this.widget.voditem[i]
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
