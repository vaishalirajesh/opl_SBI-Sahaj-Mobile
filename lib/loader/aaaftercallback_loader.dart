import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/consent_handle_res_main.dart';
import 'package:gstmobileservices/model/models/get_consent_handle_url_response_main.dart';
import 'package:gstmobileservices/model/requestmodel/get_consent_status_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_loan_app_status_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_redirectional_url_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_consent_status_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_loan_app_status_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_redirectional_url_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:lottie/lottie.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/constants/stageconstants.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusconstants.dart';
import 'package:sbi_sahay_1_0/utils/erros_handle.dart';

import '../routes.dart';
import '../utils/Utils.dart';
import '../utils/colorutils/mycolors.dart';
import '../utils/constants/imageconstant.dart';
import '../utils/dimenutils/dimensutils.dart';
import '../utils/helpers/themhelper.dart';
import '../utils/internetcheckdialog.dart';
import '../utils/movestageutils.dart';
import '../utils/strings/strings.dart';

class AAAfterCallBack extends StatefulWidget {
  const AAAfterCallBack({Key? key}) : super(key: key);

  @override
  State<AAAfterCallBack> createState() => _RedirectedLoaderState();
}

class _RedirectedLoaderState extends State<AAAfterCallBack> {
  ConsentHandleResMain? consentHandleResobject;
  GetConsentHandleUrlResMain? consentHandleUrlobject;
  String consent = '';
  String? consentFetchType;
  GetRedirectionalUrlRequest? getRedirectionalUrlRequest;

  @override
  void initState() {
    getRedirectUrlApiCall();
    super.initState();
  }

  Future<void> getRedirectUrlApiCall() async{
    if (await TGNetUtil.isInternetAvailable()) {
      getRedirectionalURLApi();
    } else {
      showSnackBarForintenetConnection(context, getRedirectionalURLApi);
    }
  }
  @override
  Widget build(BuildContext context) {
    return   WillPopScope(
        onWillPop: () async {
      return true;
    },
    child: Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient:LinearGradient(
                colors: [MyColors.pnbPinkColor,
                  ThemeHelper.getInstance()!.backgroundColor
                ],
                begin: Alignment.bottomCenter,
                end:Alignment.centerLeft)
        ),
        height : MyDimension.getFullScreenHeight(),
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
                  Image.asset(height: 250.h,width: 250.w,Utils.path(INFOSHARELOADER),fit: BoxFit.fill,),
                  // Lottie.asset(Utils.path(INFOSHARELOADER),
                  //     height: 250.h ,//80.w,
                  //     width: 250.w,//80.w,
                  //     repeat: true,
                  //     reverse: false,
                  //     animate: true,
                  //     frameRate: FrameRate.max,
                  //     fit: BoxFit.fill
                  // ),
                  SizedBox(height: 10.h),
                  Text(strVerifyTitle,style: ThemeHelper.getInstance()?.textTheme.headline1),
                  SizedBox(height: 10.h),
                  Text(strEmptyString,style: ThemeHelper.getInstance()?.textTheme.headline3,textAlign: TextAlign.center,maxLines: 10,),
                ],
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 50.h),
                child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Processing...",
                            textAlign: TextAlign.start,
                            style: ThemeHelper.getInstance()?.textTheme.headline6),
                        SizedBox(height: 10.h),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: LinearProgressIndicator(
                            semanticsLabel: 'Processing...',
                            minHeight : 8.h,
                            color: ThemeHelper.getInstance()?.primaryColor,
                            backgroundColor: ThemeHelper.getInstance()?.colorScheme.secondary,

                          ),
                        )
                      ],
                    )
                ),
              ),

            ],
          ),
        ),
      ),
    ));
  }


  //..6) Get Redirection Url
  Future<void>  getRedirectionalURLApi() async {

  String callBackURL = await TGSharedPreferences.getInstance().get(PREF_AACALLBACKURL);




  TGLog.d("callBackURL : $callBackURL");

  var uri = Uri.dataFromString(callBackURL); //converts string to a uri
  Map<dynamic, dynamic> params = uri.queryParameters; // query parameters automatically populated


    WebRedirectionURL webRedirectionURL = WebRedirectionURL();

    webRedirectionURL.ecres = params['ecres'];
    webRedirectionURL.resdate = params['resdate'];
    webRedirectionURL.fi = params['fi'];

    String loanApplicationReferenceID =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String consentAggId =
        await TGSharedPreferences.getInstance().get(PREF_CONSENT_AAID);
    consentFetchType =
        await TGSharedPreferences.getInstance().get(PREF_CONSENTTYPE);
    // String url=TGSession.getInstance().get(SESSION_URL);

    getRedirectionalUrlRequest = GetRedirectionalUrlRequest(
        loanApplicationRefId: loanApplicationReferenceID,
        consentAggId: consentAggId,
        consentFetchType: consentFetchType,
        aaRedirectionDecReq:
            GetRedirectionalUrlObj(webRedirectionURL: webRedirectionURL));
    var jsonReq = jsonEncode(getRedirectionalUrlRequest?.toJson());

    TGLog.d("Redirection URL Request : $jsonReq");
    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, URI_GET_REDIRECTIONAL_URL);
    ServiceManager.getInstance().getRedirectionalUrl(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetRedirectionUrl(response),
        onError: (error) => _onErrorGetRedirectionUrl(error));
  }
  _onSuccessGetRedirectionUrl(GetRedirectionalUrlResponse? response) {
    TGLog.d("GetRedirectionResponse: onSuccess()");
    if(response?.getRedirectionalUrlResObj()?.status == RES_SUCCESS) {
      consent = RES_SUCCESS.toString();
      //Future.delayed(const Duration(seconds: 10), () {

      if (consentFetchType == "ONE_TIME") {
        Future.delayed(const Duration(seconds: 60), () {
          getConsentHandleStatusApiCall();
        });
      } else {
        Future.delayed(const Duration(seconds: 15), () {
          getConsentHandleStatusApiCall();
        });
      }

      //});

    } else if(response?.getRedirectionalUrlResObj()?.status == CONSENT_REJECTION)
    {
      consent = CONSENT_REJECTION.toString();
      getConsentHandleStatusApiCall();
    }
    else
    {
      TGView.showSnackBar(context: context, message: response?.getRedirectionalUrlResObj()?.message ?? "");
    }
  }
  _onErrorGetRedirectionUrl(TGResponse errorResponse) {
    TGLog.d("GetRedirectionResponse : onError()");
    handleServiceFailError(context, errorResponse?.error);
  }

  Future<void> getConsentHandleStatus() async
  {
    // String loanApplicationReferenceID=  await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    // String consentAggId= await TGSharedPreferences.getInstance().get(PREF_CONSENT_AAID);
    // String consentFetchType=await TGSharedPreferences.getInstance().get(PREF_CONSENTTYPE);
    //
    // String callBackURL = await TGSharedPreferences.getInstance().get(PREF_AACALLBACKURL);
    // var uri = Uri.dataFromString(callBackURL); //converts string to a uri
    // Map<dynamic, dynamic> params = uri.queryParameters; // query parameters automatically populated
    //
    //
    // WebRedirectionURL webRedirectionURL=WebRedirectionURL();
    //
    // webRedirectionURL.ecres=params['ecres'];
    // webRedirectionURL.resdate=params['resdate'];
    // webRedirectionURL.fi=params['fi'];
    // ConsentStatusRequest consentStatusRequest =
    // ConsentStatusRequest(
    //     loanApplicationRefId: loanApplicationReferenceID,
    //     consentAggId: consentAggId,
    //     consentFetchType: consentFetchType,
    //     webRedirectionData: webRedirectionURL);

    var jsonReq = jsonEncode(getRedirectionalUrlRequest?.toJson());
    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, URI_CONSENT_STATUS_REQUEST);
    ServiceManager.getInstance().getConsentStatus(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetConsentStatus(response),
        onError: (error) => _onErrorGetConsentStatus(error));
  }

  _onSuccessGetConsentStatus(ConsentStatusResponse? response) {
    TGLog.d("ConsentStatusResponse : onSuccess()");
    if(response?.getConsentStatusResObj()?.status == RES_SUCCESS)
    {
        if(consent == RES_SUCCESS.toString())
        {
          getLoanAppStatusApiCall();
        }
    }
    else
    {
      TGView.showSnackBar(context: context, message: response?.getConsentStatusResObj().message ?? "");
    }
  }
  _onErrorGetConsentStatus(TGResponse errorResponse) {
    TGLog.d("ConsentStatusResponse : onError()");
    handleServiceFailError(context, errorResponse?.error);
  }

  Future<void> getLoanAppStatusAfterConsentStatus() async
  {
   String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);



   GetLoanStatusRequest getLoanStatusRequest;
   if(consentFetchType == "ONE_TIME"){
      getLoanStatusRequest = GetLoanStatusRequest(loanApplicationRefId: loanAppRefId);
   }else{

     String loanAppID = await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
     String repaymentPlanID = await TGSharedPreferences.getInstance().get(PREF_REPAYMENTPLANID);
     getLoanStatusRequest = GetLoanStatusRequest(loanApplicationRefId:loanAppRefId,loanApplicationId:loanAppID,repaymentPlanId:  repaymentPlanID);
   }

   var jsonReq = jsonEncode(getLoanStatusRequest.toJson());
   TGLog.d("Loan Status API : $jsonReq");

   TGPostRequest tgPostRequest = await getPayLoad(jsonReq, Utils.getManageLoanAppStatusParam('2'));
    ServiceManager.getInstance().getLoanAppStatus(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetLoanAppStatus(response),
        onError: (error) => _onErrorGetLoanAppStatus(error));
  }

  _onSuccessGetLoanAppStatus(GetLoanStatusResponse? response)
  {
    TGLog.d("LoanAppStatusResponse : onSuccess()");
    if(response?.getLoanStatusResObj().data?.stageStatus == "PROCEED")
    {
      /*if(response?.getLoanStatusResObj()?.data?.currentStage == STAGE_LOAN_OFFER)
      {*/
        MoveStage.navigateNextStage(context,response?.getLoanStatusResObj().data?.currentStage);
       /* Navigator.pushNamed(context, MyRoutes.infoShareRoutes);*/
      /*}
      else
      {
        Navigator.pushNamed(context, MyRoutes.proceedToDisbursedRoutes);
      }*/

    }
    else if(response?.getLoanStatusResObj()?.data?.stageStatus == "HOLD")
    {
      Future.delayed(const Duration(seconds: 10), () {
        getLoanAppStatusApiCall();
      });
    }
    else
    {
      getLoanAppStatusApiCall();
    }
  }
  _onErrorGetLoanAppStatus(TGResponse errorResponse)
  {
    TGLog.d("LoanAppStatusResponse : onError()");
    handleServiceFailError(context, errorResponse?.error);
  }

  Future<void> getConsentHandleStatusApiCall() async{
    if (await TGNetUtil.isInternetAvailable()) {
      getConsentHandleStatus();
    } else {
      showSnackBarForintenetConnection(context, getConsentHandleStatus);
    }
  }

  Future<void> getLoanAppStatusApiCall() async{
    if (await TGNetUtil.isInternetAvailable()) {
      getLoanAppStatusAfterConsentStatus();
    } else {
      showSnackBarForintenetConnection(context, getLoanAppStatusAfterConsentStatus);
    }
  }
}
