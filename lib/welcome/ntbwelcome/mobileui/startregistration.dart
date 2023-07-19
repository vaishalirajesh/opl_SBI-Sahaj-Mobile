import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbi_sahay_1_0/registration/mobile/gst_consent_of_gst/gst_consent_of_gst.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';

import '../../../utils/Utils.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/strings/strings.dart';

class StartRegistrationNtb extends StatelessWidget {
  const StartRegistrationNtb({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return const SafeArea(
          child: StartRegistrationNtbScreen(),
        );
      },
    );
  }
}

class StartRegistrationNtbScreen extends StatelessWidget {
  const StartRegistrationNtbScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        SystemNavigator.pop(animated: true);
        return true;
      },
      child: Scaffold(
        appBar: getAppBarWithBackBtn(
            onClickAction: () => {Navigator.pop(context, false), SystemNavigator.pop(animated: true)}),
        body: buildSetupView(context),
        bottomNavigationBar: buildBTNStartStartRegistration(context),
      ),
    );
  }

  Widget buildSetupView(BuildContext context) {
    //appbar_check_icon.svg
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildThankForConfirmingText(str_Thanks_for_confirming),
          buildGSTConfirmNTBDiscText(str_gst_confirm_NTBdisc),
          Container(
            padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
            margin: EdgeInsets.symmetric(horizontal: 20.r),
            decoration:
                BoxDecoration(color: ThemeHelper.getInstance()!.cardColor, borderRadius: BorderRadius.circular(6.r)),
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                buildImageWidget(MOBILESTEPDONE),
                SizedBox(
                  height: 10.h,
                ),
                buildCenterCard(str_Verify_Mobile_Number),
                buildCenterCard(str_Verify_gst_details),
                buildCenterCard(str_accept_tc),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImageWidget(String path) => SvgPicture.asset(
        AppUtils.path(path),
        height: 200.h,
        width: 200.w,
      );

  Widget buildThankForConfirmingText(String text) => Padding(
        padding: EdgeInsets.only(top: 30.0.h, bottom: 5.h, left: 24.w),
        child: Text(
          text,
          style: ThemeHelper.getInstance()!.textTheme.headline2!.copyWith(fontSize: 18.sp),
        ),
      );

  Widget buildGSTConfirmNTBDiscText(String text) => Padding(
        padding: EdgeInsets.only(left: 24.w, bottom: 30.h),
        child: Text(
          text,
          style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp),
          textAlign: TextAlign.center,
        ),
      );

  Widget buildCenterCard(String stepname) {
    return Padding(
      padding: EdgeInsets.only(left: 30.w, right: 30.w, bottom: 20.h),
      child: Container(
        decoration: BoxDecoration(
            color: ThemeHelper.getInstance()!.colorScheme.background, borderRadius: BorderRadius.circular(6.r)),
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, top: 15.h, bottom: 15.h),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: ThemeHelper.getInstance()!.colorScheme.primary),
                    height: 13.w,
                    width: 13.w,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: ThemeHelper.getInstance()!.backgroundColor,
                      size: 8.w,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Flexible(child: Text(stepname, style: ThemeHelper.getInstance()!.textTheme.headline3))
                ],
              )
              //ButtonUI(context, str_verify_mobile_no),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBTNStartStartRegistration(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20).w,
      child: AppButton(
        onPress: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GstConsent(),
            ),
          );
        },
        title: str_Start_Registration,
      ),
    );
  }
}
