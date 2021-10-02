import 'package:flutter/material.dart';
import 'package:lac/components/drawer.dart';
import 'package:lac/utils/constants.dart';

class Offices extends StatelessWidget {

  final BoxDecoration containerStyle= BoxDecoration(
      color: Colors.grey[50],
      //borderRadius: BorderRadius.circular(5.0,),
      border: Border(left:BorderSide(color: siteThemeColor))
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text('Offices',style: TextStyle(color: siteThemeColor),),
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

                            SizedBox(height: 15.0,),
                           Column(children: [
                             Container(
                                 decoration: shadowBox.copyWith(color: siteThemeColor),
                                 padding: EdgeInsets.all(8.0),
                                 width:MediaQuery.of(context).size.width ,
                                 child: Center(
                                     child: Text("HEADQUARTERS AND ABUJA",style: TextStyle(color: Colors.white,fontSize: 20),))),
                             Container(
                               padding: EdgeInsets.all(10.0),
                               decoration: containerStyle,
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                 Center(
                                   child: Text(
                                       "Abuja FCT",style: TextStyle(color: siteThemeColor),
                                   ),
                                 ),
                                 SizedBox(height: 8.0,),
                                 Text(
                                     "22 Port Harcourt Crescent, Off Gimbiya Crescent, Area 11 Garki, Abuja."
                                 ),
                                   SizedBox(height: 5.0,),
                                 Text(
                                     "Email: info@legalaidcouncil.gov.ng"
                                 ),
                                   SizedBox(height: 10.0,),
                                   Text(
                                       "State Coordinator – Mr. Achi Ayok 08035983517"
                                   ),
                                   SizedBox(height: 10.0,),
                                   Center(
                                     child: Text(
                                       "Abuja FCT",style: TextStyle(color: siteThemeColor),
                                     ),
                                   ),
                                   Text(
                                       "Legal Aid Council Open University Office Complex Area 3, Garki"
                                   ),
                                   SizedBox(height: 10.0,),
                                   Text(
                                       "Mr. Nurudeen Ishola 08023500657"
                                   ),
                                   SizedBox(height: 10.0,),

      SizedBox(height: 8.0,),

                                   Center(
                                     child: Text(
                                       "Abuja FCT",style: TextStyle(color: siteThemeColor),
                                     ),
                                   ),
                                   Text(
                                       "Bwari Centre - Bwari Area Council Secretariat"
                                   ),
                                   SizedBox(height: 10.0,),
                                   Text(
                                       "Mrs Helen Jack Ojikah 08033491664"
                                   ),
                                   SizedBox(height: 10.0,),
                                   Center(
                                     child: Text(
                                       "Abuja FCT",style: TextStyle(color: siteThemeColor),
                                     ),
                                   ),
                                   Text(
                                       "Gwagwalada Centre - Gwagwalada Area Council Secretariat"
                                   ),
                                   SizedBox(height: 10.0,),
                                   Text(
                                       "Mr. Olusegun Komolafe 08036785949"
                                   ),
                                   SizedBox(height: 10.0,),

                                   Center(
                                     child: Text(
                                       "Abuja FCT",style: TextStyle(color: siteThemeColor),
                                     ),
                                   ),
                                   Text(
                                       "Karu Centre - Karu Local Government Secretariat New Karu, Nasarawa State"
                                   ),
                                   SizedBox(height: 10.0,),
                                   Text(
                                       "Umoru Dickson 08028505824"
                                   ),
                                   SizedBox(height: 10.0,),

                                   SizedBox(height: 8.0,),
                               ],
                               ))

                           ],

                           ),
                            SizedBox(height: 5.0,),

                            Column(children: [
                              Container(
                                  decoration: shadowBox.copyWith(color: siteThemeColor),
                                  padding: EdgeInsets.all(8.0),
                                  width:MediaQuery.of(context).size.width ,
                                  child: Center(
                                      child: Text("NORTH CENTRAL ZONE AND STATE OFFICES",style: TextStyle(color: Colors.white,fontSize: 20),))),
                              Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: containerStyle,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          "PLATEAU STATE & NORTH CENTRAL ZONAL OFFICE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      SizedBox(height: 8.0,),
                                      Text(
                                          "1st Floor Ministry of Education Bulding State Secretariat Complex, P.O. Box 6110, Jos."
                                      ),
                                      SizedBox(height: 5.0,),
                                      Text(
                                          "State Coordinator – Mrs. R. Oguche 08035946711"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Zonal Director – Mr. Dauda Hassan 08033153487"
                                      ),
                                      SizedBox(height: 10.0,),

                                      Text(
                                          "Shendam Centre - Local Government Secretariat Complex Shendam, Plateau State"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Mr. Fedilis Sanda 08069651855"
                                      ),
                                      SizedBox(height: 10.0,),

                                      SizedBox(height: 8.0,),

                                      Center(
                                        child: Text(
                                          "BENUE STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "Block Gp, 508,Fmr Ministry of Finance P.O. Box 133, Makurdi"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mr. Helmon Koston Buba 08124449741"
                                      ),
                                      SizedBox(height: 10.0,),

                                      Text(
                                          "Katsinal Ala Centre - Local Government Secretariat Complex Katsina Ala, Benue State"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Mrs. Malami L. Aondoakaa 08032101193"
                                      ),
                                      SizedBox(height: 10.0,),

                                      Center(
                                        child: Text(
                                          "KOGI STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "Fmr. Premises of Ministry of Commerce & Industry Behind Sub-treasurer, Ibb Way, Lokoja"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mr. Obiji Leonard 08035867020"
                                      ),
                                      SizedBox(height: 10.0,),

                                      Center(
                                        child: Text(
                                          "KWARA STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "Governor’s Office Ahmadu Bello Way, G.R.A. P.O. Box 4220, Ilorin."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Rufus Michael Bamidele 08033854866"
                                      ),
                                      SizedBox(height: 10.0,),

                                      Center(
                                        child: Text(
                                          "NASARAWA STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "56 Jos Road Opp Oceanic Bank, Lafia."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mr. Hanbal Zubair 08037931603"
                                      ),
                                      SizedBox(height: 10.0,),

                                      Center(
                                        child: Text(
                                          "NIGER STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "Federal Secretariat Complex 8-83 Ground Floor P.O. Box 1136, Minna."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mrs. Bola Jibogun 07068875605"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Suleja Centre Old Local Government Secretariat Kantoma Bridge, Suleja."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Tajudeen Olaosebikan 08035926608"
                                      ),
                                      SizedBox(height: 10.0,),

                                      Text(
                                          "Bida Centre Local Government Secretariat, Bida."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "F.B. Abdulrazak 08037393273"
                                      ),
                                      SizedBox(height: 10.0,),

                                      SizedBox(height: 8.0,),
                                    ],
                                  ))

                            ],

                            ),
                            SizedBox(height: 5.0,),
                            Column(children: [
                              Container(
                                  decoration: shadowBox.copyWith(color: siteThemeColor),
                                  padding: EdgeInsets.all(8.0),
                                  width:MediaQuery.of(context).size.width ,
                                  child: Center(
                                      child: Text("NORTH EAST ZONE AND STATE OFFICES",style: TextStyle(color: Colors.white,fontSize: 20),))),
                              Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: containerStyle,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          "ADAMAWA STATE & NORTH EAST ZONAL OFFICE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      SizedBox(height: 8.0,),
                                      Text(
                                          "Federal Secretariat Complex P.O. Box 1188, Yola."
                                      ),
                                      SizedBox(height: 5.0,),
                                      Text(
                                          "State Coordinator – Mr. Francis Ogbe 08036341640"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Zonal Director – Mr. T. Lektu 08058615087"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Center(
                                        child: Text(
                                          "BORNO STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "Federal Secretariat Complex P.O. Box 5289, Maiduguri"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mr. Peter Bwala 08167155022"
                                      ),
                                      SizedBox(height: 10.0,),

                                      SizedBox(height: 8.0,),

                                      Center(
                                        child: Text(
                                          "GOMBE STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "Ministry of Justice Complex 5 New Commercial Road"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mr. Pile Gayus Kombo 07031626418"
                                      ),
                                      SizedBox(height: 10.0,),

                                      Text(
                                          "Biliri Centre - Opposite Unity Bank Biliri, Gombe"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Center(
                                        child: Text(
                                          "BAUCHI STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "Federal Secretariat Complex P.O.Box 446, Bauchi."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mr. Saminu Alkantara 08032075770"
                                      ),
                                      SizedBox(height: 10.0,),

                                      Text(
                                          "Ningi Centre - Gurama Hall Along Ningi/Kano Road Ningi, Bauchi State"
                                      ),

                                      SizedBox(height: 10.0,),

                                      Center(
                                        child: Text(
                                          "TARABA STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "Ministry of Justice Jalango."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mr. Solomon Adebowale 07039659810"
                                      ),
                                      SizedBox(height: 10.0,),

                                      Center(
                                        child: Text(
                                          "YOBE STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "Ministry of Justice Damaturu."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mr. Solomon Adebowale 07039659810"
                                      ),
                                      SizedBox(height: 10.0,),

                                      SizedBox(height: 8.0,),
                                    ],
                                  ))

                            ],

                            ),
                            SizedBox(height: 5.0,),
                            Column(children: [
                              Container(
                                  decoration: shadowBox.copyWith(color: siteThemeColor),
                                  padding: EdgeInsets.all(8.0),
                                  width:MediaQuery.of(context).size.width ,
                                  child: Center(
                                      child: Text("NORTH WEST ZONE AND STATE OFFICES",style: TextStyle(color: Colors.white,fontSize: 20),))),
                              Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: containerStyle,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          "KADUNA STATE & NORTH WEST ZONAL OFFICE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      SizedBox(height: 8.0,),
                                      Text(
                                          "Federal Secretariat Complex 3rd Floor Room 323 – 328 P.O. Box 4248, Kaduna."
                                      ),
                                      SizedBox(height: 5.0,),
                                      Text(
                                          "State Coordinator – Mrs. Biba F. Ohwoavworhua 08030921543"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Zonal Director – Mr. Ahmad Umar Abubakar 08054374225"
                                      ),
                                      SizedBox(height: 10.0,),

                                      SizedBox(height: 5.0,),
                                      Text(
                                          "Kaduna South Centre - Kaduna South Local Government Secretariat Kakuri, Kaduna."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Ramatu Jega Usman – 08033118735"
                                      ),
                                      SizedBox(height: 10.0,),

                                      SizedBox(height: 5.0,),
                                      Text(
                                          "Kafanchan Centre Civil Defence Premises Opp. Frsc Office, Kafanchan Jemaa Lga, Kaduna.."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "David Agun Adudu – 08034701644"
                                      ),
                                      SizedBox(height: 10.0,),

                                      SizedBox(height: 5.0,),
                                      Text(
                                          "Chikun Centre - Chikun Local Government Secretariat Kujama, Kaduna."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Diana Bagaiya – 07039800073"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Center(
                                        child: Text(
                                          "JIGAWA STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "High Court Complex Last Floor, Dutse."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Ms Louisa Mbamalu 08139207095"
                                      ),
                                      SizedBox(height: 10.0,),

                                      SizedBox(height: 8.0,),

                                      Center(
                                        child: Text(
                                          "KANO STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "Gidan Murtala, 1st Floor P.O. Box 2651, Kano"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mr. Muktar L. Usman 08183221224"
                                      ),
                                      SizedBox(height: 10.0,),

                                      Text(
                                          "Unogogo Centre - Near Sharia Court, Unogogo Kano."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Center(
                                        child: Text(
                                          "KATSINA STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "Federal Secretariat Complex Dandagoro, Kano Road, Katsina."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mr. Auwal Kofa 08035320951"
                                      ),


                                      SizedBox(height: 10.0,),

                                      Center(
                                        child: Text(
                                          "SOKOTO STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "Federal Secretariat Complex P.O.Box 778, Sokoto."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mr. Akilahyel Shettima 08028396869"
                                      ),
                                      SizedBox(height: 10.0,),

                                      Center(
                                        child: Text(
                                          "ZAMFARA STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "Opp Photo Palace Sani Abacha Way Gusau."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mr. Mohammed A. Jamo 08025504709"
                                      ),
                                      SizedBox(height: 10.0,),

                                      Center(
                                        child: Text(
                                          "KEBBI STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "Old High Court Complex Birnin Kebbi, Kebbi State."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – S. M. Alhassan 08063215390"
                                      ),
                                      SizedBox(height: 10.0,),

                                      SizedBox(height: 8.0,),
                                    ],
                                  ))

                            ],

                            ),
                            SizedBox(height: 5.0,),
                            Column(children: [
                              Container(
                                  decoration: shadowBox.copyWith(color: siteThemeColor),
                                  padding: EdgeInsets.all(8.0),
                                  width:MediaQuery.of(context).size.width ,
                                  child: Center(
                                      child: Text("SOUTH EAST ZONE AND STATE OFFICES",style: TextStyle(color: Colors.white,fontSize: 20),))),
                              Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: containerStyle,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          "ENUGU STATE & SOUTH EAST ZONAL OFFICE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      SizedBox(height: 8.0,),
                                      Text(
                                          "Room 251 – 258, 2nd Floor Federal Secretariat Complex P.O.Box 1709 Enugu."
                                      ),
                                      SizedBox(height: 5.0,),
                                      Text(
                                          "State Coordinator – Mr. Sunday Ndubisi 07038802661"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Zonal Director – Mr. Oliver Chukwuma 08063079364"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Center(
                                        child: Text(
                                          "ABIA STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "31 School Road, P.O. Box 982, Umuahia."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mrs. Martha Igu 08032889382"
                                      ),
                                      SizedBox(height: 10.0,),

                                      SizedBox(height: 8.0,),

                                      Center(
                                        child: Text(
                                          "ANAMBRA STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "State Secretariat, (Old Building) Ground Floor, Opp Uba Plc. Secretariat Road, P.O. Box 1158 Awka."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mrs. R. U. Maduabuchi 08033459707"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Otuocha Centre - Anambra East Local Government Secretariat Premises, Otuocha Anambra."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Umuchukwu Centre - Orumba South L.G.A. Anambra."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Center(
                                        child: Text(
                                          "IMO STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "State High Court Complex P.O. Box 2654, Owerri."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator- Mrs Ngozi Ejike 08060384449"
                                      ),
                                      SizedBox(height: 10.0,),

                                      Center(
                                        child: Text(
                                          "EBONYI STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "Ground Floor, Ministry of Justice Centenary City, Abakiliki."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mr. O. Kingsley 08035059290"
                                      ),
                                      SizedBox(height: 10.0,),

                                      SizedBox(height: 8.0,),
                                    ],
                                  ))

                            ],

                            ),
                            SizedBox(height: 5.0,),
                            Column(children: [
                              Container(
                                  decoration: shadowBox.copyWith(color: siteThemeColor),
                                  padding: EdgeInsets.all(8.0),
                                  width:MediaQuery.of(context).size.width ,
                                  child: Center(
                                      child: Text("SOUTH SOUTH ZONE AND STATE OFFICES",style: TextStyle(color: Colors.white,fontSize: 20),))),
                              Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: containerStyle,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          "DELTA STATE & SOUTH SOUTH ZONAL OFFICE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      SizedBox(height: 8.0,),
                                      Text(
                                          "Federal Secretariat Complex Asaba."
                                      ),
                                      SizedBox(height: 5.0,),
                                      Text(
                                          "State Coordinator – Mrs. Flora C. Imo 08037024118"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Zonal Director- Mr. Ben Onokohwemu 08029426828"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Center(
                                        child: Text(
                                          "EDO STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "Federal Secretariat Complex 2nd Floor Auchi Road Aduwawa, Benin City."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mr. Eddy Inenevbor 08035754605"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Auchi Centre - Behind Frsc Office Off Ibienafe Road, Akhaluma Village Auchi, Edo State"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Mr. Felix Orerhe 08035957265"
                                      ),
                                      SizedBox(height: 10.0,),


                                      Center(
                                        child: Text(
                                          "AKWA IBOM STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "Federal Secretariat Complex, Abak Road 321, 3rd Floor P.O. Box 2238, Uyo."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mr. Ogah Ogbenyi 08052231092"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Center(
                                        child: Text(
                                          "BAYELSA STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "High Court Complex Onopa, Yenogoa."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mr. Alubi C. Sunny 07033570067"
                                      ),

                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Sagbama Centre - Local Government Secretariat Sagbama Bayelsa"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Elizabeth Wachukwu 08037775032"
                                      ),
                                      SizedBox(height: 10.0,),


                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Ogbia Centre - Ogbia Lga Secretariat Bayelsa"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Julianna Ogundipe 08061200048"
                                      ),
                                      SizedBox(height: 10.0,),

                                      Center(
                                        child: Text(
                                          "CROSS RIVERS STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "2nd Floor Left Wing Federal Secretariat Complex Calabar."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mr. John Umeh Ogbonna 08053363287"
                                      ),
                                      SizedBox(height: 10.0,),

                                      Center(
                                        child: Text(
                                          "RIVERS STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "High Court Complex P.O. Box 15407 Port Harcourt."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mrs. JaneFrances Bianeyin 08033395471"
                                      ),
                                      SizedBox(height: 10.0,),


                                      Text(
                                          "Abonema Centre - Akuku Toru Local Government Secretariat Abonema."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Dinah Jack 08039375918"
                                      ),
                                      SizedBox(height: 10.0,),

                                      SizedBox(height: 8.0,),
                                    ],
                                  ))

                            ],

                            ),
                            SizedBox(height: 5.0,),
                            Column(children: [
                              Container(
                                  decoration: shadowBox.copyWith(color: siteThemeColor),
                                  padding: EdgeInsets.all(8.0),
                                  width:MediaQuery.of(context).size.width ,
                                  child: Center(
                                      child: Text("SOUTH WEST ZONE AND STATE OFFICES",style: TextStyle(color: Colors.white,fontSize: 20),))),
                              Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: containerStyle,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          "LAGOS STATE & SOUTH WEST ZONAL OFFICE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      SizedBox(height: 8.0,),
                                      Text(
                                          "10 Okotie Eboh Road South West Ikoyi Lagos."
                                      ),
                                      SizedBox(height: 5.0,),
                                      Text(
                                          "State Coordinator – Mrs. I.T. Akingbade 08059890539"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Zonal Director – Mrs. Salau 08023154578"
                                      ),
                                      SizedBox(height: 10.0,),

                                      Text(
                                          "Badagry Centre - Badagry, Lagos."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Ijeoma Mbah – 08035464273"
                                      ),
                                      Center(
                                        child: Text(
                                          "EKITI STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "10 Ajilosun Street, Ikere Road Ado Ekiti."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mrs Adeyinka Opaleke – 07067976271"
                                      ),
                                      SizedBox(height: 10.0,),
                                      Center(
                                        child: Text(
                                          "OGUN STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "Federal Secretariat Complex Room 201-204 Abeokuta."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mrs. T. A. Adeaga 0803471406."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Center(
                                        child: Text(
                                          "ONDO STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "Federal Secretariat Complex 2nd Floor, Rooms 220-225, Igbatoro Rd P.O. Bix 2014, Akure."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mrs. K. Ikpidungise 08029514412"
                                      ),

                                      SizedBox(height: 10.0,),

                                      Text(
                                          "Owo Centre Old Nrc Building, Oke-ogun, Owo Ondo."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Abdulrahaman Yusuf – 08034828609"
                                      ),
                                      SizedBox(height: 10.0,),

                                      Center(
                                        child: Text(
                                          "OSUN STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "Ministry of Justice P.M.B. 4424, Oshogbo."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mrs Julie Olorunfemi 08036963005"
                                      ),
                                      SizedBox(height: 10.0,),


                                      Center(
                                        child: Text(
                                          "OYO STATE",style: TextStyle(color: siteThemeColor),
                                        ),
                                      ),
                                      Text(
                                          "Ministry of Justice Annex State Secretariat P.O.Box 10333, Ibadan."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "State Coordinator – Mrs. Funmi Odutayo 08057072560"
                                      ),
                                      SizedBox(height: 10.0,),

                                      Text(
                                          "Akinyele Moniya Community Centre - Akinyele Local Government, Ibadan Oyo."
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                          "Yetunde Adesida – 08056672925."
                                      ),
                                      SizedBox(height: 10.0,),

                                    ],
                                  ))

                            ],

                            ),
                            SizedBox(height: 5.0,),












                          ]
                      ),
                    ],
                  )),
            ],
          )


      );
  }
}

