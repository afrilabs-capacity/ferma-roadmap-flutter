import 'package:flutter/material.dart';


//Theme color
final Color siteThemeColor= Color(int.parse("0xFFd83623"));
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

final TextAlign alignTextLeft= TextAlign.left;


/*api endpoints*/
//final String hostUrl = "192.168.43.122:8080";
//final String hostUrlPartial="/laravel/site44/public/api/v1";
//final String baseUrl = "http://192.168.43.122:8080/laravel/site44/public/api/v1";

final String hostUrl = "https://192.168.43.122:8080/lacreports.test";
final String hostUrlPartial="https://192.168.43.122:8080/lacreports.test/api/v1";
final String baseUrl = "https://192.168.43.122:8080/lacreports.test/public/api/v1";
////final String tryMe = hostUrl=="192.168.43.122:8080" ? "me":"you";

//final String hostUrl = "https://lacreportserver.xyz";
//final String hostUrlPartial="/api/v1";
//final String baseUrl = "https://lacreportserver.xyz/api/v1";
//
