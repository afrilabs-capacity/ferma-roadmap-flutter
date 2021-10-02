import 'package:flutter/material.dart';
import 'package:lac/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:lac/utils/constants.dart';
import 'package:lac/utils/validate.dart';

class AuthModal  {



//  Future<void> submit(BuildContext context,String submitType) async {
//    //show persistent bottomSheetModal
//    PersistentBottomSheetController bottomSheetController;
//    final form = _formKey.currentState;
//    if (form.validate()) {
//      //bottomSheetController =await showModalBottom(context);
//      var login;
//      login= await Provider.of<AuthProvider>(context,listen: false).login(emailController.text, passwordController.text);
//
//      if(login){
//        bottomSheetController.close();
//        apiCall=!apiCall;
//        Navigator.pop(context);
////        return;
//      }else{
//        //print('hi there');
//        final snackBar = new SnackBar(
//            content: new Text('Invalid Username or Password'),
//            //duration: snackBarDurationOpen,
//            duration: Duration(milliseconds: 4000),
//            backgroundColor: Colors.black);
//
//
//        Future.delayed(Duration(milliseconds: 5000),(){
//          apiCall=false;
//          Scaffold.of(context).showSnackBar(snackBar);
//        });
//
//      }
//
//    }
//
//  }

  showModalBottomDismiss(BuildContext context){

    final _formKey = GlobalKey<FormState>();

    /*controllers*/
    TextEditingController emailController =TextEditingController(text:'braimahjake@gmail.com');
    TextEditingController passwordController =TextEditingController(text: '1234567');

    /*auth loading indicator*/
    bool apiCall=false;

    return showModalBottomSheet(
        context: context,builder: (context){
      return Container(
        color: null,
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
                            Text("Please sign in to continue",style: TextStyle(color: siteThemeColor),),
                            SizedBox(height: 30,),
                            SizedBox(height: 25.0,),
                            Text("Sign In",style: TextStyle(color: siteThemeColor,fontSize: 30.0),),
                            TextFormField(
                              controller: emailController,
                              //initialValue: 'braimahjake@gmail.com',
                              //decoration: Styles.flatFormFields.copyWith(labelText: 'EMAIL',focusColor: Colors.pink),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                emailController.text = value.trim();
                                return Validate.validateEmail(value);
                              },
                            ),

                            TextFormField(
                                controller: passwordController,
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
                                    RaisedButton(
                                      color: siteThemeColor,
                                      disabledColor: Colors.grey,
                                      onPressed: !apiCall ? ()=> Provider.of<AuthProvider>(context,listen: false).login(emailController.text, passwordController.text) : null,
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



}

