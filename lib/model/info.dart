import 'dart:convert';
import 'package:get/get.dart';

List<Info> InfoFromJson(String str) =>
    List<Info>.from(json.decode(str).map((x) => Info.fromJson(x)));

String InfoToJson(List<Info> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Info {
  Info({
    required this.appDescription,
  });

  String appDescription;

  var isFavorite = false.obs;

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    appDescription: json["app_description"],
  );

  Map<String, dynamic> toJson() => {
    "app_description":appDescription,
  };
}

