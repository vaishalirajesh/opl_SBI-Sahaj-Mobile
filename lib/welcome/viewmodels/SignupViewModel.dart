import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config/webappconfigWidgets.dart';

class SignUpViewModel extends ChangeNotifier
{
  late BuildContext context;
  bool isChecked = false;
  var appconfing;

  final  genderList = ['Male','Female'];

  String? gender = '';

  void setContext(BuildContext context)
  {
    this.context = context;
    appconfing=WebAppConfig.of(context);
  }

  void setGender(String? gender)
  {
    this.gender = gender;
  }


  void setCheckChange(bool value) {
    isChecked = value;
    notifyListeners();
  }
}