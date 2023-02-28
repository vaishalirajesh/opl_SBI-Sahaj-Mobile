import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';
import '../../../registration/mobile/login/login.dart';
import '../../../routes.dart';
import '../../../utils/Utils.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/strings/strings.dart';
import '../../../widgets/animation_routes/page_animation.dart';
import '../../gstconsentconfirmthanks/mobile/gstconsentconfirmthanks.dart';

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
        return true;
      },
      child: Scaffold(
        appBar: getAppBarWithBackBtn(onClickAction: () => {
          Navigator.pop(context)
        }),
        body: buildSetupView(context),
      ),
    );
  }

  Widget buildSetupView(BuildContext context) {
    //appbar_check_icon.svg
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildThankForConfirmingText(str_Thanks_for_confirming),
          buildGSTConfirmNTBDiscText(str_gst_confirm_NTBdisc),
          Padding(
            padding:  EdgeInsets.only(left: 24.w,right: 24.w),
            child: Container(
              height: 445.h,
              decoration: BoxDecoration(
                  color: ThemeHelper.getInstance()!.cardColor,
                  borderRadius: BorderRadius.circular(6.r)),
              child: Column(children: [
                SizedBox(height: 20.h,),
              buildImageWidget(MOBILESTEPDONE),
              SizedBox(height: 10.h,),
              buildCenterCard(str_Verify_Mobile_Number),
              buildCenterCard(str_Verify_gst_details),
              buildCenterCard(str_accept_tc),

            ],),),
          ),
          buildBTNStartStartRegistration(context)
        ],
      ),
    );
  }

  Widget buildImageWidget(String path) => SvgPicture.asset(
        Utils.path(path),
        height: 200.h,
        width: 200.w,
      );

  Widget buildThankForConfirmingText(String text) => Padding(
        padding: EdgeInsets.only(top: 30.0.h, bottom: 5.h,left: 24.w),
        child:
            Text(text, style: ThemeHelper.getInstance()!.textTheme.headline2,),
      );

  Widget buildGSTConfirmNTBDiscText(String text) => Padding(
    padding:  EdgeInsets.only(left: 24.w,bottom: 30.h),
    child: Text(
      text,
      style: ThemeHelper.getInstance()!.textTheme.headline3,
      textAlign: TextAlign.center,
    ),
  );

  Widget buildCenterCard(String stepname) {
    return Padding(
      padding: EdgeInsets.only(left: 40.w, right: 40.w, bottom: 20.h),
      child: Container(
        height: 46.h,
        decoration: BoxDecoration(
            color: ThemeHelper.getInstance()!.colorScheme.background,
            borderRadius: BorderRadius.circular(6.r)),
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, top: 12.h),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.purple),
                    height: 15.w,
                    width: 15.w,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: ThemeHelper.getInstance()!.backgroundColor,
                      size: 8.w,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(stepname,
                      style: ThemeHelper.getInstance()!.textTheme.headline3)
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
      child: ElevatedButton(
        style: ThemeHelper.getInstance()!.elevatedButtonTheme.style,
        onPressed: () {
         // Navigator.of(context).push(CustomRightToLeftPageRoute(child: GstConsentConform(), ));
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoginWithMobileNumber(),)
          );

          //        Navigator.pushNamed(context, MyRoutes.GstConfirmThanksRoutes);
        },
        child: Text(str_Start_Registration,
            style: ThemeHelper.getInstance()!.textTheme.button),
      ),
    );
  }
}
