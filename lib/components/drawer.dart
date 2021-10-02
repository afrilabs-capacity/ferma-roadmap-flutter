import 'package:flutter/material.dart';
import 'package:lac/views/home.dart';
import 'package:lac/views/about.dart';
import 'package:lac/views/reports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:lac/views/report_type.dart';
import 'package:lac/views/feedback.dart';


class MyDrawer extends StatelessWidget {

  final BuildContext context;
  MyDrawer({this.context});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children:  <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                image: NetworkImage('https://lacreportserver.xyz/public/images/lachq.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Text(
              '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            onTap: ()=> Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Home()),),
            leading: Icon(Icons.message,color: Colors.redAccent,),
            title: Text('Home'),
          ),
          Divider(),
          ListTile(
            onTap: ()=> Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => About()),),
            leading: Icon(Icons.admin_panel_settings_outlined,color: Colors.redAccent,),
            title: Text('About'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.location_on,color: Colors.redAccent,),
            title: Text('Offices'),
          ),
          Divider(),
          ListTile(
            onTap: ()=> Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) =>ReportType()),),
            leading: Icon(Icons.insert_chart,color: Colors.redAccent,),
            title: Text('My Reports'),
          ),
          Divider(),
          ListTile(
            onTap: ()=> Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) =>FeedBack()),),
            leading: Icon(Icons.contact_mail_outlined,color: Colors.redAccent,),
            title: Text('Feedback'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.power_settings_new,color: Colors.redAccent,),
            title: Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

