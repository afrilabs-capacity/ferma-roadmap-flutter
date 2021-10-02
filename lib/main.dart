import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import  'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:lac/providers/counter.dart';
import 'package:lac/views/home.dart';
import 'package:lac/providers/auth.dart';
import 'package:lac/providers/report.dart';
import 'package:lac/providers/pdss.dart';
import 'package:lac/providers/config.dart';
import 'package:lac/providers/news.dart';



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
          ChangeNotifierProvider<CountProvider>(create: (context) => CountProvider()),
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
          ChangeNotifierProvider<PdssReportProvider>(create: (context) => PdssReportProvider()),
          ChangeNotifierProvider<NewsProvider>(create: (context) => NewsProvider()),
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
          home: Home(),
        )
      ),
    );



  });
  //fetchFromApi();
}


// void fetchFromApi() async{
//var response = await http.get("https://jsonplaceholder.typicode.com/todos/");
//List res= json.decode(response.body);
//res.forEach((element) =>
//    //print("Title $element.title")
//print(element['title'])
//
//);
////print(response.body);
//}
