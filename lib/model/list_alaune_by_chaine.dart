import 'dart:convert';
import 'package:get/get.dart';

List<ListShowsByChannel> ListShowsByChannelFromJson(String str) =>
    List<ListShowsByChannel>.from(json.decode(str).map((x) => ListShowsByChannel.fromJson(x)));

String ListShowsByChannelToJson(List<ListShowsByChannel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListShowsByChannel {
  ListShowsByChannel({
    required this.chaineName,
    required this.chaineDesc,
    required this.chaineLogo,
    required this.listShows
  });

  String chaineName;
  String chaineDesc;
  String chaineLogo;
  String listShows;

  var isFavorite = false.obs;

  factory ListShowsByChannel.fromJson(Map<String, dynamic> json) => ListShowsByChannel(
      chaineName: json["chaine_name"],
      chaineLogo: json["chaine_desc"],
      chaineDesc: json["chaine_logo"],
      listShows: json["list_shows"],
  );

  Map<String, dynamic> toJson() => {
    "chaine_name":chaineName,
    "chaine_desc":chaineLogo,
    "list_shows":chaineDesc,
    "chaine_logo":listShows,
  };
}

