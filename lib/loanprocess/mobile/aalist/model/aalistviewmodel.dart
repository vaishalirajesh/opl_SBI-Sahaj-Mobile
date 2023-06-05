


import 'package:flutter/cupertino.dart';

import '../../../../routes.dart';

class AAListViewModel extends ChangeNotifier
{
  late BuildContext context;

  bool isAANextClick = false;

  bool isChecked = false;


  void setContext(BuildContext context)
  {
    this.context = context;
  }


  void changeState() {
    isChecked = !isChecked;
    notifyListeners();
  }



  void setNextAAClick() {
    isAANextClick = true;
    notifyListeners();
  }

  void setNavigatorShareInfo() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushNamed(context, MyRoutes.infoShareRoutes);
    });
  }

}