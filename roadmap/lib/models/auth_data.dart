import 'package:shared_preferences/shared_preferences.dart';

class AuthData {
  int id;
  String token;
  String name;
  String email;
  String phone;
  String photo;
  bool onboarded;
  bool active;
  bool canReport;
  List<dynamic> roles;

  AuthData({this.id,this.name,this.token,this.email,this.phone,this.roles,this.onboarded,this.active,this.canReport,this.photo});

  void reset(){
    this.id=null;
    this.name=null;
    this.token=null;
    this.email=null;
    this.phone=null;
    this.roles=null;
    this.onboarded=null;
    this.active=null;
    this.canReport=null;
    this.photo=null;
  }



}