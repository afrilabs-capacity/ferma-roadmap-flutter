class MyCounsel{
  int id;
  String name;
  MyCounsel({this.id,this.name});

  factory MyCounsel.fromJson(Map<String, dynamic> json) {
    //final photo=json['photo_collection'];
    //List<PartnerAlbum> dataList= photo.map<PartnerAlbum>((data)=>PartnerAlbum.fromJson(data)).toList();
    return MyCounsel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }


  }

