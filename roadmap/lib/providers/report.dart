import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:roadmap/models/auth_data.dart';
import 'package:roadmap/models/report_data.dart';
import 'package:roadmap/models/paginate_data.dart';
import 'package:flutter/cupertino.dart';
//import 'package:roadmap/views/home.dart';
import 'package:roadmap/utils/constants.dart';
import 'package:roadmap/db/database_helper.dart';
import 'dart:developer';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';



class ReportProvider with ChangeNotifier {

  //ReportProvider(this.authConfig);

  //final bool authConfig;

  /*Auth data model class*/
  AuthData authData;

  /*is authenticated*/
  bool auth = true;

  /*set token*/
  String token;

  /*set longitude*/
  String longitude;

  /*set token*/
  String latitude;

  /*set photos*/
  List<Map<String, dynamic>> photos = [];

  /*set message*/
  String message;

  /*do we have initial data*/
  bool loaded = false;

  /*show filter or not*/
  bool showFilter = false;

  /*show report upload*/
  bool showReportMedia = false;

  /* Empty list of partners*/
  List reports = [];

  /* Empty list of report messages*/
  List reportMessages = [];

  /* Empty list of broadcast messages*/
  List broadcastMessages = [];

  /* Empty list of partner*/
  dynamic report;

  /*loading indicator*/
  bool loadMore = false;

  /* Empty pagination data*/
  PaginateData paginate;

  /*selected state*/
  String selectedState;

  /*selected state*/
  bool apiCallModal = false;

  /*selected state*/
  bool isSingleReportClicked = false;

  /*set sync status*/
  bool isSyncing = false;

  /*api url*/
  final String api = baseUrl;

  /*set current record*/
  int currentRecord;

  /*set navigation index*/
  int bottomNavigationIndex=0;

  /*set synced*/
  int synced=0;

  /*set unsynced*/
  int unsynced=0;

  /*set approved*/
  int approved=0;

  /*set queried*/
  int queried=0;

  /*set rejected*/
  int rejected=0;

  /*set pending*/
  int pending=0;

  /*determine if user dan post comment*/
  bool canPostComment=false;

  /*Last comment by timestamp*/
 List canPostCommentData=[];

  /*set unsynced messages*/
  int unsyncedMessages=0;

  String syncComment="";



  Future<Map<String,dynamic>> saveLocal(String message,int id) async {
    final dbHelper = DatabaseHelper.instance;
    Map<String,dynamic> result={'success':false,'id':null};
    Map<String, dynamic> row = {
      'uuid':Uuid().v4(),
      'message': message,
      'photo_1': photos.asMap()[0]!=null ? photos[0]['base64'] : null ,
      'photo_2': photos.asMap()[1]!=null ? photos[1]['base64'] : null ,
      'photo_3': photos.asMap()[2]!=null ? photos[2]['base64'] : null ,
      'photo_4': photos.asMap()[3]!=null ? photos[3]['base64'] : null ,
      'longitude': longitude,
      'latitude': latitude,
      'project_id': 1,
      'user_id': id,
      'posted':DateTime.now().toString(),
      'status': 'Pending',
      'sync_status': 0
    };

    try{
//      int n=0;
//      do {
//       n++;
//       row['uuid']=Uuid().v4();
//       final id = await dbHelper.insert(row);
//      }
//      while(n<20);
      final id = await dbHelper.insert(row);
      log('inserted row id: $id');
      photos.clear();
      currentRecord=id;
      result={'success':true,'id':id};
    }catch(e) {
      log(e.toString());
      result={'success':false,'id':null};
    }
return result;

  }


  Future<Map<String,dynamic>> saveLocalMessage(String comment,int userId) async {
    final dbHelper = DatabaseHelper.instance;
    Map<String,dynamic> result={'success':false,'id':null};
    try{
      Map <String,dynamic> row = {
        'uuid':Uuid().v4(),
        'report_uuid':report[0]['uuid'],
        'type':'Ad-Hoc',
        'posted':DateTime.now().toString(),
        'comment': comment,
        'user_id': userId,
        'status':"***",
        'sync_status': 0
      };

      final id = await dbHelper.insertMessage(row);
      await queryAllReportMessagesRecentlyPosted(userId).then((value) => notifyListeners());
      log('inserted row id: $id');
      result={'success':true,'id':id};
    }catch(e) {
      log(e.toString());
      result={'success':false,'id':null};
    }
    return result;

  }




  /*Fetch all records from db*/
  Future<dynamic> queryAllRecords() async {
    final dbHelper = DatabaseHelper.instance;
    final allData = await dbHelper.queryAllRecords();
    return allData;
  }

  /*Fetch records into list*/
  void getAllData()async{
    reports.clear();
    var allRows = await queryAllRecords();
    allRows.forEach((row)async {
      reports.add(row);
      log(row);
    }   );
  }

  /*Fetch single report*/
  Future<void> querySingleReport() async {
    final dbHelper = DatabaseHelper.instance;
    final data = await dbHelper.singleRecord(currentRecord);
    report=data;
    notifyListeners();
  }



  /// Find the first date of the week which contains the provided date.
  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  /// Find last date of the week which contains provided date.
  DateTime findLastDateOfTheWeek(DateTime dateTime) {
//    print(dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday)));
    return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  //  /*Fetch all records from db (Today)*/
  Future<void> queryAllRecordsToday(int userId) async {
    DateTime today = DateTime.now();
    final dbHelper = DatabaseHelper.instance;
    final allData = await dbHelper.queryAllRecordsToday(today.toString(),userId);
    reports=[];
    reports=allData;
    notifyListeners();
  }


  /*Fetch all records from db (This Week)*/
  Future<void> queryAllRecordsThisWeek(int userId) async {
    DateTime today = DateTime.now();
    final dbHelper = DatabaseHelper.instance;
    final allData = await dbHelper.queryAllRecordsThisWeek(findFirstDateOfTheWeek(today).toString(),findLastDateOfTheWeek(today).toString(),userId);
    reports=[];
    reports=allData;
    notifyListeners();
    //return allData;
  }

  /*Fetch all records from db (This Week)*/
  Future<void> queryAllRecordsThisMonth(int userId) async {
    final now = DateTime.now();
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final firstDayOfMonth = DateTime(now.year, now.month + 0);
    final dbHelper = DatabaseHelper.instance;
    final allData = await dbHelper.queryAllRecordsThisMonth(firstDayOfMonth.toString(),lastDayOfMonth.toString(),userId);
    reports=[];
    reports=allData;
    notifyListeners();
    //return allData;
  }

  /*Fetch all records from db (All Time)*/
  Future<List> queryAllRecordsAllTime(int userId) async {
    DateTime today = DateTime.now();
    final dbHelper = DatabaseHelper.instance;
    final allData = await dbHelper.queryAllRecordsAllTime(userId);
    reports=[];
    reports=allData;
    notifyListeners();
    return allData;
  }

  /*Fetch all records from db (All Time)*/
  Future<void> queryAllReportMessages(int userId) async {
    final dbHelper = DatabaseHelper.instance;
    final allData = await dbHelper.queryReportCommentsUUIDUserId(report[0]['uuid'], userId);
    reportMessages =[];
    reportMessages =allData;
    notifyListeners();
//  await dbHelper.deleteMessage(16);
  }

  /*Fetch all records from db (All Time)*/
  Future<void> queryAllBroadcastMessages() async {
    final dbHelper = DatabaseHelper.instance;
    final allData = await dbHelper.queryAllBroadcastMessages();
    broadcastMessages =[];
    broadcastMessages =allData;
    notifyListeners();
//  await dbHelper.deleteMessage(16);
  }


  /*Fetch all records from db (All Time)*/
  Future<void> queryAllReportMessagesRecentlyPosted(int userId) async {
    final dbHelper = DatabaseHelper.instance;
    final allData = await dbHelper.queryReportCommentsUUIDUserIdRecentlyPosted(report[0]['uuid'], userId);
   if(allData.length > 0){
     canPostCommentData =allData;
     if(allData[0]['type']=='Ad-Hoc'){
       canPostComment=false;
     }else{
       canPostComment=true;
     }


   }
    notifyListeners();
    //return allData;
  }

  /*Count all records unsynchronized*/
  Future<void> queryAllRecordsCountUnsynchronized(int userId) async {
    final dbHelper = DatabaseHelper.instance;
    final count = await dbHelper.queryAllRecordsCountUnsynchronized(userId);
    unsynced=count;
    notifyListeners();
  }

  /*Count all records synchronized*/
  Future<void> queryAllRecordsCountSynchronized(int userId) async {
    final dbHelper = DatabaseHelper.instance;
    final count = await dbHelper.queryAllRecordsCountSynchronized(userId);
    synced=count;
    notifyListeners();
  }


  /*Count all records approved*/
  Future<void> queryAllRecordsCountApproved() async {
    final dbHelper = DatabaseHelper.instance;
    final count = await dbHelper.queryAllRecordsCountApproved();
    approved=count;
    notifyListeners();
  }

  /*Count all records queried*/
  Future<void> queryAllRecordsCountQueried() async {
    final dbHelper = DatabaseHelper.instance;
    final count = await dbHelper.queryAllRecordsCountQueried();
    queried=count;
    notifyListeners();
  }

  /*Count all records rejected*/
  Future<void> queryAllRecordsCountRejected() async {
    final dbHelper = DatabaseHelper.instance;
    final count = await dbHelper.queryAllRecordsCountRejected();
    rejected=count;
    notifyListeners();
  }

  /*Count all records rejected*/
  Future<void> queryAllRecordsCountPending() async {
    final dbHelper = DatabaseHelper.instance;
    final count = await dbHelper.queryAllRecordsCountPending();
    pending=count;
    notifyListeners();
  }

  /*Count all records rejected*/
  Future<int> queryAllReportCountComments(int userId) async {
    final dbHelper = DatabaseHelper.instance;
    final count = await dbHelper.queryAllReportCountComments(userId);
    return count;
  }

  Future<void> syncNow(_connectionStatus,int userId)async{
    final dbHelper = DatabaseHelper.instance;
    if(_connectionStatus == true){
      var allRows = await dbHelper.queryAllRecordsUnsynchronized(userId);
      var allRowsPS = await dbHelper.queryAllRecordsPendingSynchronized(userId);
     var allRowsRM = await dbHelper.queryReportCommentsUserId(userId);

      if(unsynced!=0){
        syncComment="Initializing...";
        syncComment="Found $unsynced reports...";
        allRows.forEach((row)async {
          await sync(row,_connectionStatus).then((saved) async{
            if(saved){
              await dbHelper.update(row);
              queryAllRecordsCountUnsynchronized(userId);
              queryAllRecordsCountSynchronized(userId);
            }
          });

        }   );
        syncComment="Synced $unsynced reports...";

      }

      allRowsPS.forEach((row)async {
        syncComment="Updating status for ${allRowsPS.length} reports...";
        await syncStatus(row,_connectionStatus).then((saved) async{
          if(saved['success']){
            await dbHelper.updateWithUUID(saved['data']);

          }
        });


      }   );


    bool reportMessagesExist= await queryAllReportCountComments(userId) > 0 ? true : false;
    if(!reportMessagesExist){
      final dbHelper = DatabaseHelper.instance;
      final count = await dbHelper.queryAllRecordsCountSynchronized(userId);
      if(count > 0){
       final syncedRecorduuids=await dbHelper.queryAllRecordsPendingSynchronized(userId);
       syncedRecorduuids.forEach((row)async{
         await fetchReportComments(row['uuid'],userId,false);
       });

      }

    }
    else{
      final dbHelper = DatabaseHelper.instance;
      final count = await dbHelper.queryAllRecordsCountSynchronized(userId);

      if(count > 0){
        final syncedRecorduuids=await dbHelper.queryAllRecordsPendingSynchronized(userId);
        syncedRecorduuids.forEach((row)async{
          await fetchReportComments(row['uuid'],userId,true);
        });

      }

    }

      if(allRowsRM.length > 0){
        allRowsRM.forEach((row)async {
          await syncMessages(row,_connectionStatus).then((saved) async{
            if(saved){
           await dbHelper.updateMessage(row);

            }
          });

        }   );

      }

      await fetchBroadcastMessages();

      await syncFromServerToLocal(_connectionStatus,userId).then((data){
        final dbHelper = DatabaseHelper.instance;
        if(data['success']){
          if(data['data']['data'].length > 0){
//            print(data['data']['data'][0]['uuid'] );
             data['data']['data'].forEach((entry) async{
            var photo_1 = entry['photo_1']!=null ?  await networkImageToBase64('$hostUrl/uploads/${entry['photo_1']}') : null;
            var photo_2 = entry['photo_2']!=null ?  await networkImageToBase64('$hostUrl/uploads/${entry['photo_2']}') : null;
            var photo_3 = entry['photo_3']!=null ?  await networkImageToBase64('$hostUrl/uploads/${entry['photo_3']}') : null;
            var photo_4 = entry['photo_4']!=null ?  await networkImageToBase64('$hostUrl/uploads/${entry['photo_4']}') : null;

            Map<String, dynamic> row = {
              'uuid':entry['uuid'],
              'message': entry['message']!=null ? entry['message'] : "",
              'photo_1': photo_1,
              'photo_2': photo_2,
              'photo_3': photo_3,
              'photo_4': photo_4,
              'longitude': entry['longitude'],
              'latitude': entry['latitude'],
              'project_id': 1,
              'user_id': userId,
              'posted':entry['posted'],
              'status': entry['status'],
              'sync_status': 1
            };
            final id = await dbHelper.insert(row);
            queryAllRecordsCountSynchronized(userId);
               });
          }



        }
      });

      syncComment="Synchronization Complete...";
      notifyListeners();

    }//Check for connection before sending


  }



  Future<bool> sync(report,_connectionStatus) async {
    final url = "$api/report";
    Map<String, dynamic> body = {
      'uuid': report['uuid'],
      'status': report['status'],
      'message': report['message'],
      'longitude':report['longitude'],
      'latitude':report['latitude'],
      'photo_1':report['photo_1'] ?? "",
      'photo_2':report['photo_2'] ?? "",
      'photo_3':report['photo_3'] ?? "",
      'photo_4':report['photo_4'] ?? "",
      'posted':report['submitted'],
      'user_id':report['user_id'].toString(),
      'project_id':1.toString(),
    };
    var headers = {
      'Authorization':'Bearer $token',
      "Accept": "application/json"
    };
    try {
      if(_connectionStatus == true){
        isSyncing=true;
        notifyListeners();
        final response = await http.post(url,headers: headers, body: body,);
        if (response.statusCode == 200) {
          isSyncing=false;
          notifyListeners();
          return true;
        } else {
          isSyncing=false;
          notifyListeners();
          return false;
        }
      }else{
        isSyncing=false;
        notifyListeners();
        return false;
      }
    } catch (error) {
      isSyncing=false;
      notifyListeners();
//      print(error);
      throw (error);
    }
  }


  Future<Map> syncStatus(report,_connectionStatus) async {
    final url = "$api/report/sync";
    Map<String, dynamic> body = {
      'uuid': report['uuid'],
    };
    var headers = {
      'Authorization':'Bearer $token',
      "Accept": "application/json"
    };
    Map<String,dynamic> responseData=Map();
    try {
      if(_connectionStatus == true){
        isSyncing=true;
        notifyListeners();
        final response = await http.post(url,headers: headers, body: body,);
        if (response.statusCode == 200) {
          isSyncing=false;
          notifyListeners();
          responseData['data']=jsonDecode(response.body);
          responseData['success']=true;
          return responseData;
        } else {
          isSyncing=false;
          notifyListeners();
          responseData['success']=false;
          return  responseData;
        }
      }else{
        isSyncing=false;
        notifyListeners();
        responseData['success']=false;
        return  responseData;
      }

    } catch (error) {
      isSyncing=false;
      notifyListeners();
      responseData['success']=false;
      return  responseData;
    }
  }


  Future<Map> syncFromServerToLocal(_connectionStatus,int userId) async {
    final url = "$api/report/download/sync";

    var headers = {
      'Authorization':'Bearer $token',
      "Accept": "application/json"
    };
    Map<String,dynamic> responseData=Map();
    try {

      bool doesLocalDatabaseHaveRecords= await queryAllRecordsAllTime(userId).then((value) => value.length >0 ? true : false);
//      print(doesLocalDatabaseHaveRecords);
      if(_connectionStatus == true  && !doesLocalDatabaseHaveRecords){
        //print('dowloading from server');
        isSyncing=true;
        notifyListeners();
        final response = await http.get(url,headers: headers);
        //print(response.body);
        if (response.statusCode == 200) {
          isSyncing=false;
          notifyListeners();
          responseData['data']=jsonDecode(response.body);
          responseData['success']=true;
          return responseData;
        } else {
          isSyncing=false;
          notifyListeners();
          responseData['success']=false;
          return  responseData;
        }
      }else{
        isSyncing=false;
        notifyListeners();
        responseData['success']=false;
        return  responseData;
      }

    } catch (error) {
      isSyncing=false;
      notifyListeners();
      responseData['success']=false;
      return  responseData;
    }
  }


  Future<bool> syncMessages(message,_connectionStatus) async {
    final url = "$api/queried";
    Map<String, dynamic> body = {
      'report_uuid': message['report_uuid'],
      'uuid': message['uuid'],
      'comment': message['comment'],
    };
    var headers = {
      'Authorization':'Bearer $token',
      "Accept": "application/json"
    };

    try {
      if(_connectionStatus == true){
        isSyncing=true;
        notifyListeners();
        final response = await http.post(url,headers: headers, body: body,);
        if (response.statusCode == 200) {
          isSyncing=false;
          notifyListeners();
          return true;
        } else {
          isSyncing=false;
          notifyListeners();
          return false;
        }
      }else{
        isSyncing=false;
        notifyListeners();
        return false;
      }
      isSyncing=false;
    } catch (error) {
      isSyncing=false;
      notifyListeners();
//      print(error);
      throw (error);
    }
  }


    Future fetchReportComments(String uuid, int userId,bool messageTableHasData) async {
    /*api url*/
      final url = "$api/mobile/queried/"+uuid;
      /*api headers*/
    var headers = {
      'Authorization':'Bearer $token',
      "Accept": "application/json"
    };
    Map result = {};
      isSyncing=true;
    try{
      final response = await http.get( url,headers: headers);
      final dbHelper = DatabaseHelper.instance;
      Map apiResponse = json.decode(response.body);
      if(response.statusCode==200) {
        isSyncing=false;
        Map<String, dynamic> row=Map();
        if( apiResponse['data'].length > 0){
          syncComment="Checking report comments to synchronize...";
          notifyListeners();
          if(!messageTableHasData){
            syncComment="Synchronizing comments for ${apiResponse['data'].length} reports...";
            apiResponse['data'].forEach( (entry) async{
              row = {
                'uuid':entry['uuid'],
                'report_uuid':entry['report_uuid'],
                'type':entry['type'],
                'posted':entry['created_at'],
                'comment': entry['comment'],
                'user_id': userId,
                'status':"***",
                'sync_status': 1
              };
              await dbHelper.insertMessage(row);
            } )  ;
          }else{
            syncComment="Synchronizing comments for ${apiResponse['data'].length} reports...";
            notifyListeners();
            apiResponse['data'].forEach( (entry) async{
              final reportComments=await dbHelper.queryReportCommentsByUUIDAndId(entry['report_uuid'],entry['uuid'], userId);
              if(reportComments.length ==0){
                row = {
                'uuid':entry['uuid'],
                'report_uuid':entry['report_uuid'],
                'type':entry['type'],
                  'posted':entry['created_at'],
                'comment': entry['comment'],
                'user_id': userId,
                'status':"***",
                'sync_status': 1
              };
              await dbHelper.insertMessage(row);
//                print("Inserted a new record");
              }else{
//                print("Nothing to insert");
              }
            } )  ;

          }
        }
        result['message']="";
        result['success']=true;
        result['code']=200;
        notifyListeners();
      }
      if(response.statusCode==404) {
        result['message']="Server error";
        result['success']=false;
        result['code']=404;
        isSyncing=false;
        notifyListeners();
      }
      if(response.statusCode==401) {
        result['message']="Session expired";
        result['success']=false;
        result['code']=401;
        isSyncing=false;
        notifyListeners();
      }
      if(response.statusCode==500) {
        result['message']=apiResponse['message'];
        result['success']=false;
        isSyncing=false;
        result['code']=500;
        notifyListeners();
      }

      isSyncing=false;
      notifyListeners();
      return result;
    } catch(e){
      //result['message']='We\'re experiencing technical difficulties, please try again later';
      if(e is SocketException){
        result['message']="Check internet";
      }else{

        result['message']=e.toString();
      }
      result['success']=false;
//      print(e.toString());
      isSyncing=false;
      notifyListeners();
      return result;
    }
  }


  Future fetchBroadcastMessages() async {
    /*api url*/
    final url = "$api/mobile/messages";
    /*api headers*/
    var headers = {
      'Authorization':'Bearer $token',
      "Accept": "application/json"
    };
    Map result = {};
    isSyncing=true;
    try{
      final response = await http.get( url,headers: headers);
      final dbHelper = DatabaseHelper.instance;
      Map apiResponse = json.decode(response.body);
      if(response.statusCode==200) {
        isSyncing=false;
        Map<String, dynamic> row=Map();
        syncComment="Checking for broadcast messages...";
        notifyListeners();
        if( apiResponse['data'].length > 0){
          syncComment="Synchronizing broadcast messages...";
          notifyListeners();
          //print(apiResponse['data']);
            apiResponse['data'].forEach( (entry) async{
              //print(entry['uuid']);
              print(await dbHelper.queryAllBroadcastMessages());
              final reportComments=await dbHelper.queryBroadcastMessagesUUIDs(entry['uuid']);
              print(reportComments.length);
              if(reportComments.length ==0){
                row = {
                  'uuid':entry['uuid'],
                  'title':entry['title'],
                  'body':entry['body'],
                  'posted':entry['created_at'],
                };
                await dbHelper.insertBroadcastMessage(row);
                print("Not Exists broadcast messages");
//                print(token);
              }else{
                print("Nothing to insert broadcast messages");
              }
            } )  ;


        }
        result['message']="";
        result['success']=true;
        result['code']=200;
        notifyListeners();
      }
      if(response.statusCode==404) {
        isSyncing=false;
        result['message']="Server error";
        result['success']=false;
        result['code']=404;
        notifyListeners();
      }
      if(response.statusCode==401) {
        isSyncing=false;
        result['message']="Session expired";
        result['success']=false;
        result['code']=401;
        notifyListeners();
      }
      if(response.statusCode==500) {
        isSyncing=false;
        result['message']=apiResponse['message'];
        result['success']=false;
        result['code']=500;
        notifyListeners();
      }
      isSyncing=false;
      notifyListeners();
      return result;
    } catch(e){
      isSyncing=false;
      //result['message']='We\'re experiencing technical difficulties, please try again later';
      if(e is SocketException){
        result['message']="Check internet";
      }else{
        result['message']=e.toString();
      }
      result['success']=false;
//      print(e.toString());
      notifyListeners();
      return result;
    }
  }


//
//  /*Fetch all records from db (This Month)*/
//  Future<dynamic> queryAllRecordsThisMonth() async {
//    final dbHelper = DatabaseHelper.instance;
//    final allData = await dbHelper.queryAllRecordsToday();
//    return allData;
//  }
//
//  /*Fetch all records from db (All Time)*/
//  Future<dynamic> queryAllRecordsAllTime() async {
//    final dbHelper = DatabaseHelper.instance;
//    final allData = await dbHelper.queryAllRecordsToday();
//    return allData;
//  }

  void firstAndLastDayOfMonth(){
    final now = DateTime.now();
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final firstDayOfMonth = DateTime(now.year, now.month + 0);
//    print("${lastDayOfMonth.month}/${lastDayOfMonth.day}");
//    print("$lastDayOfMonth/${lastDayOfMonth.day}");
//    print("$firstDayOfMonth/${firstDayOfMonth .day}");
  }


  int getWeekNumber(){
//  final date = DateTime.now();
//  final startOfYear = new DateTime(date.year, 1, 1, 0, 0);
//  final firstMonday = startOfYear.weekday;
//  final daysInFirstWeek = 8 - firstMonday;
//  final diff = date.difference(startOfYear);
//  var weeks = ((diff.inDays - daysInFirstWeek) / 7).ceil();
//
//  if (daysInFirstWeek > 3) {
//    weeks += 1;
//  }
// return weeks;
// Find first date and last date of THIS WEEK
  DateTime today = DateTime.now();
  print(findFirstDateOfTheWeek(today));
  print(findLastDateOfTheWeek(today));

  // Find first date and last date of any provided date
  DateTime date = DateTime.parse('2020-11-24');
  print(findFirstDateOfTheWeek(date));
  print(findLastDateOfTheWeek(date));
}
  
void cleanReportValues (){
  report=null;
  photos=[];
  currentRecord=null;
  latitude=null;
  longitude=null;
  notifyListeners();

}

//  Future<void> addName(text,_connectionStatus) async {
//    print(text.toString());
//    int a = 1;
//    print(_connectionStatus.toString());
//    try {
//      if(_connectionStatus == true){
//        Response response = await Dio().post('http://192.168.42.175/SqliteSync/saveName.php',
//          options: Options(headers: {
//            HttpHeaders.contentTypeHeader: "application/json",
//          }),
//          data:  jsonEncode(<String, dynamic>{
//            "name": text.toString(),
//            "status": a
//          }),
//        );
//        // final http.Response response = await http.post(
//        //   ' http://localhost/SqliteSync/saveName.php',
//        //   headers: <String, String>{
//        //     'Content-Type': 'application/json; charset=UTF-8',
//        //   },
//        //   body: jsonEncode(<String, dynamic>{
//        //     "name": text.toString(),
//        //     "status": a
//        //   }),
//        // );
//        if (response.statusCode == 200) {
//          String body = response.statusMessage;
//          print(body);
//          Map<String, dynamic> row = {
//            DatabaseHelper.columnName : text.toString(),
//            DatabaseHelper.status : 1,
//          };
//          await dbHelper.insert(row);
//        } else {
//          print('Request failed with status: ${response.statusCode}.');
//        }
//      }else{
//        Map<String, dynamic> row = {
//          DatabaseHelper.columnName : text.toString(),
//          DatabaseHelper.status : 0,
//        };
//        final id = await dbHelper.insert(row);
//        print('inserted row id: $id');
//      }
//
//      notifyListeners();
//    } catch (error) {
//      throw (error);
//    }
//  }


  getToken() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    if (storage.getString('token') != null) {
      token = storage.getString('token');
      notifyListeners();
      return storage.getString('token');
    }
    return null;
  }

}

Future<dynamic> networkImageToBase64(String imageUrl) async {
  http.Response response = await http.get(imageUrl);
  final bytes = response!=null ? response.bodyBytes : null;
  return (bytes != null ? base64Encode(bytes) : null);
}

//
//
//  Future<Map> submitEditedReport({@ required String reportId,@ required String firstName,@ required String lastName,@ required String gender,@ required String age,@ required String occupation,@ required String granted, @ required String caseType,@ required String offence, @ required String complaints, @ required String location,@ required  String bailStatus, @ required String outcome}) async {
//    //url
//    final url = "$api/edited-daily-report";
//
//    //object map
//    Map body = {};
//
//    body= caseType=="Criminal" ? {
//      'report_id':reportId,
//      'first_name':firstName ,
//      'last_name':lastName,
//      'gender':gender ,
//      'age':age ,
//      'occupation': occupation ,
//      'granted':granted ,
//      'case_type':caseType ,
//      'offence':offence,
//      'location':location ,
//      'bail_status':bailStatus ,
//      'outcome':outcome
//    }:{
//      'report_id':reportId,
//      'first_name':firstName ,
//      'last_name':lastName,
//      'gender':gender ,
//      'age':age ,
//      'occupation': occupation ,
//      'granted':granted ,
//      'case_type':caseType ,
//      'complaints':complaints ,
//      'location':location ,
//      'bail_status':bailStatus ,
//      'outcome':outcome
//    };
//
//    var token =await this.getToken();
//
//    //print(token);
//    var headers = {
//      HttpHeaders.authorizationHeader:'Bearer $token.',
//      "Accept": "application/json"
//    };
//    Map result = {};
//
//    try{
//      final response = await http.post( url,headers: headers,  body:body);
//      print(response.body);
//      print(response.statusCode);
//      Map apiResponse = json.decode(response.body);
//
//      if(response.statusCode==200) {
//        loaded=true;
//        result['message']="";
//        result['success']=true;
//        result['code']=200;
//        //result['data']=parseReport(response.body);
//        //print(response.body);
//
//      }
//
//      if(response.statusCode==404) {
//        result['message']="Invalid validation code";
//        result['success']=false;
//        result['code']=404;
//
//      }
//
//      if(response.statusCode==401) {
//        result['message']="Session expired";
//        result['success']=false;
//        result['code']=401;
//      }
//
//      if(response.statusCode==422) {
//        result['message']="Submission contains errors";
//        result['success']=false;
//        result['data']=apiResponse;
//        result['code']=422;
//
//      }
//
//      if(response.statusCode==500) {
//        result['message']=apiResponse['message'];
//        result['success']=false;
//        result['code']=500;
//        //print(response.body);
//
//      }
//      return result;
//    } catch(e){
//      //result['message']='We\'re experiencing technical difficulties, please try again later';
//      if(e is SocketException){
//        result['message']="Check internet";
//      }else{
//        result['message']=e.toString();
//      }
//
//      result['success']=false;
//      print(e.toString());
//      return result;
//    }
//  }
//
//
//
//
//  Future fetchReports() async {
//
//    /*api url*/
//    final url = "$api/fetch-reports";
//
//    /*get token*/
//    var token =await this.getToken();
//
//    /*api headers*/
//    var headers = {
//      HttpHeaders.authorizationHeader:'Bearer $token.',
//      "Accept": "application/json"
//    };
//    Map result = {};
//
//    try{
//      final response = await http.get( url,headers: headers);
//      print(response.body);
//      print(response.statusCode);
//      Map apiResponse = json.decode(response.body);
//
//      if(response.statusCode==200) {
//        result['message']="";
//        result['success']=true;
//        result['code']=200;
//        reports = parseReports(response.body);
//        paginate=parseReportsPaginate(response.body);
//        if(paginate.nextPageUrl!=null) loadMore=true;
//        //print(paginate.nextPageUrl);
//        loaded=true;
//        showFilter=false;
//        notifyListeners();
//
//      }
//
//      if(response.statusCode==404) {
//        result['message']="Server error";
//        result['success']=false;
//        result['code']=404;
//
//      }
//
//      if(response.statusCode==401) {
//        result['message']="Session expired";
//        result['success']=false;
//        result['code']=401;
//        this.auth=false;
//        notifyListeners();
//      }
//
//
//      if(response.statusCode==500) {
//        result['message']=apiResponse['message'];
//        result['success']=false;
//        result['code']=500;
//
//      }
//      return result;
//    } catch(e){
//      //result['message']='We\'re experiencing technical difficulties, please try again later';
//      if(e is SocketException){
//        result['message']="Check internet";
//      }else{
//        result['message']=e.toString();
//      }
//
//      result['success']=false;
//      print(e.toString());
//      return result;
//    }
//  }
//
//
//
//
//  Future fetchReportSingle(String id) async {
//
//    Map<String,String> searchPayload={};
//
//    searchPayload={'report_id':id};
//
//    /*api url*/
//    final url = "$api/fetch-report/$id";
//
//    /*get token*/
//    var token =await this.getToken();
//
//    /*build request uri*/
////    var uri = Uri.http(
////        '192.168.43.122:8080', '/laravel/site44/public/api/v1/report/fetch-report/', searchPayload);
//
//    /*api headers*/
//    var headers = {
//      HttpHeaders.authorizationHeader:'Bearer $token.',
//      "Accept": "application/json"
//    };
//    Map result = {};
//
//    try{
//      final response = await http.get( url,headers: headers);
//      print(response.body);
//      print(response.statusCode);
//      Map apiResponse = json.decode(response.body);
//
//      if(response.statusCode==200) {
//        result['message']="";
//        result['success']=true;
//        result['code']=200;
//        report = parseReport(response.body);
//        notifyListeners();
//      }
//
//      if(response.statusCode==404) {
//        result['message']="Server error";
//        result['success']=false;
//        result['code']=404;
//
//      }
//
//      if(response.statusCode==401) {
//        result['message']="Session expired";
//        result['success']=false;
//        result['code']=401;
//        this.auth=false;
//        notifyListeners();
//      }
//
//
//      if(response.statusCode==500) {
//        result['message']=apiResponse['message'];
//        result['success']=false;
//        result['code']=500;
//
//      }
//      return result;
//    } catch(e){
//      //result['message']='We\'re experiencing technical difficulties, please try again later';
//      if(e is SocketException){
//        result['message']="Check internet";
//      }else{
//        result['message']=e.toString();
//      }
//
//      result['success']=false;
//      print(e.toString());
//      return result;
//    }
//  }
//
//
//
//  fetchReportsPaginate() async {
//
//    /*api url*/
//    final url = "$api/fetch-reports";
//
//    /*get token*/
//    var token =await this.getToken();
//
//    /*api headers*/
//    var headers = {
//      HttpHeaders.authorizationHeader:'Bearer $token.',
//      "Accept": "application/json"
//    };
//    Map result = {};
//
//    print("self paginate");
//
//    try{
//      final response = await http.get( paginate.nextPageUrl,headers: headers);
//      //print(response.body);
//      //print(response.statusCode);
//      Map apiResponse = json.decode(response.body);
//      if(response.statusCode==200) {
//        result['message']="";
//        result['success']=true;
//        result['code']=200;
//        reports = []..addAll(reports)..addAll(parseReports(response.body));
//        paginate=parseReportsPaginate(response.body);
//        if(paginate.nextPageUrl==null){
//          loadMore=false;
//        }
//        else{
//          loadMore=true;
//        }
//        //print(paginate.nextPageUrl);
//        //print(loadMore);
//        loaded=true;
//        showFilter=false;
//        notifyListeners();
//
//      }
//
//      if(response.statusCode==404) {
//        result['message']="Server error";
//        result['success']=false;
//        result['code']=404;
//
//      }
//
//      if(response.statusCode==401) {
//        result['message']="Session expired";
//        result['success']=false;
//        result['code']=401;
//        this.auth=false;
//        notifyListeners();
//      }
//
//
//      if(response.statusCode==500) {
//        result['message']=apiResponse['message'];
//        result['success']=false;
//        result['code']=500;
//
//      }
//      return result;
//    } catch(e){
//      //result['message']='We\'re experiencing technical difficulties, please try again later';
//      if(e is SocketException){
//        result['message']="Check internet";
//      }else{
//        result['message']=e.toString();
//      }
//
//      result['success']=false;
//      print(e.toString());
//      return result;
//    }
//  }
//
//
//  searchReportsPaginate(Map searchPayload) async {
//
//    /*api url*/
//    final url = "$api/fetch-reports";
//
//    /*get token*/
//    var token =await this.getToken();
//
//    /*build request uri*/
//    var uri = Uri.http(
//        hostUrl, '$hostUrlPartial/report/search', searchPayload);
//    //'192.168.43.122:8080', '/laravel/site44/public/api/v1/report/search', searchPayload);
//
//    /*api headers*/
//    var headers = {
//      HttpHeaders.authorizationHeader:'Bearer $token.',
//      "Accept": "application/json"
//    };
//    Map result = {};
//
//    try{
//      final response = await http.get( uri,headers: headers);
//      //print(response.body);
//      print(response.statusCode);
//      Map apiResponse = json.decode(response.body);
//
//      if(response.statusCode==200) {
//        result['message']="";
//        result['success']=true;
//        result['code']=200;
//        reports =parseReports(response.body);
//        paginate=parseReportsPaginate(response.body);
//        if(paginate.nextPageUrl==null){loadMore=false;}else{loadMore=true;}
//        //print(paginate.nextPageUrl);
//        showFilter=false;
//        loaded=true;
//
//        notifyListeners();
//
//      }
//
//      if(response.statusCode==404) {
//        result['message']="Server error";
//        result['success']=false;
//        result['code']=404;
//
//      }
//
//      if(response.statusCode==401) {
//        result['message']="Session expired";
//        result['success']=false;
//        result['code']=401;
//        this.auth=false;
//        notifyListeners();
//
//      }
//
//
//      if(response.statusCode==500) {
//        result['message']=apiResponse['message'];
//        result['success']=false;
//        result['code']=500;
//        print(response.body);
//
//      }
//      return result;
//    } catch(e){
//      //result['message']='We\'re experiencing technical difficulties, please try again later';
//      if(e is SocketException){
//        result['message']="Check internet";
//      }else{
//        result['message']=e.toString();
//      }
//
//      result['success']=false;
//      print(e.toString());
//      return result;
//    }
//  }
//
//
//
//
//  Future<Map> uploadReportImage({@ required String image,@ required String imageId,@ required String reportId}) async {
//
//    //url
//    final url = "$api/upload-report-image";
//
//    //object map
//    Map body = {};
//
//    body={
//      'image':image ,
//      'image_id':imageId,
//      'report_id':reportId
//    };
//
//    var token =await this.getToken();
//
//    //print(token);
//    var headers = {
//      HttpHeaders.authorizationHeader:'Bearer $token.',
//      "Accept": "application/json"
//    };
//    Map result = {};
//
//    try{
//      final response = await http.post( url,headers: headers,  body:body);
//      print(response.body);
//      print(response.statusCode);
//      Map apiResponse = json.decode(response.body);
//
//      if(response.statusCode==200) {
//        loaded=true;
//        result['message']="";
//        result['success']=true;
//        result['code']=200;
//
//      }
//
//      if(response.statusCode==404) {
//        result['message']="Invalid validation code";
//        result['success']=false;
//        result['code']=404;
//
//      }
//
//      if(response.statusCode==401) {
//        result['message']="Session expired";
//        result['success']=false;
//        result['code']=401;
//      }
//
//      if(response.statusCode==422) {
//        result['message']="Submission contains errors";
//        result['success']=false;
//        result['data']=apiResponse;
//        result['code']=422;
//
//      }
//
//      if(response.statusCode==500) {
//        result['message']=apiResponse['message'];
//        result['success']=false;
//        result['code']=500;
//
//      }
//      return result;
//    } catch(e){
//      //result['message']='We\'re experiencing technical difficulties, please try again later';
//      if(e is SocketException){
//        result['message']="Check internet";
//      }else{
//        result['message']=e.toString();
//      }
//
//      result['success']=false;
//      print(e.toString());
//      return result;
//    }
//  }
//
//
//
//  Future<Map> deleteReportImage({@ required String imageId,@ required String reportId}) async {
//
//    //url
//    final url = "$api/delete-report-image";
//
//    //object map
//    Map body = {};
//
//    body={
//      'image_id':imageId,
//      'report_id':reportId
//    };
//
//    var token =await this.getToken();
//
//    this.apiCallModal=true;
//    //print(token);
//    notifyListeners();
//    var headers = {
//      HttpHeaders.authorizationHeader:'Bearer $token.',
//      "Accept": "application/json"
//    };
//    Map result = {};
//
//    try{
//      final response = await http.post( url,headers: headers,  body:body);
//      print(response.body);
//      print(response.statusCode);
//      Map apiResponse = json.decode(response.body);
//
//      if(response.statusCode==200) {
//        loaded=true;
//        result['message']="";
//        result['success']=true;
//        result['code']=200;
//        this.apiCallModal=false;
//        notifyListeners();
//
//      }
//
//      if(response.statusCode==404) {
//        result['message']="Invalid validation code";
//        result['success']=false;
//        result['code']=404;
//        this.apiCallModal=false;
//        notifyListeners();
//
//      }
//
//      if(response.statusCode==401) {
//        result['message']="Session expired";
//        result['success']=false;
//        result['code']=401;
//        this.apiCallModal=false;
//        notifyListeners();
//      }
//
//
//      if(response.statusCode==500) {
//        result['message']=apiResponse['message'];
//        result['success']=false;
//        result['code']=500;
//        this.apiCallModal=false;
//        notifyListeners();
//
//      }
//      return result;
//    } catch(e){
//      //result['message']='We\'re experiencing technical difficulties, please try again later';
//      if(e is SocketException){
//        result['message']="Check internet";
//      }else{
//        result['message']=e.toString();
//      }
//
//      result['success']=false;
//      this.apiCallModal=false;
//      notifyListeners();
//      print(e.toString());
//      return result;
//    }
//  }
//
//
//
//  Future<Map> deleteReport({@ required String reportId}) async {
//
//    //url
//    final url = "$api/delete-report";
//
//    //object map
//    Map body = {};
//
//    body={
//      'report_id':reportId
//    };
//
//    var token =await this.getToken();
//
//    this.apiCallModal=true;
//    //print(token);
//    notifyListeners();
//    var headers = {
//      HttpHeaders.authorizationHeader:'Bearer $token.',
//      "Accept": "application/json"
//    };
//    Map result = {};
//
//    try{
//      final response = await http.post( url,headers: headers,  body:body);
//      print(response.body);
//      //print(response.statusCode);
//      Map apiResponse = json.decode(response.body);
//
//      if(response.statusCode==200) {
//        loaded=true;
//        result['message']="";
//        result['success']=true;
//        result['code']=200;
//        this.apiCallModal=false;
//        notifyListeners();
//
//      }
//
//      if(response.statusCode==404) {
//        result['message']="Invalid validation code";
//        result['success']=false;
//        result['code']=404;
//        this.apiCallModal=false;
//        notifyListeners();
//
//      }
//
//      if(response.statusCode==401) {
//        result['message']="Session expired";
//        result['success']=false;
//        result['code']=401;
//        this.apiCallModal=false;
//        notifyListeners();
//      }
//
//
//      if(response.statusCode==500) {
//        result['message']=apiResponse['message'];
//        result['success']=false;
//        result['code']=500;
//        this.apiCallModal=false;
//        notifyListeners();
//
//      }
//      return result;
//    } catch(e){
//      //result['message']='We\'re experiencing technical difficulties, please try again later';
//      if(e is SocketException){
//        result['message']="Check internet";
//      }else{
//        result['message']=e.toString();
//      }
//
//      result['success']=false;
//      this.apiCallModal=false;
//      notifyListeners();
//      print(e.toString());
//      return result;
//    }
//  }
//
//

//
//
////  List<ReportData> parseReports(String responseBody) {
////    final original = json.decode(responseBody).cast<String, dynamic>();
////    final parsed =json.decode(jsonEncode(original['reports']['data']));
////    return parsed.map<ReportData>((json) => ReportData.fromJson(json)).toList();
////  }
////
////  ReportData parseReport(String responseBody) {
////    final original = json.decode(responseBody).cast<dynamic, dynamic>();
////    final parsed =json.decode(jsonEncode(original['report']));
////    return ReportData.fromJson(parsed);
////  }
//
//  PaginateData parseReportsPaginate(String responseBody) {
//    final response= json.decode(responseBody);
//    return  PaginateData.fromJson(