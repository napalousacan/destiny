import 'dart:convert';
import 'package:get/get.dart';

List<VideoUrl> VideoUrlFromJson(String str) =>
    List<VideoUrl>.from(json.decode(str).map((x) => VideoUrl.fromJson(x)));

String VideoUrlToJson(List<VideoUrl> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoUrl {
  VideoUrl({
    required this.videourl,
    //required this.directUrl
  });

  //String directUrl;
  String videourl;

  var isFavorite = false.obs;

  factory VideoUrl.fromJson(Map<String, dynamic> json) => VideoUrl(
    videourl: json["video_url"]
  );

  Map<String, dynamic> toJson() => {
    "video_url":videourl
  };
}

