import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:lac/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:lac/utils/constants.dart';
import 'package:lac/utils/validate.dart';
import 'package:lac/views/home.dart';
import 'package:lac/views/login.dart';
import 'package:lac/views/password_forget_form.dart';
import 'package:lac/components/quick_menu.dart';
import 'package:lac/views/news.dart';
import 'package:flutter/services.dart';


class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  String email="braimahjake@gmail.com";
  String code="720388749";



  TextEditingController emailController =TextEditingController();
  TextEditingController codeController =TextEditingController();

  String message = '';
  bool loading=false;
  bool codeState=false;
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
                    Text('Please wait...')
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


  Future sendEmail ({BuildContext context,Function snackBar}) async{
    PersistentBottomSheetController bottomSheetController =await showModalBottom(context);
    var register= await Provider.of<AuthProvider>(context,listen: false).getRegTokenForget(email:emailController.text);
    //print(register.body);
    if(register['success']){
      //Navigator.push(context, CupertinoPageRoute(builder: (context) => RegisterForm()));
      setState(() {
        codeState=!codeState;
        modalWindowOpen=!modalWindowOpen;
      });
      bottomSheetController.close();
      return;
    }else{
      Future.delayed(Duration(milliseconds: 5000),(){
        bottomSheetController.close();
        modalWindowOpen=!modalWindowOpen;
        Scaffold.of(context).showSnackBar(snackBar(register['message']));
        setState(() {
        });
      });
    }
  }


  Future sendCode ({BuildContext context,Function snackBar}) async{
    PersistentBottomSheetController bottomSheetController =await showModalBottom(context);
    var register= await Provider.of<AuthProvider>(context,listen: false).validateRegTokenForget(email:emailController.text,code: codeController.text);
    //print(register.body);
    if(register['success']){
      bottomSheetController.close();
      modalWindowOpen=!modalWindowOpen;
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) =>  PasswordForgetForm(userEmail:emailController.text)));
      print(register['message']);
      return;
    }else{
      Future.delayed(Duration(milliseconds: 5000),(){
        bottomSheetController.close();
        modalWindowOpen=!modalWindowOpen;
        Scaffold.of(context).showSnackBar(snackBar(register['message']));
        setState(() {
        });
      });
    }
  }


  Future<void> submit(BuildContext context) async {
    //snackbar
    final snackBar =(message)=> new SnackBar(
        content: new Text(message),
        //duration: snackBarDurationOpen,
        duration: Duration(milliseconds: 4000),
        backgroundColor: Colors.black
    );

    final form = _formKey.currentState;
    if (form.validate()) {
      if(!codeState){
        sendEmail (context:context,snackBar: snackBar);
      }else{
        sendCode (context:context,snackBar: snackBar);
      }


    }






  }

  @override
  void initState() {
    // TODO: implement initState
    //testApi();
    super.initState();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  @override
  void dispose() {
    emailController.dispose();
    codeController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.


    return WillPopScope(
      onWillPop: () async =>  modalWindowOpen ?  false : true,
      child: SafeArea(
        child: Scaffold(
          //key: login,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Divider(),
                            QuickMenu(),
                            Divider(),
                            Text(!codeState ? "Please enter your email address to continue" :"Please enter your validation code to continue",style: TextStyle(color: siteThemeColor),),
                            SizedBox(height: 30,),
                            SizedBox(height: 25.0,),

                            !codeState? Text("Password Reset",style: TextStyle(color: siteThemeColor,fontSize: 30.0),): SizedBox(),
                            SizedBox(height: 10,),
                            !codeState? TextFormField(
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

                              //initialValue: 'braimahjaake@gmail.com',
                              //decoration: Styles.flatFormFields.copyWith(labelText: 'EMAIL',focusColor: Colors.pink),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                emailController.text = value.trim();
                                return Validate.validateEmail(value);
                              },
                            ):SizedBox(),


                            codeState? Text("Please check your email, we sent you a code.",style: TextStyle(color: siteThemeColor,fontSize: 25.0),):SizedBox(),
                            SizedBox(height: 10,),
                            codeState? TextFormField(
                              controller: codeController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(labelText: 'Activation Token', labelStyle: TextStyle(color: Colors.black54),
                                fillColor: Colors.white,
                                focusColor: Colors.red,
                                contentPadding:EdgeInsets.fromLTRB(11, 0, 0, 0),
                                focusedBorder:OutlineInputBorder(
                                  //borderSide: const BorderSide(color: Colors.red, width: 2.0),
                                  //borderRadius: BorderRadius.horizontal(Radi),
                                ),),
                              //initialValue: 'braimahjake@gmail.com',
//                              decoration: Styles.flatFormFields.copyWith(labelText: 'EMAIL',focusColor: Colors.pink),
//                               The validator receives the text that the user has entered.
                              validator: (value) {
                                codeController.text = value.trim();
                                return Validate.requiredField(value, "Please enter validation code");
                              },
                            ):SizedBox(),


//                            TextFormField(
//                                controller: passwordController,
//                                //initialValue: '123456',
//                                obscureText: true,
//                                //decoration: Styles.flatFormFields.copyWith(labelText: 'PASSWORD',focusColor: Colors.pink),
//                                validator: (value) {
//                                  passwordController.text = value.trim();
//                                  return Validate.requiredField(value, 'Password is required.');
//                                }
//
//                            ),
                            SizedBox(height: 20.0),

                            Builder(
                              builder: (context) => Consumer<AuthProvider>(
                                builder:(context,child,user)=>
                                    RaisedButton(
                                      color: siteThemeColor,
                                      disabledColor: Colors.grey,
                                      onPressed: !modalWindowOpen ? ()=>submit(context) : null,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          //color: Colors.green,
                                        ),
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                                        child: Text(
                                          'Continue'
                                          , style: TextStyle(color: Colors.white,),),
                                      ),
                                    ),
                              ),
                            ),

                            SizedBox(height: 25.0,),
                            Center(
                                child: Column(
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Already have an account? ",
                                              style: TextStyle(color: Colors.black),
                                            ),
                                            TextSpan(
                                                text: 'Sign In',
                                                style: TextStyle(color: siteThemeColor),
                                                //style: Styles.p.copyWith(color: Colors.green[500]),
                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () => Navigator.push(context,CupertinoPageRoute(builder: (context) => Login()),)
                                            ),

                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 8.0,),


                                    ])
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



