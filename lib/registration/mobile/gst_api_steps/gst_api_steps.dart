import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/Utils.dart';
import '../../../utils/colorutils/mycolors.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/helpers/themhelper.dart';
import '../../../utils/strings/strings.dart';

class GstApiSteps extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GstApiStepsState();
}

class _GstApiStepsState extends State<GstApiSteps> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: SafeArea(
          child: Scaffold(
        backgroundColor: MyColors.greyBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.h),
          child: Container(
            height: 80.h,
            decoration: BoxDecoration(color: ThemeHelper.getInstance()!.colorScheme.background, boxShadow: [
              BoxShadow(
                color: ThemeHelper.getInstance()!.dividerColor,
                offset: const Offset(0, 2.0),
                blurRadius: 4.0,
              )
            ]),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20.w,
                  ),
                  Icon(
                    Icons.close,
                    size: 25.h,
                    color: MyColors.black,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    "Steps",
                    style: ThemeHelper.getInstance()?.textTheme.displayLarge?.copyWith(color: MyColors.black),
                  )
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: ThemeHelper.getInstance()!.colorScheme.background,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppUtils.path(SAHAYLOGO),
                        height: 40.h,
                        width: 70.w,
                      ),
                      Icon(
                        Icons.search_rounded,
                        size: 30.h,
                        color: MyColors.PnbGrayTextColor,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      str_enable_gst_api,
                      style: ThemeHelper.getInstance()?.textTheme.headline2?.copyWith(color: MyColors.darkblack),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    _apiStepUi(str_gst_api_step1),
                    SizedBox(
                      height: 20.h,
                    ),
                    _apiStepUi(str_gst_api_step2),
                    SizedBox(
                      height: 20.h,
                    ),
                    _apiStepUi(str_gst_api_step3),
                    SizedBox(
                      height: 20.h,
                    ),
                    _apiStepUi(str_gst_api_step4),
                    SizedBox(
                      height: 20.h,
                    ),
                    _apiStepUi(str_gst_api_step5),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget _apiStepUi(String step) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          str_ol,
          style: ThemeHelper.getInstance()?.textTheme.subtitle1?.copyWith(color: MyColors.pnbsmallbodyTextColor),
        ),
        SizedBox(
          width: 5.w,
        ),
        Flexible(
            child: Text(
          step,
          style: ThemeHelper.getInstance()?.textTheme.subtitle1?.copyWith(color: MyColors.pnbsmallbodyTextColor),
        )),
      ],
    );
  }
}
