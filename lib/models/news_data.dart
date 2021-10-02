class  NewsData{

String title;
String contentHtml;
String image;

NewsData({this.title,this.contentHtml,this.image});

  factory NewsData.fromJson(Map<String, dynamic> data) {

    return NewsData(
      title: data['title'] as String,
      contentHtml: data['content_html'],
      image: data['image'] as String,


      //photos:dataList
    );
  }




}