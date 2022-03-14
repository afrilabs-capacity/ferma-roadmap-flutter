import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:roadmap/providers/auth.dart';
//import 'package:lac/views/password_forget_form.dart';
//import 'package:lac/views/forgot_password.dart';
import 'package:provider/provider.dart';
import 'package:roadmap/utils/constants.dart';
import 'package:roadmap/utils/validate.dart';
import 'package:roadmap/views/onboarding_landing.dart';
//import 'package:lac/views/home.dart';
//import 'package:lac/views/register.dart';
//import 'package:lac/views/news.dart';
//import 'package:lac/views/feedback.dart';



// Define a custom Form widget.
class Login extends StatefulWidget {

  static final String id="login";

  GlobalKey loginKey= GlobalKey();


  @override
  LoginState createState() {
    return LoginState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class LoginState extends State<Login> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController =TextEditingController();
  TextEditingController passwordController =TextEditingController();


  String message = '';
  bool loading=false;
  bool modalWindowOpen=false;
  Duration snackBarDurationOpen= Duration(days: 1);
  Duration snackBarDurationClose= Duration(microseconds: 1);


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
                    Text('Authenticating...')
                  ],
                )

            ),
          ),
        );

      },
      backgroundColor: Colors.black54,
    );
  }

  showModalBottomDismiss(BuildContext context){
    showModalBottomSheet(context: context,builder: (context){
      return Center(child: Text('Invalid username or password'));

    });
  }

  Future<void> submit(BuildContext context,String submitType) async {
    //show persistent bottomSheetModal
    PersistentBottomSheetController bottomSheetController;
    final form = _formKey.currentState;
    if (form.validate()) {
      bottomSheetController =await showModalBottom(context);
      var login;

      login= await Provider.of<AuthProvider>(context,listen: false).login(emailController.text, passwordController.text);

      if(login){
        bottomSheetController.close();
        modalWindowOpen=!modalWindowOpen;
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => OnboardingLanding()));
//        return;
      }else{
        //print('hi there');
        final snackBar = new SnackBar(
            content: new Text('Invalid Phone number or Password'),
            //duration: snackBarDurationOpen,
            duration: Duration(milliseconds: 4000),
            backgroundColor: Colors.black);


        Future.delayed(Duration(milliseconds: 5000),(){
          bottomSheetController.close();
          modalWindowOpen=false;
          Scaffold.of(context).showSnackBar(snackBar);
          setState(() {
          });
        });

      }

    }

  }

//  @override
//  void initState() {
//    // TODO: implement initState
//    //testApi();
//    super.initState();
//  }


//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//
//  }


  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above
    return WillPopScope(
      onWillPop: () async =>  modalWindowOpen ?  false : true,
      child: SafeArea(
        child: Scaffold(
          //key: login,
//          resizeToAvoidBottomPadding: true,
          backgroundColor: Colors.white,
          body: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(200.0),bottomRight: Radius.circular(200.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                  key: _formKey,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: <Widget>[
//                            Divider(),
////                            QuickMenu(),
                              Image.asset('assets/ferma.png'),
                              Divider(),
                              Text("Please sign in to continue",style: TextStyle(color: siteThemeColor),),
                              SizedBox(height: 30,),
                              SizedBox(height: 25.0,),
                              Container(
                                  padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0,bottom: 10.0),
                                  decoration:siteIconEffectGrey.copyWith(color: Colors.grey[50]),
                                  child: Text("Sign In",style: TextStyle(color: siteThemeColor,fontSize: 20.0),)),
                              SizedBox(height:45.0),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.number,
                              //initialValue: 'braimahjake@gmail.com',
                              //decoration: Styles.flatFormFields.copyWith(labelText: 'EMAIL',focusColor: Colors.pink),
                              // The validator receives the text that the user has entered.
                              decoration: InputDecoration(labelText: 'Phone Number',
                                labelStyle: TextStyle(color: Colors.black54),
                                fillColor: Colors.white,
                                focusColor: Colors.red,
                                contentPadding:EdgeInsets.fromLTRB(11, 0, 0, 0),
                                focusedBorder:OutlineInputBorder(
                                  //borderSide: const BorderSide(color: Colors.red, width: 2.0),
                                  //borderRadius: BorderRadius.horizontal(Radi),
                                ),),
                              validator: (value) {
                                emailController.text = value.trim();
                                return Validate.validatePhone(value,"Phone required");
                              },
                            ),
                            SizedBox(height: 10,),
                            TextFormField(
                                controller: passwordController,
                                keyboardType: TextInputType.number,
                                maxLength: 4,
                                //initialValue: '123456',
                                decoration: InputDecoration(labelText: 'Password',
                                  labelStyle: TextStyle(color: Colors.black54),
                                  fillColor: Colors.white,
                                  focusColor: Colors.red,
                                  contentPadding:EdgeInsets.fromLTRB(11, 0, 0, 0),
                                  focusedBorder:OutlineInputBorder(
//                                    borderSide: const BorderSide(color: Colors.red, width: 2.0),
                                    //borderRadius: BorderRadius.horizontal(Radi),
                                  ),),
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
                                      RaisedButton(
                                        color: siteThemeColor,
                                        disabledColor: Colors.grey,
                                        onPressed: !modalWindowOpen ? ()=>submit(context,'student') : null,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            //color: Colors.green,
                                          ),
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                                          child: Text(
                                            'Sign In'
                                            , style: TextStyle(color: Colors.white,),),
                                        ),
                                      ),
                                ),
                              ),

                            Center(
//                              child: Column(
//                                children: [
//                                  RichText(
//                                    text: TextSpan(
//                                      children: [
//                                        TextSpan(
//                                          text: "Don't have an account? ",
//                                          style: TextStyle(color: Colors.black),
//                                        ),
//                                        TextSpan(
//                                            text: 'Register',
//                                            style: TextStyle(color: siteThemeColor),
//                                            //style: Styles.p.copyWith(color: Colors.green[500]),
//                                            recognizer: TapGestureRecognizer()
//                                              ..onTap = () => Navigator.push(context,CupertinoPageRoute(builder: (context) => null),)
//                                        ),
//                                        TextSpan(
//                                          text: ' or',
//                                          style: TextStyle(color: Colors.black),
//                                          //style: Styles.p.copyWith(color: Colors.green[500]),
//                                        ),
//                                      ],
//                                    ),
//                                  ),
//                                  SizedBox(height: 8.0,),
//                                  RichText(
//                                    text: TextSpan(
//                                      children: [
//                                        TextSpan(
//                                          text: "forgot password? ",
//                                          style: TextStyle(color: siteThemeColor),
//                                          recognizer: TapGestureRecognizer()
//                                            ..onTap = () =>
//                                                Navigator.push(context,CupertinoPageRoute(builder: (context) => null),)
//                                          ,
//                                        ),
//
//                                      ],
//                                    ),
//                                  )
//                                  ,],
//                              ),
                            ),


                            // Add TextFormFields and RaisedButton here.
                          ]
                      ),
                    ),
                  )
              ),
            ),
          ),
        ),
      ),
    );
//passwordController.dispose();

  }




}


//
//class QuickMenu extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      padding: EdgeInsets.symmetric(vertical: 15),
//      decoration: BoxDecoration(
//        //color: Colors.white,
////                                  boxShadow: [
////                                    BoxShadow(
////                                      color: Colors.black26,
////                                      blurRadius: 1.0, // soften the shadow
////                                      spreadRadius: 1.0, //extend the shadow
////                                      offset: Offset(
////                                        0.0, // Move to right 10  horizontally
////                                        2.0, // Move to bottom 5 Vertically
////                                      ),
////                                    )
////                                  ]
//      ),
//      //color: Colors.grey[200],
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        children: <Widget>[
//          GestureDetector(
//              onTap:()=> Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Home()),),
//              child: Container(
//                  padding:EdgeInsets.all(10.0),
//                  decoration:siteIconEffectGrey,
//                  child: Icon(Icons.home,color:siteThemeColor,size: 35,))),
//          GestureDetector(
//              onTap:()=> Navigator.pushReplacement(context, PageRouteBuilder(
//                transitionDuration: Duration(seconds: 0),
//                pageBuilder: (context, animation1, animation2) => News(),
//              )),
//              child: Container(
//                  padding:EdgeInsets.all(10.0),
//                  decoration:siteIconEffectGrey,
//                  child: Icon(Icons.camera,color: siteThemeColor,size: 35,))),
//          GestureDetector(
//              onTap:()=> Navigator.push(
//                context,
//                CupertinoPageRoute(builder: (context) => FeedBack()),
//              ),
//              child: Container(
//                  padding:EdgeInsets.all(10.0),
//                  decoration:siteIconEffectGrey,
//                  child: Icon(Icons.email,color: siteThemeColor,size: 35,))),
//        ],),
//    );
//  }
//}