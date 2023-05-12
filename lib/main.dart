import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sbi_sahay_1_0/myappmobile.dart';
import 'package:sbi_sahay_1_0/utils/dimenutils/dimensutils.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  double pixelRatio = window.devicePixelRatio;

  //Size in physical pixels
  Size physicalScreenSize = window.physicalSize;
  double physicalWidth = physicalScreenSize.width;
  double physicalHeight = physicalScreenSize.height;

  MyDimension.height = physicalHeight / pixelRatio;
  MyDimension.width = physicalWidth / pixelRatio;

  setPathUrlStrategy();

  runApp(MyAppForMobileApp());
}
