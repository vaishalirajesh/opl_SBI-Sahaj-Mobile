import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/util/tg_flavor.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';

import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/constants/route_handler.dart';
import '../../../../utils/helpers/themhelper.dart';
import '../../../../utils/strings/strings.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';

class AAErrorScreen extends StatelessWidget {
  const AAErrorScreen({Key? key, this.msg = ''}) : super(key: key);

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
                  msg != '' ? msg : aa_error_txt,
                  style: ThemeHelper.getInstance()!.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AppButton(
                      onPress: () {
                        navigationHandler(
                          bankName: TGFlavor.param("bankName"),
                          currentScreen: StringAssets.aaPage,
                          context: context,
                          isCommon: false,
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
                navigationHandler(
                  bankName: TGFlavor.param("bankName"),
                  currentScreen: StringAssets.aaPage,
                  context: context,
                  isCommon: false,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPopScope(BuildContext ctx) async {
    navigationHandler(
      bankName: TGFlavor.param("bankName"),
      currentScreen: StringAssets.aaPage,
      context: ctx,
      isCommon: false,
    );
    return true;
  }
}
