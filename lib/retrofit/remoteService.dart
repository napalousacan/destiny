import 'dart:convert';
import 'package:destiny/model/appdetail.dart';
import 'package:destiny/model/data.dart';
import 'package:destiny/model/emission.dart';
import 'package:destiny/model/group.dart';
import 'package:destiny/model/groupalaune.dart';
import 'package:destiny/model/info.dart';
import 'package:destiny/model/model_tv.dart';
import 'package:destiny/model/model_video.dart';
import 'package:destiny/model/player_url.dart';
import 'package:destiny/model/video_url.dart';
import 'package:destiny/model/vod.dart';
import 'package:destiny/model/vodalaune.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../constants.dart';

class RemoteServices {
  static var client = http.Client();

  //final logger = Logger();

  static Future<List<ACANAPI>?> fetchAppDetails() async {
    var response = await client.get(Uri.parse(
        'https://acanvod.acan.group/myapiv2/appdetails/$groupName'));
    if (response.statusCode == 200) {
      AppDetails jsonString = AppDetails.fromJson(json.decode(response.body));
      //print(jsonString.acanapi[0].appEmail);
      return jsonString.acanapi;
    } else {
      //show error message
      return null;
    }
  }

  static Future<List<Dataitem>?> fetchDataAll(String url) async{
    var response = await client.get(Uri.parse(url));
    if(response.statusCode==200){
      Data jsonString = Data.fromJson(json.decode(response.body));
      return jsonString.allitems;
    }
    else{
      return null;
    }
  }

  static Future<List<Emissionitem>?> fetchDataAllEmissions(String url) async{
    var response = await client.get(Uri.parse(url));
    if(response.statusCode==200){
      Emission jsonString = Emission.fromJson(json.decode(response.body));
      //print(jsonString.allitems[0].title);
      return jsonString.allitems;
    }
    else{
      return null;
    }
  }

  static Future<List<Tvitems>?> fetchDataAllTvs(String url) async{
    var response = await client.get(Uri.parse(url));
    if(response.statusCode==200){
      Tv jsonString = Tv.fromJson(json.decode(response.body));
      return jsonString.allitems;
    }
    else{
      return null;
    }
  }

  static Future<PlayerUrl?> fetchDataUrlPlayer(String url) async{
    var response = await client.get(Uri.parse(url));
    if(response.statusCode==200){
      PlayerUrl jsonString = PlayerUrl.fromJson(json.decode(response.body));
      return jsonString;
    }
    else{
      return null;
    }
  }

  static Future<ModelVideo?> fetchDataUrlVideo(String url) async{
    var response = await client.get(Uri.parse(url));
    if(response.statusCode==200){
      var jsonString = ModelVideo.fromJson(json.decode(response.body));
      //jsonString.videourl=json.decode(response.body)['direct_url'];
      return jsonString;
    }
    else{
      return null;
    }
  }

  static Future<List<GroupItem>?> fetchDataGroup(String url) async{
    var response = await client.get(Uri.parse(url));
    if(response.statusCode==200){
      Group jsonString = Group.fromJson(json.decode(response.body));
      //print(jsonString.allitems[0]);
      return jsonString.allitems;
    }
    else{
      return null;
    }
  }

  static Future<List<GroupalauneItem>?> fetchDataGroupAlaUne(String url) async{
    var response = await client.get(Uri.parse(url));
    if(response.statusCode==200){
      GroupAlaUne jsonString = GroupAlaUne.fromJson(json.decode(response.body));
      //print(jsonString.allitems[0]);
      return jsonString.allitems;
    }
    else{
      return null;
    }
  }

  static Future<List<Voditem>?> fetchAllVod(String url) async{
    var response = await client.get(Uri.parse(url));
    if(response.statusCode==200){
      Vod jsonString = Vod.fromJson(json.decode(response.body));
      return jsonString.allitems;
    }
    else{
      return null;
    }
  }




  static Future<Info?> fetchDataInfo(String url) async{
    var response = await client.get(Uri.parse(url));
    if(response.statusCode==200){
      Info jsonString = Info.fromJson(json.decode(response.body));
      return jsonString;
    }
    else{
      return null;
    }
  }

  static Future<List<Vodalauneitem>?> fetchDataAllVodAlaUne(String url) async{
    var response = await client.get(Uri.parse(url));
    if(response.statusCode==200){
      Vodalaune jsonString = Vodalaune.fromJson(json.decode(response.body));
      //print(jsonString.allitems[0].title);
      return jsonString.allitems;
    }
    else{
      return null;
    }
  }
}

