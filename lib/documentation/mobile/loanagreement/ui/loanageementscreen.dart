import 'dart:convert';
import 'package:gstmobileservices/util/tg_net_util.dart';

import '../../../../utils/internetcheckdialog.dart';
import '../ui/launchURL/ddelaunchurlmain.dart'
    if (dart.library.html) '../ui/launchURL/ddelaunchweb.dart'
    if (dart.library.io) '../ui/launchURL/ddelaunchmobile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_loan_agreement_res_main.dart';
import 'package:gstmobileservices/model/models/get_loan_app_status_main.dart';
import 'package:gstmobileservices/model/models/share_gst_invoice_res_main.dart';
import 'package:gstmobileservices/model/requestmodel/get_loan_agreement_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_loan_app_status_request.dart';
import 'package:gstmobileservices/model/requestmodel/loan_agreement_status_request.dart';
import 'package:gstmobileservices/model/requestmodel/post_loan_agreement_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_loan_agreement_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_loan_app_status_response.dart';
import 'package:gstmobileservices/model/responsemodel/loan_agreement_status_response.dart';
import 'package:gstmobileservices/model/responsemodel/post_loan_agreement_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/erros_handle.dart';
import 'package:sbi_sahay_1_0/utils/helpers/myfonts.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/progressLoader.dart';
import 'package:webviewx/webviewx.dart';

import '../../../../loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import '../../../../loanprocess/mobile/emailafterloanagreement/mobile/email_sent_after_loan_agreement.dart';
import '../../../../routes.dart';
import '../../../../utils/colorutils/mycolors.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/constants/prefrenceconstants.dart';
import '../../../../utils/constants/statusConstants.dart';
import '../../../../utils/dimenutils/dimensutils.dart';
import '../../../../utils/jumpingdott.dart';
import '../../../../utils/strings/strings.dart';
import '../../../../widgets/animation_routes/page_animation.dart';
import '../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';

class LoanAgreementMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SafeArea(child: LoanAgreementMains());
    });
  }
}

class LoanAgreementMains extends StatefulWidget {
  @override
  LoanAgreementMainBody createState() => new LoanAgreementMainBody();
}

class LoanAgreementMainBody extends State<LoanAgreementMains> {
  final ScrollController scrollController = ScrollController();
  late WebViewXController webviewController;
  GetLoanAgreementResMain? _getLoanAgreementRes;
  ShareGstInvoiceResMain? _postLoanAppRequest;
  GetLoanStatusResMain? _getLoanStatusRes;
  bool isAgreementLoaded = false;
  bool isAgreementRead = false;
  bool isWebview = false;

  bool isAgreeLoaderStart = false;

  @override
  void initState() {
    getLoanAggApiCall();

    super.initState();
  }

  Future<void> getLoanAggApiCall() async {
    if (await TGNetUtil.isInternetAvailable()) {
      getLoanAgreement();
    } else {
      showSnackBarForintenetConnection(context, getLoanAgreement);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => DashboardWithGST(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );

          return true;
        },
        child: bodyScaffold(context));
  }

  Widget bodyScaffold(BuildContext context) {
    if (isWebview) {
      return LoadAgreementURLInWeb(context);
    } else {
      return Scaffold(
        appBar: getAppBarWithStep('3', str_documentation, 0.75,
            onClickAction: () => {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => DashboardWithGST(),
                    ),
                    (route) =>
                        false, //if you want to disable back feature set to false
                  )
                }),
        body: AbsorbPointer(
          absorbing: isAgreeLoaderStart,
          child: Padding(
            padding: EdgeInsets.only(top: 30.h, left: 20.w, right: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  Utils.path(BANKLOGOSQUARE),
                  width: 180.w,
                  height: 35.h,
                ),
                SizedBox(
                  height: 50.h,
                ),
                Text(
                  str_loan_agreement,
                  style: ThemeHelper.getInstance()?.textTheme.headline1,
                ),
                SizedBox(
                  height: 20.h,
                ),
                AccountInfoUI(context),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    DownloadAgreementBtnUI(context),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                isAgreementLoaded
                    ? aggrementContainer(context)
                    : JumpingDots(
                        color: ThemeHelper.getInstance()?.primaryColor ??
                            MyColors.pnbcolorPrimary,
                        radius: 10,
                      ) //Container()
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(bottom: 10.h, left: 20.w, right: 20.w),
            child: aggreeButton(context),
          ),
        ),
      );
    }
  }

  Widget AccountInfoUI(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(str_deposit_ac,
            style: ThemeHelper.getInstance()?.textTheme.headline3),
        SizedBox(
          width: 15.w,
        ),
        Row(
          children: [
            Container(
                height: 30.h,
                width: 30.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ThemeHelper.getInstance()?.colorScheme.secondary),
                child: Center(
                    child: SvgPicture.asset(
                  Utils.path(SMALLBANKLOGO),
                  height: 15.h,
                  width: 15.h,
                ))),
            SizedBox(
              width: 10.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Punjab National Bank',
                  style: ThemeHelper.getInstance()
                      ?.textTheme
                      .headline5
                      ?.copyWith(
                          color: ThemeHelper.getInstance()?.indicatorColor,
                          fontFamily: MyFont.Nunito_Sans_Bold,
                          fontSize: 13.sp),
                  maxLines: 3,
                ),
                Text(
                  '$str_ac_no: ${_getLoanAgreementRes?.data?.accountDetailsDataModel?.accountNumber ?? "-"}',
                  style: ThemeHelper.getInstance()
                      ?.textTheme
                      .bodyText1
                      ?.copyWith(
                          color: MyColors.PnbGrayTextColor,
                          fontSize: 13.sp,
                          fontFamily: MyFont.Nunito_Sans_Regular),
                  maxLines: 3,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget DownloadAgreementBtnUI(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TGView.showSnackBar(context: context, message: "Coming Soon...");
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: MyColors.pnbCheckBoxcolor, width: 2),
          color: ThemeHelper.getInstance()?.backgroundColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.h),
          child: Row(
            children: [
              Icon(
                Icons.file_download_sharp,
                color: ThemeHelper.getInstance()?.primaryColor,
                size: 18.h,
              ),
              SizedBox(
                width: 5.w,
              ),
              Text(
                str_download,
                style: ThemeHelper.getInstance()?.textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget aggrementContainer(BuildContext context) {

    return Container(
        height: MediaQuery.of(context).size.height * 0.50,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: WebViewX(
           javascriptMode: JavascriptMode.unrestricted,
          key: const ValueKey('webviewx'),
          initialContent: utf8.decode(base64Decode(
              _getLoanAgreementRes?.data?.loanAgreementModel?.data ?? "")),
          initialSourceType:
              _getLoanAgreementRes?.data?.loanAgreementModel?.type == "HTML"
                  ? SourceType.html
                  : SourceType.url,
          jsContent:  {
             /*EmbeddedJsContent(
               js:"function testPlatformSpecificMethod(msg) { TestDartCallback('Web callback says: ' + msg) }",

             ),*/
            EmbeddedJsContent(
              webJs:
                  "window.addEventListener('scroll', () => {if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight) {"
                      "TestDartCallback(true)"
                      /*"console.log('end of scroll')"*/
                  /*"`_functionName = allowInterop(setAgreementRead);`"*/
                  "}})",
              mobileJs:  "window.addEventListener('scroll', () => {if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight) {"
                      "TestDartCallback.postMessage(true)"
                      /*"console.log('end of scroll')"*/
                  /*"`_functionName = allowInterop(setAgreementRead);`"*/
                  "}})"
            )
          },
          dartCallBacks: {
             DartCallback(name: 'TestDartCallback', callBack: (msg) => setAgreementRead(msg))
          },
          width: MediaQuery.of(context).size.width,
          onWebViewCreated: (controller)  {
            webviewController = controller;
            /*controller.getScrollY().whenComplete(() {
                setState(() {
                  isAgreementRead = true;
                });
            });*/
          },
          height: MediaQuery.of(context).size.height * 0.50,
        ));
  }


  void setAgreementRead(bool isRead)
  {
    if(isRead as bool)
    {
      setState(() {
        isAgreementRead = true;
      });
    }

  }

  Widget aggreeButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50.h,
      child: isAgreeLoaderStart
          ? JumpingDots(
              color: ThemeHelper.getInstance()?.primaryColor ??
                  MyColors.pnbcolorPrimary,
              radius: 10,
            )
          : ElevatedButton(
              style: isAgreementRead
                  ? ThemeHelper.getInstance()!.elevatedButtonTheme.style
                  : ThemeHelper.setPinkDisableButtonBig(),
              onPressed: () async {
                if (isAgreementLoaded) {
                  setState(() {
                    isAgreeLoaderStart = true;
                  });

                  if (await TGNetUtil.isInternetAvailable()) {
                    postLoanAgreementRequest();
                  } else {
                    showSnackBarForintenetConnection(
                        context, postLoanAgreementRequest);
                  }
                } else {
                  TGView.showSnackBar(
                      context: context,
                      message: "Please wait while Aggrement Loading..");
                }
              },
              child: Center(
                child: Text(
                  str_agree,
                  style: ThemeHelper.getInstance()?.textTheme.button,
                ),
              )),
    );
  }

  Widget LoadAgreementURLInWeb(BuildContext context) {
    late WebViewXController webviewController;

    return Container(
        decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: WebViewX(
          key: const ValueKey('webviewx'),
          initialContent: utf8.decode(base64Decode(
              _getLoanStatusRes?.data?.agreementRedirectionData ?? "")),
          initialSourceType: SourceType.html,
          height: MyDimension.getFullScreenHeight(),
          width: MyDimension.getFullScreenWidth(),
          onWebViewCreated: (controller) => webviewController = controller,
          onPageStarted: (src) => {
            if (src
                    .toString()
                    .contains("https://uat-gst-sahay.instantmseloans.in/") ||
                src.toString().contains("https://uat-oam.instantmseloans.in") ||
                src
                    .toString()
                    .contains("https://gst-sahay.instantmseloans.in/") ||
                src.toString().contains(
                    "https://liveoam.instantmseloans.in/tsp/neslSuccess") ||
                src.toString().contains(
                    "https://uat-gst-sahay.instantmseloans.in/sahay/#/DDEResponse"))
              {loanAggStatusApi()}
          },
          onPageFinished: (src) => {
            debugPrint('The page has finished loading: $src\n'),
            if (src.contains("Signed%20Successfully"))
              {loanAggStatusApi()}
            else
              {}
          },
          onWebResourceError: (error) {
            setState(() {
              isWebview = false;
            });
          },
          jsContent: const {
            EmbeddedJsContent(
              js: "function testPlatformIndependentMethod() { console.log('Hi from JS') }",
            ),
            EmbeddedJsContent(
              webJs:
                  "function testPlatformSpecificMethod(msg) { TestDartCallback('Web callback says: ' + msg) }",
              mobileJs:
                  "function testPlatformSpecificMethod(msg) { TestDartCallback.postMessage('Mobile callback says: ' + msg) }",
            ),
          },
          dartCallBacks: {
            DartCallback(
              name: 'TestDartCallback',
              callBack: (msg) => "Error",
            )
          },
          webSpecificParams: const WebSpecificParams(
            printDebugInfo: true,
          ),
          mobileSpecificParams: const MobileSpecificParams(
            androidEnableHybridComposition: true,
          ),
          navigationDelegate: (navigation) {
            debugPrint(navigation.content.sourceType.toString());
            return NavigationDecision.navigate;
          },
        ));
  }

  //get Loan Agreement Data
  Future<void> getLoanAgreement() async {
    String loanAppRefId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String offerId = await TGSharedPreferences.getInstance().get(PREF_OFFERID);
    GetLoanAgreementRequest getLoanAgreementRequest = GetLoanAgreementRequest(
      loanApplicationRefId: loanAppRefId,
      offerId: offerId,
    );
    var jsonReq = jsonEncode(getLoanAgreementRequest.toJson());
    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, URI_GET_LOAN_AGREEMENT);
    ServiceManager.getInstance().getLoanAgreement(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetLoanAgreement(response),
        onError: (error) => _onErrorGetLoanAgreement(error));
  }

  _onSuccessGetLoanAgreement(GetLoanAgreementResponse? response) {
    TGLog.d("RegisterResponse : onSuccess()");

    if (response?.getLoanAgreementResObj().status == RES_DETAILS_FOUND) {
      setState(() {
        _getLoanAgreementRes = response?.getLoanAgreementResObj();
        isAgreementLoaded = true;
      });
    } else if (response?.getLoanAgreementResObj().status ==
        RES_DETAILS_NOT_FOUND) {
      Future.delayed(const Duration(seconds: 5), () {
        getLoanAggApiCall();
      });
    } else {
      setState(() {
        isAgreementLoaded = true;
      });
      LoaderUtils.handleErrorResponse(
          context,
          response?.getLoanAgreementResObj().status,
          response?.getLoanAgreementResObj().message,
          null);
    }
  }

  _onErrorGetLoanAgreement(TGResponse errorResponse) {
    TGLog.d("RegisterResponse : onError()");
    setState(() {
      isAgreementLoaded = true;
    });
    handleServiceFailError(context, errorResponse.error);
  }

  //Post Loan Agreement
  Future<void> postLoanAgreementRequest() async {
    String loanAppRefId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String loanAppId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
    PostLoanAgreementRequest postLoanAgreementRequest =
        PostLoanAgreementRequest(
      loanApplicationRefId: loanAppRefId,
      loanApplicationId: loanAppId,
    );
    var jsonReq = jsonEncode(postLoanAgreementRequest.toJson());
    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, URI_LOAN_AGREEMENT_REQUEST);
    ServiceManager.getInstance().postLoanAgreement(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessPostLoanAgreement(response),
        onError: (error) => _onErrorPostLoanAgreement(error));
  }

  _onSuccessPostLoanAgreement(PostLoanAgreementResponse? response) {
    TGLog.d("RegisterResponse : onSuccess()");
    _postLoanAppRequest = response?.getPostLoanAgreementResObj();

    if (response?.getPostLoanAgreementResObj()?.status == RES_SUCCESS) {
      loanAppStatusAfterPostAgg();
    } else {
      setState(() {
        isAgreeLoaderStart = false;
      });
      LoaderUtils.handleErrorResponse(
          context,
          response?.getPostLoanAgreementResObj()?.status,
          response?.getPostLoanAgreementResObj()?.message ?? "",
          null);
    }
  }

  _onErrorPostLoanAgreement(TGResponse errorResponse) {
    TGLog.d("RegisterResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> loanAppStatusAfterPostAgg() async
  {
    if (await TGNetUtil.isInternetAvailable()) {
      getLoanAppStatusAfterPostLoanAgreeReq();
    } else {
      showSnackBarForintenetConnection(
          context, getLoanAppStatusAfterPostLoanAgreeReq);
    }
  }
  // Loan App Status After Post Loan Agreement Request
  Future<void> getLoanAppStatusAfterPostLoanAgreeReq() async {
    String loanAppRefId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String loanAppId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
    GetLoanStatusRequest getLoanStatusRequest = GetLoanStatusRequest(
        loanApplicationRefId: loanAppRefId, loanApplicationId: loanAppId);
    var jsonReq = jsonEncode(getLoanStatusRequest.toJson());
    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, Utils.getManageLoanAppStatusParam('6'));
    ServiceManager.getInstance().getLoanAppStatus(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetLoanAppStatus(response),
        onError: (error) => _onErrorGetLoanAppStatus(error));
  }

  _onSuccessGetLoanAppStatus(GetLoanStatusResponse? response) async {
    TGLog.d("LoanAppStatusResponsePostLoanAgreeReq : onSuccess()");
    _getLoanStatusRes = response?.getLoanStatusResObj();
    if (_getLoanStatusRes?.data?.stageStatus == "PROCEED") {
      setState(() {
        isAgreeLoaderStart = false;
      });
      TGLog.d("Type :${_getLoanStatusRes!.data!.agreementType}");

      String url = utf8.decode(base64Decode(
          _getLoanStatusRes?.data?.agreementRedirectionData ?? ""));

      launchdde(url);
      // TGLog.d(url);
      // js.context.callMethod('customAlertMessage', [url]);

      // // this for internal app webview

      if (!kIsWeb) {
        setState(() {
          isWebview = true;
        });
      }
    } else if (_getLoanStatusRes?.data?.stageStatus == "HOLD") {
      Future.delayed(const Duration(seconds: 10), () {
        loanAppStatusAfterPostAgg();
      });
    } else {
      setState(() {
        isAgreeLoaderStart = false;
      });
      LoaderUtils.handleErrorResponse(
          context,
          response?.getLoanStatusResObj().status,
          response?.getLoanStatusResObj().message,
          response?.getLoanStatusResObj().data?.stageStatus);
    }
  }

  _onErrorGetLoanAppStatus(TGResponse errorResponse) {
    TGLog.d("LoanAppStatusResponsePostLoanAgreeReq : onError()");
    setState(() {
      isAgreeLoaderStart = false;
      handleServiceFailError(context, errorResponse.error);
    });
  }

  //Get Loan App Status After Webview
  Future<void> getLoanAppStatusAfterLoanAgreeWebview() async {
    String loanAppRefId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String loanAppId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
    GetLoanStatusRequest getLoanStatusRequest = GetLoanStatusRequest(
        loanApplicationRefId: loanAppRefId, loanApplicationId: loanAppId);
    var jsonReq = jsonEncode(getLoanStatusRequest.toJson());
    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, Utils.getManageLoanAppStatusParam('6'));
    ServiceManager.getInstance().getLoanAppStatus(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetLoanAppStatus1(response),
        onError: (error) => _onErrorGetLoanAppStatus1(error));
  }

  _onSuccessGetLoanAppStatus1(GetLoanStatusResponse? response) {
    TGLog.d("LoanAppStatusResponseAfterLoanAgreeWebview : onSuccess()");
    _getLoanStatusRes = response?.getLoanStatusResObj();
    if (_getLoanStatusRes?.data?.stageStatus == "PROCEED") {
      //  Navigator.pushNamed(context, MyRoutes.EmailSentRoutes);
      //  Navigator.of(context).push(CustomRightToLeftPageRoute(child: EmailSentAfterLoanAgreement(), ));
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmailSentAfterLoanAgreement(),
          ));
    } else if (_getLoanStatusRes?.data?.stageStatus == "HOLD") {
      Future.delayed(const Duration(seconds: 10), () {
        loanAppStatusAfterPostAgg();
      });
    } else {
      LoaderUtils.handleErrorResponse(
          context,
          response?.getLoanStatusResObj().status,
          response?.getLoanStatusResObj().message,
          response?.getLoanStatusResObj().data?.stageStatus);
    }
  }

  _onErrorGetLoanAppStatus1(TGResponse errorResponse) {
    TGLog.d("LoanAppStatusResponseAfterLoanAgreeWebview : onError()");
    setState(() {
      handleServiceFailError(context, errorResponse.error);
    });
  }

  //Loan Agreement Status
  Future<void> loanAgreementStatus() async {
    String loanAppRefId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String loanAppId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
    PostLoanAgreementStatusReq postLoanAgreementStatusReq =
        PostLoanAgreementStatusReq(
      loanApplicationRefId: loanAppRefId,
      loanApplicationId: loanAppId,
    );
    var jsonReq = jsonEncode(postLoanAgreementStatusReq.toJson());
    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, URI_POST_LOAN_AGREEMENT_STATUS);
    ServiceManager.getInstance().postLoanAgreementStatus(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessLoanAgreementStatus(response),
        onError: (error) => _onErrorLoanAgreementStatus(error));
  }

  _onSuccessLoanAgreementStatus(LoanAgreementStatusResponse? response) {
    TGLog.d("LoanAgreementStatusResponse : onSuccess()");
    if (response?.getLoanAgreementResObj()?.status == RES_SUCCESS) {
      loanAggStatusAfterWebviewApi();
    } else {
      LoaderUtils.handleErrorResponse(
          context,
          response?.getLoanAgreementResObj().status,
          response?.getLoanAgreementResObj().message,
          null);
    }
  }

  _onErrorLoanAgreementStatus(TGResponse errorResponse) {
    TGLog.d("LoanAgreementStatusResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> loanAggStatusApi() async
  {
    if (await TGNetUtil.isInternetAvailable()) {
      loanAgreementStatus();
    } else {
      showSnackBarForintenetConnection(
          context, loanAgreementStatus);
    }
  }

  Future<void> loanAggStatusAfterWebviewApi() async
  {
    if (await TGNetUtil.isInternetAvailable()) {
      getLoanAppStatusAfterLoanAgreeWebview();
    } else {
      showSnackBarForintenetConnection(
          context, getLoanAppStatusAfterLoanAgreeWebview);
    }
  }
}
