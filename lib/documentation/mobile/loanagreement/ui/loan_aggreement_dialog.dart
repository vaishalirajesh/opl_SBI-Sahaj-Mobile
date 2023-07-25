import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_loan_agreement_res_main.dart';
import 'package:gstmobileservices/model/models/get_loan_app_status_main.dart';
import 'package:gstmobileservices/model/models/share_gst_invoice_res_main.dart';
import 'package:gstmobileservices/model/requestmodel/get_loan_app_status_request.dart';
import 'package:gstmobileservices/model/requestmodel/loan_agreement_status_request.dart';
import 'package:gstmobileservices/model/requestmodel/post_loan_agreement_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_loan_app_status_response.dart';
import 'package:gstmobileservices/model/responsemodel/loan_agreement_status_response.dart';
import 'package:gstmobileservices/model/responsemodel/post_loan_agreement_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/erros_handle.dart';
import 'package:sbi_sahay_1_0/utils/helpers/myfonts.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/progressLoader.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';
import 'package:webviewx/webviewx.dart';

import '../../../../loanprocess/mobile/emailafterloanagreement/mobile/email_sent_after_loan_agreement.dart';
import '../../../../utils/colorutils/mycolors.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/constants/prefrenceconstants.dart';
import '../../../../utils/constants/statusConstants.dart';
import '../../../../utils/dimenutils/dimensutils.dart';
import '../../../../utils/internetcheckdialog.dart';
import '../../../../utils/jumpingdott.dart';
import '../../../../utils/strings/strings.dart';
import '../ui/launchURL/ddelaunchurlmain.dart'
    if (dart.library.html) '../ui/launchURL/ddelaunchweb.dart'
    if (dart.library.io) '../ui/launchURL/ddelaunchmobile.dart';

class LoanAgreementDialog extends StatelessWidget {
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
  bool isWebview = false;
  bool isAgreeLoaderStart = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: bodyScaffold(context),
    );
  }

  Widget bodyScaffold(BuildContext context) {
    if (isWebview) {
      return loadAgreementURLInWeb(context);
    } else {
      return PopUpViewInstructionRegister();
    }
  }

  Widget buildRowWidget(String text) => Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(AppUtils.path(IMG_GREENTICK_AA), height: 18.r, width: 18.r),
            SizedBox(width: 5.w),
            Expanded(
              child: Text(
                " $text",
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .headline3!
                    .copyWith(color: MyColors.lightBlackText, fontSize: 14.sp),
                maxLines: 2,
              ),
            ),
          ],
        ),
      );

  Widget AccountInfoUI(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: Text(str_deposit_ac, style: ThemeHelper.getInstance()?.textTheme.headline3)),
              // Remove button as per discussion with Hardik Sir
              // DownloadAgreementBtnUI(context),
            ],
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                height: 30.h,
                width: 30.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: ThemeHelper.getInstance()?.colorScheme.secondaryContainer),
                child: Center(
                    child: SvgPicture.asset(
                  AppUtils.path(SMALLBANKLOGO),
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
                  'State Bank of India',
                  style: ThemeHelper.getInstance()?.textTheme.headline5?.copyWith(
                      color: ThemeHelper.getInstance()?.indicatorColor,
                      fontFamily: MyFont.Nunito_Sans_Bold,
                      fontSize: 13.sp),
                  maxLines: 3,
                ),
                Text(
                  "Account No XXXXXX7564",
                  // '$str_ac_no: ${_getLoanAgreementRes?.data?.accountDetailsDataModel?.accountNumber ?? "-"}',
                  style: ThemeHelper.getInstance()?.textTheme.bodyText1?.copyWith(
                      color: MyColors.PnbGrayTextColor, fontSize: 13.sp, fontFamily: MyFont.Nunito_Sans_Regular),
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
        width: 100.w,
        height: 30.h,
        decoration: BoxDecoration(
          border: Border.all(color: MyColors.pnbCheckBoxcolor, width: 2),
          color: ThemeHelper.getInstance()?.backgroundColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 5.w,
            ),
            Icon(
              Icons.file_download_outlined,
              color: MyColors.ligtBlue,
              size: 18.h,
            ),
            SizedBox(
              width: 5.w,
            ),
            Text(
              str_download,
              style: ThemeHelper.getInstance()?.textTheme.bodyText2?.copyWith(color: MyColors.ligtBlue),
            ),
          ],
        ),
      ),
    );
  }

  Widget PopUpViewInstructionRegister() {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            //image: DecorationImage(image: AssetImage(Utils.path(KFSCONGRATULATIONBG)),fit: BoxFit.fill),
            color: Colors.white,
          ),
          // height: 265.h,
          width: 335.w,
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 36.h), //40
                Center(
                    child: SvgPicture.asset(AppUtils.path(GREENCONFORMTICK),
                        height: 52.h, //,
                        width: 52.w, //134.8,
                        allowDrawingOutsideViewBox: true)),
                SizedBox(height: 20.h), //40
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Your Standing Instructions have been registered successfully",
                        style:
                            ThemeHelper.getInstance()?.textTheme.headline2?.copyWith(fontFamily: MyFont.Roboto_Medium),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                //38
                SizedBox(
                  height: 40.h,
                ),
                isAgreeLoaderStart
                    ? SizedBox(
                        height: 50.h,
                        child: JumpingDots(
                          color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary,
                          radius: 10,
                        ),
                      )
                    : AppButton(
                        onPress: () {
                          onPressIAgreeButton();
                        },
                        title: str_proceed,
                      ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onPressIAgreeButton() async {
    setState(() {
      isAgreeLoaderStart = true;
    });
    if (await TGNetUtil.isInternetAvailable()) {
      postLoanAgreementRequest();
    } else {
      if (mounted) {
        showSnackBarForintenetConnection(context, postLoanAgreementRequest);
      }
    }
  }

  Widget loadAgreementURLInWeb(BuildContext context) {
    late WebViewXController webviewController;

    return Container(
        decoration:
            const BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: WebViewX(
          key: const ValueKey('webviewx'),
          initialContent: utf8.decode(base64Decode(_getLoanStatusRes?.data?.agreementRedirectionData ?? "")),
          initialSourceType: SourceType.html,
          height: MyDimension.getFullScreenHeight(),
          width: MyDimension.getFullScreenWidth(),
          onWebViewCreated: (controller) => webviewController = controller,
          onPageStarted: (src) => {
            if (src.toString().contains("https://uat-gst-sahay.instantmseloans.in/") ||
                src.toString().contains("https://uat-oam.instantmseloans.in") ||
                src.toString().contains("https://gst-sahay.instantmseloans.in/") ||
                src.toString().contains("https://liveoam.instantmseloans.in/tsp/neslSuccess") ||
                src.toString().contains("https://uat-gst-sahay.instantmseloans.in/sahay/#/DDEResponse"))
              {loanAggStatusApi()}
          },
          onPageFinished: (src) => {
            debugPrint('The page has finished loading: $src\n'),
            if (src.contains("Signed%20Successfully")) {loanAggStatusApi()} else {}
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
              webJs: "function testPlatformSpecificMethod(msg) { TestDartCallback('Web callback says: ' + msg) }",
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

  //Post Loan Agreement
  Future<void> postLoanAgreementRequest() async {
    //jiuhiuhuihiuhiuhui
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String loanAppId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
    PostLoanAgreementRequest postLoanAgreementRequest = PostLoanAgreementRequest(
      loanApplicationRefId: loanAppRefId,
      loanApplicationId: loanAppId,
    );
    var jsonReq = jsonEncode(postLoanAgreementRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_LOAN_AGREEMENT_REQUEST);
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
      LoaderUtils.handleErrorResponse(context, response?.getPostLoanAgreementResObj()?.status,
          response?.getPostLoanAgreementResObj()?.message ?? "", null);
    }
  }

  _onErrorPostLoanAgreement(TGResponse errorResponse) {
    setState(() {
      isAgreeLoaderStart = false;
    });
    TGLog.d("RegisterResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> loanAppStatusAfterPostAgg() async {
    // /kbkbjkkjkjkj
    if (await TGNetUtil.isInternetAvailable()) {
      getLoanAppStatusAfterPostLoanAgreeReq();
    } else {
      showSnackBarForintenetConnection(context, getLoanAppStatusAfterPostLoanAgreeReq);
    }
  }

  // Loan App Status After Post Loan Agreement Request
  Future<void> getLoanAppStatusAfterPostLoanAgreeReq() async {
    //kjjkbkjbkjbjk
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String loanAppId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
    GetLoanStatusRequest getLoanStatusRequest =
        GetLoanStatusRequest(loanApplicationRefId: loanAppRefId, loanApplicationId: loanAppId);
    var jsonReq = jsonEncode(getLoanStatusRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, AppUtils.getManageLoanAppStatusParam('6'));
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

      String url = utf8.decode(base64Decode(_getLoanStatusRes?.data?.agreementRedirectionData ?? ""));
      // TODO: remove navigation and add/uncomment launch URL
      // Navigator.pushReplacementNamed(context, MyRoutes.SetupEmandateRoutes);
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ESignCompletedMain(),
      //   ),
      //   (route) => false,
      // );
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
      LoaderUtils.handleErrorResponse(context, response?.getLoanStatusResObj().status,
          response?.getLoanStatusResObj().message, response?.getLoanStatusResObj().data?.stageStatus);
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
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String loanAppId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
    GetLoanStatusRequest getLoanStatusRequest =
        GetLoanStatusRequest(loanApplicationRefId: loanAppRefId, loanApplicationId: loanAppId);
    var jsonReq = jsonEncode(getLoanStatusRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, AppUtils.getManageLoanAppStatusParam('6'));
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
            builder: (context) => const EmailSentAfterLoanAgreement(),
          ));
    } else if (_getLoanStatusRes?.data?.stageStatus == "HOLD") {
      Future.delayed(const Duration(seconds: 10), () {
        loanAppStatusAfterPostAgg();
      });
    } else {
      LoaderUtils.handleErrorResponse(context, response?.getLoanStatusResObj().status,
          response?.getLoanStatusResObj().message, response?.getLoanStatusResObj().data?.stageStatus);
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
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String loanAppId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
    PostLoanAgreementStatusReq postLoanAgreementStatusReq = PostLoanAgreementStatusReq(
      loanApplicationRefId: loanAppRefId,
      loanApplicationId: loanAppId,
    );
    var jsonReq = jsonEncode(postLoanAgreementStatusReq.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_POST_LOAN_AGREEMENT_STATUS);
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
          context, response?.getLoanAgreementResObj().status, response?.getLoanAgreementResObj().message, null);
    }
  }

  _onErrorLoanAgreementStatus(TGResponse errorResponse) {
    TGLog.d("LoanAgreementStatusResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> loanAggStatusApi() async {
    if (await TGNetUtil.isInternetAvailable()) {
      loanAgreementStatus();
    } else {
      showSnackBarForintenetConnection(context, loanAgreementStatus);
    }
  }

  Future<void> loanAggStatusAfterWebviewApi() async {
    if (await TGNetUtil.isInternetAvailable()) {
      getLoanAppStatusAfterLoanAgreeWebview();
    } else {
      showSnackBarForintenetConnection(context, getLoanAppStatusAfterLoanAgreeWebview);
    }
  }
}
