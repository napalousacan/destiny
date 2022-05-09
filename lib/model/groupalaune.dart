import 'dart:convert';
import 'package:destiny/model/list_show_by_channel.dart';
import 'package:get/get.dart';

List<GroupAlaUne> GroupAlaUneFromJson(String str) =>
    List<GroupAlaUne>.from(json.decode(str).map((x) => GroupAlaUne.fromJson(x)));

String GroupAlaUneToJson(List<GroupAlaUne> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GroupAlaUne {
  GroupAlaUne({
    required this.allitems,
  });

  List<GroupalauneItem> allitems;


  var isFavorite = false.obs;

  factory GroupAlaUne.fromJson(Map<String, dynamic> json) => GroupAlaUne(
    allitems: List<GroupalauneItem>.from(
        json["allitems"].map((x) => GroupalauneItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "allitems": List<dynamic>.from(allitems.map((x) => x.toJson())),
  };
}

class GroupalauneItem {
  GroupalauneItem({
    required this.groupName,
    required this.listAlaunebygroup,
    required this.listAlauneByChaine,
    //required this.listshowsbychaines,
  });

  String groupName;
  String listAlaunebygroup;
  //List<ListShowsByChannel> listshowsbychaines;
  List<ListAlauneByChaine> listAlauneByChaine;

  factory GroupalauneItem.fromJson(Map<String, dynamic> json) => GroupalauneItem(
    groupName : json["group_name"],
    listAlaunebygroup : json["list_alaune_by_group"],
    listAlauneByChaine : List<ListAlauneByChaine>.from(json["list_alaune_by_chaine"].map((x) => ListAlauneByChaine.fromJson(x))),
  );

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["group_name"] = groupName;
    map["list_alaune_by_group"] = listAlaunebygroup;
    //map["list_shows_by_chaines"] = List<dynamic>.from(listshowsbychaines.map((x) => x.toJson()));
    map["list_alaune_by_chaine"] = List<dynamic>.from(listAlauneByChaine.map((x) => x.toJson()));
    return map;
  }
}





