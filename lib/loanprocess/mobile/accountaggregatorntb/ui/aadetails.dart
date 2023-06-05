import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import 'package:sbi_sahay_1_0/routes.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/strings/strings.dart';
import '../model/aaviewmodel.dart';

class AccountAggregatorDetails extends StatelessWidget {
  const AccountAggregatorDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountAggregatorViewModel viewModel = AccountAggregatorViewModel();
    viewModel.setContext(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return const SafeArea(
          child: AccountAggregatorScreen(),
        );
      },
    );
  }
}

class AccountAggregatorScreen extends StatefulWidget {
  const AccountAggregatorScreen({Key? key}) : super(key: key);

  @override
  State<AccountAggregatorScreen> createState() => _AccountAggregatorScreenState();
}

class _AccountAggregatorScreenState extends State<AccountAggregatorScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const DashboardWithGST(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: getAppBarWithStepDone("2", str_loan_approve_process, 0.25,
            onClickAction: () => {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const DashboardWithGST(),
                    ),
                    (route) => false, //if you want to disable back feature set to false
                  )
                }),
        body: Stack(
          children: [
            buildACCHomeContian(context),
            buildBtnNextAcc(context),
          ],
        ),
      ),
    );
  }
}

Widget buildACCHomeContian(BuildContext context) {
  return SingleChildScrollView(
    primary: true,
    child: Padding(
      padding: const EdgeInsets.all(20.0).w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeaderDisceContainer(str_header_discr),
          buildAccountAggregatorText(str_acount_aggregator),
          buildANewWaytoShareBankText(str_a_new_way_toshare_bank),
          buildImageWidget(IMG_AA_DETAILS),
          buildSetUpListViewData(),
          buildSetupHyperText(),
        ],
      ),
    ),
  );
}

Widget buildHeaderDisceContainer(String text) => Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: Container(
        height: 70.h,
        color: MyColors.veryLightgreenbg,
        child: Padding(
          padding: const EdgeInsets.all(15.0).w,
          child: Text(
            str_header_discr,
            style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp),
          ),
        ),
      ),
    );

Widget buildAccountAggregatorText(String text) => Padding(
      padding: EdgeInsets.only(left: 0.w, right: 0.w, top: 15.h),
      child: Text(
        text,
        style: ThemeHelper.getInstance()!.textTheme.headline2!,
        textAlign: TextAlign.center,
      ),
    );

Widget buildANewWaytoShareBankText(String text) => Padding(
      padding: EdgeInsets.only(left: 0.w, right: 0.w, top: 12.h, bottom: 10.h),
      child: Text(
        text,
        style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 16.sp),
        //textAlign: TextAlign.center,
      ),
    );

Widget buildBeforeProceedingDescrText(String text) => Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 25.h),
      child: Text(
        text,
        style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp),
        textAlign: TextAlign.center,
      ),
    );

Widget buildImageWidget(String path) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Align(
        alignment: Alignment.center,
        child: SvgPicture.asset(Utils.path(path), height: 350.h, width: 1.sw, allowDrawingOutsideViewBox: false),
      ),
    );

Widget buildSetUpListViewData() {
  return Padding(
    padding: EdgeInsets.only(bottom: 10.h),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        buildRowWidget(str_share_bank_statement),
        buildRowWidget(str_no_branch_visit_needed),
        buildRowWidget(str_rbi_licensed_entites),
        buildRowWidget(str_revoke_consent_at_anytime)
      ],
    ),
  );
}

Widget buildRowWidget(String text) => Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(Utils.path(IMG_GREENTICK_AA), height: 18.h, width: 18.w),
          SizedBox(width: 5.w),
          Text(" $text", style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp)),
        ],
      ),
    );

Widget buildRevokeconsetAtAnytimeRow(String title) => Row(children: [
      SvgPicture.asset(Utils.path(IMG_GREENTICK_AA), height: 15.h, width: 15.w),
      SizedBox(width: 11.w),
      Text(" $title", style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp))
    ]);

Widget buildSetupHyperText() {
  return Padding(
    padding: EdgeInsets.only(bottom: 100.0.w),
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: str_visit,
            style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp),
          ),
          TextSpan(
            text: str_rbi,
            style: ThemeHelper.getInstance()!
                .textTheme
                .headline3!
                .copyWith(color: MyColors.hyperlinkcolornew, fontSize: 14.sp, decoration: TextDecoration.underline),
          ),
          TextSpan(text: str_or, style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp)),
          TextSpan(
            text: str_sahmati,
            style: ThemeHelper.getInstance()!
                .textTheme
                .headline3!
                .copyWith(color: MyColors.hyperlinkcolornew, fontSize: 14.sp, decoration: TextDecoration.underline),
          ),
          TextSpan(
            text: str_website_to_know_more_one,
            style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp),
          ),
          TextSpan(
            text: str_website_to_know_more_two,
            style: ThemeHelper.getInstance()!
                .textTheme
                .headline3!
                .copyWith(color: MyColors.hyperlinkcolornew, fontSize: 14.sp, decoration: TextDecoration.underline),
          ),
          TextSpan(
            text: str_website_to_know_more_three,
            style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp),
          ),
        ],
      ),
    ),
  );
}

Widget buildBtnNextAcc(BuildContext context) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: const EdgeInsets.all(20.0).w,
      child: AppButton(
          onPress: () {
            Navigator.pushReplacementNamed(context, MyRoutes.AAListRoutes);
          },
          title: str_next),
    ),
  );
}
