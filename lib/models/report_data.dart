class  ReportData{
  int id;
  var userId;
  String firstName;
  String lastName;
  String gender;
  var age;
  String occupation;
  String granted;
  String caseType;
  String offence;
  String complaints;
  Map location;
  String bailStatus;
  String outcome;
  String created;
  String photoOne;
  String photoTwo;


  ReportData({this.id,this.userId,this.firstName,this.lastName,this.gender,this.age,this.occupation,this.granted,this.caseType,this.offence,this.complaints,this.location,this.bailStatus,this.outcome,this.created,this.photoOne,this.photoTwo});


  factory ReportData.fromJson(Map<String, dynamic> json) {
    //final photo=json['photo_collection'];
    //List<PartnerAlbum> dataList= photo.map<PartnerAlbum>((data)=>PartnerAlbum.fromJson(data)).toList();
    return ReportData(
        id: json['id'] as int,
        userId: json['user_id'] ,
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String,
        gender: json['gender'] as String,
        age: json['age'] ,
        occupation: json['occupation'] as String,
        granted: json['granted'] as String,
        caseType: json['case_type'] as String,
         offence: json['offence'] as String,
      complaints: json['complaints'] as String,
      location:{'id':json['location']['id'],'name':json['location']['name']},
      bailStatus: json['bail_status'] as String,
      outcome: json['outcome'] as String,
      created: json['submited'] as String,
      photoOne: json['photo_one'] as String,
      photoTwo: json['photo_two'] as String,

        //photos:dataList
    );
  }

  bool dataIsNull() {
    return [firstName].contains(null);
  }


}