import 'dart:convert';
import 'package:get/get.dart';

List<PlayerUrl> PlayerUrlFromJson(String str) =>
    List<PlayerUrl>.from(json.decode(str).map((x) => PlayerUrl.fromJson(x)));

String PlayerUrlToJson(List<PlayerUrl> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlayerUrl {
  PlayerUrl({
    //required this.videoUrl,
    required this.directUrl
  });

  String directUrl;
  //String videoUrl;

  var isFavorite = false.obs;

  factory PlayerUrl.fromJson(Map<String, dynamic> json) => PlayerUrl(
      directUrl: json["direct_url"],
      //videoUrl: json["video_url"]
  );

  Map<String, dynamic> toJson() => {
    "direct_url":directUrl,
    //"video_url":videoUrl
  };
}

