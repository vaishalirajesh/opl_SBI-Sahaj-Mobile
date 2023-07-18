import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/imageconstant.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';

import '../../../utils/constants/prefrenceconstants.dart';
import '../../../utils/jumpingdott.dart';
import '../../../utils/strings/strings.dart';
import '../../../welcome/termscondition/mobile/termscondition.dart';
import '../../../widgets/titlebarmobile/titlebarwithoutstep.dart';
import '../gst_consent_of_gst/gst_consent_of_gst.dart';
import '../gst_detail/gst_detail.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WelcomePageScreen();
  }
}

class WelcomePageScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WelcomePageScreenState();
}

class _WelcomePageScreenState extends State<WelcomePageScreen> {
  bool isLoaderStart = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop(animated: true);
        return true;
      },
      child: SafeArea(
          child: Scaffold(
        appBar: getAppBarWithBackBtn(onClickAction: () => {SystemNavigator.pop(animated: true)}),
        body: AbsorbPointer(
          absorbing: isLoaderStart,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    str_welcome_pnb,
                    style: ThemeHelper.getInstance()?.textTheme.headline1?.copyWith(fontSize: 20.sp),
                  ),
                  SizedBox(height: 10.h),
                  Text(str_keep_data_ready, style: ThemeHelper.getInstance()?.textTheme.bodyText2),
                  SizedBox(
                    height: 20.h,
                  ),
                  schemeDataContainer(),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    str_undertaking,
                    style: ThemeHelper.getInstance()?.textTheme.bodyText1?.copyWith(color: Colors.black),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  undertakingDataRow(str_undertaking_text1),
                  SizedBox(
                    height: 10.h,
                  ),
                  undertakingDataRow(str_undertaking_text2),
                  SizedBox(
                    height: 10.h,
                  ),
                  undertakingDataRow(str_undertaking_text3),
                  SizedBox(
                    height: 10.h,
                  ),
                  undertakingDataRow(str_undertaking_text4),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 90.h,
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 40.h),
            child: continueButton(),
          ),
        ),
      )),
    );
  }

  Widget schemeDataContainer() {
    return Container(
      decoration: BoxDecoration(
          color: ThemeHelper.getInstance()?.colorScheme.secondary,
          borderRadius: BorderRadius.all(Radius.circular(27.w))),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.all(20.h),
        child: Column(
          children: [
            schemeDataRow(AppUtils.path(MOBILE_GST_LOGIN), str_gst_login_detail),
            Padding(
              padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
              child: Divider(
                color: MyColors.pnbWelcomeDivider.withOpacity(0.3),
                thickness: 1.h,
              ),
            ),
            schemeDataRow(AppUtils.path(MOBILE_CURRENT_ACC), str_cur_acc_with_pnb),
            Padding(
              padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
              child: Divider(
                color: MyColors.pnbWelcomeDivider.withOpacity(0.3),
                thickness: 1.h,
              ),
            ),
            schemeDataRow(AppUtils.path(MOBILE_KYC_UPDATE), str_mobile_with_otp),
            Padding(
              padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
              child: Divider(
                color: MyColors.pnbWelcomeDivider.withOpacity(0.3),
                thickness: 1.h,
              ),
            ),
            schemeDataRow(AppUtils.path(MOBILE_MOBILE_OTP), str_email_updated_kyc),
          ],
        ),
      ),
    );
  }

  Widget schemeDataRow(String imagePath, String text) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 30.h,
          width: 30.w,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: SvgPicture.asset(
              imagePath,
              height: 12.h,
              width: 12.w,
            ),
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        Flexible(
            child: Text(
          text,
          style: ThemeHelper.getInstance()?.textTheme.headline6?.copyWith(fontSize: 14.sp),
          maxLines: 10,
        ))
      ],
    );
  }

  Widget undertakingDataRow(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          str_ol,
          style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(fontSize: 12.sp),
        ),
        SizedBox(
          width: 5.w,
        ),
        Flexible(
            child: Text(
          title,
          style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(fontSize: 13.sp),
          maxLines: 5,
        )),
      ],
    );
  }

  Widget continueButton() {
    return isLoaderStart
        ? JumpingDots(
            color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary,
            radius: 10,
          )
        : ElevatedButton(
            onPressed: () {
              setState(() {
                isLoaderStart = true;
              });
              _asyncInit();
            },
            child: Text(str_continue),
          );
  }

  _asyncInit() async {
    TGLog.d("WelcomePnb._ayncInit");
    await Future.delayed(Duration(seconds: 5));
    // String? accetoken= await TGSharedPreferences.getInstance().get(PREF_ACCESS_TOKEN);
    bool? isTCDone = await TGSharedPreferences.getInstance().get(PREF_ISTC_DONE);
    bool? isGstConsentDone = await TGSharedPreferences.getInstance().get(PREF_ISGST_CONSENT);
    bool? isGstDetailDone = await TGSharedPreferences.getInstance().get(PREF_ISGSTDETAILDONE);
    bool? isCicConsentDone = await TGSharedPreferences.getInstance().get(PREF_ISCIC_CONSENT);

    setState(() {
      isLoaderStart = false;
    });

    if (isTCDone == null || isTCDone == false) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => TCview(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );

      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TCview()));
    }
    // else if(accetoken == null){
    //
    //
    //   Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (BuildContext context) => LoginWithMobileNumber(),),
    //         (
    //         route) => false, //if you want to disable back feature set to false
    //   );

    //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginWithMobileNumber()));
    //}
    else if (isGstConsentDone == null || isGstConsentDone == false) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => GstConsent(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );

      //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GstConsent()));
    } else if (isGstDetailDone == null || isGstDetailDone == false) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => GstDetailMain(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );

      //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GstDetailMain()));
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => DashboardWithGST(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );

      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardWithGST()));
    }
  }
}
