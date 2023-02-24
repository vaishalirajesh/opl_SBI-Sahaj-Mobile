import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sbi_sahay_1_0/statefullwrapper.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/constant.dart';
import 'package:sbi_sahay_1_0/utils/constants/myconstant.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/dimenutils/dimensutils.dart';
import 'package:sbi_sahay_1_0/utils/screensize.dart';
import 'package:sbi_sahay_1_0/widgets/stepperui.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarweb/sahajnamebar.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarweb/titlebarwithdata.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarweb/titlebarwitoutdata.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class MainScrren extends StatelessWidget {
//   final bool isTitleBardRequeired;
//   final bool isSahajLineRequired;
//   final bool isDashboardMenuRequired;
//   final bool isStepperMenuRequired;
//   final bool isFooterSpaceRequired;
//   final Widget childWidgets;
//
//   var prefs;
//
//   MainScrren(
//       {required this.isTitleBardRequeired,
//       required this.isSahajLineRequired,
//       required this.isDashboardMenuRequired,
//       required this.isStepperMenuRequired,
//       required this.isFooterSpaceRequired,
//       required this.childWidgets});
//
//   @override
//   Widget build(BuildContext context) {
//     setSceenSize(WEB, context);
//     return LayoutBuilder(builder: (context, constraints) {
//       return Scaffold(
//         body: Container(
//           height: MyDimension.height,
//           color: MyColors.backgroundgrey,
//           child: SingleChildScrollView(
//             child: Column(children: [
//               Titlebar(context),
//               SahajLineBar(context),
//               DashBoardMenu(context),
//               TopSpecinge(context),
//               StepperMenu(context),
//               childWidgets,
//               FooterSpace(context),
//             ]),
//           ),
//         ),
//       );
//     });
//   }
//
//   Widget TopSpecinge(BuildContext context) {
//     if (isTitleBardRequeired) {
//       return SizedBox(height: MyDimension.height * 0.02);
//     } else {
//       return Container();
//     }
//   }
//
//   Widget FooterSpace(BuildContext context) {
//     if (isFooterSpaceRequired) {
//       return SizedBox(height: MyDimension.height * 0.02);
//     } else {
//       return Container();
//     }
//   }
//
//   Widget Titlebar(BuildContext context) {
//     if (isTitleBardRequeired) {
//       if (MyConstant.ISDASHBOARDWITHDATA == true) {
//         return TitleBarWithData(context);
//       } else {
//         return TitlebarWithoutData(context);
//       }
//     } else {
//       return Container();
//     }
//   }
//
//   Widget SahajLineBar(BuildContext context) {
//     if (isSahajLineRequired) {
//       return SahajNameBar(context);
//     } else {
//       return Container();
//     }
//   }
//
//   Widget DashBoardMenu(BuildContext context) {
//     if (isDashboardMenuRequired) {
//       return Container();
//     } else {
//       return Container();
//     }
//   }
//
//   Widget StepperMenu(BuildContext context) {
//     if (isStepperMenuRequired && MediaQuery.of(context).size.width>480) {
//       return Padding(
//           padding: EdgeInsets.only(
//               left: MyDimension.setWidthScale(
//                   context: context,
//                   largerScreen: 0.072,
//                   mediumlargeScreen: 0.072,
//                   tabletScreen: 0.072,
//                   mobileScreen: 0.072),
//               right: MyDimension.setWidthScale(
//                   context: context,
//                   largerScreen: 0.072,
//                   mediumlargeScreen: 0.072,
//                   tabletScreen: 0.072,
//                   mobileScreen: 0.072)),
//           child: StepperUI(context));
//     } else {
//       return Container();
//     }
//   }
// }
