import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/model/models/get_loan_offer_res_main.dart';
import 'package:gstmobileservices/singleton/tg_session.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';

import '../../../utils/helpers/myfonts.dart';
import '../../../widgets/titlebarmobile/titlebarwithoutstep.dart';
import '../kfs/kfs_screen.dart';

class LoanOfferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SafeArea(child: LoanOfferScreens());
    });
  }
}

class LoanOfferScreens extends StatefulWidget {
  @override
  LoanOfferScreenBody createState() => new LoanOfferScreenBody();
}

class LoanOfferScreenBody extends State<LoanOfferScreens> {
  var isOfferSelected = false;
  var isKfsLoaded = false;
  LoanOfferData? loanOfferData;

  @override
  void initState() {
    loanOfferData = TGSession.getInstance().get(PREF_LOANOFFER);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: LoanOfferScreenMain(context));
    ;
  }

  Widget LoanOfferScreenMain(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeHelper.getInstance()?.backgroundColor,
        appBar: getAppBarWithStep('2', str_loan_approve_process, 0.50, onClickAction: () => {Navigator.pop(context)}),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Valid for: 11h 48m',
                style: ThemeHelper.getInstance()?.textTheme.headline6?.copyWith(fontFamily: MyFont.Nunito_Sans_Semi_bold, fontSize: 12.sp),
              ),
              SizedBox(
                height: 25.h,
              ),
              Text(
                str_offer_detail,
                style: ThemeHelper.getInstance()?.textTheme.headline1,
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                str_lender,
                style: ThemeHelper.getInstance()?.textTheme.headline3,
              ),
              SizedBox(
                height: 30.h,
              ),
              OfferDetailCard(context),
              SizedBox(
                height: 20.h,
              ),
              RepaymentDetail(context),
              SizedBox(
                height: 30.h,
              ),
              LoanDetailsUI(context),
              SizedBox(
                height: 30.h,
              ),
              SelectLoanOfferBtnUI(context)
            ],
          ),
        )));
  }

  Widget OfferDetailCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: ThemeHelper.getInstance()?.colorScheme.secondary, borderRadius: BorderRadius.circular(12.r)),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  str_loan,
                  style: ThemeHelper.getInstance()?.textTheme.headline4?.copyWith(color: ThemeHelper.getInstance()?.colorScheme.tertiary, fontSize: 13.sp),
                ),
                Text(
                  '₹ 30,000',
                  style: ThemeHelper.getInstance()?.textTheme.headline6?.copyWith(fontSize: 14.sp),
                ),
              ],
            ),
            SizedBox(
              width: 10.w,
            ),
            Divider(
              thickness: 1,
              color: ThemeHelper.getInstance()?.disabledColor,
            ),
            SizedBox(
              width: 10.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  str_interest,
                  style: ThemeHelper.getInstance()?.textTheme.headline4?.copyWith(color: ThemeHelper.getInstance()?.colorScheme.tertiary, fontSize: 13.sp),
                ),
                Text(
                  '₹ 512(8.11%)',
                  style: ThemeHelper.getInstance()?.textTheme.headline6?.copyWith(fontSize: 14.sp),
                ),
              ],
            ),
            SizedBox(
              width: 10.w,
            ),
            Divider(
              thickness: 1,
              color: ThemeHelper.getInstance()?.disabledColor,
            ),
            SizedBox(
              width: 10.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  str_tenure,
                  style: ThemeHelper.getInstance()?.textTheme.headline4?.copyWith(color: ThemeHelper.getInstance()?.colorScheme.tertiary, fontSize: 13.sp),
                ),
                Text(
                  '90 Days',
                  style: ThemeHelper.getInstance()?.textTheme.headline6?.copyWith(fontSize: 14.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget RepaymentDetail(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          str_repayment,
          style: ThemeHelper.getInstance()?.textTheme.headline1?.copyWith(fontSize: 20.sp),
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              str_ol,
              style: ThemeHelper.getInstance()?.textTheme.headline3,
            ),
            SizedBox(
              width: 5.w,
            ),
            Flexible(
                child: Text(
              str_reduce_interest,
              style: ThemeHelper.getInstance()?.textTheme.headline3,
              maxLines: 5,
            )),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          children: [
            Text(
              str_ol,
              style: ThemeHelper.getInstance()?.textTheme.headline3,
            ),
            SizedBox(
              width: 5.w,
            ),
            Text(
              str_late_repay_penalty,
              style: ThemeHelper.getInstance()?.textTheme.headline3,
            ),
          ],
        ),
      ],
    );
  }

  Widget LoanDetailsUI(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          str_loan_details,
          style: ThemeHelper.getInstance()?.textTheme.headline1?.copyWith(fontSize: 20.sp),
        ),
        SizedBox(
          height: 20.h,
        ),
        LoanDetailCardUI(str_loan, '₹30,000', '85% of order value', true),
        SizedBox(
          height: 10.h,
        ),
        LoanDetailCardUI(str_interest, '₹ 740', '@10% p.a.', true),
        SizedBox(
          height: 10.h,
        ),
        LoanDetailCardUI(str_processing_charge, '₹ 0', '', true),
        SizedBox(
          height: 10.h,
        ),
        LoanDetailCardUI(str_repayment, '₹ 30,740', '', true),
        SizedBox(
          height: 10.h,
        ),
        LoanDetailCardUI(str_repay_before, '12 Apr 2021', '', true),
        SizedBox(
          height: 10.h,
        ),
        LoanDetailCardUI(str_late_charge, '8% per month', '', true),
        SizedBox(
          height: 10.h,
        ),
        LoanDetailCardUI(str_prepayment_penalty, 'Zero', '', false),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }

  Widget LoanDetailCardUI(String title, String value, String subText, bool isDivider) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(color: ThemeHelper.getInstance()?.indicatorColor, fontFamily: MyFont.Nunito_Sans_Semi_bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: ThemeHelper.getInstance()?.textTheme.bodyText1?.copyWith(fontFamily: MyFont.Nunito_Sans_Semi_bold),
                ),
                SizedBox(
                  height: 5.h,
                ),
                subText.isNotEmpty
                    ? Text(
                        subText,
                        style: ThemeHelper.getInstance()?.textTheme.headline4?.copyWith(color: MyColors.PnbGrayTextColor),
                      )
                    : Container(
                        height: 0.h,
                      ),
              ],
            )
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        isDivider
            ? Divider(
                thickness: 1,
                color: MyColors.PnbGrayTextColor,
              )
            : Container(
                height: 0.h,
              )
      ],
    );
  }

  Widget SelectLoanOfferBtnUI(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          // setIsKfsLoaded();
          //Navigator.of(context).push(CustomRightToLeftPageRoute(child: KfsScreen(), ));
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KfsScreen(),
              ));
          //  Navigator.pushNamed(context, MyRoutes.KfsScreenRoutes);
        },
        child: Center(
          child: Text(
            str_select_loan_offer,
            style: ThemeHelper.getInstance()?.textTheme.button,
          ),
        ));
  }
}
