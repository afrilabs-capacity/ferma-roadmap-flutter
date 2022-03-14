import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:roadmap/models/auth_data.dart';
import 'package:roadmap/utils/constants.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider with ChangeNotifier {

  AuthData authData;

  bool auth=false;

  bool authModalLoading=false;

  String authModalMessage="";

  /*set token*/
  String token;

  bool get authenticated => _auth();


  final String api = baseUrl;

  bool uploadingImage=false;
  bool sendingMessage=false;

  Future<bool> login(String email, String password) async {

    authModalLoading=true;
    authModalMessage="";
//    print(authModalMessage);
    notifyListeners();
    final url = "$api/login";
    Map<String, String> body = {
      'phone': email,
      'password': password,
      'auth_type': 'phone',
    };


    try {
      final response = await http.post(url, body: body,);
      print(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> apiResponse = json.decode(response.body);
        await storeUserData(apiResponse);
        authModalLoading=false;
        auth=true;
        getUserData();
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
//      print(e.toString());
      authModalLoading=false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePassword(String password) async {
    authModalLoading=true;
    authModalMessage="";
    notifyListeners();
//    getToken();
    final url = "$api/user/onboarding/password-change";
    Map<String, String> body = {
      'password': password,
    };
    var headers = {
      'Authorization':'Bearer $token',
      "Accept": "application/json"
    };

//    print(token);

    try {
      final response = await http.post(url,headers: headers, body: body,);


      if (response.statusCode == 200) {
        print(response.statusCode);
//        Map<String, dynamic> apiResponse = json.decode(response.body);
        SharedPreferences storage = await SharedPreferences.getInstance();
        await storage.setBool('onboarded', true);
        print("After async");
        getUserData();
        notifyListeners();
        return true;
      }

      if (response.statusCode == 401) {
        //_notification = NotificationText('Invalid email or password.');
        authModalLoading=false;
        authModalMessage="Oops! Please try again later.";
        notifyListeners();
        return false;
      }

      notifyListeners();
      return false;
    }catch(e){
      //print(e.toString());
//      print(e.toString());
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
//      print(response.body);
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
    await storage.setInt('id', apiResponse['data']['id']);
    await storage.setString('token', apiResponse['access_token']);
    await storage.setString('name', apiResponse['data']['name']);
    await storage.setString('email', apiResponse['data']['email']);
    await storage.setString('phone', apiResponse['data']['phone']);
    await storage.setBool('onboarded', apiResponse['data']['onboarded']);
    await storage.setBool('active', apiResponse['data']['active']);
    await storage.setBool('canReport', apiResponse['data']['can_report']);
    await storage.setString('roles', json.encode(apiResponse['data']['roles']));
    await storage.setString('photo', apiResponse['data']['photos']!=null ? apiResponse['data']['photos']['photo'] : "");
    this.auth=true;
    notifyListeners();
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
    print ('we are loading user data');
    SharedPreferences storage = await SharedPreferences.getInstance();
    print(storage.getString('name'));
    if(storage.getString('name')!=null)this.auth=true;
    if(storage.getString('name')!=null){
      this.authData = AuthData(
          id: storage.getInt('id') ?? null,
          name: storage.getString('name') ?? null,
          email: storage.getString('email') ?? null,
          token: storage.getString('token') ?? null,
          phone: storage.getString('phone'),
          photo: storage.getString('photo'),
          roles: json.decode(storage.getString('roles') ),
          onboarded: storage.getBool('onboarded'),
          active: storage.getBool('active'),
          canReport: storage.getBool('can_report')
      );
      notifyListeners();
    }


  }


  Future<Map> uploadProfileImage(base64,userId) async {
    final url = "$api/user/profile/avatar";
    Map<String, dynamic> body = {
      'photo': base64,
      'user_id': userId.toString(),
    };
    var headers = {
      'Authorization':'Bearer $token',
      "Accept": "application/json"
    };
    Map result = Map();
    try {
        uploadingImage=true;
        notifyListeners();
        final response = await http.post(url,headers: headers, body: body,);
        if (response.statusCode == 200) {
          var data= jsonDecode(response.body);
          uploadingImage=false;
          notifyListeners();
          result['success']=true;
          result['photo']=data['data'];
          SharedPreferences storage = await SharedPreferences.getInstance();
          await storage.setString('photo',result['photo']);
          await getUserData();
        } else {
          uploadingImage=false;
          notifyListeners();
          result['success']=false;
          result['photo']=null;
          print(response.body);
        }

    } catch (error) {
      uploadingImage=false;
      result['success']=false;
      result['photo']=null;
      notifyListeners();
      print(error);
      throw (error);
    }

    return result;
  }


  Future<Map> informationChange(message,userId) async {
    final url = "$api/user/contact";
    Map<String, dynamic> body = {
      'message': message,
      'user_id': userId.toString(),
    };
    var headers = {
      'Authorization':'Bearer $token',
      "Accept": "application/json"
    };
    Map result = Map();
    try {
      sendingMessage=true;
      notifyListeners();
      final response = await http.post(url,headers: headers, body: body,);
      if (response.statusCode == 200) {
        print(response.body);
        sendingMessage=false;
        notifyListeners();
        result['success']=true;
      } else {
        sendingMessage=false;
        notifyListeners();
        result['success']=false;
        print(response.body);
      }

    } catch (error) {
      sendingMessage=false;
      result['success']=false;
      notifyListeners();
      print(error);
//      return result;
      throw (error);

    }

    return result;
  }


  logout() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.clear();
    this.auth=false;
//    this.authData=null;
    notifyListeners();

  }


  bool _auth(){
    if( this.auth && this.authData.name!=null)return true;
    return false;
  }


  getToken() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    if (storage.getString('token') != null) {
      token = storage.getString('token');
      notifyListeners();
      return storage.getString('token');
    }
    return null;
  }}