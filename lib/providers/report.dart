import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:lac/models/auth_data.dart';
import 'package:lac/models/report_data.dart';
import 'package:lac/models/paginate_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:lac/views/home.dart';
import 'package:lac/utils/constants.dart';


class ReportProvider with ChangeNotifier {

  //ReportProvider(this.authConfig);

  //final bool authConfig;

  /*Auth data model class*/
  AuthData authData;

  /*is authenticated*/
  bool auth=true;

  /*set token*/
  String token;

  /*do we have initial data*/
  bool loaded=false;

  /*show filter or not*/
  bool showFilter=false;

  /*show report upload*/
  bool showReportMedia=false;

  /* Empty list of partners*/
  List<ReportData> reports = [];

  /* Empty list of partner*/
  ReportData report;

  /*loading indicator*/
  bool loadMore=false;

  /* Empty pagination data*/
  PaginateData  paginate;

  /*selected state*/
  String selectedState;

  /*selected state*/
  bool apiCallModal=false;

  /*api url*/
  final String api  = "$baseUrl/report";


  Future<Map> submitReport({@ required String firstName,@ required String lastName,@ required String gender,@ required String age,@ required String occupation,@ required String granted, @ required String caseType,@ required String offence, @ required String complaints, @ required String location,@ required  String bailStatus, @ required String outcome}) async {
    //url
    final url = "$api/new-daily-report";

    //object map
    Map body = {};

    body= caseType=="Criminal" ? {
    'first_name':firstName ,
    'last_name':lastName,
    'gender':gender ,
    'age':age ,
      'occupation': occupation ,
      'granted':granted ,
      'case_type':caseType ,
      'offence':offence,
      'location':location ,
      'bail_status':bailStatus ,
      'outcome':outcome
    }:{
      'first_name':firstName ,
      'last_name':lastName,
      'gender':gender ,
      'age':age ,
      'occupation': occupation ,
      'granted':granted ,
      'case_type':caseType ,
      'complaints':complaints ,
      'location':location ,
      'bail_status':bailStatus ,
      'outcome':outcome
    };

    var token =await this.getToken();

    //print(token);
    var headers = {
      HttpHeaders.authorizationHeader:'Bearer $token.',
      "Accept": "application/json"
    };
    Map result = {};

    try{
      final response = await http.post( url,headers: headers,  body:body);
      print(response.body);
      print(response.statusCode);
      Map apiResponse = json.decode(response.body);

      if(response.statusCode==200) {
        loaded=true;
        result['message']="";
        result['success']=true;
        result['code']=200;
        result['data']=parseReport(response.body);

      }

      if(response.statusCode==404) {
        result['message']="Invalid validation code";
        result['success']=false;
        result['code']=404;

      }

      if(response.statusCode==401) {
        result['message']="Session expired";
        result['success']=false;
        result['code']=401;
      }

      if(response.statusCode==422) {
        result['message']="Submission contains errors";
        result['success']=false;
        result['data']=apiResponse;
        result['code']=422;

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


  Future<Map> submitEditedReport({@ required String reportId,@ required String firstName,@ required String lastName,@ required String gender,@ required String age,@ required String occupation,@ required String granted, @ required String caseType,@ required String offence, @ required String complaints, @ required String location,@ required  String bailStatus, @ required String outcome}) async {
    //url
    final url = "$api/edited-daily-report";

    //object map
    Map body = {};

    body= caseType=="Criminal" ? {
      'report_id':reportId,
      'first_name':firstName ,
      'last_name':lastName,
      'gender':gender ,
      'age':age ,
      'occupation': occupation ,
      'granted':granted ,
      'case_type':caseType ,
      'offence':offence,
      'location':location ,
      'bail_status':bailStatus ,
      'outcome':outcome
    }:{
      'report_id':reportId,
      'first_name':firstName ,
      'last_name':lastName,
      'gender':gender ,
      'age':age ,
      'occupation': occupation ,
      'granted':granted ,
      'case_type':caseType ,
      'complaints':complaints ,
      'location':location ,
      'bail_status':bailStatus ,
      'outcome':outcome
    };

    var token =await this.getToken();

    //print(token);
    var headers = {
      HttpHeaders.authorizationHeader:'Bearer $token.',
      "Accept": "application/json"
    };
    Map result = {};

    try{
      final response = await http.post( url,headers: headers,  body:body);
      print(response.body);
      print(response.statusCode);
      Map apiResponse = json.decode(response.body);

      if(response.statusCode==200) {
        loaded=true;
        result['message']="";
        result['success']=true;
        result['code']=200;
        //result['data']=parseReport(response.body);
        //print(response.body);

      }

      if(response.statusCode==404) {
        result['message']="Invalid validation code";
        result['success']=false;
        result['code']=404;

      }

      if(response.statusCode==401) {
        result['message']="Session expired";
        result['success']=false;
        result['code']=401;
      }

      if(response.statusCode==422) {
        result['message']="Submission contains errors";
        result['success']=false;
        result['data']=apiResponse;
        result['code']=422;

      }

      if(response.statusCode==500) {
        result['message']=apiResponse['message'];
        result['success']=false;
        result['code']=500;
        //print(response.body);

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




  Future fetchReports() async {

    /*api url*/
    final url = "$api/fetch-reports";

    /*get token*/
    var token =await this.getToken();

    /*api headers*/
    var headers = {
      HttpHeaders.authorizationHeader:'Bearer $token.',
      "Accept": "application/json"
    };
    Map result = {};

    try{
      final response = await http.get( url,headers: headers);
      print(response.body);
      print(response.statusCode);
      Map apiResponse = json.decode(response.body);

      if(response.statusCode==200) {
        result['message']="";
        result['success']=true;
        result['code']=200;
        reports = parseReports(response.body);
        paginate=parseReportsPaginate(response.body);
        if(paginate.nextPageUrl!=null) loadMore=true;
        //print(paginate.nextPageUrl);
        loaded=true;
        showFilter=false;
        notifyListeners();

      }

      if(response.statusCode==404) {
        result['message']="Server error";
        result['success']=false;
        result['code']=404;

      }

      if(response.statusCode==401) {
        result['message']="Session expired";
        result['success']=false;
        result['code']=401;
        this.auth=false;
        notifyListeners();
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




  Future fetchReportSingle(String id) async {

    Map<String,String> searchPayload={};

    searchPayload={'report_id':id};

    /*api url*/
    final url = "$api/fetch-report/$id";

    /*get token*/
    var token =await this.getToken();

    /*build request uri*/
//    var uri = Uri.http(
//        '192.168.43.122:8080', '/laravel/site44/public/api/v1/report/fetch-report/', searchPayload);

    /*api headers*/
    var headers = {
      HttpHeaders.authorizationHeader:'Bearer $token.',
      "Accept": "application/json"
    };
    Map result = {};

    try{
      final response = await http.get( url,headers: headers);
      print(response.body);
      print(response.statusCode);
      Map apiResponse = json.decode(response.body);

      if(response.statusCode==200) {
        result['message']="";
        result['success']=true;
        result['code']=200;
        report = parseReport(response.body);
        notifyListeners();
      }

      if(response.statusCode==404) {
        result['message']="Server error";
        result['success']=false;
        result['code']=404;

      }

      if(response.statusCode==401) {
        result['message']="Session expired";
        result['success']=false;
        result['code']=401;
        this.auth=false;
        notifyListeners();
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



  fetchReportsPaginate() async {

    /*api url*/
    final url = "$api/fetch-reports";

    /*get token*/
    var token =await this.getToken();

    /*api headers*/
    var headers = {
      HttpHeaders.authorizationHeader:'Bearer $token.',
      "Accept": "application/json"
    };
    Map result = {};

    print("self paginate");

    try{
      final response = await http.get( paginate.nextPageUrl,headers: headers);
      //print(response.body);
      //print(response.statusCode);
      Map apiResponse = json.decode(response.body);
      if(response.statusCode==200) {
        result['message']="";
        result['success']=true;
        result['code']=200;
        reports = []..addAll(reports)..addAll(parseReports(response.body));
        paginate=parseReportsPaginate(response.body);
        if(paginate.nextPageUrl==null){
          loadMore=false;
        }
        else{
          loadMore=true;
        }
        //print(paginate.nextPageUrl);
        //print(loadMore);
        loaded=true;
        showFilter=false;
        notifyListeners();

      }

      if(response.statusCode==404) {
        result['message']="Server error";
        result['success']=false;
        result['code']=404;

      }

      if(response.statusCode==401) {
        result['message']="Session expired";
        result['success']=false;
        result['code']=401;
        this.auth=false;
        notifyListeners();
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


  searchReportsPaginate(Map searchPayload) async {

    /*api url*/
    final url = "$api/fetch-reports";

    /*get token*/
    var token =await this.getToken();

    /*build request uri*/
    var uri = Uri.http(
        hostUrl, '$hostUrlPartial/report/search', searchPayload);
    //'192.168.43.122:8080', '/laravel/site44/public/api/v1/report/search', searchPayload);

    /*api headers*/
    var headers = {
      HttpHeaders.authorizationHeader:'Bearer $token.',
      "Accept": "application/json"
    };
    Map result = {};

    try{
      final response = await http.get( uri,headers: headers);
      //print(response.body);
      print(response.statusCode);
      Map apiResponse = json.decode(response.body);

      if(response.statusCode==200) {
        result['message']="";
        result['success']=true;
        result['code']=200;
        reports =parseReports(response.body);
        paginate=parseReportsPaginate(response.body);
        if(paginate.nextPageUrl==null){loadMore=false;}else{loadMore=true;}
        //print(paginate.nextPageUrl);
        showFilter=false;
        loaded=true;

        notifyListeners();

      }

      if(response.statusCode==404) {
        result['message']="Server error";
        result['success']=false;
        result['code']=404;

      }

      if(response.statusCode==401) {
        result['message']="Session expired";
        result['success']=false;
        result['code']=401;
        this.auth=false;
        notifyListeners();

      }


      if(response.statusCode==500) {
        result['message']=apiResponse['message'];
        result['success']=false;
        result['code']=500;
        print(response.body);

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




  Future<Map> uploadReportImage({@ required String image,@ required String imageId,@ required String reportId}) async {

    //url
    final url = "$api/upload-report-image";

    //object map
    Map body = {};

    body={
      'image':image ,
      'image_id':imageId,
      'report_id':reportId
    };

    var token =await this.getToken();

    //print(token);
    var headers = {
      HttpHeaders.authorizationHeader:'Bearer $token.',
      "Accept": "application/json"
    };
    Map result = {};

    try{
      final response = await http.post( url,headers: headers,  body:body);
      print(response.body);
      print(response.statusCode);
      Map apiResponse = json.decode(response.body);

      if(response.statusCode==200) {
        loaded=true;
        result['message']="";
        result['success']=true;
        result['code']=200;

      }

      if(response.statusCode==404) {
        result['message']="Invalid validation code";
        result['success']=false;
        result['code']=404;

      }

      if(response.statusCode==401) {
        result['message']="Session expired";
        result['success']=false;
        result['code']=401;
      }

      if(response.statusCode==422) {
        result['message']="Submission contains errors";
        result['success']=false;
        result['data']=apiResponse;
        result['code']=422;

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



  Future<Map> deleteReportImage({@ required String imageId,@ required String reportId}) async {

    //url
    final url = "$api/delete-report-image";

    //object map
    Map body = {};

    body={
      'image_id':imageId,
      'report_id':reportId
    };

    var token =await this.getToken();

    this.apiCallModal=true;
    //print(token);
    notifyListeners();
    var headers = {
      HttpHeaders.authorizationHeader:'Bearer $token.',
      "Accept": "application/json"
    };
    Map result = {};

    try{
      final response = await http.post( url,headers: headers,  body:body);
      print(response.body);
      print(response.statusCode);
      Map apiResponse = json.decode(response.body);

      if(response.statusCode==200) {
        loaded=true;
        result['message']="";
        result['success']=true;
        result['code']=200;
        this.apiCallModal=false;
        notifyListeners();

      }

      if(response.statusCode==404) {
        result['message']="Invalid validation code";
        result['success']=false;
        result['code']=404;
        this.apiCallModal=false;
        notifyListeners();

      }

      if(response.statusCode==401) {
        result['message']="Session expired";
        result['success']=false;
        result['code']=401;
        this.apiCallModal=false;
        notifyListeners();
      }


      if(response.statusCode==500) {
        result['message']=apiResponse['message'];
        result['success']=false;
        result['code']=500;
        this.apiCallModal=false;
        notifyListeners();

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
      this.apiCallModal=false;
      notifyListeners();
      print(e.toString());
      return result;
    }
  }



  Future<Map> deleteReport({@ required String reportId}) async {

    //url
    final url = "$api/delete-report";

    //object map
    Map body = {};

    body={
      'report_id':reportId
    };

    var token =await this.getToken();

    this.apiCallModal=true;
    //print(token);
    notifyListeners();
    var headers = {
      HttpHeaders.authorizationHeader:'Bearer $token.',
      "Accept": "application/json"
    };
    Map result = {};

    try{
      final response = await http.post( url,headers: headers,  body:body);
      print(response.body);
      //print(response.statusCode);
      Map apiResponse = json.decode(response.body);

      if(response.statusCode==200) {
        loaded=true;
        result['message']="";
        result['success']=true;
        result['code']=200;
        this.apiCallModal=false;
        notifyListeners();

      }

      if(response.statusCode==404) {
        result['message']="Invalid validation code";
        result['success']=false;
        result['code']=404;
        this.apiCallModal=false;
        notifyListeners();

      }

      if(response.statusCode==401) {
        result['message']="Session expired";
        result['success']=false;
        result['code']=401;
        this.apiCallModal=false;
        notifyListeners();
      }


      if(response.statusCode==500) {
        result['message']=apiResponse['message'];
        result['success']=false;
        result['code']=500;
        this.apiCallModal=false;
        notifyListeners();

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
      this.apiCallModal=false;
      notifyListeners();
      print(e.toString());
      return result;
    }
  }


  getToken()async{
    SharedPreferences storage = await SharedPreferences.getInstance();
    if(storage.getString('token') != null){token=storage.getString('token');   notifyListeners(); return storage.getString('token'); }
    return null;


  }


  List<ReportData> parseReports(String responseBody) {
    final original = json.decode(responseBody).cast<String, dynamic>();
    final parsed =json.decode(jsonEncode(original['reports']['data']));
    return parsed.map<ReportData>((json) => ReportData.fromJson(json)).toList();
  }

  ReportData parseReport(String responseBody) {
    final original = json.decode(responseBody).cast<dynamic, dynamic>();
    final parsed =json.decode(jsonEncode(original['report']));
    return ReportData.fromJson(parsed);
  }

  PaginateData parseReportsPaginate(String responseBody) {
    final response= json.decode(responseBody);
    return  PaginateData.fromJson(response['reports'],'reports');
  }




}