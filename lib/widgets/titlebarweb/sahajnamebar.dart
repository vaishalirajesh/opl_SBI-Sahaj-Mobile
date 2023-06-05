import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/dimenutils/dimensutils.dart';


import '../../config/webappconfigWidgets.dart';
import '../../utils/strings/strings.dart';
import '../../utils/helpers/texthelper.dart';
//
// Widget SahajNameBar(BuildContext context)
// {
//   var appConfig=WebAppConfig.of(context);
//   return Container(
//     height: MyDimension.setHeight(context: context, largerScreen: 0.042, mediumlargeScreen: 0.042, tabletScreen: 0.042, mobileScreen: 0.042),
//     width: MyDimension.setWidthScale(context: context, largerScreen: 1, mediumlargeScreen: 1, tabletScreen: 1, mobileScreen: 1),
//     // decoration: BoxDecoration(
//     //   gradient: LinearGradient(colors: [appConfig!.colorResource.SPALASHLEFTBCK_START,appConfig!.colorResource.SPALASHLEFTBCK_END],begin: Alignment.centerLeft,end: Alignment.center)
//     // ),
//     child: Center(
//       child: Text(SAHAJ,style: MyCustomTextStyle.getRegularText(MyColors.white, MyDimension.setFontsize(context: context, largerScreen: 20, mediumlargeScreen: 18, tabletScreen: 16, mobileScreen: 12))),
//     ),
//   );
// }