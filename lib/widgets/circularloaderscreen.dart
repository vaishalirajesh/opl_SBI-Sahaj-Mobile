import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:sbi_sahay_1_0/utils/dimenutils/dimensutils.dart';
import 'package:sbi_sahay_1_0/utils/imagepathutils/myimagepath.dart';
import 'package:sbi_sahay_1_0/utils/helpers/texthelper.dart';

import '../config/webappconfigWidgets.dart';
import '../utils/colorutils/mycolors.dart';
import '../utils/constants/imageconstant.dart';

// Widget CircularLoaderUI(BuildContext context,String title,String desc)
// {
//   var appConfig=WebAppConfig.of(context);
//   return Container(
//     height: MyDimension.getFullScreenHeight(),
//     width: MyDimension.getFullScreenWidth(),
//     color: Colors.black.withOpacity(0.4),
//     child: Center(
//       child: Container(
//         width: MyDimension.getPerWidth(context: context, webper: 0.130, tabletper: 0.130, mobileper: 0.130), //250.w,
//         height: MyDimension.getPerHeight(context: context, webper: 0.231, tabletper: 0.231, mobileper: 0.231) ,//250.h,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Lottie.asset( MyImagePath(imagebaseurl: appConfig!.asstesPath).getImageUrl(CIRCULARPROGRESSBAR),
//                 height: MyDimension.getPerHeight(context: context, webper: 0.088, tabletper: 0.088, mobileper:0.088) ,//80.w,
//                 width: MyDimension.getPerWidth(context: context, webper: 0.041, tabletper: 0.041, mobileper: 0.041),//80.w,
//                 repeat: true,
//                 reverse: false,
//                 animate: true,
//                 frameRate: FrameRate.max,
//                 fit: BoxFit.fill
//             ),
//             Padding(
//                 padding: EdgeInsets.only(top: MyDimension.getPerHeight(context: context, webper: 0.027, tabletper: 0.027, mobileper: 0.027),bottom:  MyDimension.getPerHeight(context: context, webper: 0.013, tabletper: 0.013, mobileper: 0.013)),
//                 child: Expanded(child: Text(title,style: MyCustomTextStyle.getRegularText(MyColors.white, MyDimension.getPerHeight(context: context, webper: 0.016, tabletper: 0.016, mobileper: 0.016)),maxLines: 4,textAlign: TextAlign.center,)),
//             ),
//             Expanded(child: Text(desc,style: MyCustomTextStyle.getRegularText(MyColors.white, MyDimension.getPerHeight(context: context, webper: 0.014, tabletper: 0.014, mobileper: 0.014)),maxLines: 2,textAlign: TextAlign.center)),
//           ],
//         ),
//       ),
//     ),
//   );
// }



