import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lac/models/report_data.dart';
import 'package:provider/provider.dart';
import 'package:lac/providers/report.dart';
import 'package:lac/providers/auth.dart';
import 'package:lac/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:lac/models/my_state.dart';
import 'package:lac/components/drawer.dart';
import 'package:lac/components/auth_modal.dart';
import 'package:lac/utils/validate.dart';
import 'package:lac/models/report_data.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:lac/views/report_single_edit.dart';


class ReportSingle extends StatefulWidget {

  final ReportData report;
  ReportSingle({this.report});

  @override
  _ReportSingleState createState() => _ReportSingleState();
}

class _ReportSingleState extends State<ReportSingle> {


  showLoginModal(BuildContext context){

    final _formKey = GlobalKey<FormState>();


    //var _formKeyValid = _formKey.currentState;
    /*controllers*/
//    TextEditingController emailController =TextEditingController(text:'braimahjake@gmail.com');
//    TextEditingController passwordController =TextEditingController(text: '1234567');

    TextEditingController emailController =TextEditingController();
    TextEditingController passwordController =TextEditingController();

    /*auth loading indicator*/
    bool apiCall=false;

    /*auth loading indicator*/
    bool showError=false;

    double heightOfModalBottomSheet= 400.0;

    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            padding: MediaQuery.of(context).viewInsets,
            color: null,
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight: Radius.circular(25.0))
              ),
              //height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    key: _formKey,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Please sign in to continue",style: TextStyle(color: siteThemeColor),),
                              SizedBox(height: 30,),
                              SizedBox(height: 25.0,),
                              Text("Sign In",style: TextStyle(color: siteThemeColor,fontSize: 30.0),),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(labelText: 'Email',
                                  labelStyle: TextStyle(color: Colors.black54),
                                  fillColor: Colors.white,
                                  focusColor: Colors.red,
                                  contentPadding:EdgeInsets.fromLTRB(11, 0, 0, 0),
                                  focusedBorder:OutlineInputBorder(
                                    //borderSide: const BorderSide(color: Colors.red, width: 2.0),
                                    //borderRadius: BorderRadius.horizontal(Radi),
                                  ),),
                                //initialValue: 'braimahjake@gmail.com',
                                //decoration: Styles.flatFormFields.copyWith(labelText: 'EMAIL',focusColor: Colors.pink),
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  emailController.text = value.trim();
                                  return Validate.validateEmail(value);
                                },
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                  controller: passwordController,
                                  decoration: InputDecoration(labelText: 'Password',
                                    labelStyle: TextStyle(color: Colors.black54),
                                    fillColor: Colors.white,
                                    focusColor: Colors.red,
                                    contentPadding:EdgeInsets.fromLTRB(11, 0, 0, 0),
                                    focusedBorder:OutlineInputBorder(
                                      //borderSide: const BorderSide(color: Colors.red, width: 2.0),
                                      //borderRadius: BorderRadius.horizontal(Radi),
                                    ),),
                                  //initialValue: '123456',
                                  obscureText: true,
                                  //decoration: Styles.flatFormFields.copyWith(labelText: 'PASSWORD',focusColor: Colors.pink),
                                  validator: (value) {
                                    passwordController.text = value.trim();
                                    return Validate.requiredField(value, 'Password is required.');
                                  }

                              ),
                              SizedBox(height: 20.0),
                              Builder(
                                builder: (context) => Consumer<AuthProvider>(
                                  builder:(context,child,user)=>
                                      Consumer<ReportProvider>(
                                        builder:(context,data,user)=> RaisedButton(
                                          color: siteThemeColor,
                                          disabledColor: Colors.grey,
                                          onPressed: !apiCall ? ()async{
                                            if(_formKey.currentState.validate()){
                                              var submit;
                                              print('submiting');
                                              Provider.of<AuthProvider>(context,listen: false).authModalLoading  ? null : submit = await Provider.of<AuthProvider>(context,listen: false).login(emailController.text, passwordController.text);
                                              if(submit) {
                                                Navigator.pop(context);
                                                apiCall = !apiCall;
                                                data.auth=true;
                                                data.fetchReportSingle(widget.report.id.toString());


                                              }
                                            }else{

                                            }





                                          } :null,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              //color: Colors.green,
                                            ),
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                                            child: Text(
                                              !Provider.of<AuthProvider>(context,listen: false).authModalLoading ?'Sign In':'Authenticating....'
                                              , style: TextStyle(color: Colors.white,),),
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                              Consumer<AuthProvider>(builder: (context,data,child){
                                return data.authModalMessage.isNotEmpty ? Text("Invalid Username or Password",style: TextStyle(color: siteThemeColor,)) : SizedBox();
                              }),

                              SizedBox(height: 25.0,),
                              // Add TextFormFields and RaisedButton here.
                            ]
                        ),
                      ),
                    )
                ),
              ),
            ),
          );
        });



  }


  @override
  void initState() {
    Provider.of<ReportProvider>(context,listen: false).report=null;
    WidgetsBinding.instance
        .addPostFrameCallback((_)async {
      await Provider.of<ReportProvider>(context,listen: false).fetchReportSingle(widget.report.id.toString()).then((value){
        Provider.of<AuthProvider>(context,listen: false).authModalMessage="";
        print(checkUserLogin());
        //Future.delayed(Duration(seconds: 6),()=>!checkUserLogin() ? showLoginModal(context):null);
        if(!checkUserLogin()) showLoginModal(context);
      });

    });

    // TODO: implement initState
    super.initState();
  }

  checkUserLogin(){
    //print(Provider.of<ReportProvider>(context,listen: false).auth);
    return Provider.of<ReportProvider>(context,listen: false).auth;
  }

  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        appBar: AppBar(
          title: Text('Report',style: TextStyle(color: siteThemeColor),),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: siteThemeColor),
          actions: [

            Consumer<ReportProvider>(
              builder:(context,data,child)=> GestureDetector(
                  onTap: ()=> setState(() {
                    print(data.showReportMedia);
                    data.showReportMedia=!data.showReportMedia;
                  }),
                  child:Container(
                      padding:EdgeInsets.symmetric(horizontal: 15.0,vertical: 5.0),
                      margin:EdgeInsets.all(3.0),

                      decoration:siteIconEffectGrey,
                      child: Icon(Icons.add_a_photo,color: siteThemeColor))),
            ),
            SizedBox(width: 5.0,),
            Consumer<ReportProvider>(
              builder:(context,data,child)=> GestureDetector(
                  onTap: ()=> Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => EditReport(report: widget.report)),
                  ),
                  child:Container(
                      padding:EdgeInsets.symmetric(horizontal: 15.0,vertical: 5.0),
                      margin:EdgeInsets.all(3.0),
                      decoration:siteIconEffectGrey,
                      child: Icon(Icons.edit,color: siteThemeColor,))),
            ),
            SizedBox(width: 20.0,)
          ],

        ),
        drawer: MyDrawer(context:context),
        //key: login,
        backgroundColor: siteThemeColor,
        body: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              //borderRadius: BorderRadius.only(topLeft: Radius.circular(150.0),bottomRight: Radius.circular(70.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Consumer<ReportProvider>(
                builder:(context,data,child)=> Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  data.report!=null ?  !data.showReportMedia? ReportItem(reportData: widget.report):
                    UploadPassport(reportData: widget.report):Center(child: Text('Loading report....'))
                  ],
                ),
              ),
            )
        ),
      ),
    );




  }


}


class ReportItem extends StatelessWidget {
  final ReportData reportData;
  ReportItem({this.reportData});


  @override
  Widget build(BuildContext context) {
    return  Expanded(
      flex: 6,
      child: Container(
        width: double.infinity,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10,),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:  ListView(
                    children: <Widget>[
                      Row(crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(child: Consumer<ReportProvider>(
                            builder:(context,data,child)=> Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              //mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                ProfileCard(header: 'First Name',body: data.report.firstName,),
                                ProfileCard(header: 'Last Name',body: data.report.lastName,),
                                ProfileCard(header: 'Gender',body: data.report.gender,),
                                ProfileCard(header: 'Age',body: data.report.age.toString()),
                                ProfileCard(header: 'Occupation',body: data.report.occupation),
                                ProfileCard(header: 'Granted',body: data.report.granted),
                                ProfileCard(header: 'Case Type',body: data.report.caseType),
                                data.report.caseType == "Criminal" ? ProfileCard(header: 'Offence',body: data.report.offence)
                                : ProfileCard(header: 'Complaints',body: data.report.complaints),
//                                ProfileCard(header: 'Location',body: data.report.location['name']),
                                ProfileCard(header: 'Bail Status',body: data.report.bailStatus),
                                ProfileCard(header: 'Outcome',body: data.report.outcome),


                              ],
                            ),
                          ),)

                        ],
                      ),


                    ],
                  )
                ),
              ),





          ],
        ),),
    );
  }
}


class ProfileCard extends StatelessWidget {

  final String header;
  final String body;


  ProfileCard({this.header,this.body});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width:double.infinity,
      padding: const EdgeInsets.symmetric( horizontal: 25.0,vertical: 8.0),
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('$header',style: TextStyle(fontSize: 18.0,color: siteThemeColor),),
          Text('$body',),
          Divider()
        ],
      ),
    );
  }
}


enum UploadStatusOne {Uploading,BeforeUpload,AfterUpload,Uploaded}
enum UploadStatusTwo {Uploading,BeforeUpload,AfterUpload,Uploaded}

UploadStatusOne _statusOne =UploadStatusOne.BeforeUpload;
UploadStatusTwo _statusTwo =UploadStatusTwo.BeforeUpload;


class UploadPassport extends StatefulWidget {
  static final id = 'image_upload';

  final ReportData reportData;
  UploadPassport({this.reportData});


  @override
  _UploadPassportState createState() => _UploadPassportState();
}

class _UploadPassportState extends State<UploadPassport> {

  File fileOne;
  File fileTwo;

//  enum UploadStatusOne {Uploading,BeforeUpload,AfterUpload,Uploaded}
//  enum UploadStatusTwo {Uploading,BeforeUpload,AfterUpload,Uploaded}
//


  bool apiCallOne=false;

  bool apiCallTwo=false;

  bool uploadMode=false;

//  bool uploadOneSuccess;
//
//  bool uploadTwoSuccess;


  final picker = ImagePicker();


  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }



  showDeleteModal(BuildContext context,String imageId, String reportId){

    final _formKey = GlobalKey<FormState>();


    /*auth loading indicator*/
    bool apiCall=false;

    /*auth loading indicator*/
    bool showError=false;

    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,builder: (context){
      return Container(
        color: null,
        height: 300,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight: Radius.circular(25.0))
          ),
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                key: _formKey,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 30,),
                          SizedBox(height: 25.0,),
                          Text("Are you sure?",style: TextStyle(color: siteThemeColor,fontSize: 30.0),),
                          Text("You are about to delete the selected image",style: TextStyle(color: siteThemeColor,fontSize: 13.0),),
                           SizedBox(height: 50,),
                          Center(
                            child: Consumer<ReportProvider>(
                              builder:(context,data,child)=>

                                  !data.apiCallModal ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                RaisedButton(
                                    onPressed: ()async{
                                   var delete=  await Provider.of<ReportProvider>(context,listen: false).deleteReportImage(imageId: imageId, reportId: reportId);

                                   if(delete['success']){
                                     Navigator.pop(context);
                                     Provider.of<ReportProvider>(context, listen: false).fetchReportSingle(reportId);

                                   }else{
                                     Navigator.pop(context);
                                   }


                                    },
                                    color: siteThemeColor,
                                    child: Text('Yes',style: TextStyle(color: Colors.white),)

                                ),SizedBox(width: 50,),
                                  RaisedButton(
                                    onPressed: ()=>Navigator.pop(context),
                                    color: siteThemeColor,
                                    child:   Text('No',style: TextStyle(color: Colors.white),)

                                )
                              ],):RaisedButton(
                                      color: siteThemeColor,
                                      child: Text('Deleting...',style: TextStyle( color: Colors.white, fontSize: 20.0),)

                                  ),
                            ),
                          ),

//                          Consumer<AuthProvider>(builder: (context,data,child){
//                            return data.authModalMessage.isNotEmpty ? Text("Invalid Username or Password",style: TextStyle(color: siteThemeColor,)) : SizedBox();
//                          }),

                          SizedBox(height: 25.0,),
                          // Add TextFormFields and RaisedButton here.
                        ]
                    ),
                  ),
                )
            ),
          ),
        ),
      );
    }

    );
  }

  void _chooseOne() async {
    //_userProvider.changeString('wahala');
    final pickedFile  = await picker.getImage(source: ImageSource.gallery,maxHeight: 300.0,
        maxWidth: 250.0,imageQuality: 100);
    setState(() {
      if (pickedFile != null) {
        fileOne = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }



  void _chooseTwo() async {
    //_userProvider.changeString('wahala');
    final pickedFile  = await picker.getImage(source: ImageSource.gallery,maxHeight: 300.0,
        maxWidth: 250.0,imageQuality: 100);
    setState(() {
      if (pickedFile != null) {
        fileTwo = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadOne() async{
    if (fileOne == null) return;

    setState(() {
      apiCallOne=true;
    });

    String base64Image = base64Encode(fileOne.readAsBytesSync());
    String fileName = fileOne.path.split("/").last;

    var  response = await  Provider.of<ReportProvider>(context, listen: false).uploadReportImage(image:base64Image,imageId:"1",reportId: widget.reportData.id.toString());

    if(response['success']){
      fileOne =null;
      Provider.of<ReportProvider>(context, listen: false).fetchReportSingle(widget.reportData.id.toString()).then((value) => setState(() {apiCallOne=false;}));

    }else{
      setState(() {
        apiCallOne=false;
      });
    }



  }


  Future<void> _uploadTwo()  async{
    if (fileTwo == null) return;

    setState(() {
      apiCallTwo=true;
    });

    String base64Image = base64Encode(fileTwo.readAsBytesSync());
    String fileName = fileTwo.path.split("/").last;


    var  response = await  Provider.of<ReportProvider>(context, listen: false).uploadReportImage(image:base64Image,imageId:"2",reportId: widget.reportData.id.toString());

    if(response['success']){
      fileTwo =null;
      Provider.of<ReportProvider>(context, listen: false).fetchReportSingle(widget.reportData.id.toString()).then((value) => setState(() {apiCallTwo=false;}));

    }else{
      setState(() {
        apiCallTwo=false;
      });
    }

  }



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    //initAuthProvider(context);
    //showLoginModal(context);

    return  Expanded(
      child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    Text('Upload Photos',style: TextStyle(color: siteIconThemeDark,fontSize: 20.0),),
                      SizedBox(height: 10.0,),
                      Text('You can upload two images alongside your report',style: TextStyle(color: siteIconThemeDark,fontSize: 14.0),textAlign: TextAlign.center,),
                  ],)
                ),
//                  Expanded(
//                    flex: 1,
//                    child:  Center(
//                      child: Container(
//                        color: siteThemeColor,
//                        child: Text('Upload Passport',style: TextStyle(color: Colors.white,fontSize: 20.0),),
//                      ),
//                    ),
//                  ),
                Expanded(
                  flex: 2,
                  child: Row(children: [
                  Expanded(
                    //flex: 7,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        //color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)/*,topRight: Radius.circular(75.0)*/),
                      ),
                      child: Consumer<ReportProvider>(
                        builder:(context,data,child)=> Column(
                          children: <Widget>[
                            SizedBox(height: 5.0,),
                            SizedBox(height: 20.0,),
                            Stack(
                              children: <Widget>[
                                Center(
                                  child: data.report.photoOne!=null ?
                                  new CircleAvatar(backgroundColor: Colors.grey[100], backgroundImage: new NetworkImage(data.report.photoOne), radius: MediaQuery.of(context).size.width/6,):
                                  fileOne ==null ?
                                  CircleAvatar( child: Text('PLease select image',style: TextStyle(color: Colors.black,fontSize: 11),), backgroundColor: Colors.grey[200], radius: MediaQuery.of(context).size.width/6,):
                                  new CircleAvatar(backgroundColor: Colors.grey[100], backgroundImage: new FileImage(fileOne), radius: MediaQuery.of(context).size.width/6,),
//                                 child:  data.report.photoOne!=null ?
//                                 new CircleAvatar(backgroundColor: siteThemeColor, backgroundImage: new NetworkImage(data.report.photoOne), radius: MediaQuery.of(context).size.width/6,): new CircleAvatar(backgroundColor: siteThemeColor, backgroundImage: new FileImage(fileOne), radius: MediaQuery.of(context).size.width/6,)
                            ),
                                !apiCallOne ?  Positioned(
                                  left: 90.0,
                                  top: 1,
                                  //alignment:Alignment(0.4, 1),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: siteThemeColor,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.add_a_photo,
                                        color: Colors.white,
                                      ),
                                      onPressed:  _chooseOne,
                                    ),
                                  ),

                                ) : SizedBox(),

                                data.report.photoOne!=null ? Positioned(
                                  left: 90.0,
                                  top: 1,
                                  //alignment:Alignment(0.4, 1),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: siteThemeColor,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.cancel_sharp,
                                        color: Colors.white,
                                      ),
                                      onPressed:()=>showDeleteModal(context,"1",data.report.id.toString()),
                                    ),
                                  ),

                                ) : SizedBox(),

                              ],
                            ),
                            SizedBox(height: 20.0,),
                            data.report.photoOne==null ? RaisedButton(
                              onPressed: _uploadOne,
                              color: siteThemeColor,
                              child: !apiCallOne ?  Text('Upload Image',style: TextStyle(color: Colors.white),) :
                               Text('Uploading...',style: TextStyle( color: Colors.white, fontSize: 20.0),) ,

                            ):SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    //flex: 7,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)/*,topRight: Radius.circular(75.0)*/),
                      ),
                      child: Consumer<ReportProvider>(
                        builder:(context,data,child)=> Column(
                          children: <Widget>[
                            SizedBox(height: 15.0,),
                            SizedBox(height: 20.0,),
                            Stack(
                              children: <Widget>[
                                Center(
                                    child:  data.report.photoTwo!=null ?
                                    new CircleAvatar(backgroundColor: Colors.grey[100], backgroundImage: new NetworkImage(data.report.photoTwo), radius: MediaQuery.of(context).size.width/6,):
                                    fileTwo ==null ?
                                    CircleAvatar( child: Text('PLease select image',style: TextStyle(color: Colors.black,fontSize: 11),), backgroundColor: Colors.grey[200], radius: MediaQuery.of(context).size.width/6,):
                                    new CircleAvatar(backgroundColor: Colors.grey[100], backgroundImage: new FileImage(fileTwo), radius: MediaQuery.of(context).size.width/6,),

                                ),
                                !apiCallTwo ?  Positioned(
                                  left: 90.0,
                                  top: 1,
                                  //alignment:Alignment(0.4, 1),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: siteThemeColor,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.add_a_photo,
                                        color: Colors.white,
                                      ),
                                      onPressed:  _chooseTwo,
                                    ),
                                  ),

                                ) : SizedBox(),

                                data.report.photoTwo!=null ? Positioned(
                                  left: 90.0,
                                  top: 1,
                                  //alignment:Alignment(0.4, 1),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: siteThemeColor,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.cancel_sharp,
                                        color: Colors.white,
                                      ),
                                      onPressed:  ()=>showDeleteModal(context,"2",data.report.id.toString()),
                                    ),
                                  ),

                                ) : SizedBox(),

                              ],
                            ),
                            SizedBox(height: 20.0,),
                            data.report.photoTwo==null ? RaisedButton(
                              onPressed: _uploadTwo,
                              color: siteThemeColor,
                              child:  !apiCallTwo ?  Text('Upload Image',style: TextStyle(color: Colors.white),) :
                               Text('Uploading...',style: TextStyle( color: Colors.white, fontSize: 20.0),)

                            ):SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  )
                ],),)

              ],

            ),
    );




    //);
  }
}