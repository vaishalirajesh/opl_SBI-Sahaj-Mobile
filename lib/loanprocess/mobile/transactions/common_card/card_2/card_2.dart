import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/model/models/get_all_invoice_loan_response_main.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/imageconstant.dart';

import '../../../../../utils/Utils.dart';
import '../../../../../utils/helpers/themhelper.dart';
import '../../../../../utils/strings/strings.dart';
import '../../../../../widgets/ratingwidget.dart';

setText(bool flag) => (flag == true) ? str_view_more : str_hide;

setIcon(bool flag) => (flag == true) ? str_Profile : str_Profile;

class Card2 extends StatefulWidget {
  Card2({
    Key? key,
    required this.flag,
    required this.index,
    this.outstanding_invoice,
  }) : super(key: key);
  bool flag;
  int index;
  List<SharedInvoice>? outstanding_invoice;
  List<DisbursedInvoice>? disbursed_invoice;
  List<SharedInvoice>? repaid_invoice;
  List<SharedInvoice>? overdue_invoice;
  List<SharedInvoice>? expired_invoice;
  List<SharedInvoice>? cancel_invoice;
  List<SharedInvoice>? ineligible_invoice;

  @override
  State<Card2> createState() => _Card2State();
}

class _Card2State extends State<Card2> {
  var ratingText = '';
  var isRatingChange = false;
  var isDialogShowing = false;

  double? amountToPay;
  String? interestRate;
  String? disbursedmentAmount;
  String? gstin;
  String? dueDate;
  String? interestAmount;
  String? bankName;
  double? invoiceAmount;
  String? buyerName;
  String? invoiceDate;
  String? loanAmount;
  String? dueDays;
  String? amountDue;
  String? stage;
  String? fetchedDate;
  String? invoiceNumber;
  String? tenure;
  String? loanId;
  String? utrNumber;

  double rating = 3;

  String? disbursedDate;

  String? cancelDate;

  void initState() {
    super.initState();
    if (widget.outstanding_invoice != null) {
      setOutstandingInvoiceData(widget.outstanding_invoice, widget.index);
    } else if (widget.disbursed_invoice != null) {
      setDisbursedInvoice(widget.disbursed_invoice, widget.index);
    } else if (widget.repaid_invoice != null) {
      setRepaidInvoice(widget.repaid_invoice);
    } else if (widget.overdue_invoice != null) {
      setRepaidInvoice(widget.overdue_invoice);
    } else if (widget.expired_invoice != null) {
      setExpiredInvoice(widget.expired_invoice);
    } else if (widget.cancel_invoice != null) {
      setCancelInvoice(widget.cancel_invoice);
    } else if (widget.ineligible_invoice != null) {
      setIneligibleInvoice(widget.ineligible_invoice);
    }
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
          _buildContentContainer(widget.flag),
          GestureDetector(
              onTap: () {
                setState(() {
                  widget.flag = !widget.flag;
                });
              },
              child: _buildToggerContainer(widget.flag)),
        ],
      ),
    );
  }

//..part 1
  _buildContentContainer(bool flag) => Container(
        decoration: BoxDecoration(
          color: MyColors.white,
          border: Border.all(color: MyColors.pnbTextcolor.withOpacity(0.1)),
          borderRadius: BorderRadius.all(
            Radius.circular(12.r),
          ),
        ),
        child: Column(
          children: [_buildFirstPart(flag), flag ? bottomRow() : SizedBox()],
        ),
      );

  _buildToggerContainer(bool flag) => Container(
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
                flag ? str_hide : str_view_more,
                style: ThemeHelper.getInstance()!.textTheme.headline5!.copyWith(color: MyColors.pnbcolorPrimary),
              ),
              SizedBox(
                width: 15.w,
                height: 15.h,
                child: SvgPicture.asset(
                  Utils.path(flag ? UPARROWIC : DOWNARROWIC),
//
                ),
              ),
            ],
          ),
        ),
      );

//...part1 subpart 1
  Widget bottomRow() {
    return Container(
      child: Column(
        children: [
          _buildTopContentinsidecard(),
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: _buildListRow(),
          ),
          Container(
            height: 40.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    width: 100.w,
                    child: GestureDetector(
                        onTap: () {},
                        child: Text(str_Raise_dispute,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                decoration: TextDecoration.underline, color: Colors.yellow, fontSize: 13.sp)))),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 7.0.h),
                  child: Container(
                    color: MyColors.pnbGreyColor.withOpacity(0.2),
                    width: 1.w,
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    width: 100.w,
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        str_Request_for_deferment,
                        textAlign: TextAlign.center,
                        style: TextStyle(decoration: TextDecoration.underline, color: Colors.red, fontSize: 13.sp),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 7.0.h),
                  child: Container(
                    color: MyColors.pnbGreyColor.withOpacity(0.2),
                    width: 1.w,
                  ),
                ),
                SizedBox(
                    width: 100.w,
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(str_contact_support,
                          textAlign: TextAlign.center,
                          style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue, fontSize: 13.sp)),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

//..
  _buildTopContentinsidecard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Container(
        height: 42.h,
        decoration:
            BoxDecoration(color: MyColors.pnbSecondarycolor, borderRadius: BorderRadius.all(Radius.circular(8.r))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 100.h,
              child: Row(
                children: [
                  Text(
                    str_Lender + ' : ',
                    style: ThemeHelper.getInstance()!.textTheme.headline1!.copyWith(fontSize: 13.sp),
                  ),
                  Text(
                    bankName ?? '',
                    style: ThemeHelper.getInstance()!.textTheme.headline1!.copyWith(
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
                    style: ThemeHelper.getInstance()!.textTheme.headline1!.copyWith(fontSize: 13.sp),
                  ),
                  Text(
                    interestRate ?? '',
                    style: ThemeHelper.getInstance()!.textTheme.headline1!.copyWith(
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

  _buildDivider(double padding) => Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Divider(
          color: MyColors.pnbGreyColor.withOpacity(0.2),
        ),
      );

  _buildListRow() {
    return Column(children: [
      _buildRepeatRow(str_Disbursed_on, disbursedmentAmount ?? '', str_Loan_Amount, loanAmount ?? ''),
      _buildDivider(0.w),
      _buildRepeatRow(str_Invoice_date, invoiceDate ?? '', str_Invoice_amount, '0'),
      _buildDivider(0.w),
      _buildRepeatRow(str_Tenure, tenure ?? '', str_Interest_amount, interestAmount ?? ''),
      _buildDivider(0.w),
      _buildRepeatRow(str_Late_payment_charges, '0', str_Days_past_due, dueDays ?? ''),
      _buildDivider(0.w),

      // _buildRepeatRow(str_Late_payment_charges, str_l9, str_Days_past, str_10),
      // Padding(
      //   padding: EdgeInsets.symmetric(horizontal: 15.w),
      //   child: Divider(
      //     color: MyColors.pnbGreyColor.withOpacity(0.2),
      //   ),
      // ),
    ]);
  }

  _buildRepeatRow(String title1, String value1, String title2, String value2) {
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

  _buildFirstPart(bool flag) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200.w,
                      child: Text(
                        buyerName ?? '',
                        maxLines: 2,
                        style: ThemeHelper.getInstance()!.textTheme.headline1!.copyWith(fontSize: 13.sp),
                      ),
                    ),
                    Text(
                      gstin ?? '',
                      style: ThemeHelper.getInstance()!
                          .textTheme
                          .headline3!
                          .copyWith(fontSize: 10.sp, color: MyColors.pnbTextcolor),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 92.w,
                        height: 27.h,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            str_PayNow,
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          style: ThemeHelper.getInstance()!.elevatedButtonTheme.style!.copyWith(
                              foregroundColor: MaterialStatePropertyAll(MyColors.pnbcolorPrimary),
                              backgroundColor: MaterialStatePropertyAll(MyColors.pnbPinkColor)),
                        ))
                  ],
                )
              ],
            ),
            _buildDivider(0.w),
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
                              .copyWith(fontSize: 12.sp, color: MyColors.pnbTextcolor)),
                      Text(dueDate ?? '',
                          style: ThemeHelper.getInstance()!.textTheme.headline1!.copyWith(fontSize: 13.sp)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(str_Original_amount_due,
                          style: ThemeHelper.getInstance()!
                              .textTheme
                              .headline3!
                              .copyWith(fontSize: 12.sp, color: MyColors.pnbTextcolor)),
                      FittedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('0', //invoiceAmount
                                style: ThemeHelper.getInstance()!.textTheme.headline1!.copyWith(fontSize: 12.sp)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }

  void setRatingText(String value) {
    setState(() {
      this.ratingText = value;
    });
  }

  void setReviewRating(double rating) {
    setState(() {
      this.rating = rating;
      isRatingChange = true;
    });
  }

//..demoData

  List<SharedInvoice>? repaid_invoice;
  List<SharedInvoice>? overdue_invoice;
  List<SharedInvoice>? expired_invoice;
  List<SharedInvoice>? cancel_invoice;
  List<SharedInvoice>? ineligible_invoice;

  setOutstandingInvoiceData(List<SharedInvoice>? outstanding_invoice, int index) {
    /*amountToPay=outstanding_invoice?[index].amountToPay;
     interestRate=outstanding_invoice?[index].interestRate;
     disbursedmentAmount=outstanding_invoice?[index].disbursedmentAmount;
     gstin=outstanding_invoice?[index].gstin;
     dueDate=outstanding_invoice?[index].dueDate;
     interestAmount=outstanding_invoice?[index].interestAmount;
     bankName=outstanding_invoice?[index].bankName;
     invoiceAmount=outstanding_invoice?[index].invoiceAmount;
     buyerName=outstanding_invoice?[index].buyerName;
     invoiceDate=outstanding_invoice?[index].invoiceDate;
     loanAmount=outstanding_invoice?[index].loanAmount;
     dueDays=outstanding_invoice?[index].dueDate;
     amountDue=outstanding_invoice?[index].amountDue;
     stage=outstanding_invoice?[index].stage;
     fetchedDate=outstanding_invoice?[index].fetchedDate;
     invoiceNumber=outstanding_invoice?[index].invoiceNumber;
     tenure=outstanding_invoice?[index].tenure;
     loanId=outstanding_invoice?[index].loanId;
     utrNumber=outstanding_invoice?[index].utrNumber;*/
  }

  setDisbursedInvoice(List<DisbursedInvoice>? disbursed_invoice, int index) {
    stage = disbursed_invoice?[index].stage;
    dueDate = disbursed_invoice?[index].dueDate;
    bankName = disbursed_invoice?[index].bankName;
    buyerName = disbursed_invoice?[index].buyerName;
    amountToPay = disbursed_invoice?[index].amountToPay;
    fetchedDate = disbursed_invoice?[index].fetchedDate;
    disbursedDate = disbursed_invoice?[index].disbursedDate;
    invoiceNumber = disbursed_invoice?[index].invoiceNumber;
  }

  setRepaidInvoice(List<SharedInvoice>? repaid_invoice) {
    String? stage;
    String? bankName;
    String? buyerName;
    double? invoiceAmount;
    String? invoiceNumber;
    double? amountPaid;
  }

  setOverdueInvoice(List<SharedInvoice>? overdue_invoice) {
    String? stage;
    String? dueDate;
    String? bankName;
    String? buyerName;
    double? invoiceAmount;
    String? invoiceNumber;
    int? dpdPastDate;
  }

  setExpiredInvoice(List<SharedInvoice>? expired_invoice) {
    String? stage;
    String? bankName;
    String? buyerName;
    double? invoiceAmount;
    String? invoiceNumber;
    String? cancelDate;
  }

  setCancelInvoice(List<SharedInvoice>? cancel_invoice) {
    String? stage;
    String? bankName;
    String? buyerName;
    String? invoiceNumber;
    String? cancelDate;
  }

  setIneligibleInvoice(List<SharedInvoice>? ineligible_invoice) {
    String? stage;
    String? bankName;
    String? buyerName;
    String? invoiceNumber;
    String? cancelDate;
  }

  void setData() {
    // companyName=str_AmazonPvtLtd;
    // gstIn=str_23001832184;
    // type=strDisbursed;
    // dueDateValue=str_date_12;
    //
    // originalamountduevalue=str_money52;
    // disbursed_on_value=str_date_12;
    // LoanAmountvalue=str_42640;
    //
    // uTRvalue=str_l2;
    // // disbursedOnValue=str_l3;
    // InvoicedateValue=str_l5;
    // InvoiceAmountValue=str_l6;
    // //  LenderValue;
    // // ROIValue;
    //
    // TenureValue=str_l7;
    // InterestAmountValue=str_l8;
    // latePaymentChargesValue=str_l9;
    // DueDayValue=str_Days_past_due_value;
  }
}

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;

  StarRating({this.starCount = 5, this.rating = .0, required this.onRatingChanged, required this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        Icons.star,
        color: MyColors.PnbUnFilledRatingColor,
        size: 32,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        color: color,
        size: 32,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: color,
        size: 32,
      );
    }
    return GestureDetector(
      onTap: onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(children: new List.generate(starCount, (index) => buildStar(context, index)));
  }
}

class RatingBarWidget extends StatefulWidget {
  final ValueChanged<double> onRatingChanged;

  RatingBarWidget({Key? key, required this.onRatingChanged}) : super(key: key);

  @override
  _RatingBarWidgetState createState() => new _RatingBarWidgetState();
}

class _RatingBarWidgetState extends State<RatingBarWidget> {
  double rating = 5;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StarRating(
          rating: rating,
          onRatingChanged: (rating) {
            setState(() => this.rating = rating);
            widget.onRatingChanged(this.rating);
            ThemeHelper.getInstance()?.colorScheme.secondaryContainer;
          },
          color: ThemeHelper.getInstance()!.colorScheme.secondaryContainer,
        )
      ],
    );
  }
}
