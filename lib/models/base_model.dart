import 'package:firebase_database/firebase_database.dart';

class BaseModel{
  String id;
  String url;
  String name;
  String status;
  BaseModel(DataSnapshot snapshot){
    this.id = snapshot.key;
    this.url = snapshot.value['url'];
    this.name = snapshot.value['name'];
    this.status = snapshot.value['status'];
  }
}