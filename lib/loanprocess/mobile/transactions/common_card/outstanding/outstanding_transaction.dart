import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/model/models/get_all_invoice_loan_response_main.dart';
import 'package:gstmobileservices/singleton/tg_session.dart';
import 'package:intl/intl.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/imageconstant.dart';

import '../../../../../utils/Utils.dart';
import '../../../../../utils/constants/prefrenceconstants.dart';
import '../../../../../utils/helpers/themhelper.dart';
import '../../../../../utils/strings/strings.dart';

class OutstandingCard extends StatefulWidget {
  const OutstandingCard({
    Key? key,
    required this.sharedInvoice,
    required this.bottomWidget,
  }) : super(key: key);

  final SharedInvoice? sharedInvoice;
  final Widget bottomWidget;

  @override
  State<OutstandingCard> createState() {
    return _OutstandingCardState();
  }
}

class _OutstandingCardState extends State<OutstandingCard> {
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
  String? amoutDue;

  @override
  void initState() {
    setDisbursedList(widget.sharedInvoice);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setDisbursedList(widget.sharedInvoice);
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
        ),
      ),
      child: Column(
        children: [
          // setOutstandingCardUI(),
          GestureDetector(
            onTap: () {
              setState(() {
                isCardHide = !isCardHide;
              });
            },
            child: setOutstandingCardUI(),
          ) //showHideCardViewUI()),
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
          isCardHide
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: setOutStandingCardView(),
                )
              : setOutStandingCardBottomView(),
          //isCardHide ? Container() : setOutStandingCardBottomView()
        ],
      ),
    );
  }

  Widget showHideCardViewUI() {
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
              style: ThemeHelper.getInstance()!.textTheme.headline5!.copyWith(color: MyColors.pnbcolorPrimary),
            ),
            SizedBox(
              width: 12.w,
              height: 12.h,
              child: SvgPicture.asset(
                isCardHide ? AppUtils.path(DOWNARROWIC) : AppUtils.path(UPARROWIC),
//
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget setOutStandingCardView() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      buyerName ?? '',
                      style: ThemeHelper.getInstance()!.textTheme.headline5!.copyWith(
                            fontSize: 14.sp,
                            color: MyColors.pnbcolorPrimary,
                          ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      'Invoice: $invoiceNumber',
                      style: ThemeHelper.getInstance()!
                          .textTheme
                          .headline4!
                          .copyWith(fontSize: 12.sp, color: MyColors.pnbTextcolor),
                    )
                  ],
                ),
              ),
              SvgPicture.asset(
                !isCardHide ? AppUtils.path(IMG_UP_ARROW) : AppUtils.path(IMG_DOWN_ARROW),
                height: 20.h,
                width: 20.w,
              ),
              // setDueDetailUi()
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          dividerUI(0.w),
          SizedBox(
            height: 8.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: setAmountDueUi(),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //..Title Never Change
                    Text(
                      str_Due_date,
                      style: ThemeHelper.getInstance()!.textTheme.overline!,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      dueDate == null || dueDate == '' ? '-' : dueDate!,
                      style: ThemeHelper.getInstance()!.textTheme.overline!.copyWith(
                            fontSize: 14.sp,
                            color: MyColors.darkblack,
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //..Title Never Change
                      Text(
                        '',
                        style: ThemeHelper.getInstance()!.textTheme.overline!,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "Due in $dueDays ${int.parse(dueDays ?? "0") < 1 ? "Day" : "Days"}",
                        style: ThemeHelper.getInstance()!.textTheme.headline4!.copyWith(
                              fontSize: 12.sp,
                              color: AppUtils.getBgColorByTransactionStatus(str_Outstanding),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15.h,
          )
        ],
      ),
    );
  }

  Widget setAmountDueUi() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          str_Amount_due,
          style: ThemeHelper.getInstance()!.textTheme.overline!,
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          invoiceAmount ?? "",
          style: ThemeHelper.getInstance()!.textTheme.overline!.copyWith(
                fontSize: 14.sp,
                color: MyColors.darkblack,
              ),
        )
      ],
    );
  }

  Widget setOutStandingCardBottomView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          setOutStandingCardView(),
          dividerUI(0.w),
          SizedBox(
            height: 10.h,
          ),
          setRowColumValueOpenCard(
              "Disbursed On", disbursedDate ?? '-', "Lender", AppUtils.getBankFullName(bankName: bankName ?? '')),
          setRowColumValueOpenCard("Invoice Date", invoiceDate ?? '-', "ROI", '$interestRate% p.a.' ?? '-'),
          setRowColumValueOpenCard("Loan Amount", loanAmount ?? '0', "Invoice Amount", invoiceAmount ?? '0'),
          setRowColumValueOpenCard(
              "Tenure", '$tenure ${tenure == '0' ? 'Day' : 'Days'}', "Interest Amount", interestAmount ?? '0'),
          widget.bottomWidget,
        ],
      ),
    );
  }

  Widget setRowColumValueOpenCard(String title, String value, String title2, String value2) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                // width: 66.w,
                child: Text(
                  title,
                  style: ThemeHelper.getInstance()!.textTheme.overline!,
                ),
              ),
              Text(
                value,
                style: ThemeHelper.getInstance()!.textTheme.overline!.copyWith(
                      fontSize: 14.sp,
                      color: MyColors.darkblack,
                    ),
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
        SizedBox(width: 40.w),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title2, style: ThemeHelper.getInstance()!.textTheme.overline!),
              // SizedBox(
              //   height: 5.h,
              // ),
              Text(
                value2,
                style: ThemeHelper.getInstance()!.textTheme.overline!.copyWith(
                      fontSize: 14.sp,
                      color: MyColors.darkblack,
                    ),
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ],
    );
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
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .headline2!
                    .copyWith(color: MyColors.pnbcolorPrimary, fontSize: 12.sp)),
          ],
        ),
      ],
    );
  }

  Widget dividerUI(double padding) {
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

  void setOutstandingInvoiceData(SharedInvoice? disbursedInvoice) {
    dueDate = createDueDate(disbursedInvoice?.dueDate ?? '');
    disbursedDate = createDueDate(disbursedInvoice?.disbursedDate ?? '');
    bankName = disbursedInvoice?.bankName;
    interestRate = disbursedInvoice?.interestRate.toString() ?? "" + " % p.a";
    amountToPay = AppUtils.convertIndianCurrency(disbursedInvoice?.invoiceAmount?.toString());
    amoutDue = AppUtils.convertIndianCurrency(disbursedInvoice?.amountDue?.toString());
    interestAmount = AppUtils.convertIndianCurrency(disbursedInvoice?.interestAmount?.toString());
    buyerName = disbursedInvoice?.buyerName;
    disbursedOnDate = createDueDate(disbursedInvoice?.fetchedDate ?? '');
    loanId = disbursedInvoice?.loanId ?? '';
    utrNo = disbursedInvoice?.utrNumber ?? '';
    invoiceDate = AppUtils.createInvoiceDate(disbursedInvoice?.invoiceDate ?? '');
    gstin = TGSession.getInstance().get(PREF_GSTIN);
    dueDays = dueDays = disbursedInvoice?.dueDays != null ? disbursedInvoice?.dueDays.toString() : '0';
    tenure = disbursedInvoice?.tenure != null ? disbursedInvoice?.tenure.toString() : '0';
    latePaymentCharge = AppUtils.convertIndianCurrency(disbursedInvoice?.amountDue?.toString());
    invoiceAmount = AppUtils.convertIndianCurrency(disbursedInvoice?.invoiceAmount?.toString());
    loanAmount = AppUtils.convertIndianCurrency(disbursedInvoice?.loanAmount?.toString());
    invoiceNumber = disbursedInvoice?.invoiceNumber;
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
