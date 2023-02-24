import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sbi_sahay_1_0/utils/dimenutils/dimensutils.dart';
import 'package:sbi_sahay_1_0/utils/imagepathutils/myimagepath.dart';
import 'package:sbi_sahay_1_0/utils/helpers/texthelper.dart';

import '../../config/webappconfigWidgets.dart';
import '../../utils/colorutils/mycolors.dart';
import '../../utils/constants/imageconstant.dart';
import '../../utils/strings/strings.dart';


// Widget LogoutDialogUI(BuildContext context) {
//
//   var appconfing=WebAppConfig.of(context);
//   return Container(
//     height: MyDimension.getFullScreenHeight(),
//     width: MyDimension.getFullScreenWidth(),
//     color: Colors.black.withOpacity(0.4),
//     child: Center(
//       child: Container(
//         color: MyColors.white,
//         height: 255.w,
//         width: 435.w,
//         child: Padding(
//           padding: EdgeInsets.symmetric(vertical: 40.w, horizontal: 30.w),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SvgPicture.asset(
//                 MyImagePath(imagebaseurl: appconfing!.asstesPath).getImageUrl(LOGOUT),
//                 height: 50.w,
//                 width: 50.w,
//               ),
//               Padding(
//                 padding: EdgeInsets.only(top: 20.w, bottom: 30.w),
//                 child: Text(
//                 LOGOUTTEXT,
//                   style: MyCustomTextStyle.getMediumText(
//                       MyColors.darkTextColor, 16.w),
//                 ),
//               ),
//               DialogButtonUi(context)
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
//
// Widget DialogButtonUi(BuildContext context) {
//   var appconfing=WebAppConfig.of(context);
//   return Container(
//     height: 40.w,
//     child: Row(
//       mainAxisSize: MainAxisSize.max,
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Flexible(
//           flex: 1,
//           child: Padding(
//             padding: EdgeInsets.only(right: 5.w),
//             child: GestureDetector(
//                 child: Container(
//                   decoration: BoxDecoration(color: MyColors.colorAccent,border: Border.all(color: MyColors.colorAccent,width: 1.w)),
//                   child: Center(
//                     child: Text(YES,
//                         style: MyCustomTextStyle.getMediumText(
//                             MyColors.white, 16.w)),
//                   ),
//                 ),
//                 onTap: () {
//
//                 }),
//           ),
//         ),
//         /*SizedBox(width: 10.w,),*/
//         Flexible(
//           flex: 1,
//           child: Padding(
//               padding: EdgeInsets.only(left: 5.w),
//               child: GestureDetector(
//                   child: Container(
//                   //  decoration: BoxDecoration(color: MyColors.white,border: Border.all(color: MyColors.colorAccent,width: 1.w)),
//                     child: Center(
//                       child: Text(""),
//                     ),
//                   ),
//                   onTap: () {
//                       Navigator.pop(context);
//                   })
//           ),
//         )
//       ],
//     ),
//   );
// }


