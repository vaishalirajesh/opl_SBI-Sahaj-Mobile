import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbi_sahay_1_0/utils/constants/imageconstant.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/colorutils/mycolors.dart';
import '../../../../utils/strings/strings.dart';
import '../../../../widgets/app_button.dart';
import 'loanofferlistscreen.dart';

class LoanOfferDialog extends StatefulWidget {
  const LoanOfferDialog({Key? key}) : super(key: key);

  @override
  State<LoanOfferDialog> createState() => _LoanOfferDialogState();
}

class _LoanOfferDialogState extends State<LoanOfferDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
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
                      child: SvgPicture.asset(Utils.path(GREENCONFORMTICK),
                          height: 52.h, //,
                          width: 52.w, //134.8,
                          allowDrawingOutsideViewBox: true)),
                  SizedBox(height: 30.h), //40
                  Center(
                      child: Column(children: [
                    Text(
                      "Loan Offers are ready",
                      style: ThemeHelper.getInstance()?.textTheme.headline1?.copyWith(color: MyColors.darkblack),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 18.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Text(
                        "Information sharing to get loan offers from lender is completed. Initiate loan process with lender now.",
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
    );
  }

  Widget BtnCheckOut() {
    return AppButton(
      onPress: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoanOfferList(),
          ),
          (route) => false,
        );
      },
      title: str_Checkit_out,
    );
  }
}
