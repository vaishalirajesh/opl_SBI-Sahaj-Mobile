import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbi_sahay_1_0/disbursed/mobile/proceedtodisbursed/ui/proceedtodisbscreen.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/strings/strings.dart';

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(
          child: WillPopScope(
              onWillPop: () async {
                return true;
              },
              child: PaymentSuccessScreen()),
        );
      },
    );
  }
}

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({Key? key}) : super(key: key);

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBarWithBackBtn(onClickAction: () => {Navigator.pop(context)}),
        body: Container(child: setupView()),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: buildBTNStartStartRegistration(context),
        ));
  }
}

Widget setupView() {
  //appbar_check_icon.svg
  return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 0.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 28.h, bottom: 80.h),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppUtils.path(IMG_PNB_BANK_NAME),
                    height: 35.h,
                    width: 180.w,
                  ),
                  Spacer(),
                  Image.asset(AppUtils.path(IMG_SIGNDESK_LOGO), height: 21.h, width: 78.w)
                ],
              ),
            ),
            SvgPicture.asset(
              AppUtils.path(MOBILESTEPDONE), height: 78.h, width: 78.w,
              //
            ),
            Padding(
              padding: EdgeInsets.only(top: 28.h, bottom: 10.h),
              child:
                  Text("₹ 52,640", style: ThemeHelper.getInstance()!.textTheme.headline1, textAlign: TextAlign.center),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 50.h),
              child: Center(
                  child: Text(
                "You have successfully repaid via e-NACH mandate",
                style: ThemeHelper.getInstance()!.textTheme.headline2!.copyWith(fontSize: 16),
                textAlign: TextAlign.center,
              )),
            ),
            centerMainData(),
          ],
        ),
      ));
}

centerMainData() {
  return Container(
    decoration: BoxDecoration(
        border: Border.all(color: ThemeHelper.getInstance()!.disabledColor, width: 1),
        //color:ThemeHelper.getInstance()?.colorScheme.secondary,
        borderRadius: BorderRadius.all(Radius.circular(16.r))),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          setView("Transaction No.", "224686073141", true),
          setView("Date", "September 3, 2022", false),
          setView("Time", "5:30 AM", false),
        ],
      ),
    ),
  );
}

setView(String title, String subTitle, bool flag) {
  return Padding(
    padding: EdgeInsets.only(bottom: 10.h, top: flag ? 20.h : 0.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 100.w,
            child: Text(
              title,
              style: ThemeHelper.getInstance()!.textTheme.bodyText2,
            )),
        SizedBox(
          width: 17.w,
        ),
        SizedBox(width: 120.w, child: Text(subTitle, style: ThemeHelper.getInstance()!.textTheme.headline6)),
      ],
    ),
  );
}

Widget buildBTNStartStartRegistration(BuildContext context) {
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    shadowColor: Colors.transparent,
    foregroundColor: const Color(0xFF280470),
    backgroundColor: ThemeHelper.getInstance()?.primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(6.r)),
    ),
  );

  return Padding(
    padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 50.h),
    child: ElevatedButton(
      style: raisedButtonStyle,
      onPressed: () {
        // Navigator.pushNamed(context, MyRoutes.proceedToDisbursedRoutes);
        //   Navigator.of(context).push(CustomRightToLeftPageRoute(child: ProceedToDisburseMain(), ));
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProceedToDisburseMain(),
            ));
      },
      child: Text(str_Proceed, style: ThemeHelper.getInstance()!.textTheme.button),
    ),
  );
}
