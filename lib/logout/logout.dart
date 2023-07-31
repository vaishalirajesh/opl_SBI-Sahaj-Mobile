import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/common/keys.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/requestmodel/sbi_logout_request.dart';
import 'package:gstmobileservices/model/responsemodel/sbi_logout_response.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/erros_handle_util.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/constants/imageconstant.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusConstants.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/internetcheckdialog.dart';
import 'package:sbi_sahay_1_0/utils/progressLoader.dart';
import 'package:sbi_sahay_1_0/welcome/ntbwelcome/mobileui/getstarted.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TGLog.d('Hello Logout');
        _showFirstWaring(context);
      },
      child: Padding(
        padding: EdgeInsets.only(
          top: 10.h,
          bottom: 10.h,
          left: 8.w,
        ),
        child: SvgPicture.asset(AppUtils.path(LOGOUT), height: 20.h, width: 20.w),
      ),
    );
  }

  void _showFirstWaring(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text('Are you sure you want to logout?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: userLogout,
                  child: const Text('Logout'),
                )
              ],
            ),
          ],
          title: Text(
            'Logout',
            style: ThemeHelper.getInstance()!.textTheme.displayLarge,
          ),
        ),
      );

  void userLogout() async {
    if (await TGNetUtil.isInternetAvailable()) {
      logout();
    } else {
      if (context.mounted) {
        showSnackBarForintenetConnection(context, logout);
      }
    }
  }

  Future<void> logout() async {
    SBILogoutRequest sBILogoutRequest = SBILogoutRequest();
    ServiceManager.getInstance().sbiLogout(
        request: sBILogoutRequest,
        onSuccess: (response) => _onSuccessLogout(response),
        onError: (errorResponse) => _onErrorLogout(errorResponse));
  }

  _onSuccessLogout(SBILogoutResponse response) async {
    TGLog.d("sbiLogout() : Success---$response");
    Navigator.pop(context);
    if (response.getLogoutObj().status == RES_SUCCESS) {
      TGLog.d("sbiLogout ---${response.getLogoutObj().referenceId}");
      await TGSharedPreferences.getInstance().remove(PREF_ACCESS_TOKEN_SBI);
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const GetStarted(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );
      }
    } else {
      LoaderUtils.handleErrorResponse(context, response?.getLogoutObj().status, response?.getLogoutObj().message, null);
    }
    setState(() {});
  }

  _onErrorLogout(TGResponse errorResponse) {
    TGLog.d("sbiLogout() : Error");
    setState(() {});
    handleServiceFailError(context, errorResponse.error);
  }
}
