import 'package:flutter/material.dart';
import 'package:lac/components/drawer.dart';
import 'package:lac/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:lac/providers/news.dart';
import 'package:lac/models/news_data.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';


class NewsSingle extends StatefulWidget {

  final NewsData newsData;
  NewsSingle({this.newsData});

  @override
  _NewsSingleState createState() => _NewsSingleState();
}

class _NewsSingleState extends State<NewsSingle> {


//  @override
//  void initState() {
//    //Provider.of<ReportProvider>(context,listen: false).report=null;
//    WidgetsBinding.instance
//        .addPostFrameCallback((_)async {
//      news= await Provider.of<NewsProvider>(context,listen: false).fetchNews().then((value){
//        //print(value);
//      });
//
//    });
//
//    // TODO: implement initState
//    super.initState();
//  }


  String convertToTitleCase(String text) {
    if (text == null) {
      return null;
    }

    if (text.length <= 1) {
      return text.toUpperCase();
    }

    // Split string into multiple words
    final List<String> words = text.split(' ');

    // Capitalize first letter of each words
    final capitalizedWords = words.map((word) {
      if (word.trim().isNotEmpty) {
        final String firstLetter = word.trim().substring(0, 1).toUpperCase();
        final String remainingLetters = word.trim().substring(1);

        return '$firstLetter$remainingLetters';
      }
      return '';
    });

    // Join/Merge all words back to one String
    return capitalizedWords.join(' ');
  }


  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("News",style: TextStyle(color: siteThemeColor),),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: siteThemeColor),

          ),
          drawer: MyDrawer(context:context),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Image(image: NetworkImage("${widget.newsData.image}"),),
                Text(convertToTitleCase(widget.newsData.title),style: TextStyle(color: siteThemeColor,fontSize: 25,fontWeight: FontWeight.bold),),
                HtmlWidget("${widget.newsData.contentHtml}",textStyle: TextStyle(fontSize: 16))
              ],),
            ),
          )




        ),
    );

  }
}

