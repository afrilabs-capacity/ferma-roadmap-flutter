import 'package:roadmap/models/report_data.dart';


class  PaginateData{
  int currentPage;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  int perPage;
  String previousPageUrl;
  int to;
  int total;
  List<dynamic> data;


  PaginateData({this.currentPage,this.firstPageUrl,this.from,this.lastPage,this.lastPageUrl,this.nextPageUrl,this.path,this.perPage,this.previousPageUrl,this.to,this.total,this.data});



  factory PaginateData.fromJson(Map<String, dynamic> json, [String model]) {
    List <dynamic> dataList;

    final data= json['data'];
    //dataList= data.map<ReportData>((data)=>ReportData.fromJson(data)).toList();

    return PaginateData(
      currentPage: json['current_page'],
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      previousPageUrl:json['prev_page_url'] ,
      to:json['to'],
      total: json['total'],
      //data: dataList
    );
  }


}