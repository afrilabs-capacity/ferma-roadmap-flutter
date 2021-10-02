import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lac/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:lac/utils/constants.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:lac/models/carousel.dart';
import 'package:lac/views/about.dart';
import 'package:lac/views/login.dart';
import 'package:lac/views/register.dart';
import 'package:lac/views/report_menu_daily.dart';
import 'package:lac/views/offices.dart';
import 'package:lac/views/news.dart';
import 'package:lac/views/report_type.dart';
import 'package:lac/views/feedback.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool captionUp=false;
  String caption;
  Timer timer;
  ScrollController _scrollController = new ScrollController();



  List <Carousel> imageList =[
    Carousel(caption: "National Association of Nigerian Students(NANS) National Executives during the Grand Unveiling of Naija Green Card" ,imageUrl:"https://i.imgur.com/yW67w3K.jpg" ),
    Carousel(caption: "Former Vice President; His Excellency Alhaji Atiku Abubakar, endorses Naija Green Card" ,imageUrl:"https://i.imgur.com/Ie1lsDd.jpg" ),
    Carousel(caption: "Naija Green Card Initiator (Congressman Bimbo Daramola) Addressing Corps Members during One of his visit to the Nysc Orientations Camp" ,imageUrl:"https://i.imgur.com/OXmeUmz.png" ),
//    Carousel(caption: "His Imperial majesty Oba   Enitan Adeyeye Ogunwusi Ooni of Ife endorses Naija Green Card" ,imageUrl:"$siteUrl/gallery/n3.jpg" )

  ];



  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
//      //_scrollController.animateTo(0.5, duration: Duration(milliseconds: 3000), curve: null);
//      //print('scrolling slider');
//      if(mounted)  userData(context);
//        /setState(() {});
//    });
//
//
//  }

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //print('rebuilding')
    //print(Provider.of<UserProvider>(context).userAuthenticated);
    return  SafeArea(
      child: Scaffold(
        //backgroundColor: Color(int.parse("0xFFd83623")),
        backgroundColor: Colors.grey[300],
        resizeToAvoidBottomInset: false,
        body: Container(
          //color: Colors.grey[00],
          //decoration: Styles.gradientFill1,
          child: Stack(
            //mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ClipPath(
                clipper: CurvedBottomClipper(),
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage('https://lacreportserver.xyz/public/images/lachq.jpg'),fit:BoxFit.cover),

                  ),

                ),
              ),
              Positioned(
                  right: 0,
                  left: 0,
                  top: 0,
                 bottom:MediaQuery.of(context).size.height/3+25,
                  child: ClipPath(
                    clipper: CurvedBottomClipper(),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        //image: DecorationImage(image: NetworkImage('https://i.imgur.com/yW67w3K.jpg'),fit:BoxFit.cover),
                        color: Colors.black54,

                      ),

                    ),
                  ),),
              Positioned(
                  right: 30,
                  left: 30,
                  top: 100,
                  child: AuthPanel()),
              Positioned(
                //top: 230,
                right: 30,
                left: 30,
                bottom: 20,
                child: HomeMenu(),
              ),
              Column(children: [
                Expanded(flex: 1, child: Container())
              ],)



            ],
          ),
        ),


      ),
    );

  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}


class HomeMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 30,),
          Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
//                  HomeIcon(iconText: "Home",icon:Icons.home,action: ()=> Navigator.push(
//                    context,
//                    CupertinoPageRoute(builder: (context) => About()),
//                  ),
//                  ),
                  HomeIcon(iconText: "About",icon:Icons.admin_panel_settings_outlined,action: ()=> Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => About()),
                  ),
                  ),
                  HomeIcon(iconText: "Feedback",icon:Icons.email,action: ()=> Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => FeedBack()),
                  ),
                  ),


                ],
              )),
          Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  HomeIcon(iconText: "News",icon:Icons.chat_outlined,action: ()=> Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => News()),
                  ),
                  ),
//                  HomeIcon(iconText: "Resources",icon:Icons.download_done_outlined,action: ()=> Navigator.push(
//                    context,
//                    CupertinoPageRoute(builder: (context) => About()),
//                  ),
//                  ),
                  HomeIcon(iconText: "Offices",icon:Icons.location_on,action: ()=> Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => Offices()),
                  ),
                  ),

                ],
              )),
          Expanded(
              child: Consumer<AuthProvider>(
                builder:(context,data,child)=> Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                  children: [
//                  SizedBox(width: 40,),


                    !data.authenticated ?  HomeIcon(iconText: "Sign In",icon:Icons.security,action: ()=> Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => Login()),
                    )
                    ):HomeIcon(iconText: "Sign Out",icon:Icons.power_settings_new,action: () {
                      data.logout();
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => Login()),
                      );

                    }),

                    !data.authenticated ?
                    HomeIcon(iconText: "Register",icon:Icons.supervised_user_circle,action: ()=> Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => Register()),
                    ),
                    ):data.authenticated ? HomeIcon(iconText: "Reports",icon:Icons.insert_chart,action: ()=> Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => ReportType()),
                    ),
                    ):SizedBox(),

                  ],
                ),
              )),

        ],
      ),
    );
  }
}

class AuthPanel extends StatefulWidget {
  @override
  _AuthPanelState createState() => _AuthPanelState();
}

class _AuthPanelState extends State<AuthPanel> {
  @override
  void initState() {
    // TODO: implement initState
    userData(context);
    super.initState();
  }

  userData(context) async{
    Provider.of<AuthProvider>(context,listen: false).getUserData();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<AuthProvider>(
      builder:(context,data,child)=> Container(
          height: 80,
          decoration: BoxDecoration(
          color:Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
      boxShadow: [
//      BoxShadow(
//      color: Colors.grey.withOpacity(0.5),
//      spreadRadius: 5,
//      blurRadius: 7,
//      offset: Offset(0, 3), // changes position of shadow
//      ),
      ],
      ),
          child: Center(
          child: Text("Welcome back ${data.authenticated ? data.authData.name.split(" ").last:''}"))
      ),
    );
  }
}




class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // I've taken approximate height of curved part of view
    // Change it if you have exact spec for it
    final roundingHeight = size.height * 2 / 10;
    // this is top part of path, rectangle without any rounding
    final filledRectangle = Rect.fromLTRB(0, 0, size.width, size.height - roundingHeight);
    // this is rectangle that will be used to draw arc
    // arc is drawn from center of this rectangle, so it's height has to be twice roundingHeight
    // also I made it to go 5 units out of screen on left and right, so curve will have some incline there
    final roundingRectangle = Rect.fromLTRB(
        -5, size.height - roundingHeight * 2, size.width + 5, size.height);
    final path = Path();
    path.addRect(filledRectangle);
    // so as I wrote before: arc is drawn from center of roundingRectangle
    // 2nd and 3rd arguments are angles from center to arc start and end points
    // 4th argument is set to true to move path to rectangle center, so we don't have to move it manually
    path.arcTo(roundingRectangle, pi, -pi, true);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // returning fixed 'true' value here for simplicity, it's not the part of actual question, please read docs if you want to dig into it
    // basically that means that clipping will be redrawn on any changes
    return true;
  }
}



class HomeIcon extends StatelessWidget {

  final String iconText;
  final IconData icon;
  final dynamic action;
  HomeIcon({this.iconText,this.icon,this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.action,
      child: Column(
        children: [
          Container(
            padding:EdgeInsets.all(10.0),
            decoration:siteIconEffectGrey,
            //child: Icon(Icons.home,size: 35.0,color: siteThemeColor,),
            child: Icon(this.icon,size: 35.0,color: siteThemeColor,),
          ),
          Text(this.iconText)
        ],
      ),
    );
  }
}
