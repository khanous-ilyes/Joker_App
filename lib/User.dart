import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  int? id;
  String? name;

  UserModel({this.id, this.name});

  UserModel.fromJson(DocumentSnapshot json) {
    this.id = json['id'];
    this.name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
