import 'dart:convert';
import 'package:get/get.dart';

List<AppDetails> AppDetailsFromJson(String str) =>
    List<AppDetails>.from(json.decode(str).map((x) => AppDetails.fromJson(x)));

String AppDetailsToJson(List<AppDetails> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AppDetails {
  AppDetails({
   required this.acanapi
  });

  List<ACANAPI> acanapi;

  var isFavorite = false.obs;

  factory AppDetails.fromJson(Map<String, dynamic> json) => AppDetails(
    acanapi: List<ACANAPI>.from(
        json["ACAN_API"].map((x) => ACANAPI.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "acanapi": List<dynamic>.from(acanapi.map((x) => x.toJson())),
  };
}

class ACANAPI {
  ACANAPI({
    required this.appName,
    required this.appLogo,
    required this.appDataUrl,
    required this.appYoutubeUrl,
    required this.appYoutubeUid,
    required this.appGoogleApikey,
    required this.appNewsUrl,
    required this.appFbUrl,
    required this.appTwitterUrl,
    required this.appVersion,
    required this.appAuthor,
    required  this.appContact,
    required  this.appEmail,
    required  this.appWebsite,
    required  this.appInfo,
    required  this.appDescription,
    required  this.appDevelopedBy,
    required  this.appPrivacyPolicy,
    required  this.publisherId,
    required  this.appId,
    required  this.interstitalAd,
    required  this.interstitalAdId,
    required  this.interstitalAdClick,
    required  this.bannerAd,
    required  this.bannerAdId,
    required  this.appDataToload,
  });

  String appName;
  String appLogo;
  String appDataUrl;
  String appYoutubeUrl;
  String appYoutubeUid;
  String appDataToload;
  String appGoogleApikey;
  String appNewsUrl;
  String appFbUrl;
  String appTwitterUrl;
  String appVersion;
  String appAuthor;
  String appContact;
  String appEmail;
  String appWebsite;
  String appInfo;
  String appDescription;
  String appDevelopedBy;
  String appPrivacyPolicy;
  String publisherId;
  String appId;
  String interstitalAd;
  String interstitalAdId;
  String interstitalAdClick;
  String bannerAd;
  String bannerAdId;

  factory ACANAPI.fromJson(Map<String, dynamic> json) => ACANAPI(
    appName : json["app_name"],
    appLogo : json["app_logo"],
    appDataUrl : json["app_data_url"],
    appDataToload : json["app_data_toload"],
    appYoutubeUrl : json["app_youtube_url"],
    appYoutubeUid : json["app_youtube_uid"],
    appGoogleApikey : json["app_google_apikey"],
    appNewsUrl : json["app_news_url"],
    appFbUrl : json["app_fb_url"],
    appTwitterUrl : json["app_twitter_url"],
    appVersion : json["app_version"],
    appAuthor : json["app_author"],
    appContact : json["app_contact"],
    appEmail : json["app_email"],
    appWebsite : json["app_website"],
    appInfo : json["app_info"],
    appDescription : json["app_description"],
    appDevelopedBy : json["app_developed_by"],
    appPrivacyPolicy : json["app_privacy_policy"],
    publisherId : json["publisher_id"],
    appId : json["app_id"],
    interstitalAd : json["interstital_ad"],
    interstitalAdId : json["interstital_ad_id"],
    interstitalAdClick : json["interstital_ad_click"],
    bannerAd : json["banner_ad"],
    bannerAdId : json["banner_ad_id"],
  );

  Map<String, dynamic> toJson() {
  var map = <String, dynamic>{};
  map["app_name"] = appName;
  map["app_logo"] = appLogo;
  map["app_data_url"] = appDataUrl;
  map["app_data_toload"] = appDataToload;
  map["app_youtube_url"] = appYoutubeUrl;
  map["app_youtube_uid"] = appYoutubeUid;
  map["app_google_apikey"] = appGoogleApikey;
  map["app_news_url"] = appNewsUrl;
  map["app_fb_url"] = appFbUrl;
  map["app_twitter_url"] = appTwitterUrl;
  map["app_version"] = appVersion;
  map["app_author"] = appAuthor;
  map["app_contact"] = appContact;
  map["app_email"] = appEmail;
  map["app_website"] = appWebsite;
  map["app_info"] = appInfo;
  map["app_description"] = appDescription;
  map["app_developed_by"] = appDevelopedBy;
  map["app_privacy_policy"] = appPrivacyPolicy;
  map["publisher_id"] = publisherId;
  map["app_id"] = appId;
  map["interstital_ad"] = interstitalAd;
  map["interstital_ad_id"] = interstitalAdId;
  map["interstital_ad_click"] = interstitalAdClick;
  map["banner_ad"] = bannerAd;
  map["banner_ad_id"] = bannerAdId;
  return map;
  }
}



