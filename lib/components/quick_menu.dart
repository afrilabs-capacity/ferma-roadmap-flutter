
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lac/utils/constants.dart';
import 'package:lac/views/home.dart';
import 'package:lac/views/news.dart';


class QuickMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
              onTap:()=> Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Home()),),
              child: Container(
                  padding:EdgeInsets.all(10.0),
                  decoration:siteIconEffectGrey,
                  child: Icon(Icons.home,color:siteThemeColor,size: 35,))),
          GestureDetector(
              onTap:()=> Navigator.pushReplacement(context, PageRouteBuilder(
                transitionDuration: Duration(seconds: 0),
                pageBuilder: (context, animation1, animation2) => News(),
              )),
              child: Container(
                  padding:EdgeInsets.all(10.0),
                  decoration:siteIconEffectGrey,
                  child: Icon(Icons.chat_outlined,color: siteThemeColor,size: 35,))),
          GestureDetector(
              onTap:()=> Navigator.pushReplacement(context, PageRouteBuilder(
                transitionDuration: Duration(seconds: 0),
                //pageBuilder: (context, animation1, animation2) => Mp.Message(),
              )),
              child: Container(
                  padding:EdgeInsets.all(10.0),
                  decoration:siteIconEffectGrey,
                  child: Icon(Icons.email,color: siteThemeColor,size: 35,))),
        ],),
    );
  }
}