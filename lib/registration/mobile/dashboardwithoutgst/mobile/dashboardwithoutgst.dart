import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/model/models/get_gst_basic_details_res_main.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/helpers/myfonts.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/constants/prefrenceconstants.dart';
import '../../../../utils/helpers/themhelper.dart';
import '../../../../utils/strings/strings.dart';
import '../../cic_consent/cic_consent.dart';

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
    String? text =
        await TGSharedPreferences.getInstance().get(PREF_BUSINESSNAME);
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
          appBar: getAppBarWithStepDone("2", str_registration, 0.25,
              onClickAction: () => {
                    Navigator.pop(context, false),
                    SystemNavigator.pop(animated: true)
                  }),
          body: dashboardWithoutGstContent(),
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
              child: SizedBox(height: 50.h, child: startLoanProcessButton()),
            ),
          )),
    ));
  }

  Widget dashboardWithoutGstContent() {
    return ListView(
      children: [
        Container(
            alignment: Alignment.center,
            height: 85.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20.r),
                  bottomLeft: Radius.circular(20.r)),
              border: Border.all(
                  width: 1, color: ThemeHelper.getInstance()!.primaryColor),
              color: ThemeHelper.getInstance()!.primaryColor,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  SizedBox(width: 20.w),
                  Image(
                    height: 44.h,
                    width: 44.w,
                    image: AssetImage(Utils.path(DASHBOARDGSTPROFILEWOHOUTGST)),
                  ),
                  SizedBox(width: 15.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Text("Hello $name",
                          style: ThemeHelper.getInstance()?.textTheme.button),
                      SizedBox(height: 5.h),
                      Text("PAN: $pan",
                          style: ThemeHelper.getInstance()!
                              .textTheme
                              .headline5!
                              .copyWith(color: MyColors.white)),
                    ],
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    Utils.path(MOBILEDASHWIHTOUTNOTIBELL),
                    //
                  )
                ],
              ),
            )),
        Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            height: 39.h,
          ),
          Text(str_Get_Invoice_based_financein,
              style: ThemeHelper.getInstance()?.textTheme.bodyText1),
          SizedBox(
            height: 20.h,
          ),
          Text(str_3SIMPLESTEP,
              style: ThemeHelper.getInstance()?.textTheme.headline1!.copyWith(
                  fontFamily: MyFont.Nunito_Sans_ExtraBold, fontSize: 18)),
          SizedBox(
            height: 15.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: gstLoanFinanceStepsUi(),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(str_notodler_than_60,
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline6!
                  .copyWith(fontFamily: MyFont.Nunito_Sans_NunitoSansItalic)),
        ]),
      ],
    );
  }

  Widget startLoanProcessButton() {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6.r)),
      ),
    );

    return ElevatedButton(
      onPressed: () {
        //  Navigator.of(context).push(CustomRightToLeftPageRoute(child: CicConsent(), ));
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CicConsent(),
            ));
      },
      child: Text(str_Start_Loan_Process,
          style: ThemeHelper.getInstance()!.textTheme.button),
    );
  }

  Widget gstLoanFinanceStepsUi() {
    return Container(
      decoration: BoxDecoration(
        color: ThemeHelper.getInstance()!.colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // FinanceStepsUI(
            //     str_step1_gstWithout,
            //     str_step1_gstWithout_disc,
            //     viewModel),
            // SizedBox(
            //   height: 8.h,
            // ),
            financeStepsUI(str_step2_gstWithout, str_step2_gstWithout_disc),
            // SizedBox(
            //   height: 5.h,
            // ),
            financeStepsUI(str_step3_gstWithout, str_step3_gstWithout_disc),
            // SizedBox(
            //   height: 5.h,
            // ),
            financeStepsUI(str_step4_gstWithout, str_step4_gstWithout_disc),
            // SizedBox(
            //   height: 5.h,
            // ),
          ],
        ),
      ),
    );
  }

  Widget financeStepsUI(String title, String desc) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 3.h), //right_arrow_brown_ic.svg
            child: SvgPicture.asset(
              Utils.path(RIGHTARROWFILLED), height: 12.h, width: 12.w,
              //
            ),
          ),
          SizedBox(width: 5.w),
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
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontSize: 14.sp)),
          Text(desc,
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .overline!
                  .copyWith(color: MyColors.pnbcolorPrimary, fontSize: 11.sp),
              overflow: TextOverflow.ellipsis,
              maxLines: 20),
        ],
      ),
    );
  }
}
