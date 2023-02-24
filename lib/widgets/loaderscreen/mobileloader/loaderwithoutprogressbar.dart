import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:sbi_sahay_1_0/utils/dimenutils/dimensutils.dart';

import '../../../utils/colorutils/mycolors.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/helpers/themhelper.dart';

Widget MobileLoaderWithoutProgess(BuildContext context,String animation,String title,String subTitle)
{
  return Container(
    decoration: BoxDecoration(
        gradient: LinearGradient(colors: [MyColors.pnbPinkColor,
          ThemeHelper.getInstance()!.backgroundColor
        ], begin: Alignment.bottomCenter, end: Alignment.centerLeft)),
    height : MyDimension.getFullScreenHeight(),
    width: MyDimension.getFullScreenWidth(),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
                children: [
                 Image.asset(height: 180.h,width: 180.w,animation,),
                  // Lottie.asset(LOANOFFERLOADER1,
                  //     height: 250.h ,//80.w,
                  //     width: 250.w,//80.w,
                  //     repeat: true,
                  //     reverse: false,
                  //     animate: true,
                  //     frameRate: FrameRate.max,
                  //     fit: BoxFit.fill
                  // ),
                  Text(title,style: ThemeHelper.getInstance()?.textTheme.headline1,textAlign: TextAlign.center,maxLines: 3,),
                  SizedBox(height: 10.h),
                  Text(subTitle,style: ThemeHelper.getInstance()?.textTheme.headline3,textAlign: TextAlign.center,maxLines: 10,),
                ],
              ),


          ],

        ),
    ),
  );
}
