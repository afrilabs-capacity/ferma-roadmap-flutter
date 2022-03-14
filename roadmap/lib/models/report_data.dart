class  ReportData{
  int columnId;
 String status;
  String message;
  String photo_1;
  String photo_2;
  String photo_3;
  String photo_4;
  String longitude;
  String latitude;
  int projectId;
  int userId;
  int syncStatus;


  ReportData({this.columnId,this.status,this.message,this.photo_1,this.photo_2,this.photo_3,this.photo_4,this.longitude,this.latitude,this.projectId,this.userId,this.syncStatus});

//
//  factory ReportData.fromJson(Map<String, dynamic> json) {
//    //final photo=json['photo_collection'];
//    //List<PartnerAlbum> dataList= photo.map<PartnerAlbum>((data)=>PartnerAlbum.fromJson(data)).toList();
//    return ReportData(
//      id: json['id'] as int,
//      userId: json['user_id'] ,
//      firstName: json['first_name'] as String,
//      lastName: json['last_name'] as String,
//      gender: json['gender'] as String,
//      age: json['age'] ,
//      occupation: json['occupation'] as String,
//      granted: json['granted'] as String,
//      caseType: json['case_type'] as String,
//      offence: json['offence'] as String,
//      complaints: json['complaints'] as String,
//      location:{'id':json['location']['id'],'name':json['location']['name']},
//      bailStatus: json['bail_status'] as String,
//      outcome: json['outcome'] as String,
//      created: json['submited'] as String,
//      photoOne: json['photo_one'] as String,
//      photoTwo: json['photo_two'] as String,
//
//      //photos:dataList
//    );
//  }
//
//  bool dataIsNull() {
//    return [firstName].contains(null);
//  }


}