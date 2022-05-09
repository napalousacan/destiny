import 'dart:convert';
import 'package:get/get.dart';

List<Vod> VodFromJson(String str) =>
    List<Vod>.from(json.decode(str).map((x) => Vod.fromJson(x)));

String VodToJson(List<Vod> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Vod {
  Vod({
    required this.allitems
  });

  List<Voditem> allitems;

  var isFavorite = false.obs;

  factory Vod.fromJson(Map<String, dynamic> json) => Vod(
    allitems: List<Voditem>.from(
        json["allitems"].map((x) => Voditem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "allitems": List<dynamic>.from(allitems.map((x) => x.toJson())),
  };
}

class Voditem {
  Voditem({
    required this.title,
    required this.feedUrl,
    required this.videoUrl,
    required this.logo,
    required this.time,
    required this.relatedItems,
    required this.date,
    required this.type,
    required this.desc,
    required this.views,
    required this.webdetailUrl
  });

  String title;
  String desc;
  String type;
  String views;
  String logo;
  String videoUrl;
  String feedUrl;
  String relatedItems;
  String webdetailUrl;
  String date;
  String time;

  factory Voditem.fromJson(Map<String, dynamic> json) => Voditem(
    title : json["title"],
    desc : json["desc"],
    logo : json["logo"],
    type : json["type"],
    views: json["views"],
    feedUrl : json["feed_url"],
    videoUrl : json["video_url"],
    relatedItems: json["relatedItems"],
    webdetailUrl: json["webdetail_url"],
    date: json["date"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["title"] = title;
    map["desc"] = desc;
    map["logo"] = logo;
    map["type"] = type;
    map["feed_url"] = feedUrl;
    map["views"] = views;
    map["video_url"] = videoUrl;
    map["relatedItems"] = relatedItems;
    map["webdetailUrl"] = webdetailUrl;
    map["date"] = date;
    map["time"] = time;
    return map;
  }
}



