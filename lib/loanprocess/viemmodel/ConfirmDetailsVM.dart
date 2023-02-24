import 'package:flutter/material.dart';

import '../../config/webappconfigWidgets.dart';



class ConfirmDetailVM extends ChangeNotifier{
  late BuildContext context;
  bool isconditiontick = false;
  bool isChecked = false;
  bool ispopupshow=false;
  var appconfing;
  void setContext(BuildContext context)
  {
    this.context = context;

  }
  void setCheckBoxValue(bool _value) {
    isconditiontick = _value;
    notifyListeners();
  }
  void setIsChecked(bool _value) {
    isChecked = _value;
    notifyListeners();
  }

  void showpopup(){
    ispopupshow=true;
    notifyListeners();
  }

  void removepopup(){
    ispopupshow=false;
    notifyListeners();
  }
}