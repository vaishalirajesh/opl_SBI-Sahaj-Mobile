

import 'package:flutter/material.dart';

import 'package:sbi_sahay_1_0/utils/constants/appconstant.dart';

class WebAppConfig extends InheritedWidget {
  WebAppConfig({
    required this.version,
    required this.bankName,
    this.bankId,
    required this.asstesPath,
    this.baseURl,
    this.environment,
    required Widget child,
   }):super(child: child);


  final String version;
  final String bankName;
  final int? bankId;
  final String asstesPath;
  final String? baseURl;
  final String? environment;



  static WebAppConfig? of(BuildContext context) {

    return context.dependOnInheritedWidgetOfExactType<WebAppConfig>();
  }


  setAppString(String path){
    AppConstant.IMAGEBASEURL=path;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

}