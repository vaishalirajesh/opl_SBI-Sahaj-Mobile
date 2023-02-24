import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/dimenutils/dimensutils.dart';
import 'package:sbi_sahay_1_0/utils/helpers/texthelper.dart';

import '../utils/colorutils/mycolors.dart';

// Widget StepperUI(BuildContext context) {
//   var currentStage = Utils.getStepperStage();
//
//   return Container(
//     color: MyColors.stepperUIBgColor,
//     height: MyDimension.height*0.116,
//     child: Padding(
//       padding: EdgeInsets.symmetric(vertical: MyDimension.height*0.037, horizontal:MediaQuery.of(context).size.width*0.151),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           StepperGradientBoxUI(context, currentStage, "Registration"),
//           StepperGradientBoxUI(context, currentStage, "Loan Approval Process"),
//           StepperGradientBoxUI(context, currentStage, "Documentation"),
//           StepperGradientBoxUI(context, currentStage, "Loan Disbursed"),
//         ],
//       ),
//     ),
//   );
// }
//
// Widget StepperGradientBoxUI(
//     BuildContext context, String currentStage, String title) {
//   return Container(
//     width: MediaQuery.of(context).size.width*0.130,
//     height:MyDimension.height*0.042,
//     decoration: BoxDecoration(
//         gradient: LinearGradient(
//             colors: title == currentStage
//                 ? [MyColors.white, MyColors.white]
//                 : [MyColors.colorPrimary, MyColors.colorSecondary],
//             begin: Alignment(-1.0, -2.0),
//             end: Alignment(1.0, 2.0)),
//         border: Border.all(
//             color: title == currentStage
//                 ? MyColors.stepperUIColor
//                 : Colors.transparent,
//             width: 1.w)),
//     child: Center(
//       child: Text(
//         title,
//         style: MyCustomTextStyle.getMediumText(
//             title == currentStage ? MyColors.stepperUIColor : MyColors.white,
//             MyDimension.height*0.014),
//       ),
//     ),
//   );
// }
