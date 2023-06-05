

import 'dart:convert';

import 'package:flutter/cupertino.dart';




import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/webappconfigWidgets.dart';

import '../../../../utils/constants/statusConstants.dart';
import '../../../../utils/showcustomesnackbar.dart';

import '../../routes.dart';



class GSTDetailsViewModel extends ChangeNotifier {


  late BuildContext context;
  var appconfing;


  TextEditingController gstUsernameController = TextEditingController();
  TextEditingController gstinNoController = TextEditingController();

  TextEditingController gstinOTPController = TextEditingController();

  bool isgstopshown = false;

  bool ispopupshow = false;

  bool isLoader = false;
  bool isSetLoader = false;
  bool flag = false;

  void display() {
    flag = true;
    notifyListeners();
  }


  void setIsLoader() {
    Future.delayed(Duration(seconds: 1), () {
      isSetLoader = true;
      notifyListeners();
    });
  }


  bool isValidGSTUserName = false;
  bool isValidGSTINNumber = false;

  bool isValidOTP = false;

  String firstletter = "";
  String secondletter = "";
  String thirdletter = "";
  String forthletter = "";
  String fifthletter = "";
  String sixthletter = "";

  void checkOtp() {
    isValidOTP = firstletter.isNotEmpty &&
        secondletter.isNotEmpty &&
        thirdletter.isNotEmpty &&
        forthletter.isNotEmpty &&
        fifthletter.isNotEmpty &&
        sixthletter.isNotEmpty;
    notifyListeners();
  }

  void changeState() {
    isgstopshown = true;
    notifyListeners();
  }

  void changeStateisgstopshownFalse() {
    isgstopshown = false;
    notifyListeners();
  }

  void setContext(BuildContext context) {
    this.context = context;
    appconfing = WebAppConfig.of(context);
  }

  void isShowLaoder() {
    isLoader = true;
    notifyListeners();
  }

  void HideLaoder() {
    isLoader = false;
    notifyListeners();
  }


  void showpopup() {
    ispopupshow = true;
    notifyListeners();
  }

  void removepopup() {
    ispopupshow = false;
    notifyListeners();
  }

  void navigateToGstDetailScreen() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushNamed(context, MyRoutes.confirmGSTDetailRoutes);
    });
  }


  void CheckValidGSTUserName() {
    //final alphanumeric = RegExp(r'^.*[!&^%$#@*()/]+.*$');
    if (gstUsernameController.text.length >= 1) {
      isValidGSTUserName = true;
    } else {
      isValidGSTUserName = false;
    }
    notifyListeners();
  }

  void CheckValidGSTInNumber() {
    final alphanumeric =
    RegExp('\\d{2}[A-Z]{5}\\d{4}[A-Z]{1}[A-Z\\d]{1}[Z]{1}[A-Z\\d]{1}');
    if (alphanumeric.hasMatch(gstinNoController.text) &&
        gstinNoController.text.isNotEmpty &&
        gstinNoController.text.length == 15) {
      isValidGSTINNumber = true;
    } else {
      isValidGSTINNumber = false;
    }

    notifyListeners();
  }

  bool isValidGstUserName(BuildContext context) {
    if (gstUsernameController.text.isEmpty) {
      showSnackBar(context, "Please Enter gst user Name");
      return false;
    } else if (gstUsernameController.text.length <= 5) {
      showSnackBar(context, "Please Valid gst user Name");
      return false;
    }

    return true;
  }

  bool isValidGstInNumber(BuildContext context) {
    if (gstinNoController.text.isEmpty) {
      showSnackBar(context, "Please Enter gst number");
      return false;
    } else if (gstinNoController.text.length <= 14) {
      showSnackBar(context, "Please Valid gst number");
      return false;
    }
    return true;
  }

}