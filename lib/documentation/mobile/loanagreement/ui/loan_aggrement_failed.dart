import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';

import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/helpers/themhelper.dart';
import '../../../../utils/strings/strings.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';
import 'loanageementscreen.dart';

class LoanAgreementErrorScreen extends StatelessWidget {
  const LoanAgreementErrorScreen({Key? key, this.msg = ''}) : super(key: key);

  // If you want specific error msg then pas msg
  final String msg;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPopScope(context),
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(20.0.r),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 100.h,
                ),
                Image.asset(
                  AppUtils.path(AAFAIL),
                  height: 200.h,
                  width: 200.w,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  str_sorry,
                  style: ThemeHelper.getInstance()!.textTheme.displayLarge,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  esignin_error,
                  style: ThemeHelper.getInstance()!.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AppButton(
                      onPress: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => LoanAgreementMain(),
                          ),
                          (route) => false, //if you want to disable back feature set to false
                        );
                      },
                      title: str_try_again,
                    ),
                  ),
                ),
              ],
            ),
          ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.h),
            child: getAppBarWithTitle(
              '',
              onClickAction: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoanAgreementMain(),
                  ),
                  (route) => false, //if you want to disable back feature set to false
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPopScope(BuildContext ctx) async {
    Navigator.pushAndRemoveUntil(
      ctx,
      MaterialPageRoute(
        builder: (BuildContext context) => LoanAgreementMain(),
      ),
      (route) => false, //if you want to disable back feature set to false
    );
    return true;
  }
}
