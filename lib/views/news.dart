import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lac/components/drawer.dart';
import 'package:lac/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:lac/providers/news.dart';
import 'package:lac/views/news_single.dart';


class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {

  var news;

  @override
  void initState() {
    //Provider.of<ReportProvider>(context,listen: false).report=null;
    WidgetsBinding.instance
        .addPostFrameCallback((_)async {
      news= await Provider.of<NewsProvider>(context,listen: false).fetchNews().then((value){
       //print(value);
      });

    });

    // TODO: implement initState
    super.initState();
  }


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
              title: Text('News',style: TextStyle(color: siteThemeColor),),
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: siteThemeColor),

            ),
            drawer: MyDrawer(context:context),
            body:  Consumer<NewsProvider>(
            builder:(context,data,child)=> data.loaded ? ListView.builder(
      shrinkWrap: true,
          //physics: NeverScrollableScrollPhysics(),
          itemCount: data.news.length,
          itemBuilder: (context, i) => Column(children: [
            Container(
              padding: EdgeInsets.all(8.0),
              margin:EdgeInsets.all(8.0) ,
              //decoration: shadowBox.copyWith(color: siteIconThemeLight),
              child: GestureDetector(
                onTap: ()=>Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => NewsSingle(newsData:data.news[i])),
                ),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                      Container( height: 50,width:70,decoration: BoxDecoration(image: DecorationImage(image:NetworkImage("${data.news[i].image}")) )),
                      SizedBox(width: 5.0,),
                      Flexible(child: Text(convertToTitleCase(data.news[i].title.toLowerCase().length >=30 ? data.news[i].title.toLowerCase().substring(0,40)+"...":data.news[i].title.toLowerCase() ),style: TextStyle(color: siteIconThemeDark))),
                      //NetworkImage(data.news[i].image)

                    ]
                ),
              ),
            ),Divider()
          ],)
      ):Center(child: Text('Waiting for news.........',style: TextStyle(color: Colors.black),)),
      )




        ),
    );
  }
}

