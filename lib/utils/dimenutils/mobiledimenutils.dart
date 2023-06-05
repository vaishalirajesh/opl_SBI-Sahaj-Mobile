import 'package:flutter/cupertino.dart';

import 'dimensutils.dart';

class MyMobileDimension
{
  static double height = 0;
  static double width = 0;

  static double setWidthScale(
      {required BuildContext context,
        required double mediumlargeScreen,
        required double tabletScreen,
        required double mobileScreen}) {
    if (MediaQuery.of(context).size.width < 480) {
      return MediaQuery.of(context).size.width * mobileScreen;
    } else if (MediaQuery.of(context).size.width > 480 &&
        MediaQuery.of(context).size.width < 768) {
      return MediaQuery.of(context).size.width * tabletScreen;
    } else
    {
      return MediaQuery.of(context).size.width * mediumlargeScreen;
    }
  }


  static double setWidth(
      {required BuildContext context,
        required double mediumlargeScreen,
        required double tabletScreen,
        required double mobileScreen}) {
    if (MediaQuery.of(context).size.width < 480) {
      return MediaQuery.of(context).size.width * mobileScreen;
    } else if (MediaQuery.of(context).size.width > 480 &&
        MediaQuery.of(context).size.width < 768) {
      return MediaQuery.of(context).size.width * tabletScreen;
    } else{
      return MediaQuery.of(context).size.width * mediumlargeScreen;
    }
  }

  static double setHeightScale(
      {required BuildContext context,
        required double mediumlargeScreen,
        required double tabletScreen,
        required double mobileScreen}) {
    if (MediaQuery.of(context).size.width < 480) {
      return MediaQuery.of(context).size.width * mobileScreen;
    } else if (MediaQuery.of(context).size.width > 480 && MediaQuery.of(context).size.width < 768) {
      return MediaQuery.of(context).size.width * tabletScreen;
    } else {
      return MediaQuery.of(context).size.height * mediumlargeScreen;
    }
  }


  static double setHeight(
      {required BuildContext context,
        required double mediumlargeScreen,
        required double tabletScreen,
        required double mobileScreen}) {
    if (MediaQuery.of(context).size.width < 480) {
      return MyDimension.height * mobileScreen;
    } else if (MediaQuery.of(context).size.width > 480 && MediaQuery.of(context).size.width < 768) {
      return MyDimension.height * tabletScreen;
    } else {
      return MyDimension.height * mediumlargeScreen;
    }
  }
}