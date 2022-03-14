import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static final _databaseName = "TestDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'reports_new';
  static final messageTable = 'reports_messages';
  static final messageBroadcastTable = 'mesage_broadcast';
  static final settingsTable = 'settings';

  static final  columnId = 'id';
  static final status = 'Pending';
  static final message='';
  static final photo_1='';
  static final photo_2='';
  static final photo_3='';
  static final photo_4='';
  static final longitude='';
  static final latitude='';
  static final project_id='';
  static final user_id='';
  static final sync_status='';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    print(path);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }


  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
                 id INTEGER PRIMARY KEY AUTOINCREMENT,
                 sync_status INTEGER NOT NULL,
                 status TEXT NOT NULL,
                 uuid TEXT NOT NULL,
                 message TEXT NOT NULL,
                 photo_1 TEXT NULL,
                 photo_2 TEXT NULL,
                 photo_3 TEXT NULL,
                 photo_4 TEXT NULL,
                 longitude TEXT NOT NULL,
                 latitude TEXT NOT NULL,
                 project_id INTEGER NOT NULL,
                 user_id INTEGER NOT NULL,
                 posted DATETIME NULL,
                 submitted DATETIME DEFAULT CURRENT_TIMESTAMP
          )
          ''');
    await db.execute('''
          CREATE TABLE $messageTable (
                 id INTEGER PRIMARY KEY AUTOINCREMENT,
                 sync_status INTEGER NOT NULL,
                 status TEXT NOT NULL,
                 report_uuid TEXT NOT NULL,
                 uuid TEXT NOT NULL,
                 comment TEXT NOT NULL,
                 type TEXT NOT NULL,
                 user_id INTEGER NOT NULL,
                 posted DATETIME NOT NULL,
                 submitted DATETIME DEFAULT CURRENT_TIMESTAMP NULL
          )
          ''');


    await db.execute('''
          CREATE TABLE $messageBroadcastTable (
                 id INTEGER PRIMARY KEY AUTOINCREMENT,
                 title TEXT NOT NULL,
                 body TEXT NOT NULL,
                 uuid TEXT NOT NULL,
                 posted DATETIME NOT NULL,
                 submitted DATETIME DEFAULT CURRENT_TIMESTAMP NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE $settingsTable(
                 id INTEGER PRIMARY KEY AUTOINCREMENT,
                 recent_broadcast_seen INTEGER NOT NULL,
                 user_id INTEGER NOT NULL,
                 updated DATETIME NOT NULL,
                 created DATETIME DEFAULT CURRENT_TIMESTAMP NULL
          )
          ''');


  }

//  Future _onCreateMessageTable(Database db, int version) async {
//    await db.execute('''
//          CREATE TABLE $messageTable (
//                 id INTEGER PRIMARY KEY AUTOINCREMENT,
//                 sync_status INTEGER NOT NULL,
//                 status TEXT NOT NULL,
//                 uuid TEXT NOT NULL,
//                 comment TEXT NOT NULL,
//                 type TEXT NOT NULL,
//                 user_id INTEGER NOT NULL,
//                 report_id INTEGER NOT NULL,
//                 submitted DATETIME DEFAULT CURRENT_TIMESTAMP NULL
//          )
//          ''');
//  }


  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<int> insertMessage(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(messageTable, row);
  }

  Future<int> insertBroadcastMessage(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(messageBroadcastTable, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }


  //Get all records which are unsynched
  Future<List<Map<String, dynamic>>> queryUnsynchedRecords() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT id,name,status FROM $table WHERE status = 0 ORDER BY "id" DESC');
  }

  Future<List<Map<String, dynamic>>> queryAllRecords() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table  ORDER BY "id" DESC');
  }

  Future<List<Map<String, dynamic>>> queryAllRecordsThisWeek(dynamic fromDate, dynamic toDate,int userId) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE user_id= "$userId" AND posted >= "$fromDate" AND  submitted <="$toDate" ORDER BY "posted" DESC ');
  }

  Future<List<Map<String, dynamic>>> queryAllRecordsThisMonth(dynamic fromDate, dynamic toDate,int userId) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE user_id= "$userId" AND posted BETWEEN "$fromDate" AND "$toDate"  ORDER BY "posted" DESC');
  }

  Future<List<Map<String, dynamic>>> queryAllRecordsToday(dynamic date,int userId) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE user_id= "$userId"  AND posted  >= date() ORDER BY "posted" DESC');
  }

  Future<List<Map<String, dynamic>>> queryAllRecordsAllTime(int userId) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE user_id= "$userId" ORDER BY "posted" DESC');
  }

  Future<dynamic> singleRecord(int id) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE id=$id');
  }

  Future<int> queryAllRecordsCountUnsynchronized(int userId) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table WHERE user_id= "$userId" AND sync_status=0'));
  }

  Future<int>queryAllRecordsCountSynchronized(int userId) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table WHERE user_id= "$userId" AND sync_status=1'));
  }

  Future<int>queryAllRecordsCountApproved() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table WHERE status="Approved"'));
  }

  Future<int>queryAllRecordsCountRejected() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table WHERE status="Rejected"'));
  }

  Future<int>queryAllRecordsCountQueried() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table WHERE status="Queried"'));
  }

  Future<int>queryAllRecordsCountPending() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table WHERE status="Pending"'));
  }

  Future<List<Map<String, dynamic>>> queryAllRecordsUnsynchronized(int userId) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE user_id= "$userId" AND sync_status=0 ORDER BY "id" DESC');
  }

  Future<List<Map<String, dynamic>>> queryAllRecordsPendingSynchronized(int userId) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT uuid FROM $table WHERE user_id= "$userId" AND  sync_status="1" ORDER BY "id" DESC');
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<dynamic> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.rawUpdate('UPDATE $table SET sync_status = ? WHERE id = ?', [1, row['id']  ]);
  }

  Future<dynamic> updateMessage(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.rawUpdate('UPDATE $messageTable SET sync_status = ? WHERE id = ?', [1, row['id']  ]);
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<dynamic> updateWithUUID(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.rawUpdate('UPDATE $table SET status = ? WHERE UUID = ?', [row['data']['status'], row['data']['uuid']  ]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
//  Future<int> deleteMessage(int id) async {
//    Database db = await instance.database;
//    return await db.delete(messageTable, where: 'id= ?', whereArgs: [id]);
//  }

  Future deleteMessage(int id) async {
    Database db = await instance.database;
    return await db.rawQuery("DELETE  FROM $messageTable");
  }

  Future<int> queryAllReportCountComments(int userId) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $messageTable WHERE user_id= "$userId"'));
  }

  Future<List<Map<String, dynamic>>> queryReportCommentsUserId(int userId) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $messageTable WHERE user_id= "$userId" AND sync_status=0 AND type="Ad-Hoc" ORDER BY posted ASC');
  }

  Future<List<Map<String, dynamic>>> queryReportCommentsUUIDUserId(String reportUUID, int userId) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $messageTable WHERE report_uuid= "$reportUUID" AND  user_id= "$userId" ORDER BY posted ASC');
  }

  Future<List<Map<String, dynamic>>> queryReportCommentsUUIDUserIdRecentlyPosted(String reportUUID, int userId) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $messageTable WHERE report_uuid= "$reportUUID" AND  user_id= "$userId" ORDER BY "posted" DESC LIMIT 1');
  }

  Future<List<Map<String, dynamic>>> queryReportCommentsByUUIDAndId(String reportUUID,String UUID, int userId) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $messageTable WHERE report_uuid= "$reportUUID" AND uuid="$UUID" AND user_id= "$userId" ORDER BY "id" DESC');
  }

  Future<List<Map<String, dynamic>>> queryReportCommentsUUIDs(String reportUUID, int userId) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT uuid FROM $messageTable WHERE report_uuid= "$reportUUID" AND user_id= "$userId" ORDER BY "id" DESC');
  }


  //Message Broadcast
  Future<List<Map<String, dynamic>>> queryAllBroadcastMessages() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $messageBroadcastTable ORDER BY posted DESC');
  }

  Future<List<Map<String, dynamic>>> queryBroadcastMessagesUUIDs(String uuid) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $messageBroadcastTable WHERE uuid="$uuid"');
  }

  Future<int> createGeneralBroadcastSeen(int userId) async {
    Database db = await instance.database;
    int countRecords = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $settingsTable where user_id= "$userId"'));
    if(countRecords < 1){
      Map<String,dynamic> row={
        'updated':DateTime.now().toString(),
        'recent_broadcast_seen':1,
        'user_id':userId
      };
      return await db.insert(settingsTable,row);
    }else{
      return 1;
    }

  }


  Future<int> createOrUpdateGeneralBroadcastSeen(int userId) async {
    Database db = await instance.database;
    int countRecords = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $settingsTable where user_id= "$userId"'));
    if(countRecords < 1){
      Map<String,dynamic> row={
        'updated':DateTime.now().toString(),
        'recent_broadcast_seen':1,
        'user_id':userId
      };
      return await db.insert(settingsTable,row);
    }else{
      print(DateTime.now().toString());
      return await db.rawUpdate('UPDATE $settingsTable SET updated = ? WHERE user_id = ?', [DateTime.now().toString(), userId  ]);
    }

  }


  Future<int> hasUserSeenBroadcast(int userId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> settings  = await getUserSettings(userId);

    if(settings.isNotEmpty){
      print('here');
      //print(await queryAllBroadcastMessages());
      print("${settings[0]['updated']}");
      return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $messageBroadcastTable WHERE posted > "${settings[0]['updated'].toString()}"'));
    }else{
      print('there');
      return 0;
    }
  }


  Future<List<Map<String, dynamic>>> getUserSettings(int userId) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $settingsTable WHERE user_id="$userId"');
  }


  //Get all records which are unsynched
//  Future<List<Map<String, dynamic>>> queryReportCommentsUnsynced() async {
//    Database db = await instance.database;
//    return await db.rawQuery('SELECT id,name,status FROM $table WHERE status = 0 ORDER BY "id" DESC');
//  }
}



