import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';

TextStyle? textTextHeader1 = ThemeHelper.getInstance()!.textTheme.headline1;

TextStyle? textTextHeader3 = ThemeHelper.getInstance()!.textTheme.headline3;
TextStyle? textTextHeader2Copywith16 =
    ThemeHelper.getInstance()!.textTheme.headline2!.copyWith(fontSize: 16.sp);
TextStyle? textTextHeader1Copywith14 =
    ThemeHelper.getInstance()!.textTheme.headline1!.copyWith(fontSize: 14.sp);
TextStyle? textTextHeader3Copywith11 =
    ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 11.sp);
