import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/gstinvoiceslist/ui/gstinvoicelist.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/imageconstant.dart';
import 'package:sbi_sahay_1_0/utils/helpers/myfonts.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';

class CongratulationsScreen extends StatefulWidget {
  const CongratulationsScreen({Key? key}) : super(key: key);

  @override
  State<CongratulationsScreen> createState() => _CongratulationsScreenState();
}

class _CongratulationsScreenState extends State<CongratulationsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              Utils.path(KFSCONGRATULATIONBG),
              fit: BoxFit.fill,
              height: 0.35.sh,
              width: 1.sw,
            ),
            Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                children: [
                  SizedBox(height: 100.h),
                  SvgPicture.asset(
                    Utils.path(FILLGREENCONFORMTICK),
                    height: 52.h, //,
                    width: 52.w, //134.8,
                    allowDrawingOutsideViewBox: true,
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    str_congratulation,
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline2
                        ?.copyWith(fontSize: 20.sp, color: MyColors.darkblack),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 18.h),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Text(
                      str_congratulation_txt,
                      textAlign: TextAlign.center,
                      style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(
                          fontSize: 14.sp, color: MyColors.darkblack, fontFamily: MyFont.Nunito_Sans_Regular),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      str_loan_disbursed_process,
                      style: ThemeHelper.getInstance()
                          ?.textTheme
                          .headline2
                          ?.copyWith(fontSize: 16.sp, color: MyColors.darkblack),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Divider(
                    color: MyColors.pnbdivdercolor,
                    thickness: 1.h,
                  ),
                  SizedBox(height: 10.h),
                  setRowColumValueOpenCard(str_Status, strDisbursed, str_Lender, "State Bank of India"),
                  setRowColumValueOpenCard(str_Total_Loan, "₹41,600", str_Deposit_Account, 'SBI XXXXXX7564'),
                  setRowColumValueOpenCard(str_Total_Repayment, "₹26,600", str_due_date, '12 Apr, 2021 (60 days)'),
                  setRowColumValueOpenCard(str_loan_id, "90 Days", "", ""),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 30.h),
          child: AppButton(
            onPress: () {
              // Navigator.push(context, CustomRightToLeftPageRoute(child:EnableGstApi()));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const GSTInvoicesList(),
                ),
              );

              // Navigator.pushNamed(context, MyRoutes.EnableGstApiRoutes);
            },
            title: str_Financed_other_Invoices,
          ),
        ),
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
}
