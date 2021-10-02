import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lac/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:lac/utils/constants.dart';
import 'package:lac/views/home.dart';
import 'package:lac/views/add_report_daily.dart';
import 'package:lac/views/reports.dart';
import 'package:lac/views/news.dart';
import 'package:lac/views/feedback.dart';



class ReportMenuDaily extends StatefulWidget {
  @override
  _ReportMenuDailyState createState() => _ReportMenuDailyState();
}

class _ReportMenuDailyState extends State<ReportMenuDaily> {


  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return SafeArea(
      child: Scaffold(
        //key: login,
        backgroundColor: siteThemeColor,
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(200.0),bottomRight: Radius.circular(200.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Daily Report Menu",style: TextStyle(color: siteThemeColor,fontSize: 22),),
                      SizedBox(height: 30,),
                      Divider(),
                      QuickMenu(),
                      Divider(),
                      Text("View reports or submit a new one",style: TextStyle(color: siteThemeColor),),
                      SizedBox(height: 30,),
                      SizedBox(height: 25.0,),

                      Builder(
                        builder: (context) => Consumer<AuthProvider>(
                          builder:(context,child,user)=>
                              RaisedButton(
                                color: siteThemeColor,
                                disabledColor: Colors.grey,
                                onPressed: ()=>  Navigator.push(
                                  context,
                                  CupertinoPageRoute(builder: (context) => AddReport()),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    //color: Colors.green,
                                  ),
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                                  child: Text(
                                    'Add Report'
                                    , style: TextStyle(color: Colors.white,),),
                                ),
                              ),
                        ),
                      ),

                      SizedBox(height: 25.0,),

                      Builder(
                        builder: (context) => Consumer<AuthProvider>(
                          builder:(context,child,user)=>
                              RaisedButton(
                                color: siteThemeColor,
                                disabledColor: Colors.grey,
                                onPressed: ()=> Navigator.push(
                                  context,
                                  CupertinoPageRoute(builder: (context) => Reports()),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    //color: Colors.green,
                                  ),
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                                  child: Text(
                                    'My Reports'
                                    , style: TextStyle(color: Colors.white,),),
                                ),
                              ),
                        ),
                      ),



                      // Add TextFormFields and RaisedButton here.
                    ]
                ),
              ),
            ),
          ),
        ),
      ),
    );
//passwordController.dispose();

  }




}



class QuickMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        //color: Colors.white,
//                                  boxShadow: [
//                                    BoxShadow(
//                                      color: Colors.black26,
//                                      blurRadius: 1.0, // soften the shadow
//                                      spreadRadius: 1.0, //extend the shadow
//                                      offset: Offset(
//                                        0.0, // Move to right 10  horizontally
//                                        2.0, // Move to bottom 5 Vertically
//                                      ),
//                                    )
//                                  ]
      ),
      //color: Colors.grey[200],
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
                  child: Icon(Icons.camera,color: siteThemeColor,size: 35,))),
          GestureDetector(
              onTap:()=> Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => FeedBack()),
              ),
              child: Container(
                  padding:EdgeInsets.all(10.0),
                  decoration:siteIconEffectGrey,
                  child: Icon(Icons.email,color: siteThemeColor,size: 35,))),
        ],),
    );
  }
}



