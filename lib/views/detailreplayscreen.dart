import 'package:cached_network_image/cached_network_image.dart';
import 'package:destiny/controllers/appcontroller.dart';
import 'package:destiny/controllers/vodcontroller.dart';
import 'package:destiny/views/playreplay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../constants.dart';
class DetailReplayScreen extends StatelessWidget {
  late final String title;
  late final String url;
  DetailReplayScreen({required this.title,required this.url});
  final VodController c = Get.put(VodController());
  final logger=Logger();

  @override
  Widget build(BuildContext context) {
    //logger.i(this.url);
    c.fetchAllVods(this.url);
    //logger.i(c.AllVods.value[0].desc);
    return Scaffold(
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
              margin: EdgeInsets.only(top: 10),
              child: Text(
                this.title+" videos",
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
                        itemCount: c.AllVods.value.length,
                        itemBuilder: (context, i) {
                          return Container(
                              margin: EdgeInsets.only(left: 10, right: 5),
                              child: GestureDetector(
                                onTap: (){
                                  Get.to( PlayReplay(voditem: c.AllVods,vod: c.AllVods.value[i],));
                                },
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
                                                    imageUrl: c.AllVods.value[i].logo,
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
                                                      c.AllVods.value[i].title,
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
                                                      "${c.AllVods.value[i]
                                                          .date} à ${c.AllVods.value[i]
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
                                      Divider(
                                        height: 0,
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        }
                    );
              })
        ),
          ])
          )]
          )
        ],
      ),
    );
  }
}
