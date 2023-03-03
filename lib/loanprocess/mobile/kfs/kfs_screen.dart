import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/erros_handle.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';

import '../../../utils/colorutils/mycolors.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/constants/prefrenceconstants.dart';
import '../../../utils/constants/statusConstants.dart';
import '../../../utils/helpers/myfonts.dart';
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
      appBar: getAppBarWithStep('2', str_loan_approve_process, 0.50,
          onClickAction: () => {Navigator.pop(context)}),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
          gradient: LinearGradient(colors: [MyColors.lightRedGradient,MyColors.lightBlueGradient],begin: Alignment.centerLeft,end:Alignment.centerRight)
           //   color: ThemeHelper.getInstance()?.primaryColor,
          ),
          child: Column(
            children: [
              InvoiceDataUI(context),
              ApplicantDataUI(context),
              SizedBox(height: 15.h),
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
          child: SelectLoanOfferBtnUI(context),
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
                style: ThemeHelper.getInstance()?.textTheme.caption?.copyWith(
                    fontSize: 23.sp, fontFamily: MyFont.Nunito_Sans_Bold),
              ),
              /*Download KFS Statement Button(Future Implementation)*/
              /*Container(
                  height: 34.h,
                  width: 34.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: ThemeHelper.getInstance()
                          ?.colorScheme
                          .secondaryContainer),
                  child:
                      Center(child: SvgPicture.asset(Utils.path(DOWNLOADKFS))))*/
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(str_invoice_number,
                      style: ThemeHelper.getInstance()
                          ?.textTheme
                          .headline3
                          ?.copyWith(
                              color: ThemeHelper.getInstance()
                                  ?.colorScheme
                                  .surface)),
                  Text(loanOfferData?.invoiceNumber ?? "230",
                      style: ThemeHelper.getInstance()
                          ?.textTheme
                          .headline3
                          ?.copyWith(
                              color: ThemeHelper.getInstance()
                                  ?.colorScheme
                                  .background))
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(str_invoice_amount,
                      style: ThemeHelper.getInstance()
                          ?.textTheme
                          .headline3
                          ?.copyWith(
                              color: ThemeHelper.getInstance()
                                  ?.colorScheme
                                  .surface)),
                  Text("₹35,000",
                      // Utils.convertIndianCurrency(loanOfferData?.offerDetails
                      //     ?.elementAt(0)
                      //     .termsRequestedAmount
                      style: ThemeHelper.getInstance()
                          ?.textTheme
                          .headline3
                          ?.copyWith(
                              color: ThemeHelper.getInstance()
                                  ?.colorScheme
                                  .background))
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(str_date,
                      style: ThemeHelper.getInstance()
                          ?.textTheme
                          .headline3
                          ?.copyWith(
                          color: ThemeHelper.getInstance()
                              ?.colorScheme
                              .surface)),
                  Text("19 Oct, 2022",
                      style: ThemeHelper.getInstance()
                          ?.textTheme
                          .headline3
                          ?.copyWith(
                          color: ThemeHelper.getInstance()
                              ?.colorScheme
                              .background))
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget ApplicantDataUI(BuildContext context) {
    return Container(
      color: ThemeHelper.getInstance()?.colorScheme.surface.withOpacity(0.2),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(str_date,
                        style: ThemeHelper.getInstance()
                            ?.textTheme
                            .headline3
                            ?.copyWith(
                                color: ThemeHelper.getInstance()
                                    ?.colorScheme
                                    .surface)),
                    Text(
                        Utils.convertDateFormat(
                                loanOfferData
                                    ?.offerDetails?[0].offerCreatedDate,
                                'yyyy-MM-dd hh:mm:ss',
                                'dd MMM, yyyy') ??
                            "",
                        style: ThemeHelper.getInstance()
                            ?.textTheme
                            .headline3
                            ?.copyWith(
                                color: ThemeHelper.getInstance()
                                    ?.colorScheme
                                    .background))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(str_kfs_lender,
                        style: ThemeHelper.getInstance()
                            ?.textTheme
                            .headline3
                            ?.copyWith(
                                color: ThemeHelper.getInstance()
                                    ?.colorScheme
                                    .surface)),
                    Text('PNB',
                        style: ThemeHelper.getInstance()
                            ?.textTheme
                            .headline3
                            ?.copyWith(
                                color: ThemeHelper.getInstance()
                                    ?.colorScheme
                                    .background))
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.r),
                  color: ThemeHelper.getInstance()?.backgroundColor),
              child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 30.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(str_applicant_name,
                          style: ThemeHelper.getInstance()
                              ?.textTheme
                              .bodyText1
                              ?.copyWith(
                                fontFamily: MyFont.Nunito_Sans_Regular,
                              )),
                      Expanded(
                        child: Text(
                          (applicantName ?? "-"),
                          style: ThemeHelper.getInstance()
                              ?.textTheme
                              .bodyText1
                              ?.copyWith(
                                fontFamily: MyFont.Nunito_Sans_Regular,
                              ),
                          maxLines: 5,
                        ),
                      )
                    ],
                  )),
            )
          ],
        ),
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
          LoanAmtLimitUI(
              Utils.path(SANCTIONLIMIT),
              str_sanction_limit,
              Utils.convertIndianCurrency(
                  loanOfferData?.offerDetails?.elementAt(0).sanctionLimit)),
          LoanAmtLimitUI(
              Utils.path(AVAILABLELIMIT),
              str_available_limit,
              Utils.convertIndianCurrency(
                  loanOfferData?.offerDetails?.elementAt(0).availableLimit)),
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
                style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(
                    fontSize: 14.sp,
                    color: ThemeHelper.getInstance()?.colorScheme.surface)),
            SizedBox(
              height: 5.h,
            ),
            Text(value,
                style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(
                    color: ThemeHelper.getInstance()?.colorScheme.background))
          ],
        )
      ],
    );
  }

  Widget KFSDetailsUI(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(0.r), topLeft: Radius.circular(0.r)),
          color: ThemeHelper.getInstance()?.backgroundColor),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(
              height: 30.h,
            ),
            Card(
              color: ThemeHelper.getInstance()?.backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadiusDirectional.all(Radius.circular(12.r)),
                  side: BorderSide(
                      color: ThemeHelper.getInstance()!.dividerColor)),
              shadowColor: ThemeHelper.getInstance()?.shadowColor,
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(15.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                            flex: 4,
                            child: LoanDetailColumnWidget(
                                str_loan_amt,
                                Utils.convertIndianCurrency(loanOfferData
                                    ?.offerDetails
                                    ?.elementAt(0)
                                    .termsSanctionedAmount),
                                true,
                                str_loan_amt_tooltip)),
                        Flexible(flex: 1, child: Container()),
                        Flexible(
                            flex: 4,
                            child: LoanDetailColumnWidget(
                                str_total_interest,
                                Utils.convertIndianCurrency(loanOfferData
                                    ?.offerDetails
                                    ?.elementAt(0)
                                    .termsInterestAmount),
                                true,
                                str_total_interest_tooltip)),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Divider(
                      thickness: 1,
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
                                Utils.convertIndianCurrency(loanOfferData
                                    ?.offerDetails
                                    ?.elementAt(0)
                                    .netDisbursementAmount),
                                false,
                                "")),
                        Flexible(flex: 1, child: Container()),
                        Flexible(
                            flex: 4,
                            child: LoanDetailColumnWidget(
                                str_total_repay_amt,
                                Utils.convertIndianCurrency(loanOfferData
                                    ?.offerDetails
                                    ?.elementAt(0)
                                    .termsTotalAmount),
                                true,
                                str_total_repay_amt_tooltip)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Card(
              color: ThemeHelper.getInstance()?.backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadiusDirectional.all(Radius.circular(12.r)),
                  side: BorderSide(
                      color: ThemeHelper.getInstance()!.dividerColor)),
              shadowColor: ThemeHelper.getInstance()?.shadowColor,
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(15.h),
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
                            child: LoanDetailColumnWidget(
                                str_no_of_installment,
                                loanOfferData?.offerDetails
                                        ?.elementAt(0)
                                        .noOfInstallments ??
                                    "-",
                                false,
                                "")),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Divider(
                      thickness: 1,
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
                                str_penal_charge,
                                Utils.convertIndianCurrency(
                                    panelcharges.toString()),
                                false,
                                "")),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            OtherUpfrontChargesCard(context),
            SizedBox(
              height: 15.h,
            ),
            OtherDisclouserDetailCardUI(context),
            SizedBox(
              height: 50.h,
            )
          ],
        ),
      ),
    );
  }

  Widget LoanDetailColumnWidget(
      String title, String value, bool isOtherInfo, String toolTip) {
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
                      .headline5
                      ?.copyWith(
                          color: ThemeHelper.getInstance()?.indicatorColor,
                          fontSize: 15.sp),
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
                      decoration: BoxDecoration(
                          color: ThemeHelper.getInstance()?.primaryColor),
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
                            color: ThemeHelper.getInstance()
                                ?.unselectedWidgetColor,
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
          style: ThemeHelper.getInstance()?.textTheme.headline6?.copyWith(
              fontFamily: MyFont.Nunito_Sans_Semi_bold, fontSize: 15.sp),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }

  Widget RichTextWidget(
      String title, String value, String toolTip, bool isOtherInfo) {
    final key = GlobalKey<State<Tooltip>>();
    return RichText(
      textAlign: TextAlign.start,
      maxLines: 5,
      text: TextSpan(
        style: ThemeHelper.getInstance()?.textTheme.headline5?.copyWith(
              color: ThemeHelper.getInstance()
                  ?.indicatorColor, /*fontFamily: MyFont.Nunito_Sans_Semi_bold*/
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
                      decoration: BoxDecoration(
                          color: ThemeHelper.getInstance()?.primaryColor),
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
                            color: ThemeHelper.getInstance()
                                ?.unselectedWidgetColor,
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
                            .bodyText1
                            ?.copyWith(
                                color:
                                    ThemeHelper.getInstance()?.indicatorColor,
                                fontFamily: MyFont.Nunito_Sans_Semi_bold,
                                fontSize: 14.sp)),
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
                            isOtherUpFrontDetailCard
                                ? Utils.path(HIDEVIEW)
                                : Utils.path(EXPANDVIEW),
                            height: 15.h,
                            width: 15.h,
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
                          height: 15.h,
                        ),
                        OtherUpFrontRowWidget(
                            str_processing_fees,
                            Utils.convertIndianCurrency(loanOfferData
                                ?.offerDetails?[0]
                                .processingChargesDetails
                                ?.amount)),
                        SizedBox(
                          height: 15.h,
                        ),
                        OtherUpFrontRowWidget(
                            str_insurance_charges,
                            Utils.convertIndianCurrency(loanOfferData
                                ?.offerDetails?[0]
                                .insuranceChargesDetails
                                ?.amount)),
                        SizedBox(
                          height: 15.h,
                        ),
                        OtherUpFrontRowWidget(
                            str_others,
                            Utils.convertIndianCurrency(
                                otherChanrges.toString())),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: ThemeHelper.getInstance()?.textTheme.bodyText2?.copyWith(
              color: MyColors.pnbDarkGreyTextColor,
              fontFamily: MyFont.Nunito_Sans_Semi_bold,
              fontSize: 14.sp),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(value, style: ThemeHelper.getInstance()?.textTheme.bodyText1),
            SizedBox(
              width: 35.w,
            ),
          ],
        )
      ],
    );
  }

  Widget OtherDisclouserDetailCardUI(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
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
                            .bodyText1
                            ?.copyWith(
                                color:
                                    ThemeHelper.getInstance()?.indicatorColor,
                                fontFamily: MyFont.Nunito_Sans_Semi_bold,
                                fontSize: 14.sp)),
                    GestureDetector(
                      child: SvgPicture.asset(
                        isOtherDisclouserCard
                            ? Utils.path(LOANCARDUPARROW)
                            : Utils.path(LOANCARDDOWNARROW),
                        height: 15.h,
                        width: 15.h,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                                flex: 4,
                                child: LoanDetailColumnWidget(
                                    str_cooling_period,
                                    "${loanOfferData?.offerDetails?.elementAt(0).coolingOffPeriod ?? ""}",
                                    true,
                                    str_cooling_period_tooltip)),
                            Flexible(flex: 1, child: Container()),
                            Flexible(
                                flex: 4,
                                child: LoanDetailColumnWidget(
                                    str_lsp_detail,
                                    loanOfferData?.offerDetails
                                            ?.elementAt(0)
                                            ?.detailsOfLSPActAsRecoveryAgent ??
                                        "-",
                                    true,
                                    str_lsp_detail_tooltip)),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Divider(
                          thickness: 1,
                          color: ThemeHelper.getInstance()?.disabledColor,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          str_grievance_contact,
                          style: ThemeHelper.getInstance()
                              ?.textTheme
                              .bodyText1
                              ?.copyWith(
                                  color:
                                      ThemeHelper.getInstance()?.indicatorColor,
                                  fontFamily: MyFont.Nunito_Sans_Semi_bold,
                                  fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          width: 150.w,
                          child: Text(
                            loanOfferData?.offerDetails
                                    ?.elementAt(0)
                                    .contactDetailsOfNodalOfficer
                                    ?.replaceAll('null,', '')
                                    .replaceAll(',null', '') ??
                                "-",
                            style: ThemeHelper.getInstance()
                                ?.textTheme
                                .headline6
                                ?.copyWith(
                                    fontFamily: MyFont.Nunito_Sans_Semi_bold),
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

  Widget SelectLoanOfferBtnUI(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.h,
      child: ElevatedButton(
          onPressed: () async {

            // WidgetsBinding.instance.addPostFrameCallback((_) async {
            //   LoaderUtils.showLoaderwithmsg(context,
            //       msg:
            //           "$str_congrats \n $str_Congratulations \n $str_congratulation_sen \n $str_while_we_process_your_loan");
            // });
            //
            // if (await TGNetUtil.isInternetAvailable()) {
            //   setLoanOffer();
            // } else {
            //   showSnackBarForintenetConnection(context, setLoanOffer);
            // }

          },
          child: Center(
            child: Text(
              str_select_loan_offer,
              style: ThemeHelper.getInstance()?.textTheme.button,
            ),
          )),
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
      for (int i = 0;
          i < loanOfferData!.offerDetails![0].additionalCharges!.length;
          i++) {
        if ((loanOfferData!.offerDetails![0].additionalCharges?[i].description
                    .toString()
                    .toLowerCase() ??
                "")
            .contains(chargeType.toLowerCase())) {
          if (chargeType != "Penal") {
            otherChanrges = otherChanrges +
                num.parse(loanOfferData!
                        .offerDetails![0].additionalCharges?[i].amount ??
                    "0");
          } else {
            otherChanrges = otherChanrges + 0;
          }
        }
      }
    }
  }

  void calculatePanelCharges(String chargeType) {
    if (loanOfferData?.offerDetails?[0].additionalCharges?.isNotEmpty == true) {
      for (int i = 0;
          i < loanOfferData!.offerDetails![0].additionalCharges!.length;
          i++) {
        if ((loanOfferData!.offerDetails![0].additionalCharges?[i].description
                    .toString()
                    .toLowerCase() ??
                "")
            .contains(chargeType.toLowerCase())) {
          if (chargeType == "Penal") {
            panelcharges = panelcharges +
                num.parse(loanOfferData!
                        .offerDetails![0].additionalCharges?[i].amount ??
                    "0");
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
    totalCharge = totalCharge +
        num.parse(
            loanOfferData?.offerDetails?[0].processingChargesDetails?.amount ??
                "0");
    // }
    //  if(loanOfferData?.offerDetails?[0].insuranceChargesDetails?.chargeType == "FIXED_AMOUNT")
    //  {
    totalCharge = totalCharge +
        num.parse(
            loanOfferData?.offerDetails?[0].insuranceChargesDetails?.amount ??
                "0");
    // }
    // if(getAdditionalCharge("Stamp")?.contains("%") == false)
    // {
    totalCharge = totalCharge + otherChanrges;
    //}
  }

  Future<void> setLoanOffer() async {
    TGSharedPreferences.getInstance()
        .set(PREF_LOANAPPID, loanOfferData?.loanApplicationId);
    TGSharedPreferences.getInstance()
        .set(PREF_OFFERID, loanOfferData?.offerDetails?[0].offerId);
    String loanAppRefId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
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

  _onSuccessGetLoanOffer(SetLoanOfferResponse? response)  {
    TGLog.d("SetLoanOfferResponse : onSuccess()");

    if (response?.getSetLoanOfferResObj().status == RES_SUCCESS) {
      _setLoanOfferRes = response?.getSetLoanOfferResObj();
      loanAppStatusAfterSetLoanOffer();
    } else {
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(
          context,
          response?.getSetLoanOfferResObj().status,
          response?.getSetLoanOfferResObj().message,
          null);
    }
  }

  _onErrorGetLoanOffer(TGResponse errorResponse) {
    TGLog.d("SetLoanOfferResponse : onError()");
    Navigator.pop(context);
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> getLoanAppStatusAfterSelectLoanOffer() async {
    String loanAppRefId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    GetLoanStatusRequest getLoanStatusRequest =
        GetLoanStatusRequest(loanApplicationRefId: loanAppRefId);
    var jsonReq = jsonEncode(getLoanStatusRequest.toJson());
    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, Utils.getManageLoanAppStatusParam('4'));
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
        MoveStage.navigateNextStage(
            context, _getLoanStatusRes?.data?.currentStage);
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
      LoaderUtils.handleErrorResponse(
          context,
          response?.getLoanStatusResObj().status,
          response?.getLoanStatusResObj().message,
          response?.getLoanStatusResObj().data?.stageStatus);
    }
  }

  _onErrorGetLoanAppStatus(TGResponse errorResponse) {
    TGLog.d("LoanAppStatusResponse : onError()");
    Navigator.pop(context);
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> loanAppStatusAfterSetLoanOffer() async
  {
    if (await TGNetUtil.isInternetAvailable()) {
      getLoanAppStatusAfterSelectLoanOffer();
    } else {
      showSnackBarForintenetConnection(
          context, getLoanAppStatusAfterSelectLoanOffer);
    }
  }
  void getApplicantName() async {
    var name = await TGSharedPreferences.getInstance().get(PREF_BUSINESSNAME);
    setState(() {
      applicantName = name;
    });
  }
}
