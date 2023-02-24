
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sbi_sahay_1_0/config/pnb/pnbconfig.dart';
import 'package:sbi_sahay_1_0/config/sbi/sbiconfig.dart';
import 'package:sbi_sahay_1_0/myappmobile.dart';
import 'package:sbi_sahay_1_0/utils/dimenutils/dimensutils.dart';
import 'package:url_strategy/url_strategy.dart';

import 'config/webappconfigWidgets.dart';
import 'myaapweb.dart';

void main() async{

  //SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
  double pixelRatio = window.devicePixelRatio;

  //Size in physical pixels
  Size physicalScreenSize = window.physicalSize;
  double physicalWidth = physicalScreenSize.width;
  double physicalHeight = physicalScreenSize.height;


  MyDimension.height=physicalHeight/pixelRatio;
  MyDimension.width=physicalWidth/pixelRatio;


  setPathUrlStrategy();

  runApp(MyAppForMobileApp());
}



