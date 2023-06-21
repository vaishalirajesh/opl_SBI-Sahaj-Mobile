import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/consent_handle_res_main.dart';
import 'package:gstmobileservices/model/models/get_consent_handle_url_response_main.dart';
import 'package:gstmobileservices/model/requestmodel/consent_handle_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_consent_handle_url_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_consent_status_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_redirectional_url_request.dart';
import 'package:gstmobileservices/model/responsemodel/consent_handle_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_consent_handle_url_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_redirectional_url_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_session.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/constants/session_keys.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusConstants.dart';
import 'package:sbi_sahay_1_0/utils/erros_handle.dart';

import '../loanprocess/mobile/accountaggregatorntb/launchAaUrl/aalaunchurlmain.dart'
    if (dart.library.html) '../loanprocess/mobile/accountaggregatorntb/launchAaUrl/aaloaunchurlweb.dart'
    if (dart.library.io) '../loanprocess/mobile/accountaggregatorntb/launchAaUrl/aalaunchurlmobile.dart';
import '../routes.dart';
import '../utils/Utils.dart';
import '../utils/colorutils/mycolors.dart';
import '../utils/constants/appconstant.dart';
import '../utils/constants/imageconstant.dart';
import '../utils/constants/stageconstants.dart';
import '../utils/dimenutils/dimensutils.dart';
import '../utils/helpers/themhelper.dart';
import '../utils/internetcheckdialog.dart';
import '../utils/progressLoader.dart';
import '../utils/strings/strings.dart';

class RedirectedLoader extends StatefulWidget {
  const RedirectedLoader({Key? key}) : super(key: key);

  @override
  State<RedirectedLoader> createState() => _RedirectedLoaderState();
}

class _RedirectedLoaderState extends State<RedirectedLoader> {
  bool isLoader = true;
  ConsentHandleResMain? consentHandleResobject;
  GetConsentHandleUrlResMain? consentHandleUrlobject;

  @override
  void initState() {
    consentHandleApiCall();
    super.initState();
  }

  Future<void> consentHandleApiCall() async {
    if (await TGNetUtil.isInternetAvailable()) {
      consentHandleRequestApi();
    } else {
      showSnackBarForintenetConnection(context, consentHandleRequestApi);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              MyColors.pnbPinkColor,
              ThemeHelper.getInstance()!.backgroundColor
            ], begin: Alignment.bottomCenter, end: Alignment.centerLeft)),
            height: MyDimension.getFullScreenHeight(),
            width: MyDimension.getFullScreenWidth(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(),
                  Column(
                    children: [
                      Image.asset(Utils.path(RIDIRECT_AA_ONEMONEY)),
                      //  Lottie.asset(Utils.path(RIDIRECT_AA_ONEMONEY),
                      //      height: 250.h ,//80.w,
                      //      width: 250.w,//80.w,
                      //      repeat: true,
                      //      reverse: false,
                      //      animate: true,
                      //      frameRate: FrameRate.max,
                      //      fit: BoxFit.fill
                      // ),
                      SizedBox(height: 10.h),
                      Text(strMoneyTitleString,
                          style:
                              ThemeHelper.getInstance()?.textTheme.headline1),
                      SizedBox(height: 10.h),
                      Text(
                        strEmptyString,
                        style: ThemeHelper.getInstance()?.textTheme.headline3,
                        textAlign: TextAlign.center,
                        maxLines: 10,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 50.h),
                    child: Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Processing...",
                            textAlign: TextAlign.start,
                            style:
                                ThemeHelper.getInstance()?.textTheme.headline6),
                        SizedBox(height: 10.h),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: LinearProgressIndicator(
                            semanticsLabel: 'Processing...',
                            minHeight: 8.h,
                            color: ThemeHelper.getInstance()?.primaryColor,
                            backgroundColor: ThemeHelper.getInstance()
                                ?.colorScheme
                                .secondary,
                          ),
                        )
                      ],
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void hideLoader() {
    setState(() {
      isLoader = false;
    });
  }

  //..23) Consent Handle Request call in 22 success
  Future<void> consentHandleRequestApi() async {
    TGLog.d("Enter : consentHandleRequestApi()");

    String currentStage =
        await TGSharedPreferences.getInstance().get(PREF_CURRENT_STAGE);

    if (currentStage == STAGE_CONSENT_MONITORING ||
        currentStage == STAGE_E_MANDATE_STATUS) {
      TGSharedPreferences.getInstance().set(PREF_CONSENTTYPE, "PERIODIC");
    } else {
      TGSharedPreferences.getInstance().set(PREF_CONSENTTYPE, "ONE_TIME");
    }

    String loanApplicationReferenceID =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String aaCode = await TGSharedPreferences.getInstance().get(PREF_AACODE);
    String aaId = await TGSharedPreferences.getInstance().get(PREF_AAID);

    String consentFetchType =
        await TGSharedPreferences.getInstance().get(PREF_CONSENTTYPE);

    ConsentHandleRequest consentHandleRequest = ConsentHandleRequest(
        loanApplicationRefId: loanApplicationReferenceID,
        aaCode: aaCode,
        aaId: aaId,
        consentFetchType: consentFetchType);
    var jsonReq = jsonEncode(consentHandleRequest.toJson());

    TGLog.d("consentHandleReques : $jsonReq");

    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_CONSENT_HANDLE);
    ServiceManager.getInstance().consentHandleRequest(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessConsentHandle(response),
        onError: (error) => _onErrorConsentHandle(error));
  }

  _onSuccessConsentHandle(ConsentHandleResponse? response) async {
    TGLog.d("ConsentHandleResponse : onSuccess()");

    if (response?.getConsentHandleResObj().status == RES_SUCCESS) {
      consentHandleResobject = response?.getConsentHandleResObj();
      TGSharedPreferences.getInstance()
          .set(PREF_CONSENT_AAID, consentHandleResobject?.data?.consentAggId);
      if (await TGNetUtil.isInternetAvailable()) {
        getConsentUrlApi();
      } else {
        showSnackBarForintenetConnection(context, getConsentUrlApi);
      }
    } else {
      hideLoader();
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(
          context,
          response?.getConsentHandleResObj().status,
          response?.getConsentHandleResObj().message,
          null);
    }
  }

  _onErrorConsentHandle(TGResponse errorResponse) {
    TGLog.d("ConsentHandleResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
    hideLoader();
    Navigator.pop(context);
  }
//..24) Get Consent Handle Api

  Future<void> getConsentUrlApi() async {
    TGLog.d("Enter : ConsentUrlApi()");

    String consentAggId =
        await TGSharedPreferences.getInstance().get(PREF_CONSENT_AAID);
    String loanApplicationReferenceID =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);

    GetConsentHandleUrlReq getConsentHandleUrlReq = GetConsentHandleUrlReq(
        loanApplicationRefId: loanApplicationReferenceID,
        consentAggId: consentAggId);
    var jsonReq = jsonEncode(getConsentHandleUrlReq.toJson());

    TGLog.d("ConsentUrl : $jsonReq");

    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, URI_GET_CONSENT_URL);
    ServiceManager.getInstance().consentHandleUrl(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetConsentHandleUrl(response),
        onError: (error) => _onErrorGetConsentHandleUrl(error));
  }

  _onSuccessGetConsentHandleUrl(GetConsentHandleUrlResponse? response) async {
    TGLog.d("tConsentHandleUrl: onSuccess()");

    // if(consentHandleUrlobject?.status==1000){
    //
    //   AppConstant.AAWEBREDIRCTIONURL=consentHandleUrlobject?.data?.url;
    //  // TGSharedPreferences.getInstance().set(PREF_AAURL, );
    //
    //
    // }else if(consentHandleUrlobject?.status==1026){
    //
    //   await Future.delayed(Duration(seconds: 10));
    //
    //

    if (response?.getConsentHandleUrlObj().status == RES_SUCCESS) {
      consentHandleUrlobject = response?.getConsentHandleUrlObj();
      AppConstant.AAWEBREDIRCTIONURL = consentHandleUrlobject?.data?.url;
      hideLoader();
      launchAa(AppConstant.AAWEBREDIRCTIONURL!);
    } else if (response?.getConsentHandleUrlObj().status == RES_RETRY_URL) {
      await Future.delayed(Duration(seconds: 5), () async {
        if (await TGNetUtil.isInternetAvailable()) {
          getConsentUrlApi();
        } else {
          showSnackBarForintenetConnection(context, getConsentUrlApi);
        }
      });
    } else {
      hideLoader();
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(
          context,
          response?.getConsentHandleUrlObj().status,
          response?.getConsentHandleUrlObj().message,
          null);
    }
  }

  _onErrorGetConsentHandleUrl(TGResponse errorResponse) {
    TGLog.d("ConsentHandleUrl : onError()");
    handleServiceFailError(context, errorResponse.error);
    hideLoader();
    Navigator.pop(context);
  }

  //..6) Get Redirection Url
  Future<void> getRedirectionalURLApi() async {
    String loanApplicationReferenceID =
        TGSession.getInstance().get(SESSION_LOANAPPLICATIONREFID);
    String consentAggId = TGSession.getInstance().get(SESSION_CONSENTAGGID);
    String consentFetchType =
        TGSession.getInstance().get(SESSION_CONSENTFETCHTYPE);
    String url = TGSession.getInstance().get(SESSION_URL);

    GetRedirectionalUrlRequest getRedirectionalUrlRequest =
        GetRedirectionalUrlRequest(
            loanApplicationRefId: loanApplicationReferenceID,
            consentAggId: consentAggId,
            consentFetchType: 'ONE_TIME',
            aaRedirectionDecReq: GetRedirectionalUrlObj(
                webRedirectionURL: WebRedirectionURL(
                    ecres:
                        'lOK3S9YDrKZKHAmiJ9m1k88q4yp0dN4ShuxRyvq3Fy_gnFTMjsG0Rib-R9CbyHoY49JkrBw6wo-Tn_b63fLuRF6s6PR2rfSImbfvt-eQI5xwh0OcQN8tYa143qBv4kGQY4cxTfivoxZMAHM2E-hQ4WzU7hgWYisOSF2hsZc2xVOf7_WQsDwMfwMA6liJUez-49lxE5pTlrMZdDnX3iDh-kLJmpKdSFipHvoUra2sjKmXlme0YcUahxKh3_w-rW8laz16sdb4JEzVRbPsxrGCAPdu7OmejYPGqLrqPIiDQ8u-rgi0YefwBXBm_hsnP0pxbZkW6EPoUsO7Irg3g1y6ww',
                    resdate: '240220221142285',
                    fi: 'XVpVX11eV0s')));
    var jsonReq = jsonEncode(getRedirectionalUrlRequest.toJson());
    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, URI_GET_REDIRECTIONAL_URL);
    ServiceManager.getInstance().getRedirectionalUrl(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetRedirectionUrl(response),
        onError: (error) => _onErrorGetRedirectionUrl(error));
  }

  _onSuccessGetRedirectionUrl(GetRedirectionalUrlResponse? response) {
    TGLog.d("GetRedirectionResponse: onSuccess()");

    if (response?.getRedirectionalUrlResObj().status == RES_SUCCESS) {
      Navigator.pushNamed(context, MyRoutes.infoShareRoutes);
    } else if (response?.getRedirectionalUrlResObj().status == RES_RETRY_URL) {
    } else if (response?.getRedirectionalUrlResObj().status ==
        CONSENT_REJECTION) {
      Navigator.pushNamed(context, MyRoutes.infoShareRoutes);
    } else {
      LoaderUtils.handleErrorResponse(
          context,
          response?.getRedirectionalUrlResObj().status,
          response?.getRedirectionalUrlResObj().message,
          null);
    }
  }

  _onErrorGetRedirectionUrl(TGResponse errorResponse) {
    TGLog.d("GetRedirectionResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
  }
}
