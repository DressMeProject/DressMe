import 'package:cloud_firestore/cloud_firestore.dart';

class Items {
  String? categoryID;
  String? userUID;
  String? itemID;
  String? title;
  String? shortInfo;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? status;
  String? colorRGB;
  String? season;
  String? style;

  Items({
    this.categoryID,
    this.userUID,
    this.itemID,
    this.title,
    this.shortInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.status,
    this.colorRGB,
    this.season,
    this.style,
  });

  Items.fromJson(Map<String, dynamic> json) {
    categoryID = json['categoryID'];
    userUID = json['userUID'];
    itemID = json['itemID'];
    title = json['title'];
    shortInfo = json['shortInfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    status = json['status'];
    colorRGB = json['colorRGB'];
    season = json['season'];
    style = json['style'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['categoryID'] = categoryID;
    data['userUID'] = userUID;
    data['itemID'] = itemID;
    data['title'] = title;
    data['shortInfo'] = shortInfo;
    data['colorRGB'] = colorRGB;
    data['season'] = season;
    data['style'] = style;
    data['publishedDate'] = publishedDate;
    data['thumbnailUrl'] = thumbnailUrl;
    data['status'] = status;
    return data;
  }
}
