import 'dart:convert';
import 'package:get/get.dart';

List<Emission> EmissionFromJson(String str) =>
    List<Emission>.from(json.decode(str).map((x) => Emission.fromJson(x)));

String EmissionToJson(List<Emission> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Emission {
  Emission({
    required this.allitems
  });

  List<Emissionitem> allitems;

  var isFavorite = false.obs;

  factory Emission.fromJson(Map<String, dynamic> json) => Emission(
    allitems: List<Emissionitem>.from(
        json["allitems"].map((x) => Emissionitem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "allitems": List<dynamic>.from(allitems.map((x) => x.toJson())),
  };
}

class Emissionitem {
  Emissionitem({
    required this.title,
    required this.desc,
    required this.logo,
    required this.type,
    required this.feedUrl,
    required this.logoUrl,
    required this.chaineLogo,
    required this.chaineName,
    required this.date,
    required this.relatedItems,
    required this.time,
    required this.videoUrl
  });

  String title;
  String logo;
  String logoUrl;
  String desc;
  String feedUrl;
  String relatedItems;
  String time;
  String date;
  String type;
  String chaineName;
  String chaineLogo;
  String videoUrl;

  factory Emissionitem.fromJson(Map<String, dynamic> json) => Emissionitem(
    title : json["title"],
    desc : json["desc"],
    logoUrl : json["logo_url"],
    type : json["type"],
    feedUrl : json["feed_url"],
    relatedItems : json["relatedItems"],
    chaineName : json["chaine_name"],
    chaineLogo : json["chaine_logo"],
    videoUrl : json["video_url"],
    date : json["date"],
    time : json["time"],
    logo : json["logo"],
  );

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["title"] = title;
    map["desc"] = desc;
    map["logo_url"] = logoUrl;
    map["type"] = type;
    map["feed_url"] = feedUrl;
    map["relatedItems"] = relatedItems;
    map["chaine_name"] = chaineName;
    map["chaine_logo"] = chaineLogo;
    map["video_url"] = videoUrl;
    map["date"] = date;
    map["time"] = time;

    map["logo"] = logo;
    return map;
  }
}



