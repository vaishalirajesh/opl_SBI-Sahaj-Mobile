import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/common/keys.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/requestmodel/get_yono_redirection_url.dart';
import 'package:gstmobileservices/model/responsemodel/get_yono_redirection_url_response.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/erros_handle_util.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusConstants.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/internetcheckdialog.dart';
import 'package:sbi_sahay_1_0/utils/progressLoader.dart';

class BackToHome extends StatefulWidget {
  const BackToHome({Key? key}) : super(key: key);

  @override
  State<BackToHome> createState() => _BackToHomeState();
}

class _BackToHomeState extends State<BackToHome> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.exit_to_app_outlined,
        size: 24.r,
        color: MyColors.sbiPinkColor,
      ),
      title: Text('Back to Home', style: ThemeHelper.getInstance()?.textTheme.headline3),
      onTap: () {
        onpPressGetURL();
      },
    );
  }

  onpPressGetURL() async {
    if (await TGNetUtil.isInternetAvailable()) {
      getYonoRedirectionURL();
    } else {
      if (context.mounted) {
        showSnackBarForintenetConnection(context, getYonoRedirectionURL);
      }
    }
  }

  Future<void> getYonoRedirectionURL() async {
    GetYonoRedirectionURLRequest sBILogoutRequest = GetYonoRedirectionURLRequest();
    ServiceManager.getInstance().getYonoRedirectionURL(
        request: sBILogoutRequest,
        onSuccess: (response) => _onSuccessSaveConsent(response),
        onError: (errorResponse) => _onErrorSaveConsent(errorResponse));
  }

  _onSuccessSaveConsent(GetYonoRedirectionURLResponse response) async {
    TGLog.d("sbiLogout() : Success---$response");
    Navigator.pop(context);
    if (response.getYonoRedirectionURLObj().status == RES_SUCCESS) {
      TGLog.d("sbiLogout ---${response.getYonoRedirectionURLObj().referenceId}");
      await TGSharedPreferences.getInstance().remove(PREF_ACCESS_TOKEN_SBI);
      SystemNavigator.pop(animated: true);
    } else {
      LoaderUtils.handleErrorResponse(
          context, response?.getYonoRedirectionURLObj().status, response?.getYonoRedirectionURLObj().message, null);
    }
    setState(() {});
  }

  _onErrorSaveConsent(TGResponse errorResponse) {
    TGLog.d("sbiLogout() : Error");
    setState(() {});
    handleServiceFailError(context, errorResponse.error);
  }
}
