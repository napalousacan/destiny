import 'dart:convert';
import 'package:get/get.dart';

import 'list_alaune_by_chaine.dart';

List<Group> GroupFromJson(String str) =>
    List<Group>.from(json.decode(str).map((x) => Group.fromJson(x)));

String GroupToJson(List<Group> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Group {
  Group({
    required this.allitems,
  });

  List<GroupItem> allitems;


  var isFavorite = false.obs;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    allitems: List<GroupItem>.from(
        json["allitems"].map((x) => GroupItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "allitems": List<dynamic>.from(allitems.map((x) => x.toJson())),
  };
}

class GroupItem {
  GroupItem({
    required this.groupName,
    required this.listShowsByGroup,
    //required this.listAlauneByChaine,
    required this.listshowsbychaines,
  });

  String groupName;
  String listShowsByGroup;
  List<ListShowsByChannel> listshowsbychaines;
  //List<ListShowsByChannel> listAlauneByChaine;

  factory GroupItem.fromJson(Map<String, dynamic> json) => GroupItem(
    groupName : json["group_name"],
    listShowsByGroup : json["list_shows_by_group"],
    listshowsbychaines : List<ListShowsByChannel>.from(json["list_shows_by_chaines"].map((x) => ListShowsByChannel.fromJson(x))),
    //listAlauneByChaine : List<ListShowsByChannel>.from(json["list_alaune_by_chaine"].map((x) => ListShowsByChannel.fromJson(x))),
  );

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["group_name"] = groupName;
    map["list_shows_by_group"] = listShowsByGroup;
    map["list_shows_by_chaines"] = List<dynamic>.from(listshowsbychaines.map((x) => x.toJson()));
    //map["list_alaune_by_chaine"] = List<dynamic>.from(listAlauneByChaine.map((x) => x.toJson()));
    return map;
  }
}





