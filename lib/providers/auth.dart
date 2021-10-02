import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:lac/models/auth_data.dart';
import 'package:lac/utils/constants.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider with ChangeNotifier {

AuthData authData;

  bool auth=false;

  bool authModalLoading=false;

  String authModalMessage="";

  bool get authenticated => _auth();


  final String api = baseUrl;

  Future<bool> login(String email, String password) async {

    authModalLoading=true;
    authModalMessage="";
    print(authModalMessage);
    notifyListeners();

    final url = "$api/auth/login";
    Map<String, String> body = {
      'email': email,
      'password': password,
//      'password': "123",
    };
//print(password);
    try {
      final response = await http.post(url, body: body,);
      print(response.body);
      print('hi there');
      //return false;

      if (response.statusCode == 200) {
        Map<String, dynamic> apiResponse = json.decode(response.body);
        await storeUserData(apiResponse);
        //await userProvider.userData();
        //notifyListeners();

        authModalLoading=false;
        auth=true;
        notifyListeners();
        return true;
      }

      if (response.statusCode == 401) {
        //_notification = NotificationText('Invalid email or password.');
        authModalLoading=false;
        authModalMessage="Invalid username or Password";
        //print(authModalMessage);
        notifyListeners();
        return false;
      }



      notifyListeners();
      return false;
    }catch(e){
      //print(e.toString());
      print(e.toString());
      authModalLoading=false;
      notifyListeners();
      return false;
    }
  }

  Future<Map> getRegToken({String email}) async {
    final url = "$api/get-reg-token";
    Map<String, String> body = {};
    body={"email":email};
    var headers = {
      "Accept": "application/json"
    };
    Map result = {};

    try{
     final response = await http.post( url,headers: headers,  body:body);
     Map apiResponse = json.decode(response.body);
     //print(response.body);
     if(response.statusCode==200) {
       result['message']="";
       result['success']=true;
       //print(response.body);

     }

     if(response.statusCode==404) {
       result['message']="Invalid email address";
       result['success']=false;

     }

     if(response.statusCode==500) {
       result['message']=apiResponse['message'];
       result['success']=false;

     }
    return result;
    } catch(e){
      //result['message']='We\'re experiencing technical difficulties, please try again later';
      if(e is SocketException){
        result['message']="Check internet";
      }else{
        result['message']=e.toString();
      }
      result['success']=false;
      //print(e.toString());
      return result;
    }
  }



  Future<Map> validateRegToken({String email,String code}) async {
    final url = "$api/validate-reg-token";
    Map<String, String> body = {};
    body={"email":email,'code':code};
    var headers = {
      "Accept": "application/json"
    };
    Map result = {};

    try{
      final response = await http.post( url,headers: headers,  body:body);
      Map apiResponse = json.decode(response.body);
      print(response.body);
      if(response.statusCode==200) {
        result['message']="";
        result['success']=true;

      }

      if(response.statusCode==404) {
        result['message']="Invalid validation code";
        result['success']=false;

      }

      if(response.statusCode==500) {
        result['message']=apiResponse['message'];
        result['success']=false;

      }
      return result;
    } catch(e){
      //result['message']='We\'re experiencing technical difficulties, please try again later';
      if(e is SocketException){
        result['message']="Check internet";
      }else{
        result['message']=e.toString();
      }

      result['success']=false;
      //print(e.toString());
      return result;
    }
  }




Future<Map> getRegTokenForget({String email}) async {
  final url = "$api/get-reg-token-forget";
  Map<String, String> body = {};
  body={"email":email};
  var headers = {
    "Accept": "application/json"
  };
  Map result = {};

  try{
    final response = await http.post( url,headers: headers,  body:body);
    Map apiResponse = json.decode(response.body);
    //print(response.body);
    if(response.statusCode==200) {
      result['message']="";
      result['success']=true;
      //print(response.body);

    }

    if(response.statusCode==404) {
      result['message']="Invalid email address";
      result['success']=false;

    }

    if(response.statusCode==500) {
      result['message']=apiResponse['message'];
      result['success']=false;

    }
    return result;
  } catch(e){
    //result['message']='We\'re experiencing technical difficulties, please try again later';
    if(e is SocketException){
      result['message']="Check internet";
    }else{
      result['message']=e.toString();
    }
    result['success']=false;
    //print(e.toString());
    return result;
  }
}



Future<Map> validateRegTokenForget({String email,String code}) async {
  final url = "$api/validate-reg-token-forget";
  Map<String, String> body = {};
  body={"email":email,'code':code};
  var headers = {
    "Accept": "application/json"
  };
  Map result = {};

  try{
    final response = await http.post( url,headers: headers,  body:body);
    Map apiResponse = json.decode(response.body);
    print(response.body);
    if(response.statusCode==200) {
      result['message']="";
      result['success']=true;

    }

    if(response.statusCode==404) {
      result['message']="Invalid validation code";
      result['success']=false;

    }

    if(response.statusCode==500) {
      result['message']=apiResponse['message'];
      result['success']=false;

    }
    return result;
  } catch(e){
    //result['message']='We\'re experiencing technical difficulties, please try again later';
    if(e is SocketException){
      result['message']="Check internet";
    }else{
      result['message']=e.toString();
    }

    result['success']=false;
    //print(e.toString());
    return result;
  }
}




Future<Map> createPassword({String email, String password}) async {
    final url = "$api/create-password";
    Map<String, String> body = {};
    body={"password":password,"email":email};
    var headers = {
      "Accept": "application/json"
    };
    Map result = {};

    try{
      final response = await http.post( url,headers: headers,  body:body);
      Map apiResponse = json.decode(response.body);
      await storeUserData(apiResponse);
      print(response.body);
      if(response.statusCode==200) {
        result['message']="";
        result['success']=true;

      }

      if(response.statusCode==404) {
        result['message']="Invalid user";
        result['success']=false;

      }

      if(response.statusCode==500) {
        result['message']=apiResponse['message'];
        result['success']=false;

      }
      return result;
    } catch(e){
      //result['message']='We\'re experiencing technical difficulties, please try again later';
      if(e is SocketException){
        result['message']="Check internet";
      }else{
        result['message']=e.toString();
      }

      result['success']=false;
      //print(e.toString());
      return result;
    }
  }


  storeUserData(apiResponse) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setInt('id', apiResponse['user']['id']);
    await storage.setString('token', apiResponse['access_token']);
    await storage.setString('name', apiResponse['user']['name']);
    await storage.setString('email', apiResponse['user']['email']);
    await storage.setString('account_type', apiResponse['user']['account_type']);
    this.auth=true;
    notifyListeners();
    //print(storage.getString('name'));

//    if(apiResponse['user']['image']!=null)
//      await storage.setString('image', apiResponse['user']['image']);
//    if(apiResponse['user']['payment']!=null)
//      await storage.setString('payment', apiResponse['user']['payment']);
//    if(apiResponse['user']['account_type']=='student')
//      await storage.setString('payment', apiResponse['user']['payment']);

  }


Future<bool> submitFeedback(String email, String name, String message) async {

  authModalLoading=true;
  authModalMessage="";
  print(authModalMessage);
  notifyListeners();

  final url = "$api/feedback";
  Map<String, String> body = {
    'email': email,
    'name':name,
    'message':message,
//      'password': "123",
  };

  try {
    final response = await http.post(url, body: body,);
    print(response.body);

    if (response.statusCode == 200) {
      auth=true;
      notifyListeners();
      return true;
    }

    if (response.statusCode == 401) {
      //_notification = NotificationText('Invalid email or password.');
      authModalLoading=false;
      authModalMessage="Invalid username or Password";
      //print(authModalMessage);
      notifyListeners();
      return false;
    }



    notifyListeners();
    return false;
  }catch(e){
    //print(e.toString());
    authModalLoading=false;
    notifyListeners();
    return false;
  }
}

  getUserData()async{
    SharedPreferences storage = await SharedPreferences.getInstance();
    //notifyListeners();
    if(storage.getString('name')!=null)this.auth=true;
    this.authData = AuthData(name: storage.getString('name') ?? null, email: storage.getString('email') ?? null,token: storage.getString('token') ?? null,accountType: storage.getString('account_type') );
    notifyListeners();

  }

  logout() async {
        this.auth=false;
        authData.reset();
        //notifyListeners();
        SharedPreferences storage = await SharedPreferences.getInstance();
        await storage.clear();

  }


  bool _auth(){
    if( this.auth && this.authData.name!=null)return true;
    return false;
  }


////  Future<bool> passwordReset(String email) async {
////    final url = "$api/forgot-password";
////    Map<String, String> body = {
////      'email': email,
////    };
////
////    final response = await http.post( url, body: body, );
////
////    if (response.statusCode == 200) {
////      _notification = NotificationText('Reset sent. Please check your inbox.', type: 'info');
////      notifyListeners();
////      return true;
////    }
////
////    return false;
////  }
//

//
//  Future<String> getToken() async {
//    SharedPreferences storage = await SharedPreferences.getInstance();
//    String token = storage.getString('token');
//    return token;
//  }

//  logOut([bool tokenExpired = false]) async {
//    userProvider.clearUserData();
//    userProvider.userAuthenticated={};
//    _status = Status.Unauthenticated;
//    if (tokenExpired == true) {
//      _notification = NotificationText('Session expired. Please log in again.', type: 'info');
//    }
//    //userProviderModel=null;
//    SharedPreferences storage = await SharedPreferences.getInstance();
//    await storage.clear();
//    notifyListeners();
//    //print(_token);
//  }




}