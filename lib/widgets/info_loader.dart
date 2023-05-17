import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';

class ShowInfoLoader extends StatelessWidget {
  const ShowInfoLoader({Key? key, required this.msg, required this.subMsg}) : super(key: key);
  final String msg;
  final String subMsg;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        TGView.showSnackBar(context: context, message: str_back_press_alert_msg);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      backgroundColor: MyColors.pnbcolorPrimary,
                      strokeWidth: 4.w,
                      color: MyColors.pnblogocolor,
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 30, top: 10, right: 30),
                  child: Center(
                    child: Text(
                      msg,
                      textAlign: TextAlign.center,
                      style: ThemeHelper.getInstance()?.textTheme.displayLarge,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 10, right: 30),
                child: Center(
                  child: Text(
                    subMsg,
                    textAlign: TextAlign.center,
                    style: ThemeHelper.getInstance()?.textTheme.headlineMedium,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
