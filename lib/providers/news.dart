import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:lac/models/news_data.dart';



class NewsProvider with ChangeNotifier {

  //ReportProvider(this.authConfig);

  //final bool authConfig;



  /*is authenticated*/
  bool auth=true;

  /*set token*/
  String token;

  /*do we have initial data*/
  bool loaded=false;

  /* Empty list of partners*/
  List<NewsData> news = [];






  Future fetchNews() async {

    /*api url*/
    final url = "https://legalaidcouncil.gov.ng/feed/json";

    /*api headers*/
    var headers = {
      "Accept": "application/json"
    };
    Map result = {};

    try{
      final response = await http.get( url,headers: headers);
      //print(response.body);
      print(response.statusCode);
      Map apiResponse = json.decode(response.body);

      if(response.statusCode==200) {
        result['message']="";
        result['success']=true;
        result['code']=200;
        news = parseNews(response.body);
        //print(news[0].image);
        loaded=true;
        notifyListeners();

      }

      if(response.statusCode==404) {
        result['message']="Server error";
        result['success']=false;
        result['code']=404;

      }


      if(response.statusCode==500) {
        result['message']=apiResponse['message'];
        result['success']=false;
        result['code']=500;

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
      print(e.toString());
      return result;
    }
  }



  List<NewsData> parseNews(String responseBody) {
    final original = json.decode(responseBody).cast<String, dynamic>();
    final parsed =json.decode(jsonEncode(original['items']));
    return parsed.map<NewsData>((json) => NewsData.fromJson(json)).toList();
  }





}