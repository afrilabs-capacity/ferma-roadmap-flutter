import 'package:shared_preferences/shared_preferences.dart';

class AuthData {
  String token;
  String name;
  String email;
  String accountType;

  AuthData({this.name,this.token,this.email,this.accountType});

  void reset(){
    this.name=null;
    this.token=null;
    this.email=null;
    this.accountType=null;
}



}