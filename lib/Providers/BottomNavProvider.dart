import 'package:flutter/cupertino.dart';

class BottomNavProvider extends ChangeNotifier{
  int curIndex = 0;
  void changeNav(int i){
    curIndex = i;
    notifyListeners();
  }


}