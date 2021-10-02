import 'package:flutter/material.dart';
import 'package:lac/components/drawer.dart';
import 'package:lac/utils/constants.dart';

class About extends StatelessWidget {

  final BoxDecoration containerStyle= BoxDecoration(
      color: Colors.grey[50],
      //borderRadius: BorderRadius.circular(5.0,),
      border: Border(left:BorderSide(color: siteThemeColor))
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
            appBar: AppBar(
              title: Text('About LAC',style: TextStyle(color: siteThemeColor),),
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: siteThemeColor),

            ),
            drawer: MyDrawer(context:context),
            body: ListView(
              children: [
                Image.network("https://i.imgur.com/yW67w3K.jpg"),

                Container(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Column(
                            children: [

                              Container(
                                padding: EdgeInsets.all(10.0),
                                decoration: containerStyle,
                                child: Center(
                                  child: Text( "The concept of Legal aid in Nigeria can be said to have been birthed in 1961 when Sir Adetokunbo Ademola, the Chief Justice of Nigeria at the time, during the African Conference on the Rule of Law held in Lagos, pointed out the hollowness of a constitutional right to a fair hearing, if the financial aspect of access was ignored. That statement was the first official public acknowledgement of the need and desirability for legal aid in Nigeria. This led to a Bill prepared by the then Honourable Attorney-General, Dr. T.O. Elias, entitled Legal Aid and Advice Act 1961 for Parliament, in order to formally establish legal aid in Nigeria. The Bill sought to make provision for the establishment and operation of a scheme for the granting in proper cases, legal aid and legal advice, to people with low income, who could not otherwise afford to procure them for the enforcement or vindication of a legitimate right or for the purpose of obtaining a just relief. Unfortunately due to the Nigerian Civil War the Bill did not see the light of day.", textAlign: TextAlign.justify ,),
                                ),
                              ),
                              SizedBox(height: 15.0,),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                  width:MediaQuery.of(context).size.width ,
                                  color: siteThemeColor,
                                  child: Center(child: Text("Mission",style: TextStyle(color: Colors.white,fontSize: 20),))),
                              SizedBox(height: 5.0,),
                              Container(
                                padding: EdgeInsets.all(10.0),
                                decoration: containerStyle,
                                child: Text(
                                    "To ensure free, effective and efficient legal aid services to indigents in Nigeria."
                                ),),
                              SizedBox(height: 15.0,),
                              Container(
                                  padding: EdgeInsets.all(8.0),
                                  width:MediaQuery.of(context).size.width ,
                                  color: siteThemeColor,
                                  child: Center(child: Text("Vision",style: TextStyle(color: Colors.white,fontSize: 20),))),

                              SizedBox(height: 5.0,),
                              Container(
                                padding: EdgeInsets.all(10.0),
                                decoration: containerStyle,
                                child: Text(
                                    "To build a Nigerian nation where there is equal access to justice for all irrespective of means and where all rights are respected, protected and defended."
                                ),),
                              SizedBox(height: 15.0,),
                              Container(
                                  padding: EdgeInsets.all(8.0),
                                  width:MediaQuery.of(context).size.width ,
                                  color: siteThemeColor,
                                  child: Center(child: Text("Core Values",style: TextStyle(color: Colors.white,fontSize: 20),))),

                              SizedBox(height: 5.0,),
                              Container(
                                  padding: EdgeInsets.all(10.0),
                                  //decoration: containerStyle,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: containerStyle,
                                        child: Row(
                                          children: [
                                            Container(
                                              margin:EdgeInsets.all(7.0),
                                              padding: EdgeInsets.all(3.0),
                                              decoration: siteIconEffectDefault,
                                              child: Icon(Icons.check_circle,color: siteIconThemeLight,),
                                            ),
                                            SizedBox(width: 8.0,),
                                            Expanded(child: Text("Accountability"))
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 8.0,),
                                      Container(
                                        decoration: containerStyle,
                                        child: Row(
                                          children: [
                                            Container(
                                              margin:EdgeInsets.all(7.0),
                                              padding: EdgeInsets.all(3.0),
                                              decoration: siteIconEffectDefault,
                                              child: Icon(Icons.check_circle,color: siteIconThemeLight,),
                                            ),
                                            SizedBox(width: 8.0,),
                                            Expanded(child: Text("Integrity"))
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 8.0,),
                                      Container(
                                        decoration: containerStyle,
                                        child: Row(
                                          children: [
                                            Container(
                                              margin:EdgeInsets.all(7.0),
                                              padding: EdgeInsets.all(3.0),
                                              decoration: siteIconEffectDefault,
                                              child: Icon(Icons.check_circle,color: siteIconThemeLight,),
                                            ),
                                            SizedBox(width: 8.0,),
                                            Expanded(child: Text("Independence"))
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 8.0,),
                                      Container(
                                        decoration: containerStyle,
                                        child: Row(
                                          children: [
                                            Container(
                                              margin:EdgeInsets.all(7.0),
                                              padding: EdgeInsets.all(3.0),
                                              decoration: siteIconEffectDefault,
                                              child: Icon(Icons.check_circle,color: siteIconThemeLight,),
                                            ),
                                            SizedBox(width: 8.0,),
                                            Expanded(child: Text("Professionalism"))
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 8.0,),
                                      Container(
                                        decoration: containerStyle,
                                        child: Row(
                                          children: [
                                            Container(
                                              margin:EdgeInsets.all(7.0),
                                              padding: EdgeInsets.all(3.0),
                                              decoration: siteIconEffectDefault,
                                              child: Icon(Icons.check_circle,color: siteIconThemeLight,),
                                            ),
                                            SizedBox(width: 8.0,),
                                            Expanded(child: Text("Accessibility"))
                                          ],
                                        ),
                                      ),
                                    ],
                                  )

                              ),

                            ]
                        ),
                      ],
                    )),
              ],
            )


        ),
    );

  }
}

