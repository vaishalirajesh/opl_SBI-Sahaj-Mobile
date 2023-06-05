import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/helpers/myfonts.dart';
import 'package:sbi_sahay_1_0/utils/helpers/texthelper.dart';

class SbiThemes {
  static ThemeData sbiThemeMobile = ThemeData(
      unselectedWidgetColor: MyColors.pnbCheckBoxcolor,
      appBarTheme: AppBarTheme(
          backgroundColor: MyColors.white,
          foregroundColor: MyColors.white,
          elevation: 2,
          toolbarHeight: 60.h,
          titleSpacing: 0,
          titleTextStyle: TextUtils.getFontStyle(MyColors.darkblack, 18.sp, MyFont.Roboto_Medium)),
      primaryColor: MyColors.pnbcolorPrimary,
      primaryColorDark: MyColors.pnbcolorPrimary,
      colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: MyColors.pnbcolorPrimary,
          onPrimary: MyColors.pnbFilterbg,
          secondary: MyColorsSBI.sbicolorDisableColor,
          onSecondary: MyColors.pnbDashboardBackground,
          error: MyColors.errorcolor,
          onError: MyColors.errorcolor,
          background: MyColors.white,
          onBackground: MyColors.pnbContianerColor,
          surface: MyColors.pnbMediumTextcolor,
          onSurface: MyColors.pnbCheckBoxcolor,
          surfaceTint: MyColors.pnbCardBg,
          secondaryContainer: MyColors.lightSKYColor,
          tertiary: MyColors.pnbCardSmallTextColor),
      backgroundColor: MyColors.white,
      cardColor: MyColors.pnbPinkColor,
      splashColor: MyColors.pnbcolorPrimary,
      scaffoldBackgroundColor: MyColors.white,
      dividerColor: MyColors.pnbdivdercolor,
      errorColor: MyColors.errorcolor,
      indicatorColor: MyColors.black,
      shadowColor: MyColors.pnbshadowcolor,
      toggleableActiveColor: MyColors.pnbshadowcolor,
      textTheme: TextTheme(
        caption: TextUtils.getFontStyle(MyColors.white, 17.sp, MyFont.Roboto_Bold),
        headline1: TextUtils.getFontStyle(MyColors.pnbcolorPrimary, 23.sp, MyFont.Roboto_Bold),
        headline2: TextUtils.getFontStyle(MyColors.darkblack, 18.sp, MyFont.Roboto_Medium),
        headline3: TextUtils.getFontStyle(MyColors.pnbsmallbodyTextColor, 16.sp, MyFont.Roboto_Regular),
        headline4: TextUtils.getFontStyle(MyColors.pnbCheckboxTextColor, 13.sp, MyFont.Roboto_Regular),
        headline5: TextUtils.getFontStyle(MyColors.pnbTextcolor, 13.sp, MyFont.Roboto_Medium),
        bodyText1: TextUtils.getFontStyle(MyColors.pnbcolorPrimary, 16.sp, MyFont.Roboto_Bold),
        bodyText2: TextUtils.getFontStyle(MyColors.pnbsmallbodyTextColor, 13.sp, MyFont.Roboto_Regular),
        button: TextUtils.getFontStyle(MyColors.white, 16.sp, MyFont.Roboto_Medium),
        headline6: TextUtils.getFontStyle(MyColors.pnbcolorPrimary, 13.sp, MyFont.Roboto_Bold),
        overline: TextUtils.getFontStyle(MyColors.pnbTextcolor, 12.sp, MyFont.Roboto_Regular),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 45.h),
          textStyle: TextUtils.getFontStyle(MyColors.white, 16.sp, MyFont.Roboto_Medium),
          backgroundColor: MyColors.pnbcolorPrimary,
          foregroundColor: MyColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        side: MaterialStateBorderSide.resolveWith((states) => BorderSide(width: 1.0, color: MyColors.pnbCheckBoxcolor)),
        splashRadius: 50.r,
        overlayColor: MaterialStateProperty.all(MyColors.pnbCheckBoxcolor),
        checkColor: MaterialStateProperty.all(MyColors.white),
        fillColor: MaterialStateProperty.all(MyColors.pnbcolorPrimary),
      ));
}
