import 'package:flutter/material.dart';
import 'package:sbi_sahay_1_0/utils/dimenutils/dimension.dart';

class MyDimension {
  MyDimension._();
  static double height = 0;
  static double width = 0;

  static double getFullScreenHeight() {
    return height;
  }

  static double getFullScreenWidth() {
    return width;
  }

  static double getBodyHeight() {
    return height - (titlebarHeight + fotterHeight);
  }

  static double getBodyHeightWithoutFooter() {
    return height - titlebarHeight;
  }

  static double getTitbarHeight(BuildContext context) {
    return MyDimension.setHeight(context: context, largerScreen: 0.090, mediumlargeScreen: 0.090, tabletScreen: 0.090, mobileScreen: 0.090);
  }

  static double getHeightWeb(int height) {
    return double.parse((1080 / height).toStringAsFixed(2));
  }

  static double getPercentageHeight(double per, double fromheight) {
    return fromheight * per;
  }

  static double getPercentageWidth(double per, double fromwidth) {
    return fromwidth * per;
  }


  static double setWidthScale(
      {required BuildContext context,
        required double largerScreen,
        required double mediumlargeScreen,
        required double tabletScreen,
        required double mobileScreen}) {
    if (MediaQuery.of(context).size.width < 480) {
      return MediaQuery.of(context).size.width * mobileScreen;
    } else if (MediaQuery.of(context).size.width > 480 &&
        MediaQuery.of(context).size.width < 768) {
      return MediaQuery.of(context).size.width * tabletScreen;
    } else if (MediaQuery.of(context).size.width > 768 &&
        MediaQuery.of(context).size.width < 1024) {
      return MediaQuery.of(context).size.width * mediumlargeScreen;
    } else {
      return MediaQuery.of(context).size.width * largerScreen;
    }
  }


  static double setWidth(
      {required BuildContext context,
        required double largerScreen,
        required double mediumlargeScreen,
        required double tabletScreen,
        required double mobileScreen}) {
    if (MediaQuery.of(context).size.width < 480) {
      return MediaQuery.of(context).size.width * mobileScreen;
    } else if (MediaQuery.of(context).size.width > 480 &&
        MediaQuery.of(context).size.width < 768) {
      return MediaQuery.of(context).size.width * tabletScreen;
    } else if (MediaQuery.of(context).size.width > 768 &&
        MediaQuery.of(context).size.width < 1024) {
      return MediaQuery.of(context).size.width * mediumlargeScreen;
    } else {
      return MediaQuery.of(context).size.width* largerScreen;
    }
  }

  static double setHeightScale(
      {required BuildContext context,
        required double largerScreen,
        required double mediumlargeScreen,
        required double tabletScreen,
        required double mobileScreen}) {
    if (MediaQuery.of(context).size.width < 480) {
      return MediaQuery.of(context).size.width * mobileScreen;
    } else if (MediaQuery.of(context).size.width > 480 && MediaQuery.of(context).size.width < 768) {
      return MediaQuery.of(context).size.width * tabletScreen;
    } else if (MediaQuery.of(context).size.width > 768 && MediaQuery.of(context).size.width < 1024) {
      return MediaQuery.of(context).size.height * mediumlargeScreen;
    } else {
      return MediaQuery.of(context).size.width * largerScreen;
    }
  }


  static double setHeight(
      {required BuildContext context,
        required double largerScreen,
        required double mediumlargeScreen,
        required double tabletScreen,
        required double mobileScreen }) {
    if (MediaQuery.of(context).size.width < 480) {
      return MyDimension.height * mobileScreen;
    } else if (MediaQuery.of(context).size.width > 480 && MediaQuery.of(context).size.width < 768) {
      return MyDimension.height * tabletScreen;
    } else if (MediaQuery.of(context).size.width > 768 && MediaQuery.of(context).size.width < 1024) {
      return MyDimension.height * mediumlargeScreen;
    } else {
      return MyDimension.height * largerScreen;
    }
  }


  static double setFontsize(
      {required BuildContext context,
        required double largerScreen,
        required double mediumlargeScreen,
        required double tabletScreen,
        required double mobileScreen}) {

    if (MediaQuery.of(context).size.width < 480) {
      return MediaQuery.of(context).textScaleFactor  * mobileScreen;
    } else if (MediaQuery.of(context).size.width > 480 && MediaQuery.of(context).size.width < 768) {
      return MediaQuery.of(context).textScaleFactor * tabletScreen;
    } else if (MediaQuery.of(context).size.width > 768 && MediaQuery.of(context).size.width < 1024) {
      return MediaQuery.of(context).textScaleFactor  * mediumlargeScreen;
    } else {
      return MediaQuery.of(context).textScaleFactor * largerScreen;
    }


  }
















  // //..custom demenision
  static double getPerWidth(
      {required BuildContext context,
      required double webper,
      required double tabletper,
      required double mobileper}) {
    if (MediaQuery.of(context).size.width < 480) {
      return MediaQuery.of(context).size.width * mobileper;
    } else if (MediaQuery.of(context).size.width > 480 &&
        MediaQuery.of(context).size.width < 768) {
      return MediaQuery.of(context).size.width * tabletper;
    } else {
      return MediaQuery.of(context).size.width * webper;
    }
  }

  static double getPerHeight(
      {required BuildContext context,
      required double webper,
      required double tabletper,
      required double mobileper}) {
    if (MediaQuery.of(context).size.height < 480) {
      return height * mobileper;
    } else if (MediaQuery.of(context).size.height > 480 &&
        MediaQuery.of(context).size.height < 768) {
      return height * tabletper;
    } else {
      return height * webper;
    }
  }

  static double getPerFontSize(
      {required BuildContext context,
      required double webper,
      required double tabletper,
      required double mobileper}) {
    if (MediaQuery.of(context).size.height < 480) {
      return height * mobileper;
    } else if (MediaQuery.of(context).size.height > 480 &&
        MediaQuery.of(context).size.height < 768) {
      return height * tabletper;
    } else {
      return height * webper;
    }
  }

  static double getPerFontSize1(
      {required BuildContext context, required dynamic sizeinpixel}) {
    return sizeinpixel * 100 / MediaQuery.of(context).size.width;
  }


}
