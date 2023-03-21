import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_loan_app_status_main.dart';
import 'package:gstmobileservices/model/models/get_repayment_plan_res_main.dart';
import 'package:gstmobileservices/model/models/share_gst_invoice_res_main.dart';
import 'package:gstmobileservices/model/requestmodel/get_loan_app_status_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_repayment_plan_request.dart';
import 'package:gstmobileservices/model/requestmodel/set_repayment_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_loan_app_status_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_repayment_plan_response.dart';
import 'package:gstmobileservices/model/responsemodel/set_repayment_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:sbi_sahay_1_0/documentation/mobile/emailsentaftersetupemandate/emandate_status.dart';
import 'package:sbi_sahay_1_0/routes.dart';
import 'package:sbi_sahay_1_0/utils/erros_handle.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';
import 'package:webviewx/webviewx.dart';

import '../../../../loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import '../../../../loanprocess/mobile/loanaggrementcompleted/ui/loanaggrementcompleted.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/colorutils/mycolors.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/constants/prefrenceconstants.dart';
import '../../../../utils/constants/statusConstants.dart';
import '../../../../utils/dimenutils/dimensutils.dart';
import '../../../../utils/internetcheckdialog.dart';
import '../../../../utils/jumpingdott.dart';
import '../../../../utils/strings/strings.dart';
import '../../../../widgets/animation_routes/page_animation.dart';

class SetupEmandate extends StatelessWidget {
  const SetupEmandate({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(
          child: WillPopScope(
              onWillPop: () async {
                return true;
              },
              child: SetupEmandateViewScreen()),
        );
      },
    );
  }
}

class SetupEmandateViewScreen extends StatefulWidget {
  const SetupEmandateViewScreen({Key? key}) : super(key: key);

  @override
  State<SetupEmandateViewScreen> createState() =>
      _SetupEmandateViewScreenState();
}

class _SetupEmandateViewScreenState extends State<SetupEmandateViewScreen> {
  GetRepaymentPlanResMain? _getRepaymentPlanResMain;
  ShareGstInvoiceResMain? _shareGstInvoiceResMain;

  GetLoanStatusResMain? _getLoanStatusResMain;

  bool isLoadWebView = false;

  bool isLoaderStartProceed = false;

  bool isOpenDetails = false;

  @override
  void initState() {
    //getRepaymentPlanApiCall();

    super.initState();
  }

  Future<void> getRepaymentPlanApiCall() async {
    if (await TGNetUtil.isInternetAvailable()) {
      getRepaymentPlanAPI();
    } else {
      showSnackBarForintenetConnection(context, getRepaymentPlanAPI);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(
          child: WillPopScope(
              onWillPop: () async {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => DashboardWithGST(),
                  ),
                  (route) =>
                      false, //if you want to disable back feature set to false
                );
                return true;
              },
              child: isLoadWebView
                  ? LoadSetupEmandateURLInWeb(context)
                  : Scaffold(
                      appBar: getAppBarWithStepDone("3", "Documentation", 0.75,
                          onClickAction: () => {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DashboardWithGST(),
                                  ),
                                  (route) =>
                                      false, //if you want to disable back feature set to false
                                )
                              }),
                      body: AbsorbPointer(
                        absorbing: isLoaderStartProceed,
                        child: Stack(children: [
                          SingleChildScrollView(
                            primary: true,
                            child: Container(
                              child: containerView(),
                            ),
                          ),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: buildBTNLoanOffer(context))
                        ]),
                      ),
                    )),
        );
      },
    );
    /*if (isLoadWebView == true) {
      return LoadSetupEmandateURLInWeb(context);
    } else {
      return Scaffold(
        appBar: getAppBarWithStepDone("3", "Documentation", 0.75),
        body: Stack(children: [
          SingleChildScrollView(
            primary: true,
            child: Container(
              child: containerView(),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: buildBTNLoanOffer(context))
        ]),
      );
    }*/
  }

  Widget containerView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLoanIntrestTenure(),
        sizebox(height: 28.h),
        padding(
          child: text(
            text: str_setup_emandate,
            textStyle:  ThemeHelper.getInstance()!.textTheme.headline2!,
          ),
          horizontal: 20.w,
        ),
        sizebox(height: 12.h),
        padding(
          child: text(
            text: str_emandate_txt +
                (_getRepaymentPlanResMain?.data?.bankName ?? "") +
                " " +
                str_emandate_txt1 +
                (_getRepaymentPlanResMain?.data?.accountNumber ?? ""),
            textStyle: ThemeHelper.getInstance()!.textTheme.headline3?.copyWith(fontSize: 14.sp),
          ),
          horizontal: 20.w,
        ),
        sizebox(height: 24.h),

        (isOpenDetails)
            ? Padding(
                padding: EdgeInsets.only(top: 10.h,right: 20.w,left: 20.w),
                child: buildLoanDetailsContainer(),
              )
            : _buildOnlyDetialContainer(),

        // paddingOnly(
        //   child: buildLoanDetailsContainer(),
        //   bottom: 100.h,
        //   top: 0.h,
        //   right: 20.w,
        //   left: 20.w,
        // ),
        sizebox(height: 200.h),
      ],
    );
  }

  Widget buildLoanIntrestTenure() {
    return Container(
      height: 62.h,
      decoration: BoxDecoration(
        color: MyColors.veryLightgreenbg,
      ),
      child: Row(
        children: [
          SizedBox(width: 20.w),
          SvgPicture.asset(
            Utils.path(FILLGREENCONFORMTICK), height: 17.h, width: 17.w,
            //
          ),
          SizedBox(width: 6.w),
          Text(str_complete_loan_agree,
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline3!
                  .copyWith(fontSize: 14.sp, color: MyColors.pnbGreenColor))
        ],
      ),
    );
  }

  Widget buildCommonRow(
      {required String titletext,
      required String titleValue,
      double? bottom,
      double? top,
      double? left,
      double? right}) {
    return  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text(text: titletext, textStyle: textTextHeader3Copywith11),
            SizedBox(height: 2.h,),
            text(text: titleValue, textStyle: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(color: MyColors.darkblack))
          ],
        );

  }

  Widget buildLoanDetailsContainer() {
    return GestureDetector(
        onTap: () {
          setState(() {
            isOpenDetails = false;
          });
        },
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: ThemeHelper.getInstance()!.cardColor, width: 1),
                color: ThemeHelper.getInstance()?.backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(16.r))),
            //width: 335.w,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  sizebox(height: 10.h),
                  _buildTopDetilss(),
                  // text(text: str_details, textStyle: textTextHeader1),
                  sizebox(height: 10.h),
                  buildCommonRow(
                      titletext: str_bank,
                      titleValue: _getRepaymentPlanResMain?.data?.bankName ?? "State Bank of India"),
                  sizebox(height: 20.h),
                  buildCommonRow(
                      titletext: str_bank_acc_no,
                      titleValue:
                          _getRepaymentPlanResMain?.data?.accountNumber ?? "XXXXXX7564"),
                  sizebox(height: 20.h),
                  buildCommonRow(
                      titletext: str_bank_ifsc,
                      titleValue: _getRepaymentPlanResMain?.data?.bankIfsc ?? "SBIN0003471"),
                  sizebox(height: 20.h),
                  buildCommonRow(
                      titletext: str_bank_acc_name,
                      titleValue:
                          _getRepaymentPlanResMain?.data?.buyerName ?? "Indo International"),
                  sizebox(height: 20.h),
                  buildCommonRow(
                      titletext: str_acc_type,
                      titleValue: _getRepaymentPlanResMain?.data?.accType ?? "Current"),
                  sizebox(height: 20.h),
                  buildCommonRow(
                      titletext: str_mobile_no,
                      titleValue: _getRepaymentPlanResMain?.data?.mobileNo ?? "9510777718"),
                  sizebox(height: 20.h),
                  buildCommonRow(
                      titletext: str_due_date,
                      titleValue: _getRepaymentPlanResMain?.data?.dueDate ?? "12 Aug, 2022"),
                  sizebox(height: 20.h),
                  buildCommonRow(
                      titletext: str_repayment_amt,
                      titleValue: Utils.convertIndianCurrency(
                          "26240")),
                ],
              ),
            )));
  }

  _buildOnlyDetialContainer() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isOpenDetails = true;
        });
      },
      child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: ThemeHelper.getInstance()!.cardColor, width: 1),
            color: ThemeHelper.getInstance()?.backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(16.r))),
       // width: 335.w,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              _buildTopDetilss(),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      )),
    );
  }

  _buildTopDetilss() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 200.w,
            child: Text(
              "Details",
              style: ThemeHelper.getInstance()!.textTheme.headline2,
            )),
        Spacer(),
        SvgPicture.asset(
        isOpenDetails ?
    Utils.path(IMG_UP_ARROW) : Utils.path(IMG_DOWN_ARROW),
    height: 20.h,
    width: 20.w,
    ),
      ],
    );
  }

  Widget buildBTNLoanOffer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 30.h),
      child: isLoaderStartProceed
          ? JumpingDots(
              color: ThemeHelper.getInstance()?.primaryColor ??
                  MyColors.pnbcolorPrimary,
              radius: 10,
            )
          : Container(
            color: ThemeHelper.getInstance()?.backgroundColor,
            height: 110.h,
            child: Column(
              children: [
                Text("You will be redirected to lender specific page for authorising through e-NACH",style: ThemeHelper.getInstance()?.textTheme.bodyText2,textAlign: TextAlign.center),
                SizedBox(height: 18.h),
                SizedBox(
                  height: 48.h,
                  child: ElevatedButton(
                      style: ThemeHelper.getInstance()!.elevatedButtonTheme.style,
                      onPressed: () async {

                        Navigator.pushNamed(context, MyRoutes.proceedToDisbursedRoutes);
                        // setState(() {
                        //   isLoaderStartProceed = true;
                        // });
                        // if (await TGNetUtil.isInternetAvailable()) {
                        //   setRepaymentRequestAPI();
                        // } else {
                        //   showSnackBarForintenetConnection(
                        //       context, setRepaymentRequestAPI);
                        // }
                      },
                      child: const Text(
                        str_proceed,
                      ),
                    ),
                ),
              ],
            ),
          ),
    );
  }

  Widget LoadSetupEmandateURLInWeb(BuildContext context) {
    late WebViewXController webviewController;

    return Container(
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: WebViewX(
          key: const ValueKey('webviewx'),
          initialContent:
              _getLoanStatusResMain?.data?.paymentUrl.toString() ?? "",
          initialSourceType: SourceType.url,
          height: MyDimension.getFullScreenHeight(),
          width: MyDimension.getFullScreenWidth(),

          onWebViewCreated: (controller) => webviewController = controller,
          onPageStarted: (src) => {
            TGLog.d(src),
            if (src.contains("output=") ||
                src.contains(
                    "https://uat-gst-sahay.instantmseloans.in/sahay/#/ENachResponse") ||
                src.contains(
                    "https://uat-oam.instantmseloans.in/tsp/updateNeSLStatus") ||
                src.contains(
                    "https://liveoam.instantmseloans.in/tsp/neslSuccess"))
              {setRepaymentPlanStatusApiCall()}
          },

          // onPageFinished: (src) =>
          //
          //
          //     debugPrint('The page has finished loading: $src\n'),
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

  //webAPI
  Future<void> getRepaymentPlanAPI() async {
    String loanAppRefId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String loanAppId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
    String offerId = await TGSharedPreferences.getInstance().get(PREF_OFFERID);
    GetRepaymentPlanRequest getRepaymentPlanRequest = GetRepaymentPlanRequest(
        loanApplicationRefId: loanAppRefId,
        loanApplicationId: loanAppId,
        offerId: offerId);
    var jsonReq = jsonEncode(getRepaymentPlanRequest.toJson());
    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, URI_GET_REPAYMENT_PLAN);
    ServiceManager.getInstance().getRepaymentPlanDetail(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetRepaymentPlan(response),
        onError: (error) => _onErrorGetRepaymentPlan(error));
  }

  _onSuccessGetRepaymentPlan(GetRepaymentPlanResponse? response) {
    TGLog.d("GetRepaymentPlanResponse : onSuccess()");

    // setState(() {
    //   _getRepaymentPlanResMain = response?.getRepaymentPlanResObj();
    // });

    if (response?.getRepaymentPlanResObj().status == RES_DETAILS_FOUND) {
      TGSharedPreferences.getInstance().set(PREF_REPAYMENTPLANID,
          response?.getRepaymentPlanResObj().data?.repaymentPlanId);
      setState(() {
        _getRepaymentPlanResMain = response?.getRepaymentPlanResObj();
      });
    } else if (response?.getRepaymentPlanResObj().status == RES_OFFER_EXPIRED) {
      //move to no offerfound
      TGView.showSnackBar(context: context, message: "offer expired");
    } else if (response?.getRepaymentPlanResObj().status ==
        RES_OFFER_INELIGIBLE) {
      //move to no offerfound
      TGView.showSnackBar(context: context, message: "Inaligible");
    } else {
      TGView.showSnackBar(
          context: context,
          message: response?.getRepaymentPlanResObj().message ?? "");
    }
  }

  _onErrorGetRepaymentPlan(TGResponse errorResponse) {
    TGLog.d("GetRepaymentPlanResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> setRepaymentRequestAPI() async {
    String loanAppRefId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String loanAppId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
    String repaymentPlanId =
        await TGSharedPreferences.getInstance().get(PREF_REPAYMENTPLANID);

    SetRepaymentRequest setRepaymentRequest = SetRepaymentRequest(
        loanApplicationRefId: loanAppRefId,
        loanApplicationId: loanAppId,
        repaymentPlanId: repaymentPlanId);

    Map<String, dynamic> test = setRepaymentRequest.toJson();
    test.removeWhere((key, value) => value == null);
    var jsonReq = jsonEncode(test);

    TGLog.d("SetRepaymentPlanRequest : $jsonReq");

    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, URI_SET_REPAYMENT_REQUEST);
    ServiceManager.getInstance().setRepaymentRequest(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessSetRepaymentPlan(response),
        onError: (error) => _onErrorSetRepaymentPlan(error));
  }

  _onSuccessSetRepaymentPlan(SetRepaymentResponse? response) {
    TGLog.d("SetRepaymentPlanResponse : onSuccess()");

    if (response?.setRepaymentResObj().status == RES_SUCCESS) {
      setState(() {
        _shareGstInvoiceResMain = response?.setRepaymentResObj();
        getLoanAppStatusApiCall();
      });
    } else if (response?.setRepaymentResObj().status == RES_OFFER_EXPIRED) {
      //move to no offerfound
      setState(() {
        isLoaderStartProceed = false;
      });
      TGView.showSnackBar(context: context, message: "offer expired");
    } else if (response?.setRepaymentResObj().status == RES_OFFER_INELIGIBLE) {
      //move to no offerfound
      setState(() {
        isLoaderStartProceed = false;
      });
      TGView.showSnackBar(context: context, message: "Inaligible");
    } else {
      setState(() {
        isLoaderStartProceed = false;
      });
      TGView.showSnackBar(
          context: context,
          message: response?.setRepaymentResObj().message ?? "");
    }
  }

  _onErrorSetRepaymentPlan(TGResponse errorResponse) {
    TGLog.d("SetRepaymentPlanResponse : onError()");
    setState(() {
      isLoaderStartProceed = false;
      handleServiceFailError(context, errorResponse.error);
    });
  }

  Future<void> getLoanApplicaionStatusAPI() async {
    // String loanApplicationReferenceID =
    // await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    // String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);

    String loanAppRefId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String loanAppId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
    String repaymentPlanId =
        await TGSharedPreferences.getInstance().get(PREF_REPAYMENTPLANID);

    GetLoanStatusRequest getLoanStatusRequest = GetLoanStatusRequest(
        loanApplicationRefId: loanAppRefId,
        loanApplicationId: loanAppId,
        repaymentPlanId: repaymentPlanId);

    var jsonReq = jsonEncode(getLoanStatusRequest.toJson());

    TGLog.d("Before Status API Requst : $jsonReq");

    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, Utils.getManageLoanAppStatusParam('8'));

    ServiceManager.getInstance().getLoanAppStatus(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetLoanAppStatus(response),
        onError: (error) => _onErrorGetLoanAppStatus(error));
  }

  _onSuccessGetLoanAppStatus(GetLoanStatusResponse? response) async {
    TGLog.d("GetLoanAppStatusResponse : onSuccess()");
    _getLoanStatusResMain = response?.getLoanStatusResObj();

    if (_getLoanStatusResMain?.status == RES_SUCCESS) {
      if (_getLoanStatusResMain?.data?.stageStatus == "PROCEED") {
        setState(() {
          isLoaderStartProceed = false;
          _getLoanStatusResMain = response?.getLoanStatusResObj();
          isLoadWebView = true;
        });
      } else if (_getLoanStatusResMain?.data?.stageStatus == "HOLD") {
        await Future.delayed(Duration(seconds: 10));
        getLoanAppStatusApiCall();
      }
    } else {
      TGView.showSnackBar(
          context: context, message: _getLoanStatusResMain?.message ?? "");
    }
  }

  _onErrorGetLoanAppStatus(TGResponse errorResponse) {
    TGLog.d("GetLoanAppStatusResponse : onError()");
    setState(() {
      isLoaderStartProceed = false;
      handleServiceFailError(context, errorResponse.error);
    });
  }

  Future<void> setRepaymentRequestStatusAPI() async {
    String loanAppRefId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String loanAppId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
    String repaymentPlanId =
        await TGSharedPreferences.getInstance().get(PREF_REPAYMENTPLANID);

    SetRepaymentRequest setRepaymentRequest = SetRepaymentRequest(
        loanApplicationRefId: loanAppRefId,
        loanApplicationId: loanAppId,
        repaymentPlanId: repaymentPlanId,
        camsCallBackRes: "");

    var jsonReq = jsonEncode(setRepaymentRequest.toJson());

    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, URI_SET_REPAYMENT_PLAN_STATUS);

    ServiceManager.getInstance().setRepaymentPlanStatus(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessSetRepaymentPlanStatus(response),
        onError: (error) => _onErrorSetRepaymentPlanStatus(error));
  }

  _onSuccessSetRepaymentPlanStatus(SetRepaymentResponse? response) {
    TGLog.d("setRepaymentRequestStatusResponse : onSuccess()");

    if (response?.setRepaymentResObj().status == RES_SUCCESS) {
      _shareGstInvoiceResMain = response?.setRepaymentResObj();
      getLoanAppStatusAfterWebviewApiCall();
    } else if (response?.setRepaymentResObj().status == RES_OFFER_EXPIRED) {
      //move to no offerfound
      TGView.showSnackBar(context: context, message: "offer expired");
    } else if (response?.setRepaymentResObj().status == RES_OFFER_INELIGIBLE) {
      //move to no offerfound
      TGView.showSnackBar(context: context, message: "Inaligible");
    } else {
      TGView.showSnackBar(
          context: context,
          message: response?.setRepaymentResObj().message ?? "");
    }
  }

  _onErrorSetRepaymentPlanStatus(TGResponse errorResponse) {
    TGLog.d("setRepaymentRequestStatusResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> getLoanAppStatusAfterWebview() async {
    String loanAppRefId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String loanAppId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
    String repaymentPlanId =
        await TGSharedPreferences.getInstance().get(PREF_REPAYMENTPLANID);

    GetLoanStatusRequest getLoanStatusRequest = GetLoanStatusRequest(
        loanApplicationRefId: loanAppRefId,
        loanApplicationId: loanAppId,
        repaymentPlanId: repaymentPlanId);

    var jsonReq = jsonEncode(getLoanStatusRequest.toJson());

    TGLog.d("Before Status API Requst : $jsonReq");

    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, Utils.getManageLoanAppStatusParam('8'));

    ServiceManager.getInstance().getLoanAppStatus(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessLoanAppStatusAfterWebview(response),
        onError: (error) => _onErrorLoanAppStatusAfterWebView(error));
  }

//..style
  _onSuccessLoanAppStatusAfterWebview(GetLoanStatusResponse? response) async {
    TGLog.d("GetLoanAppStatusResponse : onSuccess()");
    var _getLoanStatusResMain = response?.getLoanStatusResObj();

    if (_getLoanStatusResMain?.status == RES_SUCCESS) {
      if (_getLoanStatusResMain?.data?.stageStatus == "PROCEED") {
        TGSharedPreferences.getInstance()
            .set(PREF_CURRENT_STAGE, _getLoanStatusResMain?.data?.currentStage);
        //     Navigator.of(context).push(CustomRightToLeftPageRoute(child: const EmandateStatus(), ));
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmandateStatus(),
            ));

        setState(() {
          isLoaderStartProceed = false;
          isLoadWebView = false;
        });
      } else if (_getLoanStatusResMain?.data?.stageStatus == "HOLD") {
        await Future.delayed(Duration(seconds: 10));
        getLoanAppStatusAfterWebviewApiCall();
      }
    } else {
      setState(() {
        isLoaderStartProceed = false;
        isLoadWebView = false;
      });
      TGView.showSnackBar(
          context: context, message: _getLoanStatusResMain?.message ?? "");
    }
  }

  _onErrorLoanAppStatusAfterWebView(TGResponse errorResponse) {
    TGLog.d("GetLoanAppStatusResponse : onError()");
    setState(() {
      isLoaderStartProceed = false;
      handleServiceFailError(context, errorResponse.error);
    });
  }

  Future<void> getLoanAppStatusAfterWebviewApiCall() async {
    if (await TGNetUtil.isInternetAvailable()) {
      getLoanAppStatusAfterWebview();
    } else {
      showSnackBarForintenetConnection(context, getLoanAppStatusAfterWebview);
    }
  }

  Future<void> setRepaymentPlanStatusApiCall() async {
    if (await TGNetUtil.isInternetAvailable()) {
      setRepaymentRequestStatusAPI();
    } else {
      showSnackBarForintenetConnection(context, setRepaymentRequestStatusAPI);
    }
  }

  Future<void> getLoanAppStatusApiCall() async {
    if (await TGNetUtil.isInternetAvailable()) {
      getLoanApplicaionStatusAPI();
    } else {
      showSnackBarForintenetConnection(context, getLoanApplicaionStatusAPI);
    }
  }
}

Widget sizebox({required double height}) {
  return SizedBox(
    height: height,
  );
}

Widget padding({required Widget child, required double horizontal}) => Padding(
    padding: EdgeInsets.symmetric(horizontal: horizontal), child: child);

Widget paddingOnly(
        {required Widget child,
        required double bottom,
        required double top,
        required double left,
        required double right}) =>
    Padding(
        padding:
            EdgeInsets.only(left: left, right: right, bottom: bottom, top: top),
        child: child);

Widget text(
    {required String text,
    TextStyle? textStyle,
    TextAlign? textAlgin = TextAlign.left}) {
  return Text(
    text,
    style: textStyle,
    textAlign: textAlgin,
  );
}

TextStyle? textTextHeader1 = ThemeHelper.getInstance()!
    .textTheme
    .headline1
    ?.copyWith(color: MyColors.darkblack);

TextStyle? textTextHeader3 = ThemeHelper.getInstance()!.textTheme.headline3;
TextStyle? textTextHeader2Copywith16 =
    ThemeHelper.getInstance()!.textTheme.headline2!.copyWith(fontSize: 16.sp);
TextStyle? textTextHeader1Copywith14 =
    ThemeHelper.getInstance()!.textTheme.headline1!.copyWith(fontSize: 14.sp);
TextStyle? textTextHeader3Copywith11 =
    ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 11.sp);
