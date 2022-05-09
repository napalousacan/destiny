import 'dart:convert';
import 'package:get/get.dart';

List<ListAlauneByChaine> ListAlauneByChaineFromJson(String str) =>
    List<ListAlauneByChaine>.from(json.decode(str).map((x) => ListAlauneByChaine.fromJson(x)));

String ListShowsByChannelToJson(List<ListAlauneByChaine> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListAlauneByChaine {
  ListAlauneByChaine({
    required this.chaineName,
    required this.chaineLogo,
    required this.alauneByChaine
  });

  String chaineName;
  String chaineLogo;
  String alauneByChaine;

  var isFavorite = false.obs;

  factory ListAlauneByChaine.fromJson(Map<String, dynamic> json) => ListAlauneByChaine(
      chaineName: json["chaine_name"],
      chaineLogo: json["chaine_logo"],
      alauneByChaine: json["alaune_by_chaine"],
  );

  Map<String, dynamic> toJson() => {
    "chaine_name":chaineName,
    "chaine_logo":chaineLogo,
    "alaune_by_chaine":alauneByChaine,
  };
}

