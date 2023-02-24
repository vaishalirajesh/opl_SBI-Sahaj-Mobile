import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_all_invoice_loan_response_main.dart';
import 'package:gstmobileservices/singleton/tg_session.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/imageconstant.dart';

import '../../../../../routes.dart';
import '../../../../../utils/Utils.dart';
import '../../../../../utils/constants/prefrenceconstants.dart';
import '../../../../../utils/helpers/themhelper.dart';
import '../../../../../utils/strings/strings.dart';
import '../../../../../widgets/ratingwidget.dart';

class OutstandingTransactionCard extends StatefulWidget {
  static _OutstandingTransactionCardState? _state;
  OutstandingTransactionCard({Key? key, required this.disbursedInvoice})
      : super(key: key);


  SharedInvoice? disbursedInvoice;

  @override
  State<OutstandingTransactionCard> createState() {

    return _OutstandingTransactionCardState();
  }
}

class _OutstandingTransactionCardState extends State<OutstandingTransactionCard> {
  double rating = 3;
  var ratingText = '';
  var isRatingChange = false;
  var isCardHide = true;

  String? dueDate;
  String? bankName;
  String? buyerName;
  String? amountToPay;
  String? disbursedOnDate;
  String? disbursedDate;
  String? invoiceNumber;
  String? loanId;
  String? utrNo;
  String? latePaymentCharge;
  String? interestRate;
  String? gstin;
  String? loanAmount;
  String? disbursedmentAmount;
  String? invoiceDate;
  String? invoiceAmount;
  String? tenure;
  String? interestAmount;
  String? dueDays;
  @override
  void initState() {
    setDisbursedList(widget.disbursedInvoice);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setDisbursedList(widget.disbursedInvoice);
    });
  }

  setDisbursedList(SharedInvoice? disbursedInvoice) {
    setState(() {
      setOutstandingInvoiceData(disbursedInvoice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: MyColors.pnbPinkColor,
          borderRadius: BorderRadius.all(
            Radius.circular(12.r),
          )),
      child: Column(
        children: [
          setOutstandingCardUI(),
          GestureDetector(
              onTap: () {
                  setState(() {
                    isCardHide = !isCardHide;
                  });
              },
              child: showHideCardViewUI()),
        ],
      ),
    );
  }

//Main Content
  Widget setOutstandingCardUI() {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.white,
        border: Border.all(color: MyColors.pnbTextcolor.withOpacity(0.1)),
        borderRadius: BorderRadius.all(
          Radius.circular(12.r),
        ),
      ),
      child: Column(
        children: [
          setOutStandingCardView(),
          isCardHide ? Container() : setOutStandingCardBottomView()
        ],
      ),
    );
  }


  Widget showHideCardViewUI()
  {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.pnbPinkColor,
        borderRadius: BorderRadius.all(
          Radius.circular(12.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isCardHide ? str_view_more : str_hide,
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline5!
                  .copyWith(color: MyColors.pnbcolorPrimary),
            ),
            SizedBox(
              width: 12.w,
              height: 12.h,
              child: SvgPicture.asset(
                isCardHide ? Utils.path(DOWNARROWIC) : Utils.path(UPARROWIC),
//
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget setOutStandingCardView()
  {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 150.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        buyerName ?? '',
                        style: ThemeHelper.getInstance()!
                            .textTheme
                            .headline1!
                            .copyWith(fontSize: 13.sp),
                      ),
                      Text(
                        gstin ?? '',
                        style: ThemeHelper.getInstance()!
                            .textTheme
                            .headline3!
                            .copyWith(
                            fontSize: 10.sp, color: MyColors.pnbTextcolor),
                      )
                    ],
                  ),
                ),
                setDueDetailUi()
              ],
            ),
            SizedBox(
              height: 11.h,
            ),
            dividerUI(0.w),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //..Title Never Change
                      Text(str_Due_date,
                          style: ThemeHelper.getInstance()!
                              .textTheme
                              .headline3!
                              .copyWith(
                              fontSize: 12.sp,
                              color: MyColors.pnbTextcolor)),
                      Text(dueDate ?? '',
                          style: ThemeHelper.getInstance()!
                              .textTheme
                              .headline1!
                              .copyWith(fontSize: 13.sp)),
                    ],
                  ),
                ),
                Expanded(flex: 1, child: setAmountDueUi()),
              ],
            ),
            SizedBox(
              height: 10.h,
            )
          ],
        ),
      ),
    );
  }


 Widget setDueDetailUi() {
    return SizedBox(
        width: 120.w,
        height: 27.h,
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              setState(() {
                isCardHide = !isCardHide;
              });

              //    widget.flag = !widget.flag;
            });
          },
          style: ThemeHelper.setPinkDisableButtonBig(),
          child: Text(
            "Due in ${dueDays ?? ""} Days",
            style: TextStyle(fontSize: 12.sp),
          ),
        ));
  }

  Widget setAmountDueUi() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(str_Amount_due,
            style: ThemeHelper.getInstance()!
                .textTheme
                .headline3!
                .copyWith(fontSize: 12.sp, color: MyColors.pnbTextcolor)),
        Text(amountToPay ?? "",
            style: ThemeHelper.getInstance()!
                .textTheme
                .headline1!
                .copyWith(fontSize: 12.sp))
      ],
    );
  }

  Widget setOutStandingCardBottomView() {
    return Column(
      children: [
        setLenderRoiDetailUi(),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: setTransactionDetailListUI(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(str_Rate_us),
              SizedBox(
                height: 18.h,
                child: RatingBarWidget(
                  onRatingChanged: (double value) {
                    setReviewRating(value);
                  },
                  size: 18,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Divider(
            color: MyColors.pnbGreyColor.withOpacity(0.2),
          ),
        ),
        SizedBox(
          height: 40.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {

                  },
                  child: Text(
                    str_Request_for_deferment,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.red,
                        fontSize: 13.sp),
                  ),
                ),
                SizedBox(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, MyRoutes.ContactSupportRoutes);
                      },
                      child: Text(str_contact_support,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                              fontSize: 13.sp)),
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget setLenderRoiDetailUi() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Container(
        height: 42.h,
        decoration: BoxDecoration(
            color: MyColors.pnbSecondarycolor,
            borderRadius: BorderRadius.all(Radius.circular(8.r))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 100.h,
              child: Row(
                children: [
                  Text(
                    str_Lender + ' : ',
                    style: ThemeHelper.getInstance()!
                        .textTheme
                        .headline1!
                        .copyWith(fontSize: 13.sp),
                  ),
                  Text(
                    bankName ?? '',
                    style: ThemeHelper.getInstance()!
                        .textTheme
                        .headline1!
                        .copyWith(
                      fontSize: 13.sp,
                      color: MyColors.pnbTextcolor,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 7.0.h),
              child: Container(
                color: MyColors.pnbGreyColor.withOpacity(0.2),
                width: 1.w,
              ),
            ),
            SizedBox(
              width: 100.h,
              child: Row(
                children: [
                  Text(
                    str_ROI,
                    style: ThemeHelper.getInstance()!
                        .textTheme
                        .headline1!
                        .copyWith(fontSize: 13.sp),
                  ),
                  Text(
                    interestRate ?? '',
                    style: ThemeHelper.getInstance()!
                        .textTheme
                        .headline1!
                        .copyWith(
                      fontSize: 13.sp,
                      color: MyColors.pnbTextcolor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget setTransactionDetailListUI() {
    return Column(children: [
      setTransactionDetailUi(
          str_loan_id, loanId ?? '', str_utr_no, utrNo ?? ''),
      dividerUI(0.w),
      setTransactionDetailUi(str_Disbursed_on, disbursedOnDate ?? '',
          str_Loan_Amount, loanAmount ?? ''),
      dividerUI(0.w),
      setTransactionDetailUi(str_Invoice_date, invoiceDate ?? '',
          str_Invoice_amount, invoiceAmount ?? ""),
      dividerUI(0.w),
      setTransactionDetailUi(
          str_Tenure, tenure ?? '', str_Interest_amount, interestAmount ?? ''),
      dividerUI(0.w),
      setTransactionDetailUi(str_Late_payment_charges, latePaymentCharge ?? "",
          str_Days_past_due, dueDays ?? ''),
      dividerUI(0.w),

      // _buildRepeatRow(str_Late_payment_charges, str_l9, str_Days_past, str_10),
      // Padding(
      //   padding: EdgeInsets.symmetric(horizontal: 15.w),
      //   child: Divider(
      //     color: MyColors.pnbGreyColor.withOpacity(0.2),
      //   ),
      // ),
    ]);
  }

  Widget setTransactionDetailUi(String title1, String value1, String title2, String value2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title1,
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline3!
                  .copyWith(color: MyColors.pnbTextcolor, fontSize: 12.sp),
            ),
            Text(
              value1,
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline2!
                  .copyWith(color: MyColors.pnbcolorPrimary, fontSize: 12.sp),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              title2,
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline3!
                  .copyWith(color: MyColors.pnbTextcolor, fontSize: 12.sp),
            ),
            Text(value2,
                style: ThemeHelper.getInstance()!.textTheme.headline2!.copyWith(
                    color: MyColors.pnbcolorPrimary, fontSize: 12.sp)),
          ],
        ),
      ],
    );
  }

  Widget dividerUI(double padding){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Divider(
        color: MyColors.pnbGreyColor.withOpacity(0.2),
      ),
    );
  }


  void setReviewRating(double rating) {
    setState(() {
      this.rating = rating;
      isRatingChange = true;
    });
  }



  void setOutstandingInvoiceData(SharedInvoice? disbursedInvoice)  {
    dueDate = createDueDate(disbursedInvoice?.dueDate ?? '');
    bankName = disbursedInvoice?.bankName;
    interestRate = disbursedInvoice?.interestRate.toString() ?? "" + " % p.a";
    amountToPay = Utils.convertIndianCurrency(
        disbursedInvoice?.invoiceAmount?.toString());
    interestAmount = Utils.convertIndianCurrency(
        disbursedInvoice?.interestAmount?.toString());
    buyerName = disbursedInvoice?.buyerName;
    disbursedOnDate = createDueDate(disbursedInvoice?.fetchedDate ?? '');
    loanId = disbursedInvoice?.loanId ?? '';
    utrNo = disbursedInvoice?.utrNumber ?? '';
    invoiceDate = disbursedInvoice?.invoiceDate ?? '';
    gstin =  TGSession.getInstance().get(PREF_GSTIN);
    dueDays = disbursedInvoice?.dueDays;
    tenure = disbursedInvoice?.tenure.toString();
    latePaymentCharge =
        Utils.convertIndianCurrency(disbursedInvoice?.amountDue?.toString());
    invoiceAmount = Utils.convertIndianCurrency(
        disbursedInvoice?.invoiceAmount?.toString());
    loanAmount =
        Utils.convertIndianCurrency(disbursedInvoice?.loanAmount?.toString());
  }

  String createDueDate(String date) {
    if (date.isNotEmpty) {
      DateTime dt = DateTime.parse(date);

      String formattedDate = DateFormat('MM/dd/yyyy').format(dt);
      return formattedDate;
    } else {
      return '';
    }
  }
  //..demoData

}


