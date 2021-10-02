import 'package:flutter/material.dart';
import 'package:lac/models/auth_data.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class ConfigProvider with ChangeNotifier {


  bool authConfig=false;


}