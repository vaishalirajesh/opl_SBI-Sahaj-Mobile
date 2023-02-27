import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbi_sahay_1_0/documentation/mobile/setupemandate/ui/setupemandate.dart';
import 'package:sbi_sahay_1_0/routes.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/welcome/ntbwelcome/mobileui/startregistration.dart';

import '../../../utils/Utils.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/strings/strings.dart';
import '../../../widgets/animation_routes/page_animation.dart';

class EnableGstApi extends StatelessWidget {
  const EnableGstApi({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return const SafeArea(
          child: EnableGstApiScreen(),
        );
      },
    );
  }
}

class EnableGstApiScreen extends StatefulWidget {
  const EnableGstApiScreen({Key? key}) : super(key: key);

  @override
  State<EnableGstApiScreen> createState() => _EnableGstApiScreenState();
}

class _EnableGstApiScreenState extends State<EnableGstApiScreen> {
  bool isCheckFirst = false;
  bool isCheckSecond = false;

  void changestateConfirmViewSecondCheckBox(bool value) {
    setState(() {
      isCheckSecond = value;
    });
  }

  void changestateConfirmViewFirstCheckBox(bool value) {
    setState(() {
      isCheckFirst = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
         return true;
      },
      child: Scaffold(
        appBar: buildAppBarWithEnablegst(),
        body: Stack(
          children: [
            SingleChildScrollView(
              primary: true,
              child: SizedBox(
                height: 680.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSetupView(),

                    buildbottomView(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildbottomView() {
    return Container(
      color: ThemeHelper.getInstance()!.backgroundColor,
      height: 150.h,
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            SizedBox(height: 30.h,),
            buildConfirmViewBottomText(),
            
            buildConfirmButton(context),
          ],
        ),
      ),
    );
  }

  Widget buildSetupView() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 30.h),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildConfirmViewTitle(str_confirmView_title),
          buildImageContainer(IMG_TWO_PERSON),
          buildCheckboxWidgetConfirm(),
        ],
      ),
    );
  }

  Widget buildConfirmViewTitle(String text) => Padding(
        padding: EdgeInsets.only(top: 15.h, bottom: 70.h),
        child: Text(
          text,
          style: ThemeHelper.getInstance()!
              .textTheme
              .headline1!
              .copyWith(fontSize: 16),
          textAlign: TextAlign.left,
        ),
      );

  buildImageContainer(String path) => Padding(
        padding: EdgeInsets.only(bottom: 70.h),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            height: 225.h,
            width: 245.w,
            decoration: BoxDecoration(
              color: ThemeHelper.getInstance()!.cardColor,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              Utils.path(IMG_TWO_PERSON),
              width: 100.w,
              height: 80.h,
            ),
          ),
        ),
      );

  Widget buildCheckboxWidgetConfirm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 3).w,
              child: SizedBox(
                width: 20.w,
                height: 20.h,
                child: Checkbox(
                  // checkColor: MyColors.colorAccent,
                  activeColor: ThemeHelper.getInstance()?.primaryColor,
                  value: isCheckFirst,
                  onChanged: (value) {
                    changestateConfirmViewFirstCheckBox(value!);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.r),
                    ),
                  ),
                  side: BorderSide(
                      width: 1,
                      color: isCheckFirst
                          ? ThemeHelper.getInstance()!.primaryColor
                          : ThemeHelper.getInstance()!.disabledColor),
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Text(
                str_confirm_check1,
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .headline2!
                    .copyWith(fontSize: 15.sp, color: MyColors.pnbcolorPrimary),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 3.r),
              child: SizedBox(
                width: 20.w,
                height: 20.h,
                child: Checkbox(
                  // checkColor: MyColors.colorAccent,
                  activeColor: ThemeHelper.getInstance()?.primaryColor,
                  value: isCheckSecond,
                  onChanged: (value) {
                    changestateConfirmViewSecondCheckBox(value!);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.r),
                    ),
                  ),
                  side: BorderSide(
                      width: 1,
                      color: isCheckSecond
                          ? ThemeHelper.getInstance()!.primaryColor
                          : ThemeHelper.getInstance()!.disabledColor),
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Text(str_confirm_check2,
                  style: ThemeHelper.getInstance()!
                      .textTheme
                      .headline2!
                      .copyWith(
                          fontSize: 15.sp, color: MyColors.pnbcolorPrimary),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3),
            ),
          ],
        )
      ],
    );
  }

  Widget buildConfirmViewBottomText() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: str_confirm_bottom1,
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline3!
                  .copyWith(fontSize: 12.sp, color: MyColors.pnbcolorPrimary),
            ),
            TextSpan(
                text: str_confirm_bottom2,
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .headline3!
                    .copyWith(fontSize: 12.sp, color: MyColors.ligtBlue),
                recognizer: TapGestureRecognizer()..onTap = () {}),
            TextSpan(
                text: str_confirm_bottom3,
                style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(
                    fontSize: 12.sp, color: MyColors.pnbcolorPrimary)),
            TextSpan(
                text: str_confirm_bottom4,
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .headline3!
                    .copyWith(fontSize: 12.sp, color: MyColors.ligtBlue),
                recognizer: TapGestureRecognizer()..onTap = () {}),
            TextSpan(
                text: str_confirm_bottom5,
                style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(
                    fontSize: 12.sp, color: MyColors.pnbcolorPrimary)),
            TextSpan(
                text: str_confirm_bottom6,
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .headline3!
                    .copyWith(fontSize: 12.sp, color: MyColors.ligtBlue),
                recognizer: TapGestureRecognizer()..onTap = () {}),
            TextSpan(
                text: str_confirm_bottom6,
                style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(
                    fontSize: 12.sp, color: MyColors.pnbcolorPrimary)),
          ],
        ),
      ),
    );
  }

  Widget buildConfirmButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (isCheckFirst && isCheckSecond) {
        //  Navigator.pushNamed(context, MyRoutes.StartRegistrationNtbRoutes);
        //  Navigator.push(context, CustomRightToLeftPageRoute(child:StartRegistrationNtb()));
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => StartRegistrationNtb(),)
          );
        }
      },
      style: isCheckFirst && isCheckSecond
          ? ThemeHelper.getInstance()!.elevatedButtonTheme.style
          : ThemeHelper.setPinkDisableButtonBig(),
      child: const Text(
        str_Confirm,
      ),
    );
  }

  AppBar buildAppBarWithEnablegst() {
    return AppBar(
      iconTheme: IconThemeData(
          color: ThemeHelper.getInstance()!.colorScheme.primary, size: 28),
      elevation: 0,
      automaticallyImplyLeading: true,
      title: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SvgPicture.asset(Utils.path(MOBILESAHAYLOGO),
                    //     height: 20.h, width: 20.w)
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
