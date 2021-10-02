import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:lac/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:lac/utils/constants.dart';
import 'package:lac/providers/auth.dart';
import 'package:lac/utils/validate.dart';
import 'package:lac/views/home.dart';
import 'package:lac/views/login.dart';
import 'package:lac/views/news.dart';
import 'package:lac/views/feedback.dart';


class RegisterForm extends StatefulWidget {

  String userEmail;
  RegisterForm({this.userEmail});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();


  TextEditingController passwordController =TextEditingController();
  TextEditingController passwordConfirmController =TextEditingController();


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

  Future<void> submit(BuildContext context) async {
    //snackbar
    final snackBar =(message)=> new SnackBar(
        content: new Text(message),
        //duration: snackBarDurationOpen,
        duration: Duration(milliseconds: 4000),
        backgroundColor: Colors.black);

    //show persistent bottomSheetModal
    final form = _formKey.currentState;
    if (form.validate()) {
      PersistentBottomSheetController bottomSheetController =await showModalBottom(context);

      //login= await Provider.of<AuthProvider>(context,listen: false).registerStart(emailController.text);
      var register= await Provider.of<AuthProvider>(context,listen: false).createPassword(email:widget.userEmail,password: passwordController.text);
//      //print(register.body);
      if(register['success']){
        bottomSheetController.close();
        bottomSheetController.closed.then((value) {
          Navigator.push(context, CupertinoPageRoute(builder: (context) => Home()));
        });


        return;
      }else{
        bottomSheetController.close();
        bottomSheetController.closed.then((value) {
          Future.delayed(Duration(milliseconds: 5000),(){
            bottomSheetController.close();
            modalWindowOpen=false;
            Scaffold.of(context).showSnackBar(snackBar(register['message']));
            setState(() {
            });
          });
        });

        print("error");
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
                            Text("Please enter your email address to continue",style: TextStyle(color: siteThemeColor),),
                            SizedBox(height: 30,),
                            SizedBox(height: 25.0,),
                            Text("Security",style: TextStyle(color: siteThemeColor,fontSize: 30.0),),

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
                                  return Validate.passwordValidate(value);
                                }

                            ),
                            TextFormField(
                                controller: passwordConfirmController,
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
                                  passwordConfirmController.text = value.trim();
                                  return Validate.passwordConfirmValidate(value, passwordController.text);
                                }

                            ),
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





