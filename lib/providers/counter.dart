import 'package:flutter/material.dart';


class CountProvider with ChangeNotifier{

  int counter=0;

  void countUp(){
    counter++;
    notifyListeners();
  }

  void countDown(){
    counter--;
    notifyListeners();
  }

}