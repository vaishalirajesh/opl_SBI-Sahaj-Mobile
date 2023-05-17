import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_loan_app_status_main.dart';
import 'package:gstmobileservices/model/models/get_loan_offer_res_main.dart';
import 'package:gstmobileservices/model/models/share_gst_invoice_res_main.dart';
import 'package:gstmobileservices/model/requestmodel/get_loan_app_status_request.dart';
import 'package:gstmobileservices/model/requestmodel/set_loan_offer_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_loan_app_status_response.dart';
import 'package:gstmobileservices/model/responsemodel/set_loan_offer_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_session.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:sbi_sahay_1_0/routes.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/erros_handle.dart';
import 'package:sbi_sahay_1_0/utils/helpers/myfonts.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';

import '../../../utils/colorutils/mycolors.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/constants/prefrenceconstants.dart';
import '../../../utils/constants/statusConstants.dart';
import '../../../utils/internetcheckdialog.dart';
import '../../../utils/movestageutils.dart';
import '../../../utils/progressLoader.dart';
import '../../../widgets/titlebarmobile/titlebarwithoutstep.dart';

class KfsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SafeArea(child: KfsScreens());
    });
  }
}

class KfsScreens extends StatefulWidget {
  @override
  KfsScreenBody createState() => new KfsScreenBody();
}

class KfsScreenBody extends State<KfsScreens> {
  //var isLoanOfferSelected = false;
  var isOtherUpFrontDetailCard = false;
  var isOtherDisclouserCard = false;
  var applicantName = '';
  num totalCharge = 0;
  num otherChanrges = 0;
  num panelcharges = 0;

  LoanOfferData? loanOfferData;
  ShareGstInvoiceResMain? _setLoanOfferRes;
  GetLoanStatusResMain? _getLoanStatusRes;
  TextEditingController fatherName = TextEditingController();
  bool isValidFatherName = false;

  @override
  void initState() {
    loanOfferData = TGSession.getInstance().get(PREF_LOANOFFER);
    // getApplicantName();
    // calculateOtherChanges("");
    // calculatePanelCharges("Penal");
    // setTotalCharge();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: KfsScreenMain(context));
  }

  Widget KfsScreenMain(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getInstance()?.backgroundColor,
      appBar: getAppBarWithStepDone('2', str_loan_approve_process, 0.50, onClickAction: () => {Navigator.pop(context)}),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [MyColors.lightRedGradient, MyColors.lightBlueGradient],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )
              //   color: ThemeHelper.getInstance()?.primaryColor,
              ),
          child: Column(
            children: [
              InvoiceDataUI(context),
              SizedBox(height: 5.h),
              //Removed Sanction Limit and Available Limit 3/2/23 Aarti
              /*LoanDataUI(context),
                SizedBox(height: 15.h),*/
              KFSDetailsUI(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: ThemeHelper.getInstance()?.backgroundColor,
        child: Padding(
          padding: EdgeInsets.only(bottom: 10.h, left: 20.w, right: 20.w),
          child: selectLoanOfferBtnUI(context),
        ),
      ),
    );
  }

  Widget InvoiceDataUI(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                str_kfs,
                style: ThemeHelper.getInstance()?.textTheme.headline2?.copyWith(color: MyColors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(Utils.path(DOWNLOADKFS), height: 14.h, width: 16.w, color: MyColors.white),
                  SizedBox(
                    width: 6.w,
                  ),
                  Text(
                    'Download',
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline6
                        ?.copyWith(fontSize: 16.sp, color: MyColors.white),
                    textAlign: TextAlign.right,
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    str_invoice_number,
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline3
                        ?.copyWith(fontSize: 12.sp, color: ThemeHelper.getInstance()?.colorScheme.surface),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    loanOfferData?.invoiceNumber ?? "230",
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline2
                        ?.copyWith(fontSize: 14.sp, color: ThemeHelper.getInstance()?.colorScheme.background),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    str_invoice_amount,
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline3
                        ?.copyWith(fontSize: 12.sp, color: ThemeHelper.getInstance()?.colorScheme.surface),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text("₹35,000",
                      // Utils.convertIndianCurrency(loanOfferData?.offerDetails
                      //     ?.elementAt(0)
                      //     .termsRequestedAmount
                      style: ThemeHelper.getInstance()
                          ?.textTheme
                          .headline2
                          ?.copyWith(fontSize: 14.sp, color: ThemeHelper.getInstance()?.colorScheme.background))
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    str_date,
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline3
                        ?.copyWith(fontSize: 12.sp, color: ThemeHelper.getInstance()?.colorScheme.surface),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    "19 Oct, 2022",
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline2
                        ?.copyWith(fontSize: 14.sp, color: ThemeHelper.getInstance()?.colorScheme.background),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    str_kfs_lender,
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline3
                        ?.copyWith(fontSize: 12.sp, color: ThemeHelper.getInstance()?.colorScheme.surface),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    "State Bank of India",
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline2
                        ?.copyWith(fontSize: 14.sp, color: ThemeHelper.getInstance()?.colorScheme.background),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget ApplicantDataUI(BuildContext context) {
    return Container(
      height: 100.h,
      //color: ThemeHelper.getInstance()?.backgroundColor,
      decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: MyColors.sbiPinkColor,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
          color: ThemeHelper.getInstance()?.backgroundColor),
      child: Column(
        children: [
          Container(
            height: 30.h,
            //width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8.r),
                  topLeft: Radius.circular(8.r),
                ),
                color: MyColors.sbiPinkColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  str_applicant_name + "Manish Patel",
                  style:
                      ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(color: MyColors.white, fontSize: 14.sp),
                  textAlign: TextAlign.center,
                ),
                // Expanded(
                //   child: Text(
                //   "Manish Patel",
                //     style: ThemeHelper.getInstance()
                //         ?.textTheme
                //         .headline3?.copyWith(color: MyColors.white
                //         ),textAlign: TextAlign.center,
                //     maxLines: 5,
                //   ),
                // )
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      Utils.path(IMG_kfs_bank),
                      height: 20.h,
                      width: 20.w,
                    ),
                    SizedBox(width: 10.w), //10
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Sanctioned Limit",
                            style: ThemeHelper.getInstance()
                                ?.textTheme
                                .headline3
                                ?.copyWith(color: MyColors.lightGraySmallText, fontSize: 12.sp)),
                        Text("₹5,00,000",
                            style: ThemeHelper.getInstance()?.textTheme.headline2?.copyWith(fontSize: 14.sp)),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(width: 24.w), //10
              Container(height: 40.h, width: 0.1.w, color: MyColors.pnbGreyColor),
              SizedBox(width: 24.w),
              Container(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      Utils.path(IMG_kfs_coin_stack),
                      height: 20.h,
                      width: 20.w,
                    ),
                    SizedBox(width: 10.w), //10
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Sanctioned Limit",
                            style: ThemeHelper.getInstance()
                                ?.textTheme
                                .headline3
                                ?.copyWith(color: MyColors.lightGraySmallText, fontSize: 12.sp)),
                        Text("₹5,00,000",
                            style: ThemeHelper.getInstance()?.textTheme.headline2?.copyWith(fontSize: 14.sp)),
                      ],
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget LoanDataUI(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LoanAmtLimitUI(Utils.path(SANCTIONLIMIT), str_sanction_limit,
              Utils.convertIndianCurrency(loanOfferData?.offerDetails?.elementAt(0).sanctionLimit)),
          LoanAmtLimitUI(Utils.path(AVAILABLELIMIT), str_available_limit,
              Utils.convertIndianCurrency(loanOfferData?.offerDetails?.elementAt(0).availableLimit)),
        ],
      ),
    );
  }

  Widget LoanAmtLimitUI(String image, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(image, height: 35.h, width: 35.w),
        SizedBox(
          width: 10.w,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: ThemeHelper.getInstance()
                    ?.textTheme
                    .headline3
                    ?.copyWith(fontSize: 14.sp, color: ThemeHelper.getInstance()?.colorScheme.surface)),
            SizedBox(
              height: 5.h,
            ),
            Text(value,
                style: ThemeHelper.getInstance()
                    ?.textTheme
                    .headline3
                    ?.copyWith(color: ThemeHelper.getInstance()?.colorScheme.background))
          ],
        )
      ],
    );
  }

  Widget KFSDetailsUI(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(0.r), topLeft: Radius.circular(0.r)),
          color: ThemeHelper.getInstance()?.backgroundColor),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(
              height: 16.h,
            ),
            ApplicantDataUI(context),
            SizedBox(
              height: 24.h,
            ),
            Card(
              color: ThemeHelper.getInstance()?.backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.all(Radius.circular(12.r)),
                  side: BorderSide(color: ThemeHelper.getInstance()!.backgroundColor)),
              shadowColor: ThemeHelper.getInstance()?.shadowColor,
              elevation: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                          flex: 4,
                          child: LoanDetailColumnWidget(
                              str_loan_amt,
                              Utils.convertIndianCurrency(
                                  loanOfferData?.offerDetails?.elementAt(0).termsSanctionedAmount),
                              true,
                              str_loan_amt_tooltip)),
                      Flexible(flex: 1, child: Container()),
                      Flexible(
                          flex: 4,
                          child: LoanDetailColumnWidget(
                              str_total_interest,
                              Utils.convertIndianCurrency(
                                  loanOfferData?.offerDetails?.elementAt(0).termsInterestAmount),
                              true,
                              str_total_interest_tooltip)),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Divider(
                    thickness: 0.5,
                    color: ThemeHelper.getInstance()?.disabledColor,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Flexible(
                          flex: 4,
                          child: LoanDetailColumnWidget(
                              str_net_disb_amt,
                              Utils.convertIndianCurrency(
                                  loanOfferData?.offerDetails?.elementAt(0).netDisbursementAmount),
                              false,
                              "")),
                      Flexible(flex: 1, child: Container()),
                      Flexible(
                        flex: 4,
                        child: LoanDetailColumnWidget(
                            str_total_repay_amt,
                            Utils.convertIndianCurrency(loanOfferData?.offerDetails?.elementAt(0).termsTotalAmount),
                            true,
                            str_total_repay_amt_tooltip),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Divider(
              thickness: 0.5,
              color: ThemeHelper.getInstance()?.disabledColor,
            ),
            // SizedBox(
            //   height: 10.h,
            // ),
            Card(
              color: ThemeHelper.getInstance()?.backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.all(Radius.circular(12.r)),
                  side: BorderSide(color: ThemeHelper.getInstance()!.backgroundColor)),
              shadowColor: ThemeHelper.getInstance()?.shadowColor,
              elevation: 2,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                          flex: 4,
                          child: LoanDetailColumnWidget(
                              str_anum_per_rate,
                              ("${loanOfferData?.offerDetails?.elementAt(0).termsInterestRate ?? "- "}% p.a."),
                              true,
                              str_per_rate_tooltip)),
                      Flexible(flex: 1, child: Container()),
                      Flexible(
                          flex: 4,
                          child: LoanDetailColumnWidget(str_no_of_installment,
                              loanOfferData?.offerDetails?.elementAt(0).noOfInstallments ?? "-", false, "")),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Divider(
                    thickness: 0.5,
                    color: ThemeHelper.getInstance()?.disabledColor,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Flexible(
                          flex: 4,
                          child: LoanDetailColumnWidget(
                              str_loan_tenure,
                              "${loanOfferData?.offerDetails?.elementAt(0).termsTenureDuration ?? ""} Days",
                              false,
                              "-")),
                      Flexible(flex: 1, child: Container()),
                      Flexible(
                          flex: 4,
                          child: LoanDetailColumnWidget(
                              str_penal_charge, Utils.convertIndianCurrency(panelcharges.toString()), false, "")),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            OtherUpfrontChargesCard(context),
            SizedBox(
              height: 15.h,
            ),
            OtherDisclouserDetailCardUI(),
            SizedBox(
              height: 50.h,
            )
          ],
        ),
      ),
    );
  }

  Widget LoanDetailColumnWidget(String title, String value, bool isOtherInfo, String toolTip) {
    final key = GlobalKey<State<Tooltip>>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            _onTap(key);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: Text(
                  title,
                  style: ThemeHelper.getInstance()
                      ?.textTheme
                      .headline3
                      ?.copyWith(color: MyColors.lightGraySmallText, fontSize: 12.sp),
                  maxLines: 3,
                  softWrap: true,
                ),
              ),
              SizedBox(
                width: 3.w,
              ),
              isOtherInfo
                  ? Tooltip(
                      key: key,
                      showDuration: const Duration(seconds: 1),
                      message: toolTip,
                      textAlign: TextAlign.center,
                      decoration: BoxDecoration(color: ThemeHelper.getInstance()?.primaryColor),
                      textStyle: ThemeHelper.getInstance()
                          ?.textTheme
                          ?.headline5
                          ?.copyWith(fontSize: 11.sp, color: Colors.white),
                      child: GestureDetector(
                        onTap: () {
                          _onTap(key);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 0.h),
                          child: Icon(
                            Icons.info_outline_rounded,
                            color: ThemeHelper.getInstance()?.unselectedWidgetColor,
                            size: 15.h,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 0.h,
                      width: 0.h,
                    )
            ],
          ),
        ),
        Text(
          value,
          style: ThemeHelper.getInstance()?.textTheme.headline2?.copyWith(fontSize: 14.sp),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }

  Widget RichTextWidget(String title, String value, String toolTip, bool isOtherInfo) {
    final key = GlobalKey<State<Tooltip>>();
    return RichText(
      textAlign: TextAlign.start,
      maxLines: 5,
      text: TextSpan(
        style: ThemeHelper.getInstance()?.textTheme.headline5?.copyWith(
              color: ThemeHelper.getInstance()?.indicatorColor, /*fontFamily: MyFont.Nunito_Sans_Semi_bold*/
            ),
        children: [
          TextSpan(
            text: title,
          ),
          WidgetSpan(
            child: Padding(
              padding: EdgeInsets.only(bottom: 5.h, left: 5.w),
              child: isOtherInfo
                  ? Tooltip(
                      key: key,
                      message: toolTip,
                      textAlign: TextAlign.center,
                      decoration: BoxDecoration(color: ThemeHelper.getInstance()?.primaryColor),
                      textStyle: ThemeHelper.getInstance()
                          ?.textTheme
                          ?.headline5
                          ?.copyWith(fontSize: 11.sp, color: Colors.white),
                      child: GestureDetector(
                        onTap: () {
                          _onTap(key);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 3.h),
                          child: Icon(
                            Icons.info_outline_rounded,
                            color: ThemeHelper.getInstance()?.unselectedWidgetColor,
                            size: 15.h,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 0.h,
                      width: 0.w,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget OtherUpfrontChargesCard(BuildContext context) {
    return Card(
        color: ThemeHelper.getInstance()?.backgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.all(Radius.circular(12.r)),
            side: BorderSide(color: ThemeHelper.getInstance()!.dividerColor)),
        shadowColor: ThemeHelper.getInstance()?.shadowColor,
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(15.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    setIsOtherUpFrontCardShow();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(str_other_upfront_charges,
                        style: ThemeHelper.getInstance()
                            ?.textTheme
                            .headline2
                            ?.copyWith(fontSize: 14.sp, color: MyColors.pnbcolorPrimary)),
                    Row(
                      children: [
                        Text(
                          Utils.convertIndianCurrency(totalCharge.toString()),
                          style: ThemeHelper.getInstance()?.textTheme.bodyText1,
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        GestureDetector(
                          child: SvgPicture.asset(
                            isOtherUpFrontDetailCard ? Utils.path(IMG_UP_ARROW) : Utils.path(IMG_DOWN_ARROW),
                            height: 20.h,
                            width: 20.w,
                          ),
                          onTap: () {
                            //Manish
                            setState(() {
                              setIsOtherUpFrontCardShow();
                            });
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
              isOtherUpFrontDetailCard
                  ? Column(
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            OtherUpFrontRowWidget(str_stamp_duty, Utils.convertIndianCurrency("100")),
                            SizedBox(width: 90.w),
                            OtherUpFrontRowWidget(
                                str_processing_fees,
                                Utils.convertIndianCurrency(
                                    loanOfferData?.offerDetails?[0].processingChargesDetails?.amount)),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            OtherUpFrontRowWidget(
                                str_insurance_charges,
                                Utils.convertIndianCurrency(
                                    loanOfferData?.offerDetails?[0].insuranceChargesDetails?.amount)),
                            SizedBox(width: 50.w),
                            OtherUpFrontRowWidget(str_others, Utils.convertIndianCurrency(otherChanrges.toString())),
                          ],
                        ),
                      ],
                    )
                  : Container(
                      height: 0.h,
                    )
            ],
          ),
        ));
  }

  Widget OtherUpFrontRowWidget(String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: ThemeHelper.getInstance()
              ?.textTheme
              .headline3
              ?.copyWith(fontSize: 12.sp, color: MyColors.lightGraySmallText),
        ),
        SizedBox(height: 5.h),
        Text(value, style: ThemeHelper.getInstance()?.textTheme.headline2?.copyWith(fontSize: 14.sp)),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Text(value, style: ThemeHelper.getInstance()?.textTheme.bodyText1),
        //     SizedBox(
        //       width: 35.w,
        //     ),
        //   ],
        // )
      ],
    );
  }

  Widget OtherDisclouserDetailCardUI() {
    return Card(
        color: ThemeHelper.getInstance()?.backgroundColor,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: ThemeHelper.getInstance()!.dividerColor),
            borderRadius: BorderRadiusDirectional.all(Radius.circular(12.r))),
        shadowColor: ThemeHelper.getInstance()?.shadowColor,
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(15.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    //Manish
                    setIsOtherDisclouserCardShow();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(str_other_disclouser,
                        style: ThemeHelper.getInstance()
                            ?.textTheme
                            .headline2
                            ?.copyWith(fontSize: 14.sp, color: MyColors.pnbcolorPrimary)),
                    GestureDetector(
                      child: SvgPicture.asset(
                        isOtherDisclouserCard ? Utils.path(IMG_UP_ARROW) : Utils.path(IMG_DOWN_ARROW),
                        height: 20.h,
                        width: 20.w,
                      ),
                      onTap: () {
                        setState(() {
                          //Manish
                          setIsOtherDisclouserCardShow();
                        });
                      },
                    ),
                  ],
                ),
              ),
              isOtherDisclouserCard
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 25.h,
                        ),
                        // Flexible(
                        //     flex: 4,
                        //     child: LoanDetailColumnWidget(
                        //         str_cooling_period,
                        //         "${loanOfferData?.offerDetails?.elementAt(0).coolingOffPeriod ?? "3 Days"}",
                        //         true,
                        //         str_cooling_period_tooltip)),
                        // Flexible(flex: 1, child: Container()),
                        // Flexible(
                        //     flex: 4,
                        //     child: LoanDetailColumnWidget(
                        //         str_lsp_detail,
                        //         loanOfferData?.offerDetails
                        //             ?.elementAt(0)
                        //             ?.detailsOfLSPActAsRecoveryAgent ??
                        //             "NA",
                        //         true,
                        //         str_lsp_detail_tooltip)),

                        LoanDetailColumnWidget(
                            str_cooling_period,
                            "${loanOfferData?.offerDetails?.elementAt(0).coolingOffPeriod ?? "3 Days"}",
                            true,
                            str_cooling_period_tooltip),
                        SizedBox(height: 14.h),
                        // Flexible(flex: 1, child: Container()),
                        LoanDetailColumnWidget(
                            str_lsp_detail,
                            loanOfferData?.offerDetails?.elementAt(0)?.detailsOfLSPActAsRecoveryAgent ?? "NA",
                            true,
                            str_lsp_detail_tooltip),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Flexible(
                        //         flex: 4,
                        //         child: LoanDetailColumnWidget(
                        //             str_cooling_period,
                        //             "${loanOfferData?.offerDetails?.elementAt(0).coolingOffPeriod ?? "3 Days"}",
                        //             true,
                        //             str_cooling_period_tooltip)),
                        //     Flexible(flex: 1, child: Container()),
                        //     Flexible(
                        //         flex: 4,
                        //         child: LoanDetailColumnWidget(
                        //             str_lsp_detail,
                        //             loanOfferData?.offerDetails
                        //                     ?.elementAt(0)
                        //                     ?.detailsOfLSPActAsRecoveryAgent ??
                        //                 "NA",
                        //             true,
                        //             str_lsp_detail_tooltip)),
                        //   ],
                        // ),
                        SizedBox(
                          height: 10.h,
                        ),
                        // Divider(
                        //   thickness: 1,
                        //   color: ThemeHelper.getInstance()?.disabledColor,
                        // ),
                        Text(
                          str_grievance_contact,
                          style: ThemeHelper.getInstance()
                              ?.textTheme
                              .headline3
                              ?.copyWith(color: MyColors.lightGraySmallText, fontSize: 12.sp),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          //width: 150.w,
                          child: Text(
                            loanOfferData?.offerDetails
                                    ?.elementAt(0)
                                    .contactDetailsOfNodalOfficer
                                    ?.replaceAll('null,', '')
                                    .replaceAll(',null', '') ??
                                "Jainam Shah, Greivance Redressal Officer, 1st floor, Agile Complex, Dadar, Mumbai - 400014 Phone : 022 7878 2442",
                            style: ThemeHelper.getInstance()?.textTheme.headline2?.copyWith(fontSize: 14.sp),
                            textAlign: TextAlign.start,
                          ),
                        )
                      ],
                    )
                  : Container(
                      height: 0.h,
                    )
            ],
          ),
        ));
  }

  Widget selectLoanOfferBtnUI(BuildContext context) {
    return AppButton(
        onPress: () async {
          showDialog(context: context, builder: (_) => popUpViewForCongratulation());
        },
        title: str_select_loan_offer);
  }

  Widget popUpViewForCongratulation() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.r)),
              image: DecorationImage(image: AssetImage(Utils.path(KFSCONGRATULATIONBG)), fit: BoxFit.fill),
              color: Colors.white,
            ),
            height: 350.h,
            width: 335.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 50.h), //40
                Center(
                  child: SvgPicture.asset(Utils.path(FILLGREENCONFORMTICK),
                      height: 52.h, //,
                      width: 52.w, //134.8,
                      allowDrawingOutsideViewBox: true),
                ),
                SizedBox(height: 30.h), //40
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Congratulations",
                        style: ThemeHelper.getInstance()
                            ?.textTheme
                            .headline2
                            ?.copyWith(fontSize: 20.sp, color: MyColors.lightGraySmallText),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 18.h),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Text(
                          "You will now proceed to NeSL's Digital Document Execution journey",
                          textAlign: TextAlign.center,
                          style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(
                              fontSize: 14.sp,
                              color: MyColors.lightGraySmallText,
                              fontFamily: MyFont.Nunito_Sans_Regular),
                        ),
                      ),
                    ],
                  ),
                ),
                //38
                SizedBox(height: 25.h),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: btnProceed(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget btnProceed() {
    return AppButton(
      onPress: () async {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, MyRoutes.loanDepositeAccRoutes);
      },
      title: str_proceed,
    );
  }

  void setIsOtherUpFrontCardShow() {
    isOtherUpFrontDetailCard = !isOtherUpFrontDetailCard;
    isOtherDisclouserCard = false;
    //notifyListeners();
  }

  void setIsOtherDisclouserCardShow() {
    isOtherDisclouserCard = !isOtherDisclouserCard;
    isOtherUpFrontDetailCard = false;
    //notifyListeners();
  }

  // void showAddAccDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setModelState) {
  //         return AlertDialog(
  //           insetPadding: EdgeInsets.zero,
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(30.0.r))),
  //           content: addFatherNameUI(setModelState),
  //         );
  //       });
  //     },
  //   );
  // }

  // Widget addFatherNameUI(StateSetter setModelState) {
  //   return SizedBox(
  //     height: 220.h,
  //     width: 300.w,
  //     child: Padding(
  //       padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             'Father Name',
  //             style: ThemeHelper.getInstance()?.textTheme.headline1,
  //             textAlign: TextAlign.start,
  //           ),
  //           SizedBox(
  //             height: 15.h,
  //           ),
  //           TextFormField(
  //               controller: fatherName,
  //               onChanged: (content) {
  //                 checkIsValidFatherName(setModelState);
  //               },
  //               decoration: const InputDecoration(
  //                   border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.all(Radius.circular(12))),
  //                   counterText: '',
  //                   hintText: "Enter Your Father Name"),
  //               keyboardType: TextInputType.text,
  //               inputFormatters: [
  //                 FilteringTextInputFormatter.allow(
  //                     RegExp("(?!^ +\$)^[a-zA-Z ]+\$"),
  //                     replacementString: "")
  //               ],
  //               maxLines: 1,
  //               validator: (value) {
  //                 if (value == null || value.isEmpty) {}
  //                 return null;
  //               }),
  //           SizedBox(
  //             height: 15.h,
  //           ),
  //           SizedBox(
  //             width: MediaQuery.of(context).size.width,
  //             height: 50.h,
  //             child: ElevatedButton(
  //                 style: isValidFatherName
  //                     ? ThemeHelper.getInstance()!.elevatedButtonTheme.style
  //                     : ThemeHelper.setPinkDisableButtonBig(),
  //                 onPressed: () {
  //                   if (fatherName.text.isNotEmpty) {
  //
  //                     setLoanOffer();
  //                     Navigator.pop(context);
  //                   }
  //                 },
  //                 child: Center(
  //                   child: Text(
  //                     str_agree,
  //                     style: ThemeHelper.getInstance()?.textTheme.button,
  //                   ),
  //                 )),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  void checkIsValidFatherName(StateSetter setModelState) {
    if (fatherName.text.isNotEmpty) {
      setModelState(() {
        isValidFatherName = true;
      });
    } else {
      setModelState(() {
        isValidFatherName = false;
      });
    }
  }

  void calculateOtherChanges(String chargeType) {
    if (loanOfferData?.offerDetails?[0].additionalCharges?.isNotEmpty == true) {
      for (int i = 0; i < loanOfferData!.offerDetails![0].additionalCharges!.length; i++) {
        if ((loanOfferData!.offerDetails![0].additionalCharges?[i].description.toString().toLowerCase() ?? "")
            .contains(chargeType.toLowerCase())) {
          if (chargeType != "Penal") {
            otherChanrges =
                otherChanrges + num.parse(loanOfferData!.offerDetails![0].additionalCharges?[i].amount ?? "0");
          } else {
            otherChanrges = otherChanrges + 0;
          }
        }
      }
    }
  }

  void calculatePanelCharges(String chargeType) {
    if (loanOfferData?.offerDetails?[0].additionalCharges?.isNotEmpty == true) {
      for (int i = 0; i < loanOfferData!.offerDetails![0].additionalCharges!.length; i++) {
        if ((loanOfferData!.offerDetails![0].additionalCharges?[i].description.toString().toLowerCase() ?? "")
            .contains(chargeType.toLowerCase())) {
          if (chargeType == "Penal") {
            panelcharges =
                panelcharges + num.parse(loanOfferData!.offerDetails![0].additionalCharges?[i].amount ?? "0");
          } else {
            panelcharges = panelcharges + 0;
          }
        }
      }
    }
  }

  void setTotalCharge() {
    // if(loanOfferData?.offerDetails?[0].processingChargesDetails?.chargeType == "FIXED_AMOUNT")
    // {
    totalCharge = totalCharge + num.parse(loanOfferData?.offerDetails?[0].processingChargesDetails?.amount ?? "0");
    // }
    //  if(loanOfferData?.offerDetails?[0].insuranceChargesDetails?.chargeType == "FIXED_AMOUNT")
    //  {
    totalCharge = totalCharge + num.parse(loanOfferData?.offerDetails?[0].insuranceChargesDetails?.amount ?? "0");
    // }
    // if(getAdditionalCharge("Stamp")?.contains("%") == false)
    // {
    totalCharge = totalCharge + otherChanrges;
    //}
  }

  Future<void> setLoanOffer() async {
    TGSharedPreferences.getInstance().set(PREF_LOANAPPID, loanOfferData?.loanApplicationId);
    TGSharedPreferences.getInstance().set(PREF_OFFERID, loanOfferData?.offerDetails?[0].offerId);
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    SetLoanOfferRequest setLoanOfferRequest = SetLoanOfferRequest(
        loanApplicationRefId: loanAppRefId,
        loanApplicationId: loanOfferData?.loanApplicationId,
        offerId: loanOfferData?.offerDetails?[0].offerId,
        fatherName: fatherName.text);
    var jsonReq = jsonEncode(setLoanOfferRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_SET_LOAN_OFFER);
    ServiceManager.getInstance().setLoanOffer(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetLoanOffer(response),
        onError: (error) => _onErrorGetLoanOffer(error));
  }

  _onSuccessGetLoanOffer(SetLoanOfferResponse? response) {
    TGLog.d("SetLoanOfferResponse : onSuccess()");

    if (response?.getSetLoanOfferResObj().status == RES_SUCCESS) {
      _setLoanOfferRes = response?.getSetLoanOfferResObj();
      loanAppStatusAfterSetLoanOffer();
    } else {
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(
          context, response?.getSetLoanOfferResObj().status, response?.getSetLoanOfferResObj().message, null);
    }
  }

  _onErrorGetLoanOffer(TGResponse errorResponse) {
    TGLog.d("SetLoanOfferResponse : onError()");
    Navigator.pop(context);
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> getLoanAppStatusAfterSelectLoanOffer() async {
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    GetLoanStatusRequest getLoanStatusRequest = GetLoanStatusRequest(loanApplicationRefId: loanAppRefId);
    var jsonReq = jsonEncode(getLoanStatusRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, Utils.getManageLoanAppStatusParam('4'));
    ServiceManager.getInstance().getLoanAppStatus(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetLoanAppStatus(response),
        onError: (error) => _onErrorGetLoanAppStatus(error));
  }

  _onSuccessGetLoanAppStatus(GetLoanStatusResponse? response) async {
    TGLog.d("LoanAppStatusResponse : onSuccess()");
    _getLoanStatusRes = response?.getLoanStatusResObj();
    if (_getLoanStatusRes?.status == RES_SUCCESS) {
      if (_getLoanStatusRes?.data?.stageStatus == "PROCEED") {
        Navigator.pop(context);
        MoveStage.navigateNextStage(context, _getLoanStatusRes?.data?.currentStage);
        //Navigator.pushNamed(context, MyRoutes.reviewDisbursedAccRoutes);
      } else if (_getLoanStatusRes?.data?.stageStatus == "HOLD") {
        Future.delayed(const Duration(seconds: 10), () {
          loanAppStatusAfterSetLoanOffer();
        });
      } else {
        loanAppStatusAfterSetLoanOffer();
      }
    } else {
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(context, response?.getLoanStatusResObj().status,
          response?.getLoanStatusResObj().message, response?.getLoanStatusResObj().data?.stageStatus);
    }
  }

  _onErrorGetLoanAppStatus(TGResponse errorResponse) {
    TGLog.d("LoanAppStatusResponse : onError()");
    Navigator.pop(context);
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> loanAppStatusAfterSetLoanOffer() async {
    if (await TGNetUtil.isInternetAvailable()) {
      getLoanAppStatusAfterSelectLoanOffer();
    } else {
      showSnackBarForintenetConnection(context, getLoanAppStatusAfterSelectLoanOffer);
    }
  }

  void getApplicantName() async {
    var name = await TGSharedPreferences.getInstance().get(PREF_BUSINESSNAME);
    setState(() {
      applicantName = name;
    });
  }
}
