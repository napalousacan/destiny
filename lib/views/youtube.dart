import 'package:cached_network_image/cached_network_image.dart';
import 'package:destiny/controllers/appcontroller.dart';
import 'package:destiny/views/playlist_youtube.dart';
import 'package:destiny/views/youtubePlayer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_api/youtube_api.dart';

import '../constants.dart';
//import 'package:youtube_api/youtube_api.dart';

class YoutubeScreen extends StatefulWidget {
  //YoutubeScreen({Key? key}) : super(key: key);
  @override
  State<YoutubeScreen> createState() => _YoutubeScreenState();
}

class _YoutubeScreenState extends State<YoutubeScreen> with AutomaticKeepAliveClientMixin<YoutubeScreen>{
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  final AppDetailsController c = Get.put(AppDetailsController());
  late YoutubeAPI ytApi;
  late YoutubeAPI ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  bool isLoading = true;
  bool isLoadingPlaylist = true;
  final logger=Logger();

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
    super.initState();

    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
    ytApi = new YoutubeAPI(c.AppDetailsList[0].appGoogleApikey, maxResults: 50, type: "video");
    //logger.i(ytResult);
    ytApiPlaylist =
    new YoutubeAPI(c.AppDetailsList[0].appGoogleApikey, maxResults: 50, type: "playlist");
    //logger.i(ytApiPlaylist);
    callAPI();
    //print('hello');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
              slivers: <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 10,),
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          "New videos",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "CeraPro",
                              fontWeight: FontWeight.bold,
                              color: colorPrimary),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
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
                      Container(
                        height: MediaQuery.of(context).size.height/2,
                          child:
                          //isLoading ? Center(child: CircularProgressIndicator()):
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: 12,
                                    itemBuilder: (context, i) {
                                      return GestureDetector(
                                        onTap: (){
                                          Navigator.of(context).pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (context) => YoutubeVideoPlayer(
                                                    url: ytResult[i].url,
                                                    title: ytResult[i].title,
                                                    img: ytResult[i].thumbnail['medium']
                                                    ['url'],
                                                    date: Jiffy(ytResult[i].publishedAt,
                                                        "yyyy-MM-ddTHH:mm:ssZ")
                                                        .yMMMMEEEEdjm,
                                                    related: "",
                                                    ytResult: ytResult, videos: [],
                                                  )),
                                                  (Route<dynamic> route) => true);
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(left: 10, right: 5),
                                            child: Container(
                                              width: 180,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
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
                                                                imageUrl: ytResult[i].thumbnail['medium']
                                                                ['url'],
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
                                                                  ytResult[i].title,
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
                                                                  "Du ${Jiffy(ytResult[i].publishedAt,"yyyy-MM-ddTHH:mm:ssZ").format("dd/MM/yyyy à HH:mm")} " ,
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
                                                  Divider(
                                                    height: 0,
                                                  ),
                                                ],
                                              ),
                                            )),
                                      );
                                    }
                                )
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 10,),
                        margin: EdgeInsets.only(top: 10),
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
                        padding: EdgeInsets.all(10),
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
                      isLoadingPlaylist ? Center(
                        child: Text(
                          "No playlists for the moment...",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "CeraPro",
                              fontWeight:
                              FontWeight.bold),
                        ),
                        //child: CircularProgressIndicator(),
                      ) :
                      Container(
                        child:ListView.builder(
                          shrinkWrap: true,
                          /* gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),*/
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, position) {
                            return
                                Hero(
                                  tag: new Text(ytResultPlaylist[position].id),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(PlaylistScreen(title: ytResultPlaylist[position].id,));
                                    },
                                    child: Container(
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                                  Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: 110,
                                                    //alignment: Alignment.center,
                                                    child: new Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[
                                                        ClipRRect(
                                                          //borderRadius: BorderRadius.circular(20),
                                                          child:
                                                          CachedNetworkImage(
                                                            imageUrl: ytResultPlaylist[position].thumbnail["medium"]["url"],
                                                            height: 110,
                                                            width: 150,
                                                            fit: BoxFit.cover,
                                                            placeholder: (context, url) =>
                                                                Image.asset(
                                                                  "assets/images/logodest.png",
                                                                  fit: BoxFit.contain,
                                                                  height: 130,
                                                                  width: 230,
                                                                ),
                                                            errorWidget: (context, url,
                                                                error) =>
                                                                Image.asset(
                                                                  "assets/images/logodest.png",
                                                                  fit: BoxFit.contain,
                                                                  height: 130,
                                                                  width: 230,
                                                                ),

                                                          ),
                                                        ),
                                                        Flexible(
                                                          child:
                                                              Container(
                                                                alignment: Alignment.center,
                                                                padding: EdgeInsets.all(10),
                                                                child: Text(
                                                                  ytResultPlaylist[position].title,
                                                                  maxLines: 2,
                                                                  textAlign: TextAlign.center,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                      fontSize: 14.0,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.black),
                                                                ),
                                                              ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            Get.to(PlaylistScreen(title: ytResultPlaylist[position].id,));
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets.all(10),
                                                            child: Icon(
                                                              Icons.playlist_play,
                                                              size: 40,
                                                              color: colorPrimary,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                            ],
                                          ),
                                        )),
                                  ),
                                );
                          },
                          itemCount: ytResultPlaylist.length,
                        ),
                      )
                    ])
                )]
          )
        ],
      ),
    );
  }
}
