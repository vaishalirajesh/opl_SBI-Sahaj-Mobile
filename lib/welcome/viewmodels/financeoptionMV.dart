import 'package:flutter/cupertino.dart';

import '../../config/webappconfigWidgets.dart';

class FinanceVM extends ChangeNotifier
{
  late BuildContext context;
  bool isStarted = false;

  bool ispopupshow=false;

  bool isFirstSelected = false;
  bool isSecondSelected = false;


   late WebAppConfig appconfing;



  void setFirstSelected()
  {
    isFirstSelected = true;
    isSecondSelected = false;
    notifyListeners();
  }

  void setSecondSelected()
  {
    isSecondSelected = true;
    isFirstSelected = false;
    notifyListeners();
  }

  void setContext(BuildContext context)
  {
    this.context = context;
    appconfing = WebAppConfig.of(context)!;

  }
  void setIsStartedScreen()
  {
    isStarted = true;
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