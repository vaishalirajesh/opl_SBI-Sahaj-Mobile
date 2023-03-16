import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbi_sahay_1_0/registration/mobile/signupdetails/signup.dart';
import 'package:sbi_sahay_1_0/routes.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';

import '../../../utils/Utils.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/strings/strings.dart';
import '../../../widgets/animation_routes/page_animation.dart';
import 'enablegstapintb.dart';

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

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: ListView(
          children: [

             PNBLogo(),

             SahayLogo(),

            CardViewSetup(),

            GetStartedBTN(context),

            BtnLoginTC()
          ],
        ),
      ),
    );
  }
}

Widget SahayLogo() {
  return Padding(
    padding:  EdgeInsets.only(bottom:45.h),
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

Widget PNBLogo() {
  return
    Padding(
      padding:  EdgeInsets.only(top:60.h,bottom: 40.h),
      child: Center(child:
      SvgPicture.asset(
      Utils.path(BANKLOGOSQUARE),
      width: 180.w,
      height: 35.h,
  )),
    );
}

Widget CardViewSetup() {
  return Padding(
    padding: EdgeInsets.only(left: 20.w, right: 20.w,bottom: 100.h),
    child: Container(
        height: 240.h,
        decoration: BoxDecoration(
          color: ThemeHelper.getInstance()!.cardColor,
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        child: Center(
          child: Padding(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: str_gst_sahay,
                      style: ThemeHelper.getInstance()!
                          .textTheme
                          .headline1!
                          .copyWith(fontSize: 16.sp,color: MyColors.pnbsmallbodyTextColor)),
                  TextSpan(
                      text: str_disc,
                      style: ThemeHelper.getInstance()!.textTheme.headline3),
                  TextSpan(
                      text: strVideo,
                      style: ThemeHelper.getInstance()!
                          .textTheme
                          .headline3!
                          .copyWith(color: MyColors.ligtBlue,decoration:
                      TextDecoration.underline)),
                  TextSpan(
                      text: strLast,
                      style: ThemeHelper.getInstance()!.textTheme.headline3),
                ]),
              ),
              padding: EdgeInsets.only(left: 20.w, right: 20.w)),
        )),
  );
}

Widget GetStartedBTN(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(left: 20.w, right: 20.w,bottom: 5.h),
    child: ElevatedButton(
      onPressed: () {
       // Navigator.push(context, CustomRightToLeftPageRoute(child:EnableGstApi()));
        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpView(),));

        // Navigator.pushNamed(context, MyRoutes.EnableGstApiRoutes);
      },
      child: Text(str_get_started,
          style: ThemeHelper.getInstance()!.textTheme.button),
    ),
  );
}

Widget BtnLoginTC() {
  return TextButton(
    onPressed: () {
      //action
    },
    child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
              text: str_all_have_acc,
              style: ThemeHelper.getInstance()!.textTheme.headline3),
          TextSpan(
              text: str_logintc,
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline3!
                  .copyWith(fontSize: 14.sp, color: MyColors.ligtBlue),
              recognizer: TapGestureRecognizer()..onTap = () {}),
        ])),
  );
}
