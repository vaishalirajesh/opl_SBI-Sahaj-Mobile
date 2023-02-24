


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../utils/colorutils/mycolors.dart';
import '../../../../utils/dimenutils/dimensutils.dart';
import '../../../../utils/helpers/themhelper.dart';

Widget FetchLoanOfferLoaderWithProgess(BuildContext context,String animation,String title,String subTitle)
{
  return Container(
    decoration: BoxDecoration(
        gradient:LinearGradient(
            colors: [MyColors.pnbPinkColor,
              ThemeHelper.getInstance()!.backgroundColor
            ],
            begin: Alignment.bottomCenter,
            end:Alignment.centerLeft)
    ),
    height : MyDimension.getFullScreenHeight(),
    width: MyDimension.getFullScreenWidth(),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(),
          Column(
            children: [
              Image.asset(height: 250.h,width: 250.w,animation,fit: BoxFit.fill,),
              // Lottie.asset(animation,
              //     height: 250.h ,//80.w,
              //     width: 250.w,//80.w,
              //     repeat: true,
              //     reverse: false,
              //     animate: true,
              //     frameRate: FrameRate.max,
              //     fit: BoxFit.fill
              // ),
              SizedBox(height: 10.h),
              Text(title,style: ThemeHelper.getInstance()?.textTheme.headline1),
              SizedBox(height: 10.h),
              Text(subTitle,style: ThemeHelper.getInstance()?.textTheme.headline3,textAlign: TextAlign.center,maxLines: 10,),
            ],
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 50.h),
            child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Processing...",
                        textAlign: TextAlign.start,
                        style: ThemeHelper.getInstance()?.textTheme.headline6),
                    SizedBox(height: 10.h),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        semanticsLabel: 'Processing...',
                        minHeight : 8.h,
                        color: ThemeHelper.getInstance()?.primaryColor,
                        backgroundColor: ThemeHelper.getInstance()?.colorScheme.secondary,

                      ),
                    )
                  ],
                )
            ),
          ),

        ],
      ),
    ),
  );
}