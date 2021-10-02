import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lac/components/drawer.dart';
import 'package:lac/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:lac/providers/auth.dart';
import 'package:lac/utils/validate.dart';



class FeedBack extends StatefulWidget {
  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {

  TextEditingController emailController =TextEditingController();
  TextEditingController nameController =TextEditingController();
  TextEditingController messageController =TextEditingController();


  bool loading=false;
  bool modalWindowOpen=false;
  final _formKey = GlobalKey<FormState>();
  bool messageMode=true;

  Future<void> submitFeedback(BuildContext context,String submitType) async {
    //show persistent bottomSheetModal
    PersistentBottomSheetController bottomSheetController;
    final form = _formKey.currentState;
    if (form.validate()) {
      bottomSheetController =await showModalBottom(context);
      var login;

      login= await Provider.of<AuthProvider>(context,listen: false).submitFeedback(emailController.text, nameController.text,messageController.text);

      if(login){
        bottomSheetController.close();
        modalWindowOpen=!modalWindowOpen;
        setState(() {
          messageMode=false;
        });
        //Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Home()));
//        return;
      }else{
        //print('hi there');
//        final snackBar = new SnackBar(
//            content: new Text('Invalid Username or Password'),
//            //duration: snackBarDurationOpen,
//            duration: Duration(milliseconds: 4000),
//            backgroundColor: Colors.black);
//
//
//        Future.delayed(Duration(milliseconds: 5000),(){
//          bottomSheetController.close();
//          modalWindowOpen=false;
//          Scaffold.of(context).showSnackBar(snackBar);
//          setState(() {
//          });
//        });

      }

    }

  }


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


  var news;

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }


@override
void dispose(){

 emailController.dispose();
 nameController.dispose();
 messageController.dispose();
    super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
          resizeToAvoidBottomPadding: true,
          appBar: AppBar(
            title: Text('Feedback',style: TextStyle(color: siteThemeColor),),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: siteThemeColor),

          ),
          drawer: MyDrawer(context:context),
          body:  SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: messageMode ? Form(
                key: _formKey,
                child: Column(children: [

                SizedBox(height: 30,),
                SizedBox(height: 25.0,),
                Text("Leave us a message",style: TextStyle(color: siteThemeColor,fontSize: 30.0),),
                SizedBox(height:30.0),
                  TextFormField(
                    controller: nameController,
                    //initialValue: 'braimahjake@gmail.com',
                    //decoration: Styles.flatFormFields.copyWith(labelText: 'EMAIL',focusColor: Colors.pink),
                    // The validator receives the text that the user has entered.
                    decoration: InputDecoration(labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.black54),
                      fillColor: Colors.white,
                      focusColor: Colors.red,
                      contentPadding:EdgeInsets.fromLTRB(11, 0, 0, 0),
                      focusedBorder:OutlineInputBorder(
                        //borderSide: const BorderSide(color: Colors.red, width: 2.0),
                        //borderRadius: BorderRadius.horizontal(Radi),
                      ),),
                    validator: (value) {
                      nameController.text = value.trim();
                      return Validate.requiredField(value, 'Required field');
                    },
                  ),
                  SizedBox(height:30.0),
                TextFormField(
                  controller: emailController,
                  //initialValue: 'braimahjake@gmail.com',
                  //decoration: Styles.flatFormFields.copyWith(labelText: 'EMAIL',focusColor: Colors.pink),
                  // The validator receives the text that the user has entered.
                  decoration: InputDecoration(labelText: 'Email',
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
                    return Validate.validateEmail(value);
                  },
                ),
                  SizedBox(height:30.0),
                  TextFormField(
                      controller: messageController,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      maxLines: 8,
                      //initialValue: '123456',
                      //decoration: Styles.flatFormFields.copyWith(labelText: 'PASSWORD',focusColor: Colors.pink),
                      decoration: InputDecoration(labelText: 'Message', labelStyle: TextStyle(color: Colors.black54),
                        fillColor: Colors.white,
                        focusColor: Colors.red,
                        contentPadding:EdgeInsets.fromLTRB(11, 30, 0, 0),
                        focusedBorder:OutlineInputBorder(
                          //borderSide: const BorderSide(color: Colors.red, width: 2.0),
                          //borderRadius: BorderRadius.horizontal(Radi),
                        ),),
                      validator: (value) {
                        messageController.text = value.trim();
                        return Validate.requiredField(value, 'Required field');
                      }

                  ),
                SizedBox(height: 10,),
                  Builder(
                    builder: (context) => RaisedButton(
                      color: siteThemeColor,
                      disabledColor: Colors.grey,
                      onPressed: !modalWindowOpen ? ()=>submitFeedback(context,'student') : null,
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
                  ),
                      ],),
              ): Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height:MediaQuery.of(context).size.height/4),
                Text("Thank You",style: TextStyle(color: siteThemeColor,fontSize: 30.0),),
                SizedBox(height: 25.0,),
                Text("Thank you for your email. Please expect a response from us as soon as possible.",style: TextStyle(color: siteThemeColor,fontSize: 14.0),),
              ],),
            ),
          )




      ),
    );
  }
}

