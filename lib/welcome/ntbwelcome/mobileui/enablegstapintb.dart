import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/welcome/ntbwelcome/mobileui/startregistration.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';

import '../../../utils/Utils.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/strings/strings.dart';
import '../../../widgets/titlebarmobile/titlebarwithoutstep.dart';

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
        Navigator.pop(context, false);
        SystemNavigator.pop(animated: true);
        return true;
      },
      child: Scaffold(
        appBar: getAppBarWithBackBtn(
            onClickAction: () => {Navigator.pop(context, false), SystemNavigator.pop(animated: true)}),
        body: Stack(
          children: [
            SingleChildScrollView(
              primary: true,
              child: SizedBox(
                height: 700.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSetupView(),
                    buildBottomView(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomView() {
    return Container(
      color: ThemeHelper.getInstance()!.backgroundColor,
      height: 200.h,
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            SizedBox(
              height: 30.h,
            ),
            buildConfirmViewBottomText(),
            SizedBox(
              height: 30.h,
            ),
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          style: ThemeHelper.getInstance()!.textTheme.headline1!.copyWith(fontSize: 16.sp, color: MyColors.darkblack),
          // textAlign: TextAlign.left,
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
              padding: const EdgeInsets.only(top: 0).w,
              child: SizedBox(
                width: 20.w,
                height: 20.h,
                child: Theme(
                  data: ThemeData(useMaterial3: true),
                  child: Checkbox(
                    // checkColor: MyColors.colorAccent,
                    activeColor: ThemeHelper.getInstance()?.primaryColor,
                    value: isCheckFirst,
                    onChanged: (value) {
                      changestateConfirmViewFirstCheckBox(value!);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(2.r),
                      ),
                    ),
                    side: BorderSide(
                        width: 1,
                        color: isCheckFirst
                            ? ThemeHelper.getInstance()!.primaryColor
                            : ThemeHelper.getInstance()!.primaryColor),
                  ),
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
                    .copyWith(fontSize: 15.sp, color: MyColors.darkblack),
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
                child: Theme(
                  data: ThemeData(useMaterial3: true),
                  child: Checkbox(
                    // checkColor: MyColors.colorAccent,
                    activeColor: ThemeHelper.getInstance()?.primaryColor,
                    value: isCheckSecond,
                    onChanged: (value) {
                      changestateConfirmViewSecondCheckBox(value!);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(2.r),
                      ),
                    ),
                    side: BorderSide(
                        width: 1,
                        color: isCheckSecond
                            ? ThemeHelper.getInstance()!.primaryColor
                            : ThemeHelper.getInstance()!.primaryColor),
                  ),
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
                      .copyWith(fontSize: 15.sp, color: MyColors.darkblack),
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
              style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp, color: MyColors.black),
            ),
            TextSpan(
                text: str_confirm_bottom2,
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .headline3!
                    .copyWith(fontSize: 14.sp, color: MyColors.hyperlinkcolornew, decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()..onTap = () {}),
            TextSpan(
                text: str_confirm_bottom3,
                style:
                    ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp, color: MyColors.black)),
            TextSpan(
                text: str_confirm_bottom4,
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .headline3!
                    .copyWith(fontSize: 12.sp, color: MyColors.hyperlinkcolornew, decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()..onTap = () {}),
            TextSpan(
                text: str_confirm_bottom5,
                style:
                    ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp, color: MyColors.black)),
            TextSpan(
                text: str_confirm_bottom6,
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .headline3!
                    .copyWith(fontSize: 14.sp, color: MyColors.hyperlinkcolornew, decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()..onTap = () {}),
            TextSpan(
                text: str_confirm_bottom6,
                style:
                    ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp, color: MyColors.black)),
          ],
        ),
      ),
    );
  }

  Widget buildConfirmButton(BuildContext context) {
    return AppButton(
      onPress: () {
        if (isCheckFirst && isCheckSecond) {
          TGSharedPreferences.getInstance().set(PREF_ISTC_DONE, true);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const StartRegistrationNtb(),
            ),
          );
        }
      },
      title: str_Confirm,
      isButtonEnable: isCheckFirst && isCheckSecond,
    );
  }
}
