import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sbi_sahay_1_0/routes.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';

import '../../../utils/helpers/myfonts.dart';
import '../../documentation/mobile/reviewdisbursedacc/ui/reviewdisbursedaccscreen.dart';

import '../../loanstatus/mobile/paymentsuccess.dart';
import '../../widgets/animation_routes/page_animation.dart';

class PayNow extends StatelessWidget {


  PayNow({super.key});

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {
        return   WillPopScope(
            onWillPop: () async {
          return true;
        },
        child: PrepayNow());
      },
    );
  }
}

class PrepayNow extends StatefulWidget {
  const PrepayNow({Key? key}) : super(key: key);

  @override
  State<PrepayNow> createState() => _PrepayNowState();
}

class _PrepayNowState extends State<PrepayNow> {
  bool isListLoaded = false;
  var isOfferSelected = false;
  var isKfsLoaded = false;
  var isOtherUpFrontDetailCard = false;
  var isOtherDisclouserCard = false;

  void setIsListLoaded() {
    Future.delayed(const Duration(seconds: 3), () {
      isListLoaded = true;
      setState(() {});
    });
  }

  void setIsOfferSelected() {
    setState(() {
    isOfferSelected = true;
    });
  }

  void setIsKfsLoaded() {
    setState(() {
    isKfsLoaded = true;
    isOfferSelected = false;
 });
  }

  void setIsOtherUpFrontCardShow() {
    setState(() {
    isOtherUpFrontDetailCard = !isOtherUpFrontDetailCard;
    isOtherDisclouserCard = false;
    });
  }

  void setIsOtherDisclouserCardShow() {
    isOtherDisclouserCard = !isOtherDisclouserCard;
    isOtherUpFrontDetailCard = false;
    setState(() {});
  }

//   void navigateToCongratulationScreen() {
//  //   Navigator.pushNamed(context, MyRoutes.loanOfferSelectedRoutes);
// //    Navigator.of(context).push(CustomRightToLeftPageRoute(child: CongratulationsMain(), ));
//     Navigator.push(context,
//         MaterialPageRoute(builder: (context) => CongratulationsMain(),)
//     );
//   }

  void navigateToReviewLoanAccScreen() {
    Future.delayed(const Duration(seconds: 3), () {
     // Navigator.pushNamed(context, MyRoutes.reviewDisbursedAccRoutes);
     // Navigator.of(context).push(CustomRightToLeftPageRoute(child: ReviewDisbursedAccMain(), ));
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ReviewDisbursedAccMain(),)
      );

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: getAppBarWithBackBtn(onClickAction: () => {
          Navigator.pop(context)
        }),
        body: buildPrepayNowScreen(),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: buildAgreeandcheckbox(),
        ),
      ),
    );
  }

  Widget buildPrepayNowScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              str_pay_now,
              style: ThemeHelper.getInstance()!.textTheme.headline1,
            ),

            Padding(
              padding:  EdgeInsets.only(top:5.h,bottom: 5.h),
              child: Text(
                "${strInvoiceNumber}23001832188",
                style: ThemeHelper.getInstance()?.textTheme.headline3,
              ),
            ),

            Text(
              "$str_Invoice_Amount₹ 52,000",
              style: ThemeHelper.getInstance()?.textTheme.headline3,
            ),

            Padding(
              padding:  EdgeInsets.only(top:5.h,bottom: 30.h),
              child: Text(
                str_lender,
                style: ThemeHelper.getInstance()?.textTheme.headline3,
              ),
            ),

            OfferDetailCard(context),

            LoanDetailsUI(),
          ],
        ),
      ),
    );
  }

  Widget buildAgreeandcheckbox() {
    return SizedBox(
      height: 120.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          buildCheckboxWidgetCustom1(),
          SizedBox(height: 15.h),
          Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              child: SelectLoanOfferBtnUI(context)),
          SizedBox(height: 20.h)
        ],
      ),
    );
  }

  Widget buildCheckboxWidgetCustom1() {
    return Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20.w,
                height: 20.h,
                child: Checkbox(
                  // checkColor: MyColors.colorAccent,
                  activeColor: ThemeHelper.getInstance()?.primaryColor,
                  value: isOfferSelected,
                  onChanged: (_) {
                    isOfferSelected = _!;
                    setState(() {});

                    // viewmodel.setCheckChange(bool!);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(2.r),
                    ),
                  ),
                  side: BorderSide(
                      width: 1,
                      color: ThemeHelper.getInstance()!.disabledColor),
                ),
              ),
              SizedBox(width: 10.w),
              Flexible(
                  child: Text(
                str_I_agree_Above_details,
                style: ThemeHelper.getInstance()?.textTheme.bodyText1,
                maxLines: 3,
                textAlign: TextAlign.left,
              )),
            ]));
  }

  Widget OfferDetailCard(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(bottom:20.0.h),
      child: Container(
        decoration: BoxDecoration(
            color: ThemeHelper.getInstance()?.colorScheme.secondary,
            borderRadius: BorderRadius.circular(12.r)),
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
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline4
                        ?.copyWith(
                            color:
                                ThemeHelper.getInstance()?.colorScheme.tertiary,
                            fontSize: 13.sp),
                  ),
                  Text(
                    '₹ 40,000',
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline6
                        ?.copyWith(fontSize: 14.sp),
                  ),
                ],
              ),

              custDivider(),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    str_interest,
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline4
                        ?.copyWith(
                            color:
                                ThemeHelper.getInstance()?.colorScheme.tertiary,
                            fontSize: 13.sp),
                  ),

                  Text(
                    '₹ 1040(10%)',
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline6
                        ?.copyWith(fontSize: 14.sp),
                  ),
                ],
              ),

              custDivider(),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    str_tenure,
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline4
                        ?.copyWith(
                            color:
                                ThemeHelper.getInstance()?.colorScheme.tertiary,
                            fontSize: 13.sp),
                  ),
                  Text(
                    '90 Days',
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline6
                        ?.copyWith(fontSize: 14.sp),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget custDivider()=> Padding(
    padding:  EdgeInsets.only(left:10.w,right: 10.w),
    child: Divider(
      thickness: 1,
      color: ThemeHelper.getInstance()?.disabledColor,
    ),
  );


  Widget LoanDetailsUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(str_loan_details,style: ThemeHelper.getInstance()?.textTheme.headline1?.copyWith(fontSize: 20.sp),),
        // SizedBox(height: 20.h,),
        LoanDetailCardUI("Loan ID", 'LON2345678434', '', true),


        LoanDetailCardUI("UTR Number", '159357456852', '', true),


        LoanDetailCardUI(
            "Amount overdue", '₹ 52,640', '(incl. late payment charges)', true),

        LoanDetailCardUI("Days past due", '10 Days', '', true),

        LoanDetailCardUI("GSTIN", '29ABCDE1234F3Z6', '', true),

        LoanDetailCardUI("Customer name", 'PayTm', '', true),

        LoanDetailCardUI("Due Date", '10 Aug 22', '', false),

        LoanDetailCardUI("Original amount due", '₹ 42,640', '', true),

        LoanDetailCardUI("Disbursed on", '05 May 22', '', true),

        LoanDetailCardUI("Loan amt", '₹ 41,640', '', true),

        LoanDetailCardUI("Invoice date", '03 Aug 22', '', true),

        LoanDetailCardUI(
            "Late payment charge", '2%', '(on outstanding dues)', true),


        LoanDetailCardUI("Bank name", 'Punjab National Bank', '', true),

        LoanDetailCardUI("ROI", '10%', '', true),

      ],
    );
  }

  Widget LoanDetailCardUI(
      String title, String value, String subText, bool isDivider) {
    return Padding(
      padding:  EdgeInsets.only(bottom:10.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding:  EdgeInsets.only(bottom:5.h),
                  child: Text(
                    title,
                    style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(
                        color: ThemeHelper.getInstance()?.indicatorColor,
                        fontFamily: MyFont.Nunito_Sans_Semi_bold),
                  ),
                ),

                subText.isNotEmpty
                    ? Text(
                        subText,
                        style: ThemeHelper.getInstance()
                            ?.textTheme
                            .headline4
                            ?.copyWith(color: MyColors.PnbGrayTextColor),
                      )
                    : Container(
                        height: 0.h,
                      ),
              ]),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .bodyText1
                        ?.copyWith(fontFamily: MyFont.Nunito_Sans_Semi_bold),
                  ),
                  //SizedBox(height: 5.h,),
                  //subText.isNotEmpty ? Text(subText,style: ThemeHelper.getInstance()?.textTheme.headline4?.copyWith(color: MyColors.PnbGrayTextColor),) : Container(height: 0.h,),
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
      ),
    );
  }

  Widget SelectLoanOfferBtnUI(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
        //  Navigator.pushNamed(context, MyRoutes.PaymentSuccessRoutes);
         // Navigator.of(context).push(CustomRightToLeftPageRoute(child: PaymentSuccess(), ));
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PaymentSuccess(),)
          );
        },
        child: Center(
          child: Text(
            str_proceed,
            style: ThemeHelper.getInstance()?.textTheme.button,
          ),
        ),);
  }
}
