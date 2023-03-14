import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbi_sahay_1_0/documentation/mobile/setupemandate/ui/setupemandate.dart';
import 'package:sbi_sahay_1_0/routes.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/helpers/myfonts.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/strings/strings.dart';
import '../../../../widgets/animation_routes/page_animation.dart';
import '../../banklist/mobile/banklist.dart';
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
  State<AccountAggregatorScreen> createState() =>
      _AccountAggregatorScreenState();
}

class _AccountAggregatorScreenState extends State<AccountAggregatorScreen> {
  @override
  Widget build(BuildContext context) {
    return   WillPopScope(
        onWillPop: () async {
      return true;
    },
    child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: getAppBarWithStepDone("2", str_loan_approve_process, 0.25,onClickAction: () =>{
        Navigator.pop(context)
      }),
      body: Stack(
        children: [
         buildACCHomeContian(context),
         buildBtnNextAcc(context),
                 ],
      ),
    ));
  }
}

Widget buildACCHomeContian(BuildContext context) {
  return
    SingleChildScrollView(
      primary: true, child:
    Padding(
    padding: const EdgeInsets.all(20.0).w,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeaderDisceContainer(str_header_discr),
        buildAccountAggregatorText(str_acount_aggregator),
        buildANewWaytoShareBankText(str_a_new_way_toshare_bank),
       // buildBeforeProceedingDescrText(str_before_proceeding_discr),

        buildImageWidget(IMG_AA_DETAILS),
        buildSetUpListViewData(),
        buildSetupHyperText(),
      ],
    ),
  ),);
}

Widget buildHeaderDisceContainer(String text) => Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: Container(
        height: 70.h,
        color: ThemeHelper.getInstance()!.cardColor,
        child: Padding(
          padding: EdgeInsets.all(15.0).w,
          child: Text(
            str_header_discr,
            style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(
                  fontSize: 13.sp,
                  fontFamily: MyFont.Nunito_Sans_Regular,
                ),
          ),
        ),
      ),
    );

Widget buildAccountAggregatorText(String text) => Padding(
      padding: EdgeInsets.only(left: 0.w, right: 0.w, top: 15.h),
      child: Text(
        text,
        style: ThemeHelper.getInstance()!
            .textTheme
            .headline1!
            .copyWith(fontSize: 25.sp),
        textAlign: TextAlign.center,
      ),
    );

Widget buildANewWaytoShareBankText(String text) => Padding(
      padding: EdgeInsets.only(left: 0.w, right: 0.w, top: 5.h,bottom: 10.h),
      child: Text(
        text,
        style: ThemeHelper.getInstance()!
            .textTheme
            .headline3!
            .copyWith(fontSize: 16.sp),
        textAlign: TextAlign.center,
      ),
    );

Widget buildBeforeProceedingDescrText(String text) => Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 25.h),
      child: Text(
        text,
        style: ThemeHelper.getInstance()!
            .textTheme
            .headline3!
            .copyWith(fontSize: 14.sp),
        textAlign: TextAlign.center,
      ),
    );

Widget buildImageWidget(String path) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 60.w,vertical: 20.h),
      child: SvgPicture.asset(Utils.path(path),
          height: 350.h, allowDrawingOutsideViewBox: false),
    );

Widget buildSetUpListViewData() {
  return Padding(
    padding: EdgeInsets.only(left: 20.0.w, right: 20.w, bottom: 30.h),
    child: SizedBox(
      height: 145.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          buildRowWidget(str_share_bank_statement),
          buildRowWidget(str_no_branch_visit_needed),
          buildRowWidget(str_rbi_licensed_entites),
          buildRevokeconsetAtAnytimeRow(str_revoke_consent_at_anytime)
        ],
      ),
    ),
  );
}

Widget buildRowWidget(String text) => Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Row(
        children: [
          SvgPicture.asset(Utils.path(IMG_GREENTICK_AA),
              height: 15.h, width: 15.w),
          Text(" $text",
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline1!
                  .copyWith(color: MyColors.black, fontSize: 14.sp)),
        ],
      ),
    );

Widget buildRevokeconsetAtAnytimeRow(String title) => Row(children: [
  SvgPicture.asset(Utils.path(IMG_GREENTICK_AA),
      height: 15.h, width: 15.w),
      Text(" $title",
          style: ThemeHelper.getInstance()!
              .textTheme
              .headline1!
              .copyWith(color: MyColors.black, fontSize: 13.sp))
    ]);

Widget buildSetupHyperText() {
  return Padding(
    padding: EdgeInsets.only(bottom: 100.0.w),
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: str_visit,
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline1!
                  .copyWith(color: MyColors.pnbGreyColor, fontSize: 13)),
          TextSpan(
              text: str_rbi,
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline1!
                  .copyWith(color: MyColors.ligtBlue, fontSize: 13)),
          TextSpan(
              text: str_or,
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline1!
                  .copyWith(color: MyColors.pnbGreyColor, fontSize: 13)),
          TextSpan(
              text: str_sahmati,
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline1!
                  .copyWith(color: MyColors.ligtBlue, fontSize: 13)),
          TextSpan(
              text: str_website_to_know_more,
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline1!
                  .copyWith(color: MyColors.pnbGreyColor, fontSize: 13)),
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
      child: ElevatedButton(
        style: ThemeHelper.getInstance()!.elevatedButtonTheme.style,
        onPressed: () {
          Navigator.pushNamed(context, MyRoutes.AAListRoutes);
        //   Navigator.push(context,
        //       MaterialPageRoute(builder: (context) => BankList(),)
        //   );

        },
        child: const Text(str_next),
      ),
    ),
  );
}
