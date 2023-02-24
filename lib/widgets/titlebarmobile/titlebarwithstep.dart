import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbi_sahay_1_0/utils/imagepathutils/myimagepath.dart';
import 'package:sbi_sahay_1_0/utils/helpers/texthelper.dart';

import '../../config/webappconfigWidgets.dart';
import '../../utils/colorutils/mycolors.dart';
import '../../utils/dimenutils/dimensutils.dart';
import '../../utils/constants/imageconstant.dart';

// Widget StepTitleBarView(BuildContext context, String step, String title, double progress) {
//
//   var appConfig=WebAppConfig.of(context);
//   return SizedBox(
//     height: MyDimension.setHeight(
//         context: context,
//         largerScreen: 0.089,
//         mediumlargeScreen: 0.089,
//         tabletScreen: 0.089,
//         mobileScreen: 0.089),
//     child: Card(
//       margin: EdgeInsets.zero,
//       shape: BeveledRectangleBorder(),
//       borderOnForeground: false,
//       elevation: 5.0,
//       shadowColor: MyColors.stepperUICardShadow,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(),
//           Padding(
//             padding: EdgeInsets.symmetric(
//                 horizontal: MyDimension.setWidthScale(
//                     context: context,
//                     largerScreen: 0.051,
//                     mediumlargeScreen: 0.051,
//                     tabletScreen: 0.051,
//                     mobileScreen: 0.051)
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     GestureDetector(
//                       child: SvgPicture.asset(
//                           MyImagePath(imagebaseurl: appConfig!.asstesPath).getImageUrl(MOBILEBACKBTN),
//                         height: MyDimension.setHeight(
//                             context: context,
//                             largerScreen: 0.016,
//                             mediumlargeScreen: 0.016,
//                             tabletScreen: 0.016,
//                             mobileScreen: 0.016),
//                         width: MyDimension.setHeight(
//                             context: context,
//                             largerScreen: 0.036,
//                             mediumlargeScreen: 0.036,
//                             tabletScreen: 0.036,
//                             mobileScreen: 0.036)
//                       ),
//                       onTap: () {},
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(
//                           left: MyDimension.setWidthScale(
//                               context: context,
//                               largerScreen: 0.064,
//                               mediumlargeScreen: 0.064,
//                               tabletScreen: 0.064,
//                               mobileScreen: 0.064)
//                       ),
//                       child: Container(
//                           width: MyDimension.setHeight(
//                               context: context,
//                               largerScreen: 0.028,
//                               mediumlargeScreen: 0.028,
//                               tabletScreen: 0.028,
//                               mobileScreen: 0.028),
//                           height: MyDimension.setHeight(
//                               context: context,
//                               largerScreen: 0.028,
//                               mediumlargeScreen: 0.028,
//                               tabletScreen: 0.028,
//                               mobileScreen: 0.028),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),color: MyColors.stepperUIBgColor,boxShadow: [BoxShadow(color: MyColors.colorAccent,spreadRadius: 1.0)]),
//                           child: Center(
//                             child: Text(step,
//                                 style: MyCustomTextStyle.getRegularText(MyColors.colorPrimary, MyDimension.setFontsize(context: context, largerScreen: 14, mediumlargeScreen: 14, tabletScreen: 14, mobileScreen: 14))),
//                           )),
//                     ),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//
//                         Padding(
//                           padding: EdgeInsets.only(left: MyDimension.setWidthScale(
//                               context: context,
//                               largerScreen: 0.026,
//                               mediumlargeScreen: 0.026,
//                               tabletScreen: 0.026,
//                               mobileScreen: 0.026)),
//                           child: Text(title,style: MyCustomTextStyle.getMediumText(MyColors.darkTextColor, MyDimension.setFontsize(context: context, largerScreen: 16, mediumlargeScreen: 16, tabletScreen: 16, mobileScreen: 16))),
//                         )  ,
//                         Padding(
//                           padding: EdgeInsets.only(left: MyDimension.setWidthScale(
//                               context: context,
//                               largerScreen: 0.013,
//                               mediumlargeScreen: 0.013,
//                               tabletScreen: 0.013,
//                               mobileScreen: 0.013)),
//                           child: Icon(Icons.arrow_drop_down,size: MyDimension.setHeight(
//                               context: context,
//                               largerScreen: 0.022,
//                               mediumlargeScreen: 0.022,
//                               tabletScreen: 0.022,
//                               mobileScreen: 0.022),),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(right: 4.w),
//                       child: SvgPicture.asset(
//                         MyImagePath(imagebaseurl: appConfig!.asstesPath).getImageUrl(SMALLBANKLOGO),
//                         height:MyDimension.setHeight(
//                             context: context,
//                             largerScreen: 0.028,
//                             mediumlargeScreen: 0.028,
//                             tabletScreen: 0.028,
//                             mobileScreen: 0.028),
//                         width:MyDimension.setHeight(
//                             context: context,
//                             largerScreen: 0.028,
//                             mediumlargeScreen: 0.028,
//                             tabletScreen: 0.028,
//                             mobileScreen: 0.028),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(left: MyDimension.setWidthScale(
//                           context: context,
//                           largerScreen: 0.010,
//                           mediumlargeScreen: 0.010,
//                           tabletScreen: 0.010,
//                           mobileScreen: 0.010)),
//                       child: SvgPicture.asset(
//                         MyImagePath(imagebaseurl: appConfig!.asstesPath).getImageUrl(MOBILESAHAYLOGO),
//                         height:MyDimension.setHeight(
//                             context: context,
//                             largerScreen: 0.028,
//                             mediumlargeScreen: 0.028,
//                             tabletScreen: 0.028,
//                             mobileScreen: 0.028),
//                         width:MyDimension.setHeight(
//                             context: context,
//                             largerScreen: 0.028,
//                             mediumlargeScreen: 0.028,
//                             tabletScreen: 0.028,
//                             mobileScreen: 0.028),
//                       ),
//                     ),
//                   ],
//                 ),
//
//               ],
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomLeft,
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               child: LinearProgressIndicator(value: progress,
//                   semanticsLabel: 'Processing...',
//                   minHeight: MyDimension.setHeight(
//                       context: context,
//                       largerScreen: 0.003,
//                       mediumlargeScreen: 0.003,
//                       tabletScreen: 0.003,
//                       mobileScreen: 0.003),
//                   color: MyColors.colorAccent,
//                   backgroundColor: Colors.transparent),
//             ),
//           )
//         ],
//       ),
//     ),
//   );
// }