class  PdssReportData{
  int id;
  var userId;
  String firstName;
  String lastName;
  String gender;
  String marriage;
  String occupation;
  String pod;
  String offence;
  String dateArrested;
  String dateReleased;
  String councilAssigned;
  String photoOne;
  String photoTwo;
  String created;
  String duration;

  PdssReportData({this.id,this.userId,this.firstName,this.lastName,this.gender,this.marriage,this.occupation,this.pod,this.offence,this.dateArrested,this.dateReleased,this.councilAssigned,this.photoOne,this.photoTwo,this.created,this.duration});


  factory PdssReportData.fromJson(Map<String, dynamic> json) {
    //final photo=json['photo_collection'];
    //List<PartnerAlbum> dataList= photo.map<PartnerAlbum>((data)=>PartnerAlbum.fromJson(data)).toList();
    return PdssReportData(
      id: json['id'] as int,
      userId: json['user_id'] ,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      gender: json['gender'] as String,
      marriage: json['marital_status'] as String,
      occupation: json['occupation'] as String,
      pod: json['pod'] as String,
      offence: json['offence'] as String,
      dateArrested: json['date_arrested'] as String,
      dateReleased: json['date_released'] as String,
      councilAssigned: json['counsel_assigned'] as String,
      created: json['submited'] as String,
      photoOne: json['photo_one'] as String,
      photoTwo: json['photo_two'] as String,
      duration: json['duration'] as String,

      //photos:dataList
    );
  }

  bool dataIsNull() {
    return [firstName].contains(null);
  }


}