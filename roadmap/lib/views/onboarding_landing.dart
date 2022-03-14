import 'package:provider/provider.dart';
import 'package:roadmap/providers/auth.dart';
import 'package:roadmap/providers/report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roadmap/utils/constants.dart';
import 'package:roadmap/models/auth_data.dart';
import 'package:roadmap/utils/validate.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'dart:io';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:roadmap/db/database_helper.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:roadmap/views/login.dart';
import 'package:roadmap/views/onboarding.dart';
import 'package:roadmap/utils/app_theme.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';




class OnboardingLanding extends StatefulWidget {
  @override
  _OnboardingLandingState createState() => _OnboardingLandingState();
}

class _OnboardingLandingState extends State<OnboardingLanding> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
//    Provider.of<AuthProvider>(context,listen: false).getUserData();
    return WillPopScope(
      onWillPop: ()async{
        print('popping scope');
        return true;
      },
      child: SafeArea(child: Consumer<ReportProvider>(
        builder:(context,reportProvider,child) =>Scaffold(
            bottomNavigationBar: Consumer<AuthProvider>(
              builder:(context,authProvider,child)=> authProvider.authData.onboarded ? CurvedNavigationBar(
                key: _bottomNavigationKey,
                index: reportProvider.bottomNavigationIndex,
                height: 60.0,
                items: <Widget>[
                  Container(child: Icon(Icons.home, size: 30)),
                  Container(child: Stack(children: [
                    Icon(Icons.add, size: 30),
//              Positioned( top:27.0,child: Text("Add Report",style: TextStyle(color: Colors.black,fontSize: 8.0)))
                  ],)),

                  Container(child: Icon(Icons.compare_arrows, size: 30)),
                  Container(child: Icon(Icons.perm_identity, size: 30)),
                  Container(child: Icon(Icons.power_settings_new, size: 30)),
                ],
                color: Colors.white,
                buttonBackgroundColor: Colors.white,
                backgroundColor: siteThemeColor,
                animationCurve: Curves.easeInOut,
                animationDuration: Duration(milliseconds: 600),
                onTap: (index) {
                  setState(() {
                    reportProvider.bottomNavigationIndex=index;
                    _page = reportProvider.bottomNavigationIndex;
                  });
                },
                letIndexChange: (index) => true,
              ):SizedBox(),
            ),
            backgroundColor: Colors.grey[100],
          body: Consumer<AuthProvider>(
            builder: (context,data,child)
           {

             if(!data.authenticated) {
               reportProvider.bottomNavigationIndex=0;
               reportProvider.notifyListeners();
               WidgetsBinding.instance.addPostFrameCallback((_) {
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login()));
               });


             }else{
              if(!data.authData.onboarded){
                return Onboarding();
              }else{
                if( isAdHoc(data.authData.roles)){
                  if(reportProvider.bottomNavigationIndex==0)return Dashboard(data.authData);
                  if(reportProvider.bottomNavigationIndex==1)return  MapWidget();
                  if(reportProvider.bottomNavigationIndex==2)return SyncronizationPage();
                  if(reportProvider.bottomNavigationIndex==3)return ProfilePage();
                  if(reportProvider.bottomNavigationIndex==4)return SignOut();
                }else{
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      UnauthorizedAccess(),
                      Icon(Icons.lock,color: Colors.grey[300],size: 200.0,),
                      SignOut()
                    ],);
                }
              }
//               return Dashboard(data.authData);
             }

            return SizedBox();
             }

           )),
      )),
    );
  }
}


class UnauthorizedAccess extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child:Text("Unauthorized Access")),
    );
  }
}

class Dashboard extends StatefulWidget {
  final AuthData authData;
  Dashboard(this.authData);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  final dbHelper = DatabaseHelper.instance;
  int userSeenBroadcastValue=0;

  showModalBottom(BuildContext context) async {

    return Scaffold.of(context).showBottomSheet(
          (BuildContext context){
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter updateModalState /*You can rename this!*/)=> Container(
            decoration: BoxDecoration(
//            borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight:Radius.circular(25.0) ),
              color:Colors.black54,
            ),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Consumer<AuthProvider>(
                builder:(context,authProvider,child)=> Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded( child: SizedBox(),),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight:Radius.circular(25.0) ),
                                color: Colors.white,
                              ),
                              height: 500,
                              width: double.infinity,
//                  child: Center(child: Text(report['message']!="" ? report['message'] : "No comment found.")),
                              child: Consumer<ReportProvider>(
                                builder:
                                    (context,reportProvider,child)=>Column(children: [
                                  Center(
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.pinkAccent,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.cancel_sharp,
                                          color: Colors.white,
                                          size: 25.0,
                                        ),
                                        onPressed:()=>Navigator.of(context).pop(),
                                      ),
                                    ),
                                  ),
                                  Expanded(child:Column(children: [
                                    SizedBox(height: 5.0),
                                    Text("General Broadcast",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
//                                    SizedBox(height: 20.0),
                                    Expanded(
                                      flex: 1,
                                      child: ListView.builder(
//                                key: UniqueKey()
                                          padding: const EdgeInsets.all(8),
                                          itemCount: reportProvider.broadcastMessages.length >0 ? reportProvider.broadcastMessages.length : 1,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (BuildContext context, int index) {

                                            return reportProvider.broadcastMessages.length>0 ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Card(
                                                  shape: RoundedRectangleBorder(
//                                                    borderRadius: BorderRadius.circular(40), // if you need this
                                                    side: BorderSide(
                                                      color: Colors.grey.withOpacity(0.2),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Container(
                                                    color: Colors.white,
                                                    width:  double.infinity,
//                                                    height: 120,
                                                    child: Column(children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(reportProvider.broadcastMessages[index]['title'],style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold)),
                                                      ),
                                                     Column(
//                                                       crossAxisAlignment: CrossAxisAlignment.end,
                                                       children: [
                                                       Padding(
                                                         padding: const EdgeInsets.all(8.0),
                                                         child: Text(reportProvider.broadcastMessages[index]['body']),
                                                       ),
                                                       Container(
                                                         margin:EdgeInsets.all(5.0),
                                                         decoration:BoxDecoration(
                                                           borderRadius: BorderRadius.circular(5.0)
                                            ),
                                                         child: Padding(
                                                           padding: const EdgeInsets.all(2.0),
                                                           child: Text("Posted ${formatDateF(reportProvider.broadcastMessages[index]['posted'])}",style: TextStyle(color:Colors.grey[500]),),
                                                         ),
                                                       )
                                                     ],)
                                                    ],),
                                                  ),
                                                )

                                            ],): Column(children: [
                                              Text( "No broadcast(s) found")
                                            ],);

                                          }
                                      ),
                                    )


                                  ],))
                                ],),
                              ),
                            ),
                          ),


                        ],),
                    )

                  ],),
              ),
            ),
          ),
        );

      },
      backgroundColor: Colors.black54,
    );
  }

  @override
  void didChangeDependencies() async{
    // TODO: implement didChangeDependencies
    Provider.of<ReportProvider>(context,listen: false).isSingleReportClicked=false;
    Provider.of<ReportProvider>(context,listen: false).currentRecord=null;
    Provider.of<ReportProvider>(context,listen: false).queryAllBroadcastMessages();
    super.didChangeDependencies();
  }

 void initState(){
    hasUserSeenBroadcast();
    createGeneralBroadcastSeen();
   super.initState();
 }

  Future<int> hasUserSeenBroadcast() async{
    //userSeenBroadcastValue=await dbHelper.hasUserSeenBroadcast(widget.authData.id);
    int wasValueReturned= await dbHelper.hasUserSeenBroadcast(widget.authData.id);
    if(wasValueReturned!=null){
      userSeenBroadcastValue=wasValueReturned;
      setState(() {
      });
    }
    return  userSeenBroadcastValue;
  }

  Future<void> createGeneralBroadcastSeen() async{
    int wasValueReturned= await dbHelper.createGeneralBroadcastSeen(widget.authData.id);
    if(wasValueReturned!=null){
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
//    Navigator.of(context).pop();
    //print('mounted to check unread messages');
    return Consumer<ReportProvider>(
      builder:(context,reportProvider,child)=> !reportProvider.isSingleReportClicked?  Container(
         width: double.infinity,
        child: Column(
        children: [
          Expanded(child: Container(
            width: double.infinity,
              color: siteThemeColor,
              child: Column(children: [
                Expanded(child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: ()async {
                          await dbHelper.createOrUpdateGeneralBroadcastSeen(
                              widget.authData.id);
                          //print(await dbHelper.getUserSettings(widget.authData.id));
                          print(await dbHelper.hasUserSeenBroadcast(widget.authData.id));
                          await showModalBottom(context);

                        },
                      child: Stack(children: [
                         Icon(Icons.mail,color: Colors.white,),
                        userSeenBroadcastValue > 0 ? Align(alignment: Alignment.topLeft, child: Icon(Icons.memory,color: Colors.red,size: 15.0,),) :Align(alignment: Alignment.topLeft, child: SizedBox(height: 5.0,),),

                      ],),
                    ),
                  )
                ],),),
                widget.authData.photo!="" ? Expanded(flex:2, child: new  CachedNetworkImage(
                  imageUrl: "$hostUrl/uploads/avatar/${widget.authData.photo}",
                  placeholder: (context, url) => CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.person,size: 100,), radius: 50,),
                  errorWidget: (context, url, error) => CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.person,size: 100,), radius: 50,),
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: 50,
                  backgroundImage: imageProvider,
                ),
                ), )
//                    NetworkImage("$hostUrl/uploads/avatar/${widget.authData.photo}"), radius: MediaQuery.of(context).size.width/6,))
        :CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.person,size: 100,), radius: MediaQuery.of(context).size.width/6,),
                Expanded(child: Center(child: Text(" Welcome Back ${widget.authData.name}",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.w600),)))
              ],))),
          SizedBox(height: 40.0,),
          Text(" My Reports",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 17.0,fontWeight: FontWeight.w600),),

          Expanded(child: Tabs()),
          SizedBox(height: 15.0,)

        ],
      ),):SingleReport(),
    );
  }
}



class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  bool _connectionStatus;
  Position _currentPosition;
  bool reportHome=true;

  _getCurrentLocation() async {
    var position = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    var lastPosition = await Geolocator.getLastKnownPosition();
//    print(lastPosition);
    if (position != null) {
      setState(() {
        _currentPosition = position;
        Provider.of<ReportProvider>(context,listen: false).latitude=position.latitude.toString();
        Provider.of<ReportProvider>(context,listen: false).longitude=position.longitude.toString();
      });
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    Provider.of<ReportProvider>(context,listen: false).cleanReportValues();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if(reportHome){
      return _currentPosition!= null ? Column(
        children: [
          Expanded(
            flex: 2,
            child:OfflineBuilder(
                connectivityBuilder: (context,ConnectivityResult connectivity,child,
                    ){
                  _connectionStatus = connectivity != ConnectivityResult.none;
                  if(_connectionStatus){
                    print(connectivity);

                  }
                  return Column(children: [
                    Expanded(
                      child: _connectionStatus ? FlutterMap(
                        options: MapOptions(
                          center: LatLng(_currentPosition.latitude, _currentPosition.longitude),
                          zoom: 13.0,
                        ),
                        layers: [
                          TileLayerOptions(
                              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                              additionalOptions: {
                                'accessToken':'pk.eyJ1IjoiYnJhaW1haGpha2UiLCJhIjoiY2t1anA4cThlMGx5eDJvcDZ0azY4cmhociJ9.vPEFdfjeoJonmhxpMWtpZA',
                              },
                              subdomains: ['a', 'b', 'c']
                          ),
                          MarkerLayerOptions(
                            markers: [
                              Marker(
                                width: 80.0,
                                height: 80.0,
                                point: LatLng(51.5, -0.09),
                                builder: (ctx) =>
                                    Container(
                                      child: FlutterLogo(),
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ): Container(
                        width:double.infinity,
                          color:Colors.grey[200],
                          child: Icon(Icons.location_on,size: 200.0,color: siteThemeColor,)),
                    ),
//                    Text(_connectionStatus.toString())
                  ],);

                },
                builder: (context)=>SizedBox()
            ) ,
          ),
          SizedBox(height: 40.0),
          Expanded(child: Center(
            child: Column(children: [
              Text("Ready to create a report? "),
              SizedBox(height: 7.0),
              Text("Please click the button below to continue."),
              SizedBox(height: 20.0),
              FlatButton(child:
              OutlineButton(
                shape: StadiumBorder(),
                textColor: siteThemeColor,
                child: Text('Add a report'),
                borderSide: BorderSide(
                    color: siteThemeColor, style: BorderStyle.solid,
                    width: 1),
                onPressed: ()=>setState(()=>reportHome=false),
              )
              )
            ],),
          ),),


        ],
      ):Center(child: Text("Loading map..."),);
    }else{
      return AddReport();
    }
  }
}


class AddReport extends StatefulWidget {
  @override
  _AddReportState createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController =TextEditingController();
  String message = '';
  bool loading=false;
  bool modalWindowOpen=false;
  Duration snackBarDurationOpen= Duration(days: 1);
  Duration snackBarDurationClose= Duration(microseconds: 1);
  bool submitMode=true;
  FocusNode myFocusNode = FocusNode();
  bool additionalInfoMode=false;
  List formStages = [1,2,3,];



  showModalBottom(BuildContext context) async {
    modalWindowOpen=true;
    return Scaffold.of(context).showBottomSheet(
          (BuildContext context){
        return Center(
          child: Container(
            color: Colors.black,
            child: Container(
                height: 70,
                color: Colors.white,
                width: MediaQuery.of(context).size.width-40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 35,),
                    Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(siteThemeColor),)),
                    SizedBox(width: 35,),
                    Text('Submitting report...')
                  ],
                )

            ),
          ),
        );

      },
      backgroundColor: Colors.black54,
    );
  }


  /*reference to our single class that manages the database*/
  final dbHelper = DatabaseHelper.instance;



  Future<void> submitReport() async{
    PersistentBottomSheetController bottomSheetController1;
    bottomSheetController1 =await showModalBottom(context);
    var authUserId= Provider.of<AuthProvider>(context,listen: false).authData.id;
    Map<String,dynamic> result= await Provider.of<ReportProvider>(context,listen: false).saveLocal(firstNameController.text,authUserId);

    if(result['success']){
      Future.delayed(const Duration(milliseconds: 500), () async{
        // Here you can write your code
        if(mounted) {
          setState(() {
            /*do stuff after submit*/
            bottomSheetController1.close();
            bottomSheetController1.closed.then((value){
              submitMode = false;
              firstNameController.clear();

            });


          });

        }
        await Provider.of<ReportProvider>(context,listen: false).querySingleReport();
      });
    }else{
      //show persistent bottomSheetModal
      final snackBar =(message)=> new SnackBar(
          content: new Text("Your report has not been submitted!"),
          //duration: snackBarDurationOpen,
          duration: Duration(milliseconds: 4000),
          backgroundColor: Colors.black);

    }



  }

  Future<void> submit(BuildContext context,ReportProvider data) async {
    //show persistent bottomSheetModal
    final snackBar =(message)=> new SnackBar(
        content: new Text(message),
        //duration: snackBarDurationOpen,
        duration: Duration(milliseconds: 4000),
        backgroundColor: Colors.black);
    PersistentBottomSheetController bottomSheetController;
    final form = _formKey.currentState;
    if (data.photos.length>0) {
      bottomSheetController =await showModalBottom(context);
      bottomSheetController.closed.then((value) {
        // this callback will be executed on close
        this.modalWindowOpen=false;
      });
      print("in submit box");

    }

  }

@override
  void initState() {
    // TODO: implement initState
//  _getAllData();
//  KeyboardVisibilityNotification().addNewListener(
//    onChange: (bool visible) {
//      if (!visible) {
//        myFocusNode.unfocus()
//      }
//    },
//  );
  print("form stage ${formStages[0]}");
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    firstNameController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return KeyboardVisibilityBuilder(
        builder: (context, child, isKeyboardVisible)=> Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
//              borderRadius: BorderRadius.only(topRight: Radius.circular(70.0),bottomLeft: Radius.circular(60.0)),
            ),
            child: Form(
                key: _formKey,
                child: Consumer<ReportProvider>(
                  builder:(context,reportProvider,child)=> submitMode ?
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: Column(children: [
                                Text("Additional Information",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                                SizedBox(height: 20.0),
                                Text("Do you have additional information?"),
                                SizedBox(height: 5.0),
                                Expanded(
                                  child: Container(
//                                decoration: shadowBox1,
                                    child: Focus(
                                      onFocusChange: (hasFocus) {
                                        if(hasFocus) {
                                          // do stuff
//                                        print('has focus');
                                          setState(() {
                                            additionalInfoMode=true;
                                          });
                                        }else{
                                          setState(() {
                                            additionalInfoMode=false;
                                          });
//                                        print('not has focus');
                                        }
                                      },
                                      child: TextFormField(
                                        controller: firstNameController,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 5,
                                        //initialValue: 'braimahjake@gmail.com',
                                        //decoration: Styles.flatFormFields.copyWith(labelText: 'EMAIL',focusColor: Colors.pink),
                                        // The validator receives the text that the user has entered.
                                        decoration: InputDecoration(labelText: '',focusColor: Colors.pink,contentPadding:EdgeInsets.fromLTRB(11, 0, 0, 0)),
                                        validator: (value) {
                                          firstNameController.text = value.trim();
                                          return Validate.requiredField(value, 'Required field');
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],)
                          ),
                          !isKeyboardVisible ? Expanded(
                            flex: 3,
                            child: Column(children: [
                              SizedBox(height: 20.0),
                              Text("Photos (You can attach upto 4 images)"),
                              SizedBox(height: 5.0),
                              Expanded(flex: 2, child: TakePhotos(context)),
                              SizedBox(height: 20.0),
                            ],),):SizedBox(),
                          !isKeyboardVisible ?  Consumer<AuthProvider>(
                            builder:(context,child,user)=>  RaisedButton(
                              color:  !modalWindowOpen && reportProvider.photos.length!=0 ? siteThemeColor : Colors.grey,
                              disabledColor: Colors.grey,
                              onPressed:(){
                                FocusScopeNode currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                return  !modalWindowOpen && reportProvider.photos.length!=0  ? submitReport() : null;
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  //color: Colors.green,
                                ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                                child: Text(
                                  'Submit'
                                  , style: TextStyle(color: Colors.white,),),
                              ),
                            ),
                          ):SizedBox(),




                          // Add TextFormFields and RaisedButton here.
                        ]
                    ),
                  ):
                  SingleReport(),
                )
            ),
          ),
        ),
      ),
    );



//passwordController.dispose();

  }




}


class TakePhotos extends StatefulWidget {
  final BuildContext addReportContext;
  TakePhotos(this.addReportContext);
  @override
  _TakePhotosState createState() => _TakePhotosState();
}

class _TakePhotosState extends State<TakePhotos> {
  XFile _image;
//  var picker = ImagesPicker;
  List<String> photos= [];

  CameraController _cameraController;
  Future<void> _initializeCameraControllerFuture;

 void _showCamera(BuildContext context) async {
   FocusScopeNode currentFocus = FocusScope.of(widget.addReportContext);
   if (!currentFocus.hasPrimaryFocus) {
     currentFocus.unfocus();
   }
    final cameras = await availableCameras();
    final camera = cameras.first;
         setState(() {
           _cameraController = CameraController( camera, ResolutionPreset.low);

           _initializeCameraControllerFuture = _cameraController.initialize();
         });
         showCameraWidget(context);
  }


  Future<XFile> _takePicture() async {
    if (_cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await _cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print(e);
      return null;
    }
  }

  void onTakePictureButtonPressed(ReportProvider data) {
    _takePicture().then((XFile file) {
      if (mounted) {
        setState(() {
           _image=file;
           file.saveTo(file.path);
           String base64Image = base64Encode(File(file.path).readAsBytesSync());
           data.photos.add({'path':file.path,'base64':base64Image});
//           print(base64Image);
           _cameraController.dispose();
        });

      }
      Navigator.of(context).pop();
    });
  }



  showCameraWidget(BuildContext context){
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
   return showModalBottomSheet(
       context: context,
       builder: (context) {
         return Container(
             height: double.infinity,
             child:  Stack(children: <Widget>[
             FutureBuilder(
             future: _initializeCameraControllerFuture,
             builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.done) {
             return Transform.scale(
               scale: 1,
               child: Center(
                 child: CameraPreview( _cameraController),
             ));
           } else {
             return Center(child: CircularProgressIndicator(color: siteThemeColor,));
           }
         },
         ),
         Positioned.fill(
           child: Align(
             alignment: Alignment.bottomCenter,
             child: Consumer<ReportProvider>(
               builder:(context,data,child)=> FloatingActionButton(
               backgroundColor: siteThemeColor,
               onPressed: ()=>onTakePictureButtonPressed(data),
               tooltip: 'Take Picture',
               child: Icon(Icons.add_a_photo,color: Colors.white,),
               ),
             ),
           ),
         )
         ]));
  });}



  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          backgroundColor: Colors.grey[100],
        body: Consumer<ReportProvider>(
          builder:(context,data,child) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  child:  data.photos.length==0
                      ? Center(child: Text('No image(s) taken'))
                      : Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:  data.photos.map((Map<String,dynamic> file) => Expanded(
                      child: Stack(
                        children: [
                          Container(
                            width: 60.0,
                            margin: EdgeInsets.only(left: 9.0,right: 9.0,top: 15.0),
//                  color: Colors.white,
                            padding: EdgeInsets.all(5.0),
                            decoration:shadowBox1,
//                decoration: shadowBox1,
                            child: Image.file(File(file['path'])),),
                          Positioned(
                            left: 43.0,
                            top:1,
                            //alignment:Alignment(0.4, 1),
                            child: CircleAvatar(
                            radius: 15,
                              backgroundColor: Colors.pinkAccent,
                              child: IconButton(
                                icon: Icon(
                                  Icons.cancel_sharp,
                                  color: Colors.white,
                                  size: 12.0,
                                ),
                                onPressed:(){
                                  setState( ()=>data.photos.removeWhere((item) => file == item));
                                  data.notifyListeners();
                                }

                              ),
                              ),
                            ),


                        ],
                      ),
                    )
                    ).toList(),),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Consumer<ReportProvider>(
          builder:(context,data,child)=> FloatingActionButton(
            backgroundColor:  data.photos.length !=4 ?  siteThemeColor:Colors.grey,
            onPressed: ()=> data.photos.length !=4 ?  _showCamera(context):null,
            tooltip: 'Pick Image',
            child: Icon(Icons.add_a_photo,color:  Colors.white,),
          ),
        ),
      ),
    );
  }
}




class SyncronizationPage extends StatefulWidget {
  @override
  _SyncronizationPageState createState() => _SyncronizationPageState();
}

class _SyncronizationPageState extends State<SyncronizationPage> {

  bool _connectionStatus;
  int authUserId;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    authUserId= Provider.of<AuthProvider>(context,listen: false).authData.id;
    Provider.of<ReportProvider>(context,listen: false).queryAllRecordsCountUnsynchronized(authUserId);
    Provider.of<ReportProvider>(context,listen: false).queryAllRecordsCountSynchronized(authUserId);
    Provider.of<ReportProvider>(context,listen: false).getToken();
    Provider.of<ReportProvider>(context,listen: false).syncComment="";

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Consumer<ReportProvider>(
        builder:(context,reportProvider,child)=> Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
//            Expanded(child: SizedBox()),
            SizedBox(height: 10.0,),
          Expanded(
            flex: 3,
            child: Center(
              child: CircularPercentIndicator(
                radius: 160.0,
                lineWidth: 13.0,
                animation: true,
                percent: double.parse(".${reportProvider.synced}"),
                center: new Text(
                  "${reportProvider.synced.toDouble()}%",
                  style:
                  new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                footer: new Text(
                  "Reports",
                  style:
                  new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: siteThemeColor,
              ),

            ),
          ),
            Expanded(child: SizedBox()),
            Expanded( child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child: SizedBox(),),
//            Icon(Icons.location_on,color: siteThemeColor,),
                Expanded(
                  flex: 2,
                  child: Column(children: [
                    Text("Synced:",style: TextStyle(color: Colors.grey[500])),
                    Text("${reportProvider.synced}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 25.0))
                  ],),),
                Expanded(child: SizedBox(),),
//            Icon(Icons.location_on,color: siteThemeColor),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text("Unsynced:",style: TextStyle(color: Colors.grey[500])),
                      Text("${reportProvider.unsynced}",style: TextStyle(fontWeight: FontWeight.w600,fontSize:25.0))
                    ],),),
                Expanded(child: SizedBox(),),
              ],
            )),
            Expanded(child: SizedBox()),
            OfflineBuilder(
              connectivityBuilder: (context,ConnectivityResult connectivity,child,
              ){
              _connectionStatus = connectivity != ConnectivityResult.none;
                if(_connectionStatus){
                 print(connectivity);

                }
                return RaisedButton(
                  color: _connectionStatus && !reportProvider.isSyncing  ? siteThemeColor: Colors.grey ,
                  disabledColor: Colors.grey,
                  onPressed:()async =>!reportProvider.isSyncing  ? await reportProvider.syncNow(_connectionStatus,authUserId):null,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      //color: Colors.green,
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                    child: Text(
                      !reportProvider.isSyncing ? 'Synchronize' : "Synchronizing..."
                      , style: TextStyle(color: Colors.white,),),
                  ),
                );

              },
              builder: (context)=>SizedBox()
            ),
            SizedBox(height: 5.0,),
            Center(child: Text(reportProvider.syncComment)),

//            OfflineBuilder(
//                connectivityBuilder: (context,ConnectivityResult connectivity,child,
//                    ){
//                  _connectionStatus = connectivity != ConnectivityResult.none;
//                  if(_connectionStatus){
//                    print(connectivity);
//
//                  }
//                  return RaisedButton(
//                    color: _connectionStatus && !reportProvider.isSyncing  ? siteThemeColor: Colors.grey ,
//                    disabledColor: Colors.grey,
//                    onPressed:()async =>!reportProvider.isSyncing  ? await reportProvider.syncStatusNow(_connectionStatus):null,
//                    child: Container(
//                      decoration: BoxDecoration(
//                        borderRadius: BorderRadius.circular(12),
//                        //color: Colors.green,
//                      ),
//                      alignment: Alignment.center,
//                      padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
//                      child: Text(
//                        !reportProvider.isSyncing ? 'Report Status Update' : "Updating..."
//                        , style: TextStyle(color: Colors.white,),),
//                    ),
//                  );
//
//                },
//                builder: (context)=>SizedBox()
//            ),
            Expanded(child: SizedBox()),
//            Expanded(child: Text(reportProvider.unsynced!=0 ? " " : "Nothing to synchronize")),
        ],
        ),
      ),
    );
  }
}



class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {

  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: new Scaffold(
        appBar: new PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: new Container(
            color: Colors.grey[100],
            child: new SafeArea(
              child: Column(
                children: <Widget>[
                  new Expanded(child: new Container()),
                  new TabBar(
                    indicatorColor: siteThemeColor,
                    labelStyle: TextStyle(fontSize: 11.5),
                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.black,
                    tabs: [new Text("Today"), new Text("This Week"), new Text("This Month"),new Text("All Time")],
                  ),
                ],
              ),
            ),
          ),
        ),
        body:  TabBarView(
            children: <Widget>[
              new ReportsToday(),
              new ReportsThisWeek(),
              new ReportsThisMonth(),
              new ReportsAllTime()
            ],
          ),

      ),
    );
  }
}

class SingleReport extends StatefulWidget {
  @override
  _SingleReportState createState() => _SingleReportState();
}

class _SingleReportState extends State<SingleReport> {

  PersistentBottomSheetController bottomSheetController ;


  showModalBottom(BuildContext context, dynamic report, int reportId) async {
    return Scaffold.of(context).showBottomSheet(
          (BuildContext context){
        return Center(
          child: Container(
            height: double.infinity,
//            color: Colors.black,
            child: Column(children: [
              Expanded(child: Stack(children: [

                ImageSlideshow(

                  /// Width of the [ImageSlideshow].
                  width: double.infinity,

                  /// Height of the [ImageSlideshow].
                  height: double.infinity,

                  /// The page to show when first creating the [ImageSlideshow].
                  initialPage: 0,

                  /// The color to paint the indicator.
                  indicatorColor: Colors.black54,

                  /// The color to paint behind th indicator.
                  indicatorBackgroundColor: Colors.grey,


                  /// The widgets to display in the [ImageSlideshow].
                  /// Add the sample image file into the images folder
                  children: [
                    Image.memory(base64Decode(report['photo_${reportId.toString()}']),fit:BoxFit.cover ),
//                Image.memory(base64Decode(report['photo_${reportId.toString()}']),fit:BoxFit.cover ),
//                Image.memory(base64Decode(report['photo_${reportId.toString()}']),fit:BoxFit.cover )
//                Image.asset(
//                  'images/sample_image_1.jpg',
//                  fit: BoxFit.cover,
//                ),

                  ],

                  /// Called whenever the page in the center of the viewport changes.
                  onPageChanged: (value) {
                    print('Page changed: $value');
                  },

                  /// Auto scroll interval.
                  /// Do not auto scroll with null or 0.
                  autoPlayInterval: null,
                ),
                Positioned(
                  left: 0,
                  right:0,
                  top:2,
                  //alignment:Alignment(0.4, 1),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.pinkAccent,
                    child: IconButton(
                      icon: Icon(
                        Icons.cancel_sharp,
                        color: Colors.white,
                        size: 25.0,
                      ),
                      onPressed:()=>Navigator.of(context).pop(),
                    ),
                  ),),
              ],),)
            ],),
          ),
        );

      },
//      backgroundColor: Colors.black54,
    );
  }

  ScrollController listScrollController = ScrollController();

  TextEditingController commentController =TextEditingController();


  showModalBottom1(BuildContext context, dynamic report, int reportId) async {




    return Scaffold.of(context).showBottomSheet(
          (BuildContext context){
            commentController.clear();
            Future.delayed(const Duration(milliseconds: 500), () {

              if (listScrollController.hasClients) {
                final position = listScrollController.position.maxScrollExtent;
                listScrollController.animateTo(
                  position,
                  duration: Duration(seconds: 1),
                  curve: Curves.easeOut,
                );
                print('has children');
                setState(() {

                });
              }

            });

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter updateModalState /*You can rename this!*/)=> Container(
            decoration: BoxDecoration(
//            borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight:Radius.circular(25.0) ),
              color:Colors.black54,
            ),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
//            Expanded( child: SizedBox(),),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight:Radius.circular(25.0) ),
                        color: Colors.white,
                      ),
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
//                  child: Center(child: Text(report['message']!="" ? report['message'] : "No comment found.")),
                      child: Consumer<ReportProvider>(
                        builder:
                            (context,reportProvider,child)=> Column(children: [
                        Expanded(child: Center(
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.pinkAccent,
                            child: IconButton(
                              icon: Icon(
                                Icons.cancel_sharp,
                                color: Colors.white,
                                size: 25.0,
                              ),
                              onPressed:()=>Navigator.of(context).pop(),
                            ),
                          ),
                        ),),
                          Expanded(flex: 3, child:
              Scrollbar(
                            child: ListView.builder(
//                                key: UniqueKey(),
                                controller: listScrollController,
                                padding: const EdgeInsets.all(8),
                                itemCount: reportProvider.reportMessages.length >0 ? reportProvider.reportMessages.length : 1,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {

                                  return reportProvider.reportMessages.length>0 ? Container(

                                    margin: EdgeInsets.only(top: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          reportProvider.reportMessages[index]['type']=='Ad-Hoc' ? MainAxisAlignment.end : MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            reportProvider.reportMessages[index]['type']!='Ad-Hoc' ?
                                             Column(children: [
                                               Text('Admin',style:MyTheme.bodyTextTime),
                                               Icon(Icons.person,size: 40,color: Colors.grey,),
                                             ],): SizedBox(),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              constraints: BoxConstraints(
                                                  maxWidth: MediaQuery.of(context).size.width * 0.6),
                                              decoration: BoxDecoration(
                                                  color: reportProvider.reportMessages[index]['type']=='Ad-Hoc' ? Colors.pinkAccent : Colors.grey[200],
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(16),
                                                    topRight: Radius.circular(16),
                                                    bottomLeft: Radius.circular(reportProvider.reportMessages[index]['type']=='Ad-Hoc' ? 12 : 0),
                                                    bottomRight: Radius.circular(reportProvider.reportMessages[index]['type']=='Ad-Hoc' ? 0 : 12),
                                                  )),
                                              child: Text(
                                                reportProvider.reportMessages[index]['comment'],
                                                style: MyTheme.bodyTextMessage.copyWith(
                                                    color: reportProvider.reportMessages[index]['type']=='Ad-Hoc' ? Colors.white : Colors.grey[800]),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            reportProvider.reportMessages[index]['type']=='Ad-Hoc' ? MainAxisAlignment.end : MainAxisAlignment.start,
                                            children: [
                                              reportProvider.reportMessages[index]['type']!='admin' ?
                                                SizedBox(
                                                  width: 40,
                                                ):SizedBox(),
//                                          Icon(
//                                            Icons.done_all,
//                                            size: 20,
//                                            color: MyTheme.bodyTextTime.color,
//                                          ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                timeago.format(DateTime.parse(reportProvider.reportMessages[index]['posted']) ),
                                                style: MyTheme.bodyTextTime,
                                              ),
//                                            Text(
//                                              DateTime.parse(reportProvider.reportMessages[index]['posted']).toString(),
//                                              style: MyTheme.bodyTextTime,
//                                            )
                                            ],
                                          ),
                                        ),
//                                  Text(reportProvider.canPostComment.toString()),
//                                      Text(reportProvider.canPostCommentData.toString())
                                      ],

                                    ),
                                  ): Column(children: [Center(child: Text( report['message']!="" ? report['message'] : "No comment found")),
//                                    Text(reportProvider.canPostComment.toString()),
//                                    Text(reportProvider.canPostCommentData.toString())

                                  ],) ;


//                                Container(
////                                height: 50,
////                              color: Colors.amber[colorCodes[index]],
//                                child: Column(children: [
//                                  Text(reportProvider.reportMessages[index]['type'],textAlign: TextAlign.left,),
//                                  Center(child: Text('Entry ${reportProvider.reportMessages[index]['comment']}'))
//                                ],),
//                              );
                                }
                            ),
                          )
                            ,),
                        Expanded(child:Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.emoji_emotions_outlined,
                                        color: Colors.grey[500],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          enabled: reportProvider.canPostComment,
                                          controller: commentController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Type your message ...',
                                            hintStyle: TextStyle(color: Colors.grey[500]),
                                          ),
                                        ),
                                      ),
//                                  Icon(
//                                    Icons.attach_file,
//                                    color: Colors.grey[500],
//                                  )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: ()async{
                                  final position2 = listScrollController.position.maxScrollExtent;
                                  listScrollController.animateTo(
                                    position2,
                                    duration: Duration(seconds: 1),
                                    curve: Curves.easeOut,
                                  );
                                  return commentController.text.isNotEmpty  && reportProvider.canPostComment  ?  await reportProvider.saveLocalMessage(commentController.text,report['user_id']).then((value) async {
                                    if(value['success'])commentController.clear();
                                    await reportProvider.queryAllReportMessages(report['user_id']).then((value) {
                                      updateModalState(() {
                                       print('heya');
                                      });
                                    }


                                    );

                                    
                                  }): null;
                                },
                                child: CircleAvatar(
                                  backgroundColor: reportProvider.canPostComment ? Colors.pinkAccent : Colors.pinkAccent[100],
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ))
                        ],),
                      ),
                    ),
                  ),


                ],),
              )

            ],),
          ),
        );

      },
//     backgroundColor: Colors.black54,
    )
    ;
  }



  @override
  void didChangeDependencies() async{
    // TODO: implement didChangeDependencies
//   Provider.of<ReportProvider>(context,listen: false).fetchReportComments();
    var authUserId= Provider.of<AuthProvider>(context,listen: false).authData.id;
    Provider.of<ReportProvider>(context,listen: false).queryAllReportMessages(authUserId);
    Provider.of<ReportProvider>(context,listen: false).queryAllReportMessagesRecentlyPosted(authUserId);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
//    bottomSheetController.close();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return Consumer<ReportProvider>(
      builder:(context,reportProvider,child)=> Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          reportProvider.report!=null ?  Expanded(
            flex: 2,
            child: Container(
                height: 300,
                width: double.infinity,
                color: siteThemeColor,
                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: Container(
                      padding: EdgeInsets.all(10.0),
                      width:double.infinity,
                      child: Row(
                        crossAxisAlignment:CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        GestureDetector(
                            onTap: (){
                              reportProvider.isSingleReportClicked=false;
                              reportProvider.currentRecord=null;
                              reportProvider.bottomNavigationIndex=0;
                              reportProvider.notifyListeners();
                            },
                            child: Icon(Icons.arrow_back,color: Colors.white,size: 30.0,)),
                          GestureDetector(
                              onTap: ()async=>
                                   await  showModalBottom1(context,reportProvider.report[0],0),
                              child: Icon(Icons.message,color: Colors.white,size: 30.0,))
                      ],),

                    ),),
                   Expanded(flex: 2,
                       child:Column(children: [
                     Text("status",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),
                     Text("${reportProvider.report[0]['status']}",style: TextStyle(color: Colors.white,fontWeight:FontWeight.w800,fontSize: 40.0),),
//                         Text("${reportProvider.report[0]['message']}")
                   ],))
                  ],)),
          ):SizedBox(),
          SizedBox(height: 30.0,),
          reportProvider.report!=null ? Expanded(
              child:Column(children: [
                Text("Location",style: TextStyle(fontWeight: FontWeight.w600),),
                SizedBox(height: 5.0,),
                Divider(),
                SizedBox(height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: SizedBox(),),
                    Icon(Icons.location_on,color: siteThemeColor,),
                    Expanded(
                      flex: 2,
                      child: Column(children: [
                        Text("Longitude:",style: TextStyle(color: Colors.grey[500])),
                        Text("${reportProvider.report[0]['longitude']}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.0))
                      ],),),
                    Expanded(child: SizedBox(),),
                    Icon(Icons.location_on,color: siteThemeColor),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text("Latitude:",style: TextStyle(color: Colors.grey[500])),
                          Text("${reportProvider.report[0]['latitude']}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.0))
                        ],),),
                    Expanded(child: SizedBox(),),
                  ],
                ),
              ],)
          ):SizedBox(),
          Text("Photos",style: TextStyle(fontWeight: FontWeight.w600),),
          SizedBox(height: 10.0,),
          Divider(),
          SizedBox(height: 10.0,),
          reportProvider.report!=null ? Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  reportProvider.report[0]['photo_1'] !=null ?   Expanded(child:Stack(
                    children: [
                      Container(
                        decoration: shadowBox1,
                        child: Image.memory(base64Decode(reportProvider.report[0]['photo_1'])),),
                      Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                                onTap: ()async=> showModalBottom(context,reportProvider.report[0],1),
                                child: Icon(Icons.remove_red_eye,color: Colors.grey[100])),
                          ))
                    ],
                  )):SizedBox(),
                  SizedBox(width: 5.0,),
                  reportProvider.report[0]['photo_2'] !=null ?  Expanded(child:Stack(
                    children: [
                      Container(
                        decoration: shadowBox1,
                        child: Image.memory(base64Decode(reportProvider.report[0]['photo_2'])),),
                      Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                                onTap: ()async=> showModalBottom(context,reportProvider.report[0],2),
                                child: Icon(Icons.remove_red_eye,color: Colors.grey[100])),
                          ))
                    ],
                  )):SizedBox(),
                  SizedBox(width: 5.0,),
                  reportProvider.report[0]['photo_3'] !=null ?  Expanded(child:Stack(
                    children: [
                      Container(
                        decoration: shadowBox1,
                        child: Image.memory(base64Decode(reportProvider.report[0]['photo_3'])),),
                      Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                                onTap: ()async=> showModalBottom(context,reportProvider.report[0],3),
                                child: Icon(Icons.remove_red_eye,color: Colors.grey[100])),
                          ))
                    ],
                  )):SizedBox(),
                  SizedBox(width: 5.0,),
                  reportProvider.report[0]['photo_4'] !=null ?   Expanded(child:Stack(
                    children: [
                      Container(
                        decoration: shadowBox1,
                        child: Image.memory(base64Decode(reportProvider.report[0]['photo_4'])),),
                      Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                                onTap: ()async=> showModalBottom(context,reportProvider.report[0],4),
                                child: Icon(Icons.remove_red_eye,color: Colors.grey[100])),
                          ))
                    ],
                  )):SizedBox(),
                  reportProvider.report[0]['photo_3'] ==null && reportProvider.report[0]['photo_4'] ==null ? Expanded(child: Text("")):SizedBox(),
                  reportProvider.report[0]['photo_3'] ==null && reportProvider.report[0]['photo_4'] ==null ? Expanded(child: Text("")):SizedBox(),
                  reportProvider.report[0]['photo_2'] ==null && reportProvider.report[0]['photo_3'] ==null && reportProvider.report[0]['photo_4'] ==null ? Expanded(child: Text("")):SizedBox(),
                reportProvider.report[0]['photo_4'] ==null ? Expanded(child: Text("")):SizedBox()

                ],),
            ),
          ):SizedBox(),
          SizedBox(height: 5.0,),

        ],),
    );
  }
}


class ReportsToday extends StatefulWidget {
  @override
  _ReportsTodayState createState() => _ReportsTodayState();
}

class _ReportsTodayState extends State<ReportsToday> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    var authUserId= Provider.of<AuthProvider>(context,listen: false).authData.id;
    Provider.of<ReportProvider>(context,listen: false).queryAllRecordsToday(authUserId);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportProvider>(
      builder:(context,reportProvider,child)=> reportProvider.reports.length>0 ?  ListView.builder(
        itemCount: reportProvider.reports.length,
        itemBuilder:(context,index)=> Container(
          padding: EdgeInsets.all(10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child:Stack(
                children: [
                  Container(
                    height: 50,
                    width: 50,
//                    decoration: shadowBox1,
                    child: Image.memory(base64Decode(reportProvider.reports[index]['photo_1'])),),
                ],
              )),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.0,),
                    Text("Submitted:",style: TextStyle(color: Colors.grey[500])),
                    Text(formatDateF(reportProvider.reports[index]['posted'])),
                    SizedBox(height: 2.0,),
                  ],),
              ),
              SizedBox(width: 10.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0,),
                  Text("Status:",style: TextStyle(color: Colors.grey[500])),
                  Text("${reportProvider.reports[index]['status']}"),
                  SizedBox(height: 2.0,),
                ],),
              Expanded(child: GestureDetector(
                  onTap: (){
                    reportProvider.isSingleReportClicked=true;
                    reportProvider.currentRecord=reportProvider.reports[index]['id'];
                    reportProvider.querySingleReport();
                    setState(() {

                    });
                  },
                  child: Icon(Icons.remove_red_eye,
                    color: siteThemeColor,
                  )),)
            ],),
        ),
      ):Center(child: Text("No report(s) found")),
    );
  }
}


class ReportsThisWeek extends StatefulWidget {
  @override
  _ReportsThisWeekState createState() => _ReportsThisWeekState();
}

class _ReportsThisWeekState extends State<ReportsThisWeek> {

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    var authUserId= Provider.of<AuthProvider>(context,listen: false).authData.id;
    Provider.of<ReportProvider>(context,listen: false).queryAllRecordsThisWeek(authUserId);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportProvider>(
      builder:(context,reportProvider,child)=> reportProvider.reports.length>0 ?   ListView.builder(
        itemCount: reportProvider.reports.length,
        itemBuilder:(context,index)=> Container(
          padding: EdgeInsets.all(10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child:Stack(
                children: [
                  Container(
                    height: 50,
                    width: 50,
//                    decoration: shadowBox1,
                    child: Image.memory(base64Decode(reportProvider.reports[index]['photo_1'])),),
                ],
              )),
             Expanded(
               flex: 2,
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                 SizedBox(height: 10.0,),
                 Text("Submitted:",style: TextStyle(color: Colors.grey[500])),
                 Text(formatDateF(reportProvider.reports[index]['posted'])),
                 SizedBox(height: 2.0,),
               ],),
             ),
              SizedBox(width: 10.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0,),
                  Text("Status:",style: TextStyle(color: Colors.grey[500])),
                  Text("${reportProvider.reports[index]['status']}"),
                  SizedBox(height: 2.0,),
                ],),
              Expanded(child: GestureDetector(
                  onTap: (){
                    reportProvider.currentRecord=reportProvider.reports[index]['id'];
                    reportProvider.isSingleReportClicked=true;
                    reportProvider.querySingleReport();
                    setState(() {

                    });
                  },
                  child: Icon(Icons.remove_red_eye,color: siteThemeColor,)),)
          ],),
        ),
      ):Center(child: Text("No report(s) found")),
    );
  }
}


class ReportsThisMonth extends StatefulWidget {
  @override
  _ReportsThisMonthState createState() => _ReportsThisMonthState();
}

class _ReportsThisMonthState extends State<ReportsThisMonth> {

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    var authUserId= Provider.of<AuthProvider>(context,listen: false).authData.id;
    Provider.of<ReportProvider>(context,listen: false).queryAllRecordsThisMonth(authUserId);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportProvider>(
      builder:(context,reportProvider,child)=> reportProvider.reports.length>0 ?   ListView.builder(
        itemCount: reportProvider.reports.length,
        itemBuilder:(context,index)=> Container(
          padding: EdgeInsets.all(10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child:Stack(
                children: [
                  Container(
                    height: 50,
                    width: 50,
//                    decoration: shadowBox1,
                    child: Image.memory(base64Decode(reportProvider.reports[index]['photo_1'])),),
                ],
              )),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.0,),
                    Text("Submitted:",style: TextStyle(color: Colors.grey[500])),
                    Text(formatDateF(reportProvider.reports[index]['posted'])),
                    SizedBox(height: 2.0,),
                  ],),
              ),
              SizedBox(width: 10.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0,),
                  Text("Status:",style: TextStyle(color: Colors.grey[500])),
                  Text("${reportProvider.reports[index]['status']}"),
                  SizedBox(height: 2.0,),
                ],),
              Expanded(child: GestureDetector(
                  onTap: (){
                    reportProvider.currentRecord=reportProvider.reports[index]['id'];
                    reportProvider.isSingleReportClicked=true;
                    reportProvider.querySingleReport();
                    setState(() {

                    });
                  },
                  child: Icon(Icons.remove_red_eye,color: siteThemeColor,)),)
            ],),
        ),
      ):Center(child: Text("No report(s) found")),
    );
  }
}

class ReportsAllTime extends StatefulWidget {
  @override
  _ReportsAllTimeState createState() => _ReportsAllTimeState();
}

class _ReportsAllTimeState extends State<ReportsAllTime> {

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    var authUserId= Provider.of<AuthProvider>(context,listen: false).authData.id;
    Provider.of<ReportProvider>(context,listen: false).queryAllRecordsAllTime(authUserId);
    Provider.of<ReportProvider>(context,listen: false).firstAndLastDayOfMonth();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportProvider>(
      builder:(context,reportProvider,child)=> reportProvider.reports.length>0 ?   ListView.builder(
        itemCount: reportProvider.reports.length,
        itemBuilder:(context,index)=> Container(
          padding: EdgeInsets.all(10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child:Stack(
                children: [
                  Container(
                    height: 50,
                    width: 50,
//                    decoration: shadowBox1,
                    child: Image.memory(base64Decode(reportProvider.reports[index]['photo_1'])),),
                ],
              )),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.0,),
                    Text("Submitted:",style: TextStyle(color: Colors.grey[500])),
                    Text(formatDateF(reportProvider.reports[index]['posted'])),
                    SizedBox(height: 2.0,),
                  ],),
              ),
              SizedBox(width: 10.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0,),
                  Text("Status:",style: TextStyle(color: Colors.grey[500])),
                  Text("${reportProvider.reports[index]['status']}"),
                  SizedBox(height: 2.0,),
                ],),
              Expanded(child: GestureDetector(
                  onTap: (){
                    reportProvider.currentRecord=reportProvider.reports[index]['id'];
                    reportProvider.isSingleReportClicked=true;
                    reportProvider.querySingleReport();
                    setState(() {

                    });
                  },
                  child: Icon(Icons.remove_red_eye,color: siteThemeColor,)),)
            ],),
        ),
      ):Center(child: Text("No report(s) found")),
    );
  }
}


class KeyboardVisibilityBuilder extends StatefulWidget {
  final Widget child;
  final Widget Function(
      BuildContext context,
      Widget child,
      bool isKeyboardVisible,
      ) builder;

  const KeyboardVisibilityBuilder({
    Key key,
    this.child,
    @required this.builder,
  }) : super(key: key);

  @override
  _KeyboardVisibilityBuilderState createState() => _KeyboardVisibilityBuilderState();
}

class _KeyboardVisibilityBuilderState extends State<KeyboardVisibilityBuilder>
    with WidgetsBindingObserver {
  var _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
    }
  }




  @override
  Widget build(BuildContext context) => widget.builder(
    context,
    widget.child,
    _isKeyboardVisible,
  );
}



class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  TextEditingController commentController =TextEditingController();
  ScrollController contactScrollController = ScrollController();


  showModalBottom(BuildContext context) async {

    bool messageSent=false;
    bool startedTyping=false;
    commentController.clear();


    return Scaffold.of(context).showBottomSheet(
          (BuildContext context){
        return SingleChildScrollView(
//          reverse: true,
        controller: contactScrollController,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter updateModalState /*You can rename this!*/){
              Future.delayed(const Duration(milliseconds: 500), () {

                if (contactScrollController.hasClients) {
                  final position = contactScrollController.position.maxScrollExtent;
                  contactScrollController.animateTo(
                    position,
                    duration: Duration(seconds: 1),
                    curve: Curves.easeOut,
                  );
                  //print('has children');
                  setState(() {});
                }

              });
              return Container(
                decoration: BoxDecoration(
//            borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight:Radius.circular(25.0) ),
                  color:Colors.black54,
                ),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  child: Consumer<AuthProvider>(
                    builder:(context,authProvider,child)=> Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded( child: SizedBox(),),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight:Radius.circular(25.0) ),
                                    color: Colors.white,
                                  ),
                                  height: 500,
                                  width: double.infinity,
//                  child: Center(child: Text(report['message']!="" ? report['message'] : "No comment found.")),
                                  child: Consumer<ReportProvider>(
                                    builder:
                                        (context,reportProvider,child)=> !messageSent ? Column(children: [
                                      Center(
                                        child: CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.pinkAccent,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.cancel_sharp,
                                              color: Colors.white,
                                              size: 25.0,
                                            ),
                                            onPressed:()=>Navigator.of(context).pop(),
                                          ),
                                        ),
                                      ),
                                      Text("Contact Us",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                                      SizedBox(height: 20.0),
                                      Text("How may we serve you today?"),
                                      Expanded(child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(children: [
                                          TextFormField(
                                            onChanged: (value) => updateModalState((){
                                              startedTyping=true;
                                            }),
                                            controller:commentController,
                                            keyboardType: TextInputType.multiline,
                                            maxLines: 6,
                                            //initialValue: 'braimahjake@gmail.com',
                                            //decoration: Styles.flatFormFields.copyWith(labelText: 'EMAIL',focusColor: Colors.pink),
                                            // The validator receives the text that the user has entered.
                                            decoration: InputDecoration(labelText: '',focusColor: Colors.pink,contentPadding:EdgeInsets.fromLTRB(11, 0, 0, 0)),
                                            validator: (value) {
//                                 firstNameController.text = value.trim();
                                              return Validate.requiredField(value, 'Required field');
                                            },
                                          ),
                                       Padding(
                                         padding: const EdgeInsets.all(8.0),
                                         child:startedTyping ?  Text(commentController.text.isEmpty ? "Required field" : "",style: TextStyle(color: Colors.pinkAccent),) : SizedBox(),
                                       ),
                                        ],),
                                      )),

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          color: !authProvider.sendingMessage && commentController.text.isNotEmpty ?  siteThemeColor:Colors.grey ,
                                          disabledColor: Colors.grey,
                                          onPressed:()async => commentController.text!="" && !authProvider.sendingMessage ? authProvider.informationChange(commentController.text, authProvider.authData.id).then((sent) => updateModalState((){
                                            commentController.clear();
                                            if(sent['success']){messageSent=true;}

                                          })):print('empty ere'),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              //color: Colors.green,
                                            ),
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                                            child: Text(
                                              !authProvider.sendingMessage ?  'Submit' : 'Submitting...'
                                              , style: TextStyle(color: Colors.white,),),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5.0,)
//                             Expanded(child: Center(child: Text("Hi there"),),)
                                    ],):Column(children: [
                                      Center(
                                        child: CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.pinkAccent,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.cancel_sharp,
                                              color: Colors.white,
                                              size: 25.0,
                                            ),
                                            onPressed:()=>Navigator.of(context).pop(),
                                          ),
                                        ),
                                      ),
                                      Expanded(child:Column(children: [
                                        Icon(Icons.check_box,size:200, color: siteThemeColor,),
                                        Text('Your message was successfully sent.')
                                      ],))
                                    ],),
                                  ),
                                ),
                              ),


                            ],),
                        )

                      ],),
                  ),
                ),
              );
            } ,
          ),
        );

      },
      backgroundColor: Colors.black54,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Consumer<AuthProvider>(
        builder:(context,authProvider,child)=> Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          Expanded(
            flex: 3,
            child:Container(
            width: double.infinity,
            color: siteThemeColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                Expanded(child: ProfileAvatar()),

              ],),
            ),
            ) ,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  decoration: shadowBox1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      Icon(Icons.perm_identity),
                      SizedBox(width: 5.0,),
                      Text("${authProvider.authData.name}")
                    ],),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                decoration: shadowBox1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Icon(Icons.phone),
                    SizedBox(width: 5.0,),
                    Text("${authProvider.authData.phone}")
                  ],),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                decoration: shadowBox1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Icon(Icons.email),
                    SizedBox(width: 5.0,),
                    Text("${authProvider.authData.email}"),

                  ],),
                ),
              ),
            ),
          ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                color:  siteThemeColor,
                disabledColor: Colors.grey,
                onPressed:()async =>  showModalBottom(context),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    //color: Colors.green,
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                  child: Text(
                    'Request Information Change'
                    , style: TextStyle(color: Colors.white,),),
                ),
              ),
            ),
            Expanded(child: SizedBox(),),
//            Expanded(child: SizedBox(),)
        ],),
      ),
    );
  }
}


class ProfileAvatar extends StatefulWidget {
  @override
  _ProfileAvatarState createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  File _image;
  final picker = ImagePicker();
  String uploadComplete="";

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        String base64Image = base64Encode(_image.readAsBytesSync());
        var userId=Provider.of<AuthProvider>(context,listen: false).authData.id;
        Provider.of<AuthProvider>(context,listen: false).uploadProfileImage(base64Image, userId).then((uploaded) {
          print (uploaded['photo']);
          if(uploaded['success']){
            setState(() {
              uploadComplete="Upload Successful";
            });
            Future.delayed(const Duration(milliseconds: 2000), () {
            setState(() {
              uploadComplete="";
            });
            });

          }else{
            setState(() {
              uploadComplete="Error: Check network and try again!";
            });
            Future.delayed(const Duration(milliseconds: 2000), () {
              setState(() {
                uploadComplete="";
              });
            });
          }
        });

      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    Provider.of<AuthProvider>(context,listen: false).getToken();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder:(context,authProvider,child)=> Column(children: [
        Expanded(child: SizedBox(),),
        Expanded(child: SizedBox(),),
        Container(child: Container(
            height: 150,
            width: 150,
            child:  Stack(
              children: <Widget>[
                Center(
                  child: _image == null && authProvider.authData.photo==""
                      ? CircleAvatar( child: Text('Please select image',style: TextStyle(color: Colors.black,fontSize: 13.0),), backgroundColor: Colors.grey[200], radius: MediaQuery.of(context).size.width/3,)
                      : _image!=null ?  new CircleAvatar(backgroundColor: Colors.green, backgroundImage: new FileImage(_image), radius: MediaQuery.of(context).size.width/3,) :authProvider.authData.photo!="" ?

    CachedNetworkImage(
    imageUrl: "$hostUrl/uploads/avatar/${authProvider.authData.photo}",
    placeholder: (context, url) => CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.person,size: 100,), radius: 80,),
    errorWidget: (context, url, error) => CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.person,size: 100,), radius: 80,),
    imageBuilder: (context, imageProvider) => CircleAvatar(
    radius: 80,
    backgroundImage: imageProvider,
    ),
    )
                  :SizedBox() ,
                ),
                Align(
                  alignment:Alignment.topRight,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.green,
                    child: IconButton(
                      icon: Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                      ),
                      onPressed:  getImage,
                    ),
                  ),

                ) ,

              ],
            ))),
        SizedBox(height: 5.0,),
        Expanded(child: authProvider.uploadingImage  ? Text('Uploading...',style:TextStyle(color: Colors.white)): SizedBox(),),
        Expanded(child: uploadComplete!="" && !authProvider.uploadingImage  ? Text(uploadComplete,style:TextStyle(color: Colors.white)): SizedBox(),),
      ],),
    );
  }
}



class SignOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Consumer<AuthProvider>(
          builder:(context,authProvider,child)=> Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text("Sign out of your current session.",style: TextStyle(color:Colors.grey[500]),),
            SizedBox(height: 15.0,),
            RaisedButton(
              color:  Colors.redAccent,
              disabledColor: Colors.grey,
              onPressed:()async => await authProvider.logout(),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  //color: Colors.green,
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                child: Text(
                  'Sign Out'
                  , style: TextStyle(color: Colors.white,),),
              ),
            )
          ],),
        )
      ],),
    );
  }
}

String  formatDateF(dateObj){
  String dateOBDCommand = dateObj;
  DateTime date = DateTime.parse(dateOBDCommand);
  String result = DateFormat('yyyy-MM-dd H:m:s').format(date);
  return result;
}


//
//class ReportsThisWeek  extends StatefulWidget {
//  @override
//  _ReportsThisWeek State createState() => _ReportsThisWeek State();
//}
//
//class _ReportsThisWeek State extends State<ReportsThisWeek > {
//  @override
//
//  Widget build(BuildContext context) {
//    return ListView.builder(
//      itemCount: 50,
//      itemBuilder:(context,index)=> new Text("Tab 1"),
//    );
//  }
//}



