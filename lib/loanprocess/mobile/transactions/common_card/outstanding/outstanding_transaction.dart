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
         // setOutstandingCardUI(),
          GestureDetector(
              onTap: () {
                  setState(() {
                    isCardHide = !isCardHide;
                  });
              },
              child: setOutstandingCardUI())//showHideCardViewUI()),
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
          isCardHide ? setOutStandingCardView() : setOutStandingCardBottomView(),
          //isCardHide ? Container() : setOutStandingCardBottomView()
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
                        buyerName ?? 'Flipcart Pvt. Ltd.',
                        style: ThemeHelper.getInstance()!
                            .textTheme
                            .headline1!
                            .copyWith(fontSize: 13.sp),
                      ),
                      Text(
                        gstin ?? 'Invoice: 23001832184',
                        style: ThemeHelper.getInstance()!
                            .textTheme
                            .headline3!
                            .copyWith(
                            fontSize: 10.sp, color: MyColors.pnbTextcolor),
                      )
                    ],
                  ),
                ),
                SvgPicture.asset(
                  !isCardHide ?
                  Utils.path(IMG_UP_ARROW) : Utils.path(IMG_DOWN_ARROW),
                  height: 20.h,
                  width: 20.w,
                ),
               // setDueDetailUi()
              ],
            ),
            SizedBox(
              height: 11.h,
            ),
            dividerUI(0.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: setAmountDueUi()),
                Expanded(
                  flex: 3,
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
                      Text('09/08/2022',
                          style: ThemeHelper.getInstance()!
                              .textTheme
                              .headline1!
                              .copyWith(fontSize: 13.sp,color: MyColors.pnbDarkGreyTextColor)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //..Title Never Change
                      Text("Due in 10 days",
                          style: ThemeHelper.getInstance()!
                              .textTheme
                              .headline3!
                              .copyWith(
                              fontSize: 12.sp,
                              color: MyColors.pnbYellowColor)),
                      // Text(dueDate ?? '09/08/2022',
                      //     style: ThemeHelper.getInstance()!
                      //         .textTheme
                      //         .headline1!
                      //         .copyWith(fontSize: 13.sp)),
                    ],
                  ),
                ),
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
        width: 100.w,
        height: 30.h,
        child: ElevatedButton(
          onPressed: () {
            // setState(() {
            //   setState(() {
            //     isCardHide = !isCardHide;
            //   });
            //
            //   //    widget.flag = !widget.flag;
            // });
          },
         // style: ThemeHelper.getInstance()?.elevale,
           child:
     Text(
            "Prepay Now",
            style: TextStyle(fontSize: 12.sp),
          ),
        ));
  }

  Widget setOpenBottomViewText(){
   return Text.rich(TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: "Request for deferment",
            style: ThemeHelper.getInstance()!
                .textTheme
                .headline6!
                .copyWith(
                fontSize: 12.sp,
                color: MyColors.pnbcolorPrimary,
                decoration:
                TextDecoration.underline),
          ),
          WidgetSpan(
            child: SizedBox(width: 36),
          ),
          TextSpan(
            text: "Contact support",
            style: ThemeHelper.getInstance()!
                .textTheme
                .headline6!
                .copyWith(
                fontSize: 12.sp,
                color:
                MyColors.pnbcolorPrimary,decoration:
            TextDecoration.underline),
          ),

        ]));

  }


  Widget setAmountDueUi() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
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
                .copyWith(fontSize: 12.sp,color: MyColors.pnbDarkGreyTextColor))
      ],
    );
  }

  Widget setOutStandingCardBottomView() {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      buyerName ?? 'Flipcart Pvt. Ltd.',
                      style: ThemeHelper.getInstance()!
                          .textTheme
                          .headline1!
                          .copyWith(fontSize: 13.sp),
                    ),
                    Text(
                      gstin ?? 'Invoice: 23001832184',
                      style: ThemeHelper.getInstance()!
                          .textTheme
                          .headline3!
                          .copyWith(
                          fontSize: 10.sp, color: MyColors.pnbTextcolor),
                    )
                  ],
                ),
              ),
              SvgPicture.asset(
                !isCardHide ?
                Utils.path(IMG_UP_ARROW) : Utils.path(IMG_DOWN_ARROW),
                height: 20.h,
                width: 20.w,
              ),
              // setDueDetailUi()
            ],
          ),
          SizedBox(
            height: 11.h,
          ),
          dividerUI(0.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: setAmountDueUi()),
              Expanded(
                flex: 3,
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
                    Text('09/08/2022',
                        style: ThemeHelper.getInstance()!
                            .textTheme
                            .headline1!
                            .copyWith(fontSize: 13.sp,color: MyColors.pnbDarkGreyTextColor)),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //..Title Never Change
                    Text("Due in 10 days",
                        style: ThemeHelper.getInstance()!
                            .textTheme
                            .headline3!
                            .copyWith(
                            fontSize: 12.sp,
                            color: MyColors.pnbYellowColor)),
                    // Text(dueDate ?? '09/08/2022',
                    //     style: ThemeHelper.getInstance()!
                    //         .textTheme
                    //         .headline1!
                    //         .copyWith(fontSize: 13.sp)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          dividerUI(0.w),
          SizedBox(
            height: 10.h,
          ),
          setRowColumValueOpenCard("Disbursed On","09/08/2022","Lender","State Bank of India"),
          setRowColumValueOpenCard("Invoice Date","09/08/2022","ROI","10% p.a."),
          setRowColumValueOpenCard("Loan Amount","₹41,600","Invoice Amount","₹52,000"),
          setRowColumValueOpenCard("Tenure","90 Days","Interest Amount","₹1040"),
          //SizedBox(height: 10.h),
          setDueDetailUi(),
          SizedBox(height: 15.h),
          setOpenBottomViewText(),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }

  Widget setRowColumValueOpenCard(String title, String value,String title2, String value2) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 66.w,
              child: Text(title,
                  style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(
                      fontSize: 12.sp,
                      )),
            ),
            // SizedBox(
            //   height: 5.h,
            // ),
            Text(value,
                style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(fontSize: 14.sp,)),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
        SizedBox(width: 40.w),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title2,
                style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(
                    fontSize: 12.sp,
                   )),
            // SizedBox(
            //   height: 5.h,
            // ),
            Text(value2,
                style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(fontSize: 14.sp,)),
            SizedBox(
              height: 20.h,
            ),
          ],
        )
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


