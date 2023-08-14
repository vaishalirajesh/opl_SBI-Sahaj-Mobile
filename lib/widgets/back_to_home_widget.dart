import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/common/keys.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/requestmodel/get_yono_redirection_url.dart';
import 'package:gstmobileservices/model/responsemodel/get_yono_redirection_url_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/erros_handle_util.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:gstmobileservices/util/tg_view.dart';
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
    var jsonReq = jsonEncode(sBILogoutRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_SBI_REDIRECT_YONO);
    ServiceManager.getInstance().getYonoRedirectionURL(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessSaveConsent(response),
        onError: (errorResponse) => _onErrorSaveConsent(errorResponse));
  }

  _onSuccessSaveConsent(GetYonoRedirectionURLResponse yonoResponse) async {
    TGLog.d("getYonoRedirectionURL() : Success---$yonoResponse");
    if (yonoResponse.getYonoRedirectionURLObj().status == RES_DETAILS_FOUND) {
      await TGSharedPreferences.getInstance().remove(PREF_ACCESS_TOKEN_SBI);
      final dio = Dio();
      Map<String, String> requestBody = <String, String>{
        'checksum': yonoResponse.getYonoRedirectionURLObj().data?.hashString ?? '',
        'data': yonoResponse.getYonoRedirectionURLObj().data?.data ?? '',
        'channelId': yonoResponse.getYonoRedirectionURLObj().data?.channelId ?? '',
      };
      dio.options.contentType = Headers.formUrlEncodedContentType;
      final rs = await dio.post("https://uatyb.sbi/yonobusiness/yonolanding.htm",
          options: Options(contentType: Headers.formUrlEncodedContentType), data: FormData.fromMap(requestBody));
      if (rs.statusCode == 200) {
        TGLog.d('Uploaded!');
      } else {
        TGView.showSnackBar(context: context, message: "Something went wrong");
      }
    } else {
      LoaderUtils.handleErrorResponse(context, yonoResponse?.getYonoRedirectionURLObj().status,
          yonoResponse?.getYonoRedirectionURLObj().message, null);
    }
  }

  _onErrorSaveConsent(TGResponse errorResponse) {
    TGLog.d("getYonoRedirectionURL() : Error");
    setState(() {});
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> callYonoAPI() async {}
}
