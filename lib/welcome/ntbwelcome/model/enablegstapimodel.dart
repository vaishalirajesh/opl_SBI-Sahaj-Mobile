



import 'package:flutter/cupertino.dart';

class EnableGstAPiVM extends ChangeNotifier{

  late BuildContext context;

  bool isCheckFirst = false;
  bool isCheckSecond = false;

  void setContxt(BuildContext context){
    this.context = context;
  }

  void changestateConfirmViewSecondCheckBox(bool value) {
    isCheckSecond = value;
    notifyListeners();
  }

  void changestateConfirmViewFirstCheckBox(bool value) {
    isCheckFirst = value;
    notifyListeners();
  }


}