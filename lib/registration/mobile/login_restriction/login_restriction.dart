import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/singleton/tg_session.dart';
import 'package:sbi_sahay_1_0/utils/constants/session_keys.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';

class RestrictLogin extends StatelessWidget {
  const RestrictLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return RestrictLoginScreen();
  }
}

class RestrictLoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RestrictLgoinState();
}

class RestrictLgoinState extends State<RestrictLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop(animated: true);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 100.h),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  TGSession.getInstance().get(SESSION_ERROR_MSG) ?? '',
                  style: ThemeHelper.getInstance()?.textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30.h,
                ),
                ElevatedButton(
                  onPressed: () {
                    SystemNavigator.pop(animated: true);
                  },
                  child: Center(
                    child: Text(str_back_home),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
