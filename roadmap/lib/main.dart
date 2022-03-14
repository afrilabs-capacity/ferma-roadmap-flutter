import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import  'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:roadmap/views/login.dart';
import 'package:roadmap/providers/auth.dart';
import 'package:roadmap/views/onboarding_landing.dart';
import 'package:roadmap/providers/report.dart';
import 'package:roadmap/db/database_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';
import 'dart:io';



void main() {


  //print('hi there');
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    // runApp(new MyApp());
    Provider.debugCheckInvalidValueType = null;

    runApp(
      MultiProvider(
          providers: [
//            ChangeNotifierProvider<CountProvider>(create: (context) => CountProvider()),
//          ProxyProvider<UserProvider, AuthProvider>(
//            update: (_, userProvider, __) => AuthProvider(userProvider: userProvider),
//          ),
//          ChangeNotifierProvider<UserProvider>(
//              create: (_) => UserProvider()
//          ),
//          ProxyProvider<UserProvider, AuthProvider>(
//            update: (_,userProvider, __) => AuthProvider( userProviderModel: userProvider.user),
//          ),
            ChangeNotifierProvider<AuthProvider>(create: (context) => AuthProvider()),
            ChangeNotifierProvider<ReportProvider>(create: (context) => ReportProvider()),
//            ChangeNotifierProvider<PdssReportProvider>(create: (context) => PdssReportProvider()),
//            ChangeNotifierProvider<NewsProvider>(create: (context) => NewsProvider()),
//          ChangeNotifierProvider<PaymentModalProvider>(create: (context) => PaymentModalProvider()),
//          ChangeNotifierProvider<PartnerProvider>(create: (context) => PartnerProvider()),
//          ChangeNotifierProvider<DealProvider>(create: (context) => DealProvider()),
//          ChangeNotifierProvider<StudentProvider>(create: (context) =>  StudentProvider()),
//          ChangeNotifierProvider<MessageProvider>(create: (context) =>  MessageProvider()),
//          ChangeNotifierProvider<AlbumProvider>(create: (context) =>   AlbumProvider()),
//          ChangeNotifierProvider<RouteProvider>(create: (context) =>   RouteProvider()),
//          ChangeNotifierProvider<ChatProvider>(create: (context) =>   ChatProvider()),
          ],
          //builder: (context) => AuthProvider(),
          child: MaterialApp(
            home: PrepareApp()
          )
      ),
    );



  });
  //fetchFromApi();
}


class PrepareApp extends StatefulWidget {
  @override
  _PrepareAppState createState() => _PrepareAppState();
}

class _PrepareAppState extends State<PrepareApp> {


  // homepage layout

  /*connection status*/
  bool _connectionStatus;

  final Connectivity _connectivity = Connectivity();

  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  

  void initState(){
//    _getAllData();
  }
  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  void setState(fn) {
    if(mounted){
//      print('mounted in PrepareApp');
//      Provider.of<AuthProvider>(context,listen: false).getUserData();
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('mounted in PrepareApp');
    Provider.of<AuthProvider>(context,listen: false).getUserData();
    return Consumer<AuthProvider>(
        builder:(context,data,child){
          if(data.authenticated){
            return  OnboardingLanding();
          }else{
            return Login();
          }
        });
  }
}


