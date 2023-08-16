import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/requestmodel/get_yono_redirection_url.dart';
import 'package:gstmobileservices/model/responsemodel/get_yono_redirection_url_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/util/erros_handle_util.dart';
import 'package:gstmobileservices/util/showcustomesnackbar.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusConstants.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/internetcheckdialog.dart';

class BackToHome extends StatefulWidget {
  const BackToHome({Key? key}) : super(key: key);

  @override
  State<BackToHome> createState() => _BackToHomeState();
}

class _BackToHomeState extends State<BackToHome> {
  GetYonoRedirectionURLResponse redirectionResponse = GetYonoRedirectionURLResponse();

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

  Future<void> _onSuccessSaveConsent(GetYonoRedirectionURLResponse yonoResponse) async {
    TGLog.d("getYonoRedirectionURL() : Success---$yonoResponse");
    redirectionResponse = yonoResponse;
    if (yonoResponse.getYonoRedirectionURLObj().status == RES_DETAILS_FOUND) {
      if (await TGNetUtil.isInternetAvailable()) {
        callYonoAPI(yonoResponse);
      } else {
        if (context.mounted) {
          showSnackBarForIntenetConnectionWithArgs(context, callYonoAPI);
        }
      }
    }
  }

  _onErrorSaveConsent(TGResponse errorResponse) {
    TGLog.d("getYonoRedirectionURL() : Error");
    setState(() {});
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> callYonoAPI(GetYonoRedirectionURLResponse yonoResponse) async {
    Map<String, String> requestBody = <String, String>{
      'checksum': yonoResponse.getYonoRedirectionURLObj().data?.hashString ?? '',
      'data': yonoResponse.getYonoRedirectionURLObj().data?.data ?? '',
      'channelId': yonoResponse.getYonoRedirectionURLObj().data?.channelId ?? '',
    };
    Map<String, String> headers = {
      "Access-Control-Allow-Origin": "https://gsts.uat.sbi/*",
      "Access-Control-Allow-Methods": "POST",
      "Access-Control-Allow-Headers": "Origin",
    };
    final dio = Dio();
    const path = 'https://uatyb.sbi/yonobusiness/yonolanding.htm';
    final response = await dio.post(path,
        options: Options(
          headers: headers,
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: jsonEncode(requestBody));
    TGLog.d(response.extra.toString());
    TGLog.d(response.requestOptions.headers);
    print(response.data);
  }

  void showSnackBarForIntenetConnectionWithArgs(
      BuildContext context, Future<void> Function(GetYonoRedirectionURLResponse yonoResponse) apicall) async {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Retry"),
      onPressed: () async {
        if (await TGNetUtil.isInternetAvailable()) {
          showSnackBar(context, "You are online now");
          Navigator.of(context).pop(false);
          apicall(redirectionResponse);
        } else {
          showSnackBar(context, "You are offline");
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Connectivity"),
      content: Text("You are Offline.Please Turn on internet"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            child: alert,
            onWillPop: () async {
              return false;
            });
      },
    );
  }
}
