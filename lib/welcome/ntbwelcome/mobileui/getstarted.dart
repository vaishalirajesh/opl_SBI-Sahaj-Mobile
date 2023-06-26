import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/util/jumpingdot_util.dart';
import 'package:gstmobileservices/util/tg_flavor.dart';
import 'package:sbi_sahay_1_0/registration/mobile/login/login.dart';
import 'package:sbi_sahay_1_0/registration/mobile/signupdetails/signup.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/Utils.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/strings/strings.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return const SafeArea(child: GetStarted());
      },
    );
  }
}

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  bool isLoaderStart = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: AbsorbPointer(
          absorbing: isLoaderStart,
          child: ListView(
            children: [
              pNBLogo(),
              sahayLogo(),
              cardViewSetup(),
            ],
          ),
        ),
        bottomNavigationBar: AbsorbPointer(
          absorbing: isLoaderStart,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 10.h,
              ),
              getStartedBTN(context),
              SizedBox(
                height: 5.h,
              ),
              loginButton(context),
              SizedBox(
                height: 15.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getStartedBTN(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 5.h),
      child: isLoaderStart
          ? SizedBox(
              height: 50.h,
              child: JumpingDots(
                color: ThemeHelper.getInstance()?.primaryColor ??
                    MyColors.pnbcolorPrimary,
                radius: 10,
              ),
            )
          : AppButton(
              onPress: () {
                setState(() {
                  isLoaderStart = true;
                });
                Future.delayed(const Duration(seconds: 2), () {
                  TGLog.d('Bank name--${TGFlavor.param("bankName")}');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpView(),
                    ),
                  );
                  setState(() {
                    isLoaderStart = false;
                  });
                });

                // Navigator.pushNamed(context, MyRoutes.EnableGstApiRoutes);
              },
              title: str_get_started,
            ),
    );
  }
}

Widget sahayLogo() {
  return Padding(
    padding: EdgeInsets.only(bottom: 45.h),
    child: Center(
      child: SvgPicture.asset(
        Utils.path(IMG_SAHAY_LOGO),
        height: 110,
        width: 150,
        allowDrawingOutsideViewBox: true,
        //color: Colors.black,
      ),
    ),
  );
}

Widget pNBLogo() {
  return Padding(
    padding: EdgeInsets.only(top: 60.h, bottom: 40.h),
    child: Center(
      child: SvgPicture.asset(
        Utils.path(BANKLOGOSQUARE),
        width: 180.w,
        height: 35.h,
      ),
    ),
  );
}

Widget cardViewSetup() {
  return Container(
    // height: 200.h,
    padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 20.r),
    margin: EdgeInsets.only(bottom: 50.h, left: 20.w, right: 20.w),
    decoration: BoxDecoration(
      color: ThemeHelper.getInstance()!.cardColor,
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
    ),
    child: Center(
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: str_gst_sahay,
                style: ThemeHelper.getInstance()!.textTheme.headline1!.copyWith(
                    fontSize: 22.sp, color: MyColors.pnbsmallbodyTextColor),
              ),
              TextSpan(
                text: str_disc,
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .displayMedium!
                    .copyWith(fontSize: 22.sp),
              ),
              TextSpan(
                recognizer: new TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri.parse(
                        "https://www.youtube.com/watch?v=vcxK5Ppd4R4"));
                  },
                text: strVideo,
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .displayMedium!
                    .copyWith(
                        color: MyColors.hyperlinkcolornew,
                        decoration: TextDecoration.underline,
                        fontSize: 22.sp),
              ),
              TextSpan(
                text: strLast,
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .displayMedium!
                    .copyWith(fontSize: 22.sp),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget loginButton(BuildContext context) {
  return TextButton(
    onPressed: () {
      //action
    },
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
              text: str_all_have_acc,
              style: ThemeHelper.getInstance()!.textTheme.headline3),
          TextSpan(
              text: str_logintc,
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .displayMedium!
                  .copyWith(fontSize: 14.sp, color: MyColors.hyperlinkcolornew),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  TGLog.d("On tap login");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginWithMobileNumber(),
                    ),
                  );
                }),
        ],
      ),
    ),
  );
}
