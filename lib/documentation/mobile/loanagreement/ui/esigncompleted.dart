import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/common/app_init.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_loan_app_status_main.dart';
import 'package:gstmobileservices/model/requestmodel/get_loan_app_status_request.dart';
import 'package:gstmobileservices/model/requestmodel/loan_agreement_status_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_loan_app_status_response.dart';
import 'package:gstmobileservices/model/responsemodel/loan_agreement_status_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/erros_handle_util.dart';
import 'package:gstmobileservices/util/tg_flavor.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:sbi_sahay_1_0/routes.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusConstants.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';
import 'package:sbi_sahay_1_0/widgets/info_loader.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/colorutils/mycolors.dart';
import '../../../../utils/constants/prefrenceconstants.dart';
import '../../../../utils/helpers/themhelper.dart';
import '../../../../utils/internetcheckdialog.dart';
import '../../../../utils/movestageutils.dart';
import 'loan_aggrement_failed.dart';

class ESignCompleted extends StatefulWidget {
  Map queryParams = {};

  ESignCompleted({required this.queryParams});
  @override
  ESignCompletedstate createState() => ESignCompletedstate();
}

class ESignCompletedstate extends State<ESignCompleted> {
  var isChecked = false;
  bool isTriggerdLoader = false;
  bool isLoadData = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    TGLog.d("_init: Start");
    await Future.delayed(Duration(seconds: 1));
    initService();
    TGLog.d("_init: End");
    TGLog.d(TGFlavor.param("bankName"));
    if (TGFlavor.applyMock() == true) {
      await Future.delayed(Duration(seconds: 7));
    } else {
      await Future.delayed(Duration(seconds: 2));
    }
    if (widget.queryParams.values.isNotEmpty) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setModelState) {
            print(widget.queryParams.values.first);

            return Center(child: showErrorDialog(setModelState, widget.queryParams.values.first, widget.queryParams.values.elementAt(1)));
          });
        },
      );
    } else {
      getLoanAgreementStatus();
    }
  }

  Widget showErrorDialog(StateSetter setModelState, String error, String error_code) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Container(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            decoration: BoxDecoration(
              color: ThemeHelper.getInstance()!.cardColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Material(
              color: ThemeHelper.getInstance()!.cardColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(height: 15.h),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      error_code,
                      style: ThemeHelper.getInstance()?.textTheme.headline2!.copyWith(color: MyColors.pnbcolorPrimary).copyWith(fontSize: 12.sp),
                    ),
                  ),
                  // const Spacer(),

                  Text(error, style: ThemeHelper.getInstance()?.textTheme.bodyMedium!.copyWith(color: MyColors.pnbCardMediumTextColor, fontSize: 12.sp)),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 30.h),
                    child: applySortButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget applySortButton() {
    return SizedBox(
      height: 40.h,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, MyRoutes.DashboardWithGSTRoutes);
        },
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
        ),
        child: Center(
          child: Text(
            str_back_home,
            style: ThemeHelper.getInstance()?.textTheme.button,
          ),
        ),
      ),
    );
  }

  Future<void> getLoanAgreementStatus() async {
    if (await TGNetUtil.isInternetAvailable()) {
      loanAgreementStatus();
    } else {
      showSnackBarForintenetConnection(context, loanAgreementStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: const ShowInfoLoader(
            msg: str_digital_document_process,
            subMsg: str_Kindly_wait_for_60s,
          ),
        ),
      );
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
    ServiceManager.getInstance().postLoanAgreementStatus(request: tgPostRequest, onSuccess: (response) => _onSuccessLoanAgreementStatus(response), onError: (error) => _onErrorLoanAgreementStatus(error));
  }

  _onSuccessLoanAgreementStatus(LoanAgreementStatusResponse? response) {
    TGLog.d("LoanAgreementStatusResponse : onSuccess()");
    if (response?.getLoanAgreementResObj().status == RES_SUCCESS) {
      getLoanAppStatusAfterWebviewAPI();
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const LoanAgreementErrorScreen(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
      isLoadData = true;
      setState(() {});
      TGView.showSnackBar(context: context, message: response?.getLoanAgreementResObj().message ?? "");
    }
  }

  _onErrorLoanAgreementStatus(TGResponse errorResponse) {
    TGLog.d("LoanAgreementStatusResponse : onError()");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoanAgreementErrorScreen(),
      ),
      (route) => false, //if you want to disable back feature set to false
    );
    isLoadData = true;
    setState(() {});
    handleServiceFailError(context, errorResponse.error);
  }

  //Get Loan App Status After Webview
  Future<void> getLoanAppStatusAfterLoanAgreeWebview() async {
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String loanAppId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
    GetLoanStatusRequest getLoanStatusRequest = GetLoanStatusRequest(loanApplicationRefId: loanAppRefId, loanApplicationId: loanAppId);
    var jsonReq = jsonEncode(getLoanStatusRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, AppUtils.getManageLoanAppStatusParam('13'));
    ServiceManager.getInstance().getLoanAppStatus(request: tgPostRequest, onSuccess: (response) => _onSuccessGetLoanAppStatus1(response), onError: (error) => _onErrorGetLoanAppStatus1(error));
  }

  _onSuccessGetLoanAppStatus1(GetLoanStatusResponse? response) {
    GetLoanStatusResMain? _getLoanStatusRes;
    TGLog.d("LoanAppStatusResponseAfterLoanAgreeWebview : onSuccess()");
    _getLoanStatusRes = response?.getLoanStatusResObj();
    TGLog.d('Current stage-1-${_getLoanStatusRes?.data?.stageStatus}');
    if (_getLoanStatusRes?.data?.stageStatus == "PROCEED") {
      TGLog.d('Current stage- if');
      //  Navigator.pushNamed(context, MyRoutes.EmailSentRoutes);
      //  Navigator.of(context).push(CustomRightToLeftPageRoute(child: EmailSentAfterLoanAgreement(), ));
      // Navigator.pop(context);
      // if (context.mounted) {
      //   TGLog.d('Current stage- if--2');
      //   // isLoadData = true;
      //   // MoveStage.navigateNextStage(context, response?.getLoanStatusResObj().data?.currentStage);
      // }
      Future.delayed(const Duration(seconds: 2)).then((value) => MoveStage.navigateNextStage(context, response?.getLoanStatusResObj().data?.currentStage));
      // Navigator.pushReplacementNamed(context, MyRoutes.SetupEmandateRoutes);
      TGLog.d('Current stage- if--2');
    } else if (_getLoanStatusRes?.data?.stageStatus == "HOLD") {
      TGLog.d('Current stage- else if');

      Future.delayed(const Duration(seconds: 10), () async {
        // getLoanAppStatusAfterPostLoanAgreeReq();
        getLoanAppStatusAfterWebviewAPI();
      });
    } else {
      TGLog.d('Current stage- else');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const LoanAgreementErrorScreen(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
      isLoadData = true;
      setState(() {});
      TGView.showSnackBar(context: context, message: _getLoanStatusRes?.message ?? "");
    }
  }

  _onErrorGetLoanAppStatus1(TGResponse errorResponse) {
    TGLog.d("LoanAppStatusResponseAfterLoanAgreeWebview : onError()");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoanAgreementErrorScreen(),
      ),
      (route) => false, //if you want to disable back feature set to false
    );
    isLoadData = true;
    setState(() {});
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> getLoanAppStatusAfterWebviewAPI() async {
    if (await TGNetUtil.isInternetAvailable()) {
      getLoanAppStatusAfterLoanAgreeWebview();
    } else {
      showSnackBarForintenetConnection(context, getLoanAppStatusAfterLoanAgreeWebview);
    }
    ;
  }
}
