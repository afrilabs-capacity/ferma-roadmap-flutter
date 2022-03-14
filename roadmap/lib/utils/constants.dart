import 'package:flutter/material.dart';


//Theme color
final Color siteThemeColor= Colors.greenAccent[400];
final Color siteIconThemeColor= Colors.white70;
final Color siteIconThemeLight= Colors.white;
final Color siteIconThemeDark= Colors.black;
final BoxDecoration siteIconEffectGrey= BoxDecoration(
  borderRadius: BorderRadius.circular(50),
  color: Colors.grey[100],
);

final BoxDecoration siteIconEffectPink= BoxDecoration(
  borderRadius: BorderRadius.circular(50),
  color: Colors.pink[100],
);

final BoxDecoration siteIconEffectDefault= BoxDecoration(
  borderRadius: BorderRadius.circular(50),
  color: Color(int.parse("0xFFd83623")),
);

final BoxDecoration shadowBox= BoxDecoration(
//    color: siteThemeColor,
    borderRadius:  BorderRadius.only(topLeft: Radius.circular(10.0)),
    boxShadow: <BoxShadow>[
      BoxShadow(
          color: Colors.black54,
          blurRadius: 15.0,
          offset: Offset(0.0, 0.4)
      )
    ]
);


final BoxDecoration shadowBox1 =BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10),
      topRight: Radius.circular(10),
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(10)
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 5,
      blurRadius: 7,
      offset: Offset(0, 3), // changes position of shadow
    ),
  ],
);

final TextAlign alignTextLeft= TextAlign.left;


/*api endpoints*/
//final String hostUrl = "192.168.43.122:8080";
//final String hostUrlPartial="/laravel/site44/public/api/v1";
//final String baseUrl = "http://192.168.43.122:8080/laravel/site44/public/api/v1";

/*production*/
//final String hostUrl = "https://roadzoftserver.xyz";
//final String baseUrl = "https://roadzoftserver.xyz/api";


/*dev*/
final String hostUrl = "https://18e3-197-211-63-30.eu.ngrok.io";
final String baseUrl = "https://18e3-197-211-63-30.eu.ngrok.io/api";



////final String tryMe = hostUrl=="192.168.43.122:8080" ? "me":"you";
//final String hostUrl = "https://lacreportserver.xyz";
//final String hostUrlPartial="/api/v1";
//final String baseUrl = "http://86cb-197-211-63-8.eu.ngrok.io/api";


bool isAdHoc(List<dynamic> roles){
   bool hasRole=false;
   for(var i = 0; i < roles.length; i++){
     roles[i]['name']=="Ad-hoc" ? hasRole=true:hasRole=false;
   }

   return hasRole;

}

