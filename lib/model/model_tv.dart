import 'dart:convert';
import 'package:get/get.dart';

List<Tv> TvFromJson(String str) =>
    List<Tv>.from(json.decode(str).map((x) => Tv.fromJson(x)));

String TvToJson(List<Tv> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tv {
  Tv({
    required this.allitems
  });

  List<Tvitems> allitems;

  var isFavorite = false.obs;

  factory Tv.fromJson(Map<String, dynamic> json) => Tv(
    allitems: List<Tvitems>.from(
        json["allitems"].map((x) => Tvitems.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "allitems": List<dynamic>.from(allitems.map((x) => x.toJson())),
  };
}

class Tvitems {
  Tvitems({
    required this.title,
    required this.desc,
    required this.logo,
    required this.logoUrl,
    required this.vodFeed,
    required this.alauneFeed,
    required this.type,
    required this.feedUrl,
    required this.streamUrl,
  });

  String title;
  String desc;
  String logo;
  String logoUrl;
  String alauneFeed;
  String vodFeed;
  String type;
  String feedUrl;
  String streamUrl;

  factory Tvitems.fromJson(Map<String, dynamic> json) => Tvitems(
    title : json["title"],
    desc : json["desc"],
    logo : json["logo"],
    type : json["type"],
    feedUrl : json["feed_url"],
    streamUrl : json["stream_url"],
    alauneFeed: json["alaune_feed"],
    logoUrl: json["logo_url"],
    vodFeed: json["vod_feed"],
  );

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["title"] = title;
    map["desc"] = desc;
    map["logo"] = logo;
    map["type"] = type;
    map["feed_url"] = feedUrl;
    map["stream_url"] = streamUrl;
    map["alaune_feed"] = alauneFeed;
    map["logo_url"] = logoUrl;
    map["vod_feed"] = vodFeed;
    return map;
  }
}



