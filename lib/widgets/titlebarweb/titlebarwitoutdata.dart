import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/dimenutils/dimensutils.dart';
import 'package:sbi_sahay_1_0/utils/imagepathutils/myimagepath.dart';
import 'package:sbi_sahay_1_0/utils/helpers/texthelper.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarweb/sahajnamebar.dart';

import '../../config/webappconfigWidgets.dart';
import '../../utils/colorutils/mycolors.dart';
import '../../utils/constants/imageconstant.dart';

// Widget TitlebarWithoutData(BuildContext context) {
//   var appConfig=WebAppConfig.of(context);
//   return Container(
//     color: MyColors.white,
//     width: MyDimension.setWidthScale(context: context, largerScreen: 1, mediumlargeScreen: 1, tabletScreen: 1, mobileScreen: 1),
//     child: Stack(
//       children: [
//         getStepName(context),
//         Container(
//           width: MyDimension.width,
//           height: MyDimension.getTitbarHeight(context),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: MyDimension.setWidthScale(context: context, largerScreen: 0.073, mediumlargeScreen: 0.039, tabletScreen: 0.029, mobileScreen: 0.018)),
//             child:  Row(
//               mainAxisAlignment:MediaQuery.of(context).size.width>480? MainAxisAlignment.spaceBetween:MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SvgPicture.asset(MyImagePath(imagebaseurl: appConfig!.asstesPath).getImageUrl(LOGO),
//                   width: MyDimension.setHeight(
//                       context: context,
//                       largerScreen: 0.333,
//                       mediumlargeScreen: 0.315,
//                       tabletScreen: 0.236,
//                       mobileScreen: 0.148),
//                   height: MyDimension.setHeight(
//                       context: context,
//                       largerScreen: 0.044,
//                       mediumlargeScreen: 0.042,
//                       tabletScreen: 0.032,
//                       mobileScreen: 0.020),
//                 ),
//                 SizedBox(width: MyDimension.setWidthScale(context: context, largerScreen: 0, mediumlargeScreen: 0, tabletScreen: 0, mobileScreen: 0.020)),
//                 Image.asset(Utils.path(MyImagePath(imagebaseurl: appConfig!.asstesPath).getImageUrl(SBISAHAJLOGO)),
//
//                   width: MyDimension.setHeight(
//                       context: context,
//                       largerScreen: 0.059,
//                       mediumlargeScreen: 0.059,
//                       tabletScreen: 0.059,
//                       mobileScreen: 0.045),
//                   height: MyDimension.setHeight(
//                       context: context,
//                       largerScreen: 0.059,
//                       mediumlargeScreen: 0.059,
//                       tabletScreen: 0.059,
//                       mobileScreen: 0.045),
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//       ],
//     ),
//   );
//
//
//
// }
//
//
// Widget getStepName(BuildContext context){
//
//
//   if(MediaQuery.of(context).size.width<480){
//     return Row(
//       children: [
//         SizedBox(width: MyDimension.setWidthScale(context: context, largerScreen: 0, mediumlargeScreen: 0, tabletScreen: 0, mobileScreen: 0.020)),
//
//         Padding(
//           padding:  EdgeInsets.symmetric(vertical: MyDimension.setHeight(context: context, largerScreen: 0, mediumlargeScreen: 0, tabletScreen: 0, mobileScreen: 0.035),horizontal: 0),
//           child: Text(Utils.getStepperStage(),style: MyCustomTextStyle.getBoldText(MyColors.darkTextColor, MyDimension.setFontsize(context: context, largerScreen: 0, mediumlargeScreen: 0, tabletScreen: 0, mobileScreen: 12)),),
//         ),
//
//       ],
//     );
//   }else{
//     return Container();
//   }
//
// }
