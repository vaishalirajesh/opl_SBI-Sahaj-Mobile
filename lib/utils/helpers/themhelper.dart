import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/themes/pnbthems.dart';

import 'myfonts.dart';

class ThemeHelper {
  static ThemeData? theme;

  static void setTheme(ThemeData themeData) {
    theme = themeData;
  }

  static ThemeData? getInstance() {
    if (theme != null) {
      return theme;
    } else {
      return PnbThemes.pnbThemeMobile;
    }
  }

  static TextStyle setSemiboldFontMidium(Color color,double fontSize,String fontFamily){
    return TextStyle(color: color,fontSize: fontSize,fontFamily:fontFamily,);
  }
static ButtonStyle setDisableButtonSmall(){
    return ThemeHelper.getInstance()!
        .elevatedButtonTheme
        .style!
        .copyWith(
        foregroundColor:
        MaterialStateProperty.all(
            ThemeHelper.getInstance()!.colorScheme.primary),
        backgroundColor:
        MaterialStateProperty.all(
            ThemeHelper.getInstance()!.colorScheme.secondary),
        textStyle:
        MaterialStateProperty.all(
          TextStyle(fontSize: 12.sp,fontFamily: MyFont.Nunito_Sans_Bold),

        ));
}


  static ButtonStyle setDisableButtonBig(){
    return ThemeHelper.getInstance()!
        .elevatedButtonTheme
        .style!
        .copyWith(
        foregroundColor:
        MaterialStateProperty.all(
            ThemeHelper.getInstance()!.backgroundColor),
        backgroundColor:
        MaterialStateProperty.all(
            ThemeHelper.getInstance()!.colorScheme.secondary),
        textStyle:
        MaterialStateProperty.all(
          TextStyle(fontSize: 16.sp,fontFamily: MyFont.Roboto_Medium),

        ));
  }


  static ButtonStyle setPinkDisableButtonBig(){
    return ThemeHelper.getInstance()!
        .elevatedButtonTheme
        .style!
        .copyWith(
        foregroundColor:
        MaterialStateProperty.all(
            MyColors.white),
        backgroundColor:
        MaterialStateProperty.all(
            MyColorsSBI.sbicolorDisableColor),
        textStyle:
        MaterialStateProperty.all(
          TextStyle(fontSize: 16.sp,fontFamily: MyFont.Nunito_Sans_Bold),

        ));
  }




}
