import 'dart:async';

import 'package:destiny/model/appdetail.dart';
import 'package:destiny/model/data.dart';
import 'package:destiny/model/emission.dart';
import 'package:destiny/model/group.dart';
import 'package:destiny/model/groupalaune.dart';
import 'package:destiny/model/model_tv.dart';
import 'package:destiny/model/model_video.dart';
import 'package:destiny/model/player_url.dart';
import 'package:destiny/model/video_url.dart';
import 'package:destiny/model/vodalaune.dart';
import 'package:destiny/retrofit/remoteService.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class AppDetailsController extends GetxController {
  var isLoading = true.obs;
  var AppDetailsList = <ACANAPI>[].obs;
  var DataAll =<Dataitem>[].obs;
  var Allemissions =<Emissionitem>[].obs;
  var AllvodAlaUne =<Vodalauneitem>[].obs;
  var Alltvs =<Tvitems>[].obs;
  var Allgroups =<GroupItem>[].obs;
  var Allgroupsalaune=<GroupalauneItem>[].obs;
  var Modelgroup=Group(allitems: []).obs;
  var playerurl=new PlayerUrl(directUrl: '');
  var videorurl=new ModelVideo(videoUrl: '');
  var video_vod="".obs;
  final logger=Logger();
  int connectionType=1;
  late StreamSubscription _streamSubscription ;

  @override
  void onInit() {
    fetchAppDetails();
    super.onInit();
  }



  @override
  void onClose() {
    //stop listening to network state when app is closed
    _streamSubscription.cancel();
  }

  void fetchAppDetails() async {
    try {
      isLoading(true);
      var appdetails = await RemoteServices.fetchAppDetails();
      //fetchVideoUrl("");
      if (appdetails != null) {
        AppDetailsList.value = appdetails;
        if(appdetails[0].appDataToload=="vod")
          {
            fetchAllData(appdetails[0].appDataUrl);
          }
        else if(appdetails[0].appDataToload=="youtube"){
          fetchAllData(appdetails[0].appDataUrl);
        }
      }
    } finally {
      isLoading(false);
    }
  }

  void fetchAllData(String url) async{
    try {
      isLoading(true);
    var allitems = await RemoteServices.fetchDataAll(url);
    if(allitems !=null){
      DataAll.value=allitems;
      if(allitems[2].title=="CHAINE VOD")
        {
          fetchAllGroup(allitems[2].feedUrl);
        }
      if(allitems[4].title=="CHAINE A la UNE"){
        //logger.i(allitems[4].feedUrl);
        fetchAllGroupAlaUne(allitems[4].feedUrl);
      }

      if(allitems[0].title=="Les Directs"){
        //logger.i(allitems[4].feedUrl);
        fetchAllTvs(allitems[0].feedUrl);
      }
      
      //fetchVideoUrl('https://acanvod.acan.group/myapiv2/directplayback/33/json');
    }
    } finally {
      isLoading(false);
    }
  }

  void fetchAllEmissions(String url) async{
    try {
      isLoading(true);
    var allitems = await RemoteServices.fetchDataAllEmissions(url);
    if(allitems !=null){
      Allemissions.value=allitems;
      //print(Allemissions.value[0].title);
    }
    } finally {
      isLoading(false);
    }
  }

  void fetchAllTvs(String url) async{
    try {
      isLoading(true);
    var allitems = await RemoteServices.fetchDataAllTvs(url);
    if(allitems !=null){
      Alltvs.value=allitems;
      fetchPlayerUrl(Alltvs.value[0].feedUrl);
    }
    } finally {
      isLoading(false);
    }
  }

  void fetchPlayerUrl(String url) async{
    try {
      isLoading(true);
    var allitems = await RemoteServices.fetchDataUrlPlayer(url);
    if(allitems !=null){
      playerurl=allitems;
    }
    } finally {
      isLoading(false);
    }
  }

  void fetchVideoUrl(String url) async{
    //logger.i('napal ousman adda');
    try {
      isLoading(true);
      var allitems = await RemoteServices.fetchDataUrlVideo(url);
      if(allitems !=null){
        //logger.i(allitems);
        videorurl=allitems;
        //logger.i("napal",allitems.videourl);
      }
    } finally {
      isLoading(false);
    }
  }


  void fetchAllGroup(String url) async{
    try {
      isLoading(true);
    var allitems = await RemoteServices.fetchDataGroup(url);
    if(allitems !=null){
      Allgroups.value=allitems;
        fetchAllEmissions(Allgroups.value[0].listShowsByGroup);
      //logger.i(Allgroups.value[0].listShowsByGroup);
    }
    } finally {
      isLoading(false);
    }
  }

  void fetchAllGroupAlaUne(String url) async{
    try {
      isLoading(true);
      var allitems = await RemoteServices.fetchDataGroupAlaUne(url);
      if(allitems !=null){
        Allgroupsalaune.value=allitems;
        fetchAllVodAlaUne(Allgroupsalaune.value[0].listAlaunebygroup);
        //logger.i(Allgroupsalaune.value[0].listAlaunebygroup);
      }
    } finally {
      isLoading(false);
    }
  }


  void fetchAllVodAlaUne(String url) async{
    try {
      isLoading(true);
      var allitems = await RemoteServices.fetchDataAllVodAlaUne(url);
      if(allitems !=null){
        AllvodAlaUne.value=allitems;
      }
    } finally {
      isLoading(false);
    }
  }
}