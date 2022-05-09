import 'dart:convert';
import 'package:get/get.dart';

List<Vodalaune> VodalauneFromJson(String str) =>
    List<Vodalaune>.from(json.decode(str).map((x) => Vodalaune.fromJson(x)));

String VodalauneToJson(List<Vodalaune> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Vodalaune {
  Vodalaune({
    required this.allitems
  });

  List<Vodalauneitem> allitems;

  var isFavorite = false.obs;

  factory Vodalaune.fromJson(Map<String, dynamic> json) => Vodalaune(
    allitems: List<Vodalauneitem>.from(
        json["allitems"].map((x) => Vodalauneitem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "allitems": List<dynamic>.from(allitems.map((x) => x.toJson())),
  };
}

class Vodalauneitem {
  Vodalauneitem({
    required this.chaineId,
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
    required this.logoUrl
  });

  String title;
  String desc;
  String type;
  String views;
  String logo;
  String videoUrl;
  String feedUrl;
  String relatedItems;
  String logoUrl;
  String date;
  String time;
  String chaineId;

  factory Vodalauneitem.fromJson(Map<String, dynamic> json) => Vodalauneitem(
    chaineId : json["chaine_id"],
    title : json["title"],
    desc : json["desc"],
    type : json["type"],
    views: json["views"],
    logo : json["logo"],
    logoUrl: json["logo_url"],
    videoUrl : json["video_url"],
    relatedItems: json["relatedItems"],
    feedUrl : json["feed_url"],
    date: json["date"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["chaine_id"] = chaineId;
    map["title"] = title;
    map["desc"] = desc;
    map["logo"] = logo;
    map["type"] = type;
    map["feed_url"] = feedUrl;
    map["views"] = views;
    map["video_url"] = videoUrl;
    map["relatedItems"] = relatedItems;
    map["logo_url"] = logoUrl;
    map["date"] = date;
    map["time"] = time;
    return map;
  }
}



