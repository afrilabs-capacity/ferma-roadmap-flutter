import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:lac/providers/auth.dart';
import 'package:lac/providers/pdss.dart';
import 'package:provider/provider.dart';
import 'package:lac/utils/constants.dart';
import 'package:lac/providers/auth.dart';
import 'package:lac/utils/validate.dart';
import 'package:lac/views/home.dart';
import 'package:lac/views/login.dart';
import 'package:lac/views/reports.dart';
import 'package:lac/views/report_pdss_single.dart';
import 'package:lac/views/register.dart';
import 'package:lac/models/my_state.dart';
import 'package:lac/models/counsel_data.dart';
import 'package:intl/intl.dart';
import 'package:lac/views/news.dart';
import 'package:lac/views/feedback.dart';



class AddReportPdss extends StatefulWidget {
  @override
  _AddReportPdssState createState() => _AddReportPdssState();
}

class _AddReportPdssState extends State<AddReportPdss> {


  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController =TextEditingController();
  TextEditingController lastNameController =TextEditingController();
  TextEditingController podController =TextEditingController();
  TextEditingController dateArrestedController =TextEditingController();
  TextEditingController dateReleasedController =TextEditingController();
  TextEditingController durationController =TextEditingController();

  /*date instance*/
  DateTime selectedDateArrested = DateTime.now();

  /*date instance*/
  DateTime selectedDateReleased = DateTime.now();

  /*date format instance*/
  DateFormat dateFormat = DateFormat("d-MM-yyyy");

  /*Set focus on desired widget*/
  FocusNode myFocusNode;


  //Dropdown
  List<String> genderList =["Male","Female"];
  List<String> occupationList=["Business Man","Trader","Farmer","Civil Servant","Retiree","NYSC","Unemployed","HouseWife","Student","Artisan","Driver"];
  List<String> caseTypeList=["Criminal","Civil"];
  List<String> offenceList=["Murder","Grievous Harm","Manslaughter","Armed Robbery","Robbery","Culp. Hom. PWD","Illegal Possession","Stealing","Theft","Accident","Assault","Kidnapping","Rape","Assault Occ. Bodily Harm","Breach of Peace","Mischief","Other Criminal Offence"];
  List<String> complaintsList=["Complaints","Employment/Labour Matters","Landlord/Tenant Matters","Fundamental Human Rights","Inheritance Matters","Matrimonial Matters","Accident","Defamation","Land Dispute","Death Benefit","Other Civil Complaint"];
  List<String> grantedList=["Yes","No"];
  List<String> ageList=[];
  List<String> outcomeList=["Struck Out","Adjourned","Legal Advice","Unstated","Convicted","Discharge","Discharge/Acquited"];
  List<String> marriageList=["Married","Single","Divoce","Widow","Widower"];

/*Instance of MyState*/
  MyState myState = MyState();

  String ageValue;
  String genderValue;
  String occupationValue;
  String offenceValue;
  String counselValue;
  String marriageValue;


  int selectsValidCounter=0;
  bool showSelectErrors=false;
  String message = '';
  bool loading=false;
  bool modalWindowOpen=false;
  Duration snackBarDurationOpen= Duration(days: 1);
  Duration snackBarDurationClose= Duration(microseconds: 1);



  Future<Null> dateArrested(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            //primarySwatch: buttonTextColor,//OK/Cancel button text color
            primaryColor: siteThemeColor,//Head background
            accentColor:  siteThemeColor,

            colorScheme: ColorScheme.light(primary: siteThemeColor),
            buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary
            ),
            //dialogBackgroundColor: Colors.white,//Background color
          ),
          child: child,
        );
      },
      context: context,
      initialDate: selectedDateArrested,
      firstDate: DateTime(2020, 8),
      lastDate: DateTime(2025),
      initialEntryMode: DatePickerEntryMode.calendar,



    );



    if (picked != null && picked != selectedDateArrested)
      setState(() {
        FocusScope.of(context).requestFocus(myFocusNode);
        selectedDateArrested = picked;
        dateArrestedController.text=dateFormat.format(selectedDateArrested);
        print(selectedDateArrested);
        //dobController.f
      });
  }




  Future<Null> dateReleased(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            //primarySwatch: buttonTextColor,//OK/Cancel button text color
            primaryColor: siteThemeColor,//Head background
            accentColor:  siteThemeColor,

            colorScheme: ColorScheme.light(primary: siteThemeColor),
            buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary
            ),
            //dialogBackgroundColor: Colors.white,//Background color
          ),
          child: child,
        );
      },
      context: context,
      initialDate: selectedDateReleased,
      firstDate: DateTime(2020, 8),
      lastDate: DateTime(2022),
      initialEntryMode: DatePickerEntryMode.calendar,


    );


    if (picked != null && picked != selectedDateReleased)
      setState(() {
        FocusScope.of(context).requestFocus(myFocusNode);
        selectedDateReleased = picked;
        dateReleasedController.text=dateFormat.format(selectedDateReleased);
        print(selectedDateReleased);
        //dobController.f
      });
  }


  showModalBottom(BuildContext context) async {
    this.modalWindowOpen=true;
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

//  showModalBottomDismiss(BuildContext context){
//    showModalBottomSheet(context: context,builder: (context){
//      return Center(child: Text('Invalid username or password'));
//
//    });
//  }


  showModalBottomDismiss(dynamic errorBag){
    //Map errors=jsonDecode(errorBag);
    List<Widget> apiErrors=[];
    //print(errors['first_name']);
    errorBag.forEach((key,value){
      apiErrors.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.error_outline,color: Colors.pink,),
              SizedBox(width: 5.0,),
              Flexible(child: Text(errorBag[key][0].toString(),style: TextStyle(color: Colors.pink),)),
            ],
          )
      ));
      //print(value);
    });



    int errorCount=apiErrors.length;

    return showModalBottomSheet(
        context: context,builder: (context){
      return Container(
        color: Colors.black45,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight: Radius.circular(25.0))
            ),
            height: double.infinity,
            child: Column(
              children: <Widget>[
                SizedBox(height: 15.0,),
                Text('We found ($errorCount) errors',style: TextStyle(fontSize: 20.0),),
                Divider(),
                SizedBox(height: 10.0,),
                Expanded(
                  child: ListView(
                      shrinkWrap: true,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: apiErrors
                  ),
                ),
              ],
            )
        ),
      );
    }

    );

  }



  List age(start,end){
    int start =17;
    int end=100;
    while(start<end){
      start++;
      ageList.add(start.toString());

    }
    ageList.add("");
    return ageList;

  }

  validateSelects(){
    selectsValidCounter=0;
//    if(ageValue==null) selectsValidCounter++;
    if(occupationValue==null) selectsValidCounter++;
    if(genderValue==null)  selectsValidCounter++;
    if(counselValue==null)  selectsValidCounter++;
    if(marriageValue==null)  selectsValidCounter++;

    showSelectErrors=true;
    print("$selectsValidCounter inside validate function");
    setState(() {});

  }




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
                                      Consumer<PdssReportProvider>(
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

  Future<void> submit(BuildContext context,String submitType) async {
    //show persistent bottomSheetModal
    final snackBar =(message)=> new SnackBar(
        content: new Text(message),
        //duration: snackBarDurationOpen,
        duration: Duration(milliseconds: 4000),
        backgroundColor: Colors.black);

    validateSelects();
    PersistentBottomSheetController bottomSheetController;
    final form = _formKey.currentState;
    if (form.validate() && selectsValidCounter==0) {
      bottomSheetController =await showModalBottom(context);

      bottomSheetController.closed.then((value) {
        // this callback will be executed on close
        this.modalWindowOpen=false;
      });

      //print("in submit box");
      var submit= await Provider.of<PdssReportProvider>(context,listen: false).submitReport(firstName: firstNameController.text,lastName: lastNameController.text,gender: genderValue,marriage: marriageValue, occupation: occupationValue,pod:podController.text, dateArrested: dateArrestedController.text,dateReleased: dateReleasedController.text, offence: offenceValue,councilAssigned: counselValue,duration: durationController.text);
      //bottomSheetController.close();

      if(submit['success']){
        bottomSheetController.close();
        //this.modalWindowOpen=false;
        setState(() {

        });
        //print(submit['data'].id.toString());
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => ReportPdssSingle(report:submit['data'])));
      }else{
        bottomSheetController.close();
        setState(() {
          //this.modalWindowOpen=false;
        });
        print(submit['code']);
        if(submit['code']==422) await showModalBottomDismiss(submit['data']['errors']);
        if((submit['code']==401))  showLoginModal(context);
      }

    }

  }

  @override
  void initState() {
    // TODO: implement initState
    //testApi();
    age(18,99);

    WidgetsBinding.instance
        .addPostFrameCallback((_)async {
      await Provider.of<PdssReportProvider>(context,listen: false).fetchCounsels().then((value){
        //Future.delayed(Duration(seconds: 6),()=>!checkUserLogin() ? showLoginModal(context):null);
//        if(!checkUserLogin()) showLoginModal(context);
      });

    });
    super.initState();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    firstNameController.dispose();
    lastNameController.dispose();
    podController.dispose();
    dateArrestedController.dispose();
    dateReleasedController.dispose();
    durationController.dispose();
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
          backgroundColor: siteThemeColor,
          body: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(70.0),bottomLeft: Radius.circular(60.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Consumer<PdssReportProvider>(
                builder:(context,data,child)=> Form(
                    key: _formKey,
                    child:  Center(
                      child: SingleChildScrollView(
                        child:  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          Divider(),
                          QuickMenu(),
                          Divider(),
                          SizedBox(height: 25.0,),
                          Text("PDSS Report Form",style: TextStyle(color: siteThemeColor,fontSize: 22.0),),
                            SizedBox(height: 25.0,),
                        !data.counselLoaded ? SizedBox(height: 100,):SizedBox(),
                        data.counselLoaded ?  Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                TextFormField(
                                  controller: firstNameController,
                                  //initialValue: 'braimahjake@gmail.com',
                                  //decoration: Styles.flatFormFields.copyWith(labelText: 'EMAIL',focusColor: Colors.pink),
                                  // The validator receives the text that the user has entered.
                                  decoration: InputDecoration(labelText: 'First Name',focusColor: Colors.pink,contentPadding:EdgeInsets.fromLTRB(11, 0, 0, 0),),
                                  validator: (value) {
                                    firstNameController.text = value.trim();
                                    return Validate.requiredField(value, 'Required field');
                                  },
                                ),
                                SizedBox(height: 10.0,),

                                TextFormField(
                                    controller: lastNameController,
                                    //initialValue: '123456',

                                    //decoration: Styles.flatFormFields.copyWith(labelText: 'PASSWORD',focusColor: Colors.pink),
                                    decoration: InputDecoration(labelText: 'Last Name',focusColor: Colors.pink,contentPadding:EdgeInsets.fromLTRB(11, 0, 0, 0)),
                                    validator: (value) {
                                      lastNameController.text = value.trim();
                                      return Validate.requiredField(value, 'Required field');
                                    }

                                ),
                                SizedBox(height: 5.0,),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 5.0),
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: genderValue==null && showSelectErrors ? Colors.red:Colors.white ))
                                  ),
                                  child: Card(
                                    elevation: 1,
                                    margin: EdgeInsets.only(bottom: 0),
                                    child: ListTile(
                                      title:Text("Gender"),
                                      contentPadding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      trailing: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          isExpanded: false,
                                          value: genderValue,
                                          selectedItemBuilder: (BuildContext context) {
                                            return genderList.map<Widget>((String item) {
                                              return SizedBox(width: 50, child: Center(child: Text(item,textAlign: TextAlign.right )));
                                            }).toList();
                                          },
                                          items: genderList.map((item) {
                                            return new DropdownMenuItem(
                                              child: new Text(item),
                                              value: item,
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              genderValue = value;
                                              validateSelects();
                                            });
                                          },
                                          style: TextStyle(color: Colors.black, decorationColor: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 5.0),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: marriageValue==null && showSelectErrors ? Colors.red:Colors.white ),),),
                                  child: Card(
                                    elevation: 1,
                                    margin: EdgeInsets.only(bottom: 0),
                                    child: ListTile(
                                      title:Text("Marital Status"),
                                      contentPadding:
                                      EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      trailing: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          isExpanded: false,
                                          value: marriageValue,
                                          selectedItemBuilder: (BuildContext context) {
                                            return marriageList.map<Widget>((String item) {
                                              return Center(child: Text(item,textAlign: TextAlign.right ));
                                            }).toList();
                                          },
                                          items: marriageList.map((item) {
                                            return new DropdownMenuItem(
                                              child: new Text(item),
                                              value: item,
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              marriageValue = value;
                                              validateSelects();
                                            });
                                          },
                                          style: TextStyle(color: Colors.black, decorationColor: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 5.0),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: occupationValue==null && showSelectErrors ? Colors.red:Colors.white ),
                                    ),
                                  ),
                                  child: Card(
                                    elevation: 1,
                                    margin: EdgeInsets.only(bottom: 0),
                                    child: ListTile(
                                      title:Text("Occupation"),
                                      contentPadding:
                                      EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      trailing: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          isExpanded: false,
                                          value: occupationValue,
                                          selectedItemBuilder: (BuildContext context) {
                                            return occupationList.map<Widget>((String item) {
                                              return SizedBox(width: 80, child: Center(child: Text(item,textAlign: TextAlign.right )));
                                            }).toList();
                                          },
                                          items: occupationList.map((item) {
                                            return new DropdownMenuItem(
                                              child: new Text(item),
                                              value: item,
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              occupationValue = value;
                                              validateSelects();
                                            });
                                          },
                                          style: TextStyle(color: Colors.black, decorationColor: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 5.0),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: offenceValue==null && showSelectErrors ? Colors.red:Colors.white ),),),
                                  child: Card(
                                    elevation: 1,
                                    margin: EdgeInsets.only(bottom: 0),
                                    child: ListTile(
                                      title:Text("Offence"),
                                      contentPadding:
                                      EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      trailing: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          isExpanded: false,
                                          value: offenceValue,
                                          selectedItemBuilder: (BuildContext context) {
                                            return offenceList.map<Widget>((String item) {
                                              return SizedBox(width: 90, child: Center(child: Text(item,textAlign: TextAlign.right )));
                                            }).toList();
                                          },
                                          items: offenceList.map((item) {
                                            return new DropdownMenuItem(
                                              child: new Text(item),
                                              value: item,
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              offenceValue = value;
                                              validateSelects();
                                            });
                                          },
                                          style: TextStyle(color: Colors.black, decorationColor: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                TextFormField(
                                    controller: podController,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.done,
                                    maxLines: 4,
                                    //initialValue: '123456',
                                    //decoration: Styles.flatFormFields.copyWith(labelText: 'PASSWORD',focusColor: Colors.pink),
                                    decoration: InputDecoration(labelText: 'Place of Detention',focusColor: Colors.pink,contentPadding:EdgeInsets.fromLTRB(11, 0, 0, 0)),
                                    validator: (value) {
                                      podController.text = value.trim();
                                      return Validate.requiredField(value, 'Required field');
                                    }

                                ),
                                SizedBox(height: 20.0),
                                InkWell(
                                  onTap: (){
                                    FocusScope.of(context).requestFocus(new FocusNode());
                                    dateArrested(context);},
                                  child: IgnorePointer(
                                    child: TextFormField(
                                        controller: dateArrestedController,
                                        keyboardType: TextInputType.multiline,
//                                maxLines: 5,
                                        //initialValue: '123456',

                                        //decoration: Styles.flatFormFields.copyWith(labelText: 'PASSWORD',focusColor: Colors.pink),
                                        decoration: InputDecoration(labelText: 'Date Arrested',focusColor: Colors.pink,contentPadding:EdgeInsets.fromLTRB(11, 0, 0, 0)),
                                        validator: (value) {
                                          dateArrestedController.text = value.trim();
                                          return Validate.requiredField(value, 'Required field');
                                        }

                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                InkWell(
                                  onTap: (){
                                    FocusScope.of(context).requestFocus(new FocusNode());
                                    dateReleased(context);
                                  },
                                  child: IgnorePointer(
                                    child: TextFormField(
                                        controller: dateReleasedController,
                                        keyboardType: TextInputType.multiline,
//                                maxLines: 5,
                                        //initialValue: '123456',

                                        //decoration: Styles.flatFormFields.copyWith(labelText: 'PASSWORD',focusColor: Colors.pink),
                                        decoration: InputDecoration(labelText: 'Date Released',focusColor: Colors.pink,contentPadding:EdgeInsets.fromLTRB(11, 0, 0, 0)),
                                        validator: (value) {
                                          dateReleasedController.text = value.trim();
                                          return Validate.requiredField(value, 'Required field');
                                        }

                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 5.0),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: counselValue==null && showSelectErrors ? Colors.red:Colors.white ),),),
                                  child: Card(
                                    elevation: 1,
                                    margin: EdgeInsets.only(bottom: 0),
                                    child: ListTile(
                                      title:Text("Counsel Assigned"),
                                      contentPadding:
                                      EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      trailing: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          isExpanded: false,
                                          value: counselValue,
                                          selectedItemBuilder: (BuildContext context) {
                                            return data.counsels.map<Widget>((item) {
                                              return SizedBox(width: 90, child: Center(child: Text(item.name,textAlign: TextAlign.right )));
                                            }).toList();
                                          },
                                          items: data.counsels.map<DropdownMenuItem<String>>((item) {
                                            return new DropdownMenuItem(
                                              child: new Text(item.name),
                                              value: item.name,
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              counselValue = value;
                                              validateSelects();
                                            });
                                          },
                                          style: TextStyle(color: Colors.black, decorationColor: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                TextFormField(
                                    controller: durationController,
                                    //initialValue: '123456',

                                    //decoration: Styles.flatFormFields.copyWith(labelText: 'PASSWORD',focusColor: Colors.pink),
                                    decoration: InputDecoration(labelText: 'Duration',focusColor: Colors.pink,contentPadding:EdgeInsets.fromLTRB(11, 0, 0, 0)),
                                    validator: (value) {
                                      durationController.text = value.trim();
                                      return Validate.requiredField(value, 'Required field');
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
                                              'Submit'
                                              , style: TextStyle(color: Colors.white,),),
                                          ),
                                        ),
                                  ),
                                ),

                                SizedBox(height: 25.0,),



                                // Add TextFormFields and RaisedButton here.
                              ]
                          ) :Text("Initializing form, please wait........."),
                            !data.counselLoaded ? SizedBox(height: 150,):SizedBox(),
                        ],)
                      ),
                    )
                ),
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



