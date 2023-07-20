import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/model/models/get_gst_basic_details_res_main.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';

import '../../../../loanprocess/mobile/gstinvoiceslist/ui/gstinvoicelist.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/constants/prefrenceconstants.dart';
import '../../../../utils/helpers/themhelper.dart';
import '../../../../utils/strings/strings.dart';

class DashboardWithoutGST extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(child: DashboardWithourGStScreen());
      },
    );
  }
}

class DashboardWithourGStScreen extends StatefulWidget {
  @override
  DashboardwithoutState createState() => DashboardwithoutState();
}

class DashboardwithoutState extends State<DashboardWithourGStScreen> {
  GetGstBasicdetailsResMain? _basicdetailsResponse;

  String? name = '';
  String? pan = '';

  Future<void> setData() async {
    String? text = await TGSharedPreferences.getInstance().get(PREF_BUSINESSNAME);
    String? text1 = await TGSharedPreferences.getInstance().get(PREF_PANNO);
    setState(() {
      name = text;
      pan = text1;
    });
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, false);
          SystemNavigator.pop(animated: true);
          return true;
        },
        child: Scaffold(
          appBar: getAppBarWithStepDone(
            "2",
            str_loan_approve_process,
            0.25,
            isRegistrationScreen: true,
            onClickAction: () => {
              Navigator.pop(context, false),
              SystemNavigator.pop(animated: true),
            },
          ),
          body: dashboardWithoutGstContent(),
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: startLoanProcessButton(),
            ),
          ),
        ),
      ),
    );
  }

  Widget dashboardWithoutGstContent() {
    return ListView(
      children: [
        Container(
          alignment: Alignment.center,
          height: 85.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(0.r),
              bottomLeft: Radius.circular(0.r),
            ),
            border: Border.all(width: 1, color: ThemeHelper.getInstance()!.primaryColor),
            gradient: LinearGradient(
              colors: [MyColors.lightRedGradient, MyColors.lightBlueGradient],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            children: [
              SizedBox(width: 20.w),
              SvgPicture.asset(
                AppUtils.path(DASHBOARDGSTPROFILEWOHOUTGST),
                height: 35.h,
                width: 35.w,
              ),
              SizedBox(width: 15.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Text(str_hello + name!, style: ThemeHelper.getInstance()?.textTheme.button),
                  SizedBox(height: 5.h),
                  Text(
                    str_pan + pan!,
                    style: ThemeHelper.getInstance()!.textTheme.headline5!.copyWith(color: MyColors.white),
                  ),
                ],
              ),
              // const Spacer(),
              // SvgPicture.asset(
              //   Utils.path(MOBILEDASHWIHTOUTNOTIBELL),
              //   //
              // )
            ],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 30.h,
            ),
            Text(
              str_Get_Invoice_based_financein,
              style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(fontSize: 14.sp),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(str_3SIMPLESTEP, style: ThemeHelper.getInstance()?.textTheme.headline2),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: gstLoanFinanceStepsUi(),
            ),
            // Text(
            //   str_notodler_than_60,
            //   style: ThemeHelper.getInstance()!.textTheme.subtitle1?.copyWith(fontFamily: MyFont.Roboto_Italic),
            // ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }

  Widget startLoanProcessButton() {
    return AppButton(
      onPress: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const GSTInvoicesList(),
          ),
          (route) => false, //i
        );
      },
      title: str_Start_Loan_Process,
    );
  }

  Widget gstLoanFinanceStepsUi() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const MySeparator(
              color: Colors.grey,
            ),
            SizedBox(
              height: 20.h,
            ),
            financeStepsUI(str_step1_gstWithout, str_step1_gstWithout_disc, MOBILEDASHWITOUTSTEP1),
            SizedBox(
              height: 20.h,
            ),
            const MySeparator(
              color: Colors.grey,
            ),
            SizedBox(
              height: 20.h,
            ),
            financeStepsUI(str_step2_gstWithout, str_step2_gstWithout_disc, MOBILEDASHWITOUTSTEP2),
            SizedBox(
              height: 20.h,
            ),
            const MySeparator(
              color: Colors.grey,
            ),
            SizedBox(
              height: 20.h,
            ),
            financeStepsUI(str_step3_gstWithout, str_step3_gstWithout_disc, MOBILEDASHWITOUTSTEP3),
            SizedBox(
              height: 20.h,
            ),
            const MySeparator(
              color: Colors.grey,
            ),
            SizedBox(
              height: 20.h,
            ),
            financeStepsUI(str_step4_gstWithout, str_step4_gstWithout_disc, MOBILEDASHWITOUTSTEP4),
            SizedBox(
              height: 20.h,
            ),
            const MySeparator(
              color: Colors.grey,
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget financeStepsUI(String title, String desc, String img) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 3.h), //right_arrow_brown_ic.svg
            child: SvgPicture.asset(
              AppUtils.path(img), height: 40.h, width: 40.w,
              //
            ),
          ),
          SizedBox(width: 15.w),
          gstFinanceStepTextUi(title, desc)
        ],
      ),
    );
  }

  Widget gstFinanceStepTextUi(String title, String desc) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: ThemeHelper.getInstance()!.textTheme.headline2?.copyWith(fontSize: 14.sp, color: MyColors.black)),
          Text(desc,
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline3!
                  .copyWith(fontSize: 14.sp, color: MyColors.lightGraySmallText),
              overflow: TextOverflow.ellipsis,
              maxLines: 20),
        ],
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 0.5, this.color = Colors.black}) : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
