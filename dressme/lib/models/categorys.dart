import 'package:cloud_firestore/cloud_firestore.dart';

class Categorys {
  String? categoryID;
  String? userUID;
  String? categoryTitle;
  String? categoryInfo;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? status;

  Categorys({this.categoryID, this.userUID, this.categoryTitle, this.categoryInfo, this.publishedDate, this.thumbnailUrl, this.status});

  Categorys.fromJson(Map<String, dynamic> json) {
    categoryID = json["categoryID"];
    userUID = json['userUID'];
    categoryTitle = json['categoryTitle'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["categoryID"] = categoryID;
    data['userUID'] = userUID;
    data['categoryTitle'] = categoryTitle;
    data['publishedDate'] = publishedDate;
    data['thumbnailUrl'] = thumbnailUrl;
    data['status'] = status;

    return data;
  }
}
