import 'package:cloud_firestore/cloud_firestore.dart';

class Categorys {
  String? categoryID;
  String? userUID;
  String? categoryTitle;
  String? clothes;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? status;

  Categorys({this.categoryID, this.userUID, this.categoryTitle, this.publishedDate, this.thumbnailUrl, this.status});

  Categorys.fromJson(Map<String, dynamic> json) {
    categoryID = json["categoryID"];
    userUID = json['userUID'];
    categoryTitle = json['categoryTitle'];
    clothes = json['clothes'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["categoryID"] = categoryID;
    data['userUID'] = userUID;
    data['categoryTitle'] = categoryTitle;
    data['clothes'] = clothes;
    data['publishedDate'] = publishedDate;
    data['thumbnailUrl'] = thumbnailUrl;
    data['status'] = status;

    return data;
  }
}
