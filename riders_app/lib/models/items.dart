import 'package:cloud_firestore/cloud_firestore.dart';

class Items{
  String? itemID;
  String? menuID;
  String? sellerUID;
  String? sellerName;
  String? title;
  String? shortInfo;
  String? longDescription;
  int? price;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? status;

  Items({
    this.itemID,
    this.menuID,
    this.sellerUID,
    this.sellerName,
    this.title,
    this.shortInfo,
    this.longDescription,
    this.price,
    this.publishedDate,
    this.thumbnailUrl,
    this.status,
  });

  Items.fromJson(Map<String, dynamic> json){
    itemID = json["itemID"];
    menuID = json["menuID"];
    sellerUID = json["sellerUID"];
    sellerName = json["sellerName"];
    title = json["title"];
    shortInfo = json["shortInfo"];
    longDescription = json["longDescription"];
    price = json["price"];
    publishedDate = json["publishedDate"];
    thumbnailUrl = json["thumbnailUrl"];
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["itemID"] = itemID;
    data["menuID"] = menuID;
    data["sellerUID"] = sellerUID;
    data["sellerName"] = sellerName;
    data["title"] = title;
    data["shortInfo"] = shortInfo;
    data["longDescription"] = longDescription;
    data["price"] = price;
    data["publishedDate"] = publishedDate;
    data["thumbnailUrl"] = thumbnailUrl;
    data["status"] = status;

    return data;
  }

}