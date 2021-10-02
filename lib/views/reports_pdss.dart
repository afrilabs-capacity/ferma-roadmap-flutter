import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lac/models/pdss_data.dart';
import 'package:provider/provider.dart';
import 'package:lac/providers/report.dart';
import 'package:lac/providers/pdss.dart';
import 'package:lac/providers/auth.dart';
import 'package:lac/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:lac/models/my_state.dart';
import 'package:lac/components/drawer.dart';
import 'package:lac/components/auth_modal.dart';
import 'package:lac/utils/validate.dart';
import 'package:lac/views/report_pdss_single.dart';



class ReportsPdss extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        appBar: AppBar(
          title: Text('PDSS Reports',style: TextStyle(color: siteThemeColor),),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: siteThemeColor),

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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //Text("Reports",style: TextStyle(color: siteThemeColor,fontSize: 30.0),),
                    SizedBox(height: 10,),
                    MyFilter(),
                    Divider(),
                    ReportList()
                  ],
                ),
                // Add TextFormFields and RaisedButton here.
              ),
            )
        ),
      ),
    );




  }


}




class ReportList extends StatelessWidget {

  showDeleteModal(BuildContext context,String reportId){

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
                          Text("You are about to delete the selected report",style: TextStyle(color: siteThemeColor,fontSize: 13.0),),
                          SizedBox(height: 30,),
                          Center(
                            child: Consumer<ReportProvider>(
                              builder:(context,data,child)=>

                              !data.apiCallModal ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RaisedButton(
                                      onPressed: ()async{
                                        var delete=  await Provider.of<PdssReportProvider>(context,listen: false).deleteReport(reportId: reportId);
                                        //print(reportId);

                                        if(delete['success']){
                                          Provider.of<PdssReportProvider>(context, listen: false).fetchReports().then((value) => Navigator.pop(context));

                                        }else{
                                          Navigator.pop(context);
                                        }


                                      },
                                      //onPressed: ()=>null,
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

  @override
  Widget build(BuildContext context) {
    return Consumer<PdssReportProvider>(
      builder: (context,data,child)=>Expanded(
        flex: 1,
        child: data.reports.length!=0  ?  data.loaded ? NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo)  {
            if (data.loadMore && scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent){
              data.loaded=false;
              data.fetchReportsPaginate();
              data.loadMore=false;
              print("calling paginate on api");
              //if(!data.auth) showLoginModal(context);
            } return false;
          },
          child: ListView.builder(
            itemCount: data.reports.length,
            itemBuilder: (context, index) {
              return  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5.0),
                        color: siteThemeColor,
                        child: Row(
                          children: [
                            SizedBox(width: 10.0,),
                            Expanded(flex: 3, child: Center(child: Text("FIRST NAME",style: TextStyle(color: siteIconThemeLight),)),), Expanded(flex: 3, child: Center(child: Text("LAST NAME",style: TextStyle(color: siteIconThemeLight),)),),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                          //borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            SizedBox(),
                            Expanded(flex: 1, child: Row(children: [
                              Flexible(
                                child: Center(
                                  child: Text( '${data.reports[index].firstName.length <= 9
                                      ? data.reports[index].firstName :
                                  data.reports[index].firstName.substring(0,9)+"..."}',style: TextStyle(color: Colors.black)),
                                ),
                              ),

                            ],)
                            ),

                            Expanded(flex: 1, child: Row(children: [
                              Flexible(
                                child: Center(
                                  child: Text( '${data.reports[index].lastName.length <= 9
                                      ? data.reports[index].lastName :
                                  data.reports[index].lastName.substring(0,9)+"..."}',style: TextStyle(color: Colors.black)),
                                ),
                              )
                            ],)
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text('Submited: ',style: TextStyle(fontWeight: FontWeight.bold,color: siteThemeColor)),
                            Text('${data.reports[index].created}',),
                            SizedBox(width: 8.0,),
                            Text('|',style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(width: 8.0,),
                            Text('Counsel: ',style: TextStyle(fontWeight: FontWeight.bold,color: siteThemeColor)),
                            Flexible(child: Text('${data.reports[index].councilAssigned}',)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(flex: 2, child: Row(
                              children: <Widget>[
                                Text('Offence: ',style: TextStyle(fontWeight: FontWeight.bold,color: siteThemeColor)),
                                Flexible(child: Text( '${data.reports[index].offence}',style: TextStyle(color: siteThemeColor),))
                              ],
                            )),

                            Expanded(child: GestureDetector(
                                onTap: ()=>Navigator.push(
                                  context,
                                  CupertinoPageRoute(builder: (context) => ReportPdssSingle(report:data.reports[index])),
                                ),
                                child: Icon(Icons.remove_red_eye,color: siteThemeColor,)),),

                            Expanded(child: GestureDetector(
                                onTap: ()=>showDeleteModal(context,data.reports[index].id.toString()),
                                child: Icon(Icons.cancel_sharp,color: siteThemeColor,)))
                          ],
                        ),
                      ),
                      SizedBox(height: 5,),
                      Divider()
                      //Divider(),
                    ],
                  )
              );
            },
          ),
        ) : Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Waiting for reports.........',style: TextStyle(color: Colors.black),),
//              Skeleton(width: MediaQuery.of(context).size.width-20,),
//              SizedBox(height: 20,),
//              Skeleton(width: MediaQuery.of(context).size.width-30,),
//              SizedBox(height: 20,),
//              Skeleton(width: MediaQuery.of(context).size.width-40,),
//              SizedBox(height: 20,),
//              Skeleton(width: MediaQuery.of(context).size.width-50,),
//              SizedBox(height: 20,),
//              Skeleton(width: MediaQuery.of(context).size.width-60,),
            SizedBox(height: 20,),
          ],):Text('No results found.........',style: TextStyle(color: Colors.black),),
      ),
    );
  }
}



class MyFilter extends StatefulWidget {

  @override
  _MyFilterState createState() => _MyFilterState();
}

class _MyFilterState extends State<MyFilter> {


  /*business name search*/
  TextEditingController firstNameController = TextEditingController();

  /*business name search*/
  TextEditingController lastNameController = TextEditingController();


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
                                                data.fetchReports();


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
    // TODO: implement initState
    print("hhhh");
    WidgetsBinding.instance
        .addPostFrameCallback((_)async {

          var pdssReportProvider=Provider.of<PdssReportProvider>(context,listen: false);
          var authProvider=Provider.of<AuthProvider>(context,listen: false);
      await pdssReportProvider.fetchReports().then((value){
        pdssReportProvider.showFilter=false;
        authProvider.authModalMessage="";
        if(!pdssReportProvider.counselLoaded)pdssReportProvider.fetchCounsels();
        //Future.delayed(Duration(seconds: 6),()=>!checkUserLogin() ? showLoginModal(context):null);
        if(!checkUserLogin()) showLoginModal(context);
      });

    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Provider.of<AuthProvider>(context,listen: false).authModalMessage="";
    //Future.delayed(Duration(seconds: 6),()=>!checkUserLogin() ? showLoginModal(context):null);
    super.didChangeDependencies();

  }

  checkUserLogin(){
    print(Provider.of<PdssReportProvider>(context,listen: false).auth);
    return Provider.of<PdssReportProvider>(context,listen: false).auth;
  }


  @override
  Widget build(BuildContext context) {
    //businessNameController.text="Happy Bites";
    //return Container(child:Text('hi there') ,);
    return  Consumer<PdssReportProvider>(
      builder: (context,data,child)=>Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: siteThemeColor,
                  borderRadius:  BorderRadius.only(topLeft: Radius.circular(10.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black54,
                        blurRadius: 15.0,
                        offset: Offset(0.0, 0.4)
                    )
                  ]
              ),
              child: Column(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.all( 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Showing",
                                  style: TextStyle(color: siteIconThemeLight),
                                ),
                                TextSpan(
                                  text: ' (',
                                  style: TextStyle(color: siteIconThemeDark),
                                ),
                                TextSpan(
                                  text: ' ${data.reports!=null ? data.reports.length : 0 } ',
                                  style: TextStyle(color: siteIconThemeLight),
                                ),
                                TextSpan(
                                  text: ') ',
                                  style: TextStyle(color: siteIconThemeDark),
                                ),
                                TextSpan(
                                  text: 'of',
                                  style: TextStyle(color: siteIconThemeLight),
                                ),
                                TextSpan(
                                  text: ' (',
                                  style: TextStyle(color: siteIconThemeDark),
                                ),
                                TextSpan(
                                  text: ' ${data.paginate!=null ? data.paginate.total.toString() : 0 }',
                                  style: TextStyle(color: siteIconThemeLight),
                                ),
                                TextSpan(
                                  text: ' )',
                                  style: TextStyle(color: siteIconThemeDark),
                                ),
                                TextSpan(
                                  text: ' results',
                                  style: TextStyle(color: siteIconThemeLight),
                                ),
                              ],
                            ),
                          ),

                          // Text('Showing (${data.partners!=null ? data.partners.length : 0 }) of (${data.paginate!=null ? data.paginate.total.toString() : 0 }) results',style: TextStyle(fontSize: 16.0),),
                          //Text('Deals!!',style: TextStyle(color:Colors.green,fontSize: 30.0),),
                          Row(

                            children: <Widget>[
                              Text('filter',style: TextStyle(color:siteIconThemeLight),),
                              GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      data.showFilter=!data.showFilter;
                                    });
                                  },
                                  child: Icon(Icons.sort,color:Colors.black,))
                            ],
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          //color: Colors.grey[200],
                            borderRadius: BorderRadius.all(Radius.circular(25.0))
                        ),

                        // padding: EdgeInsets.all(10.0),
                        //margin: EdgeInsets.symmetric(horizontal: 15.0),
                        child:  Text("Search by First Name, Last Name or Counsel",style: TextStyle(color: siteIconThemeLight), textAlign: TextAlign.left,),

                      ),
                    ),

                    data.showFilter ?  SizedBox(height: 5.0 ):SizedBox(height: 8.0 ),

                    data.showFilter ?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 45,
                        child: TextFormField(
                          controller:  firstNameController,
                          //controller: _deliveryController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(5),   //  <- you can it to 0.0 for no space
                              isDense: true,
                              filled: true,
                              fillColor: Colors.grey[200],
                              labelText: 'First Name',
                              labelStyle: TextStyle(
                                  color: Colors.black
                              ),
                              focusColor: Colors.pink
                          ),
                        ),
                      ),
                    ):SizedBox(),
                    data.showFilter ?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 45,
                        child: TextFormField(

                          controller:  lastNameController,
                          //controller: _deliveryController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(5),   //  <- you can it to 0.0 for no space
                              isDense: true,
                              filled: true,
                              fillColor: Colors.grey[200],
                              labelText: 'Last Name',
                              labelStyle: TextStyle(
                                  color: Colors.black
                              ),
                              focusColor: Colors.pink
                          ),
                        ),
                      ),
                    ):SizedBox(),
                    data.showFilter ? Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      padding: EdgeInsets.all(5.0),
    child: Card(
    elevation: 1,
    margin: EdgeInsets.only(bottom: 0),
    child: ListTile(
    title:Text("Counsel Assigned"),
    contentPadding:
    EdgeInsets.fromLTRB(6, 0, 10, 0),
    trailing: DropdownButtonHideUnderline(
    child: DropdownButton(
    isExpanded: false,
    value: data.selectedCounsel,
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
    data.selectedCounsel = value;
    });
    },
    style: TextStyle(color: Colors.black, decorationColor: Colors.red),
    ),
    ),
    ),
    ),
    )
                        :SizedBox(),
                    data.showFilter ?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: ButtonTheme(
                              minWidth: MediaQuery.of(context).size.width-20,
                              height: 40,
                              buttonColor: Colors.black,
                              child: RaisedButton(
                                onPressed: () {
//                              if(firstNameController.text==null)
//                                return null;
//                              if(lastNameController.text==null)
//                                return null;
//                              if(data.selectedState==null)
//                                return null;


                                  Map<String,String> searchPayload={
                                    'first_name':firstNameController.text,
                                    'last_name':lastNameController.text,
                                    'counsel_assigned':data.selectedCounsel
                                  };
                                  data.loaded=false;
                                  data.searchReportsPaginate(searchPayload);
                                },
                                child: Text("Search",style: TextStyle(color: Colors.white),),
                              ),
                            ),),
                          SizedBox(width: 10.0,),
                          Expanded(
                              child: GestureDetector(
                                onTap:(){
                                  data.selectedCounsel=null;
                                  if(firstNameController!=null)
                                    firstNameController.clear();
                                  if(lastNameController!=null)
                                    lastNameController.clear();
                                  data.fetchReports();
                                  setState(() {

                                  });
                                },
                                child: Row(children: <Widget>[
                                  Text('reset',style: TextStyle(color: siteIconThemeLight),),
                                  Icon(Icons.refresh,color: siteIconThemeDark,),
                                ],),
                              )
                          ),
                        ],
                      ),
                    ):SizedBox()




                  ]
              ),),]),);



  }

  @override
  void dispose() {
    // TODO: implement dispose
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }


}