import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/model/models/get_loan_app_status_main.dart';
import 'package:gstmobileservices/model/models/share_gst_invoice_res_main.dart';
import 'package:gstmobileservices/util/jumpingdot_util.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';

import '../../../../utils/colorutils/mycolors.dart';
import '../../../../widgets/app_button.dart';

class OfferExpireDialog extends StatefulWidget {
  const OfferExpireDialog({Key? key}) : super(key: key);

  @override
  State<OfferExpireDialog> createState() => _OfferExpireDialogState();
}

class _OfferExpireDialogState extends State<OfferExpireDialog> {
  ShareGstInvoiceResMain? _shareGstInvoiceRes;
  GetLoanStatusResMain? _getLoanStatusRes;
  late Timer timer;
  bool isStartTimer = true;
  bool isLoanDataFeched = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const DashboardWithGST(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );
        return true;
      },
      child: Scaffold(
        body: AbsorbPointer(
          absorbing: isLoanDataFeched,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.white,
                ),
                // height: 400.h,
                width: 335.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 40.h), //40
                    Center(
                      child: Icon(
                        Icons.error_outline_outlined,
                        color: ThemeHelper.getInstance()?.primaryColor,
                        size: 50.h,
                      ),
                    ),
                    SizedBox(height: 30.h), //40
                    Center(
                        child: Column(children: [
                      Text(
                        "Sorry!",
                        style: ThemeHelper.getInstance()?.textTheme.headline1?.copyWith(color: MyColors.darkblack),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 18.h),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Text(
                          "It seems this offer is expired. Request you to start new loan process once new GST return is filled.",
                          textAlign: TextAlign.center,
                          style: ThemeHelper.getInstance()?.textTheme.bodyText2,
                        ),
                      ),
                    ])),
                    //38
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: BtnCheckOut(),
                    ),
                    SizedBox(height: 30.h), //40
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget BtnCheckOut() {
    return isLoanDataFeched
        ? JumpingDots(
            color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary,
            radius: 10,
          )
        : AppButton(
            onPress: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const DashboardWithGST(),
                ),
                (route) => false, //if you want to disable back feature set to false
              );
            },
            title: "Back to Home",
          );
  }
}
