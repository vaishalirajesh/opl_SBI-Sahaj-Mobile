import 'dart:convert';

import 'package:flutter/material.dart';
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
import 'package:sbi_sahay_1_0/utils/constants/statusConstants.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';
import 'package:sbi_sahay_1_0/widgets/info_loader.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/constants/prefrenceconstants.dart';
import '../../../../utils/internetcheckdialog.dart';
import '../../../../utils/movestageutils.dart';
import '../../dashboardwithgst/mobile/dashboardwithgst.dart';

class ESignCompletedMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ESignCompletedMains();
  }
}

class ESignCompletedMains extends StatefulWidget {
  @override
  ESignCompleted createState() => ESignCompleted();
}

class ESignCompleted extends State<ESignCompletedMains> {
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
    getLoanAgreementStatus();
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
    return !isLoadData
        ? const ShowInfoLoader(
            msg: str_digital_document_process,
            subMsg: str_Kindly_wait_for_60s,
          )
        : LayoutBuilder(builder: (context, constraints) {
            return SafeArea(
              child: WillPopScope(
                onWillPop: () async {
                  if (!isLoadData) {
                    return false;
                  } else {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const DashboardWithGst(),
                      ),
                      (route) => false, //if you want to disable back feature set to false
                    );
                    return true;
                  }
                },
                child: Container(),
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
    ServiceManager.getInstance().postLoanAgreementStatus(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessLoanAgreementStatus(response),
        onError: (error) => _onErrorLoanAgreementStatus(error));
  }

  _onSuccessLoanAgreementStatus(LoanAgreementStatusResponse? response) {
    TGLog.d("LoanAgreementStatusResponse : onSuccess()");
    if (response?.getLoanAgreementResObj().status == RES_SUCCESS) {
      getLoanAppStatusAfterWebviewAPI();
    } else {
      isLoadData = true;
      TGView.showSnackBar(context: context, message: response?.getLoanAgreementResObj().message ?? "");
    }
  }

  _onErrorLoanAgreementStatus(TGResponse errorResponse) {
    TGLog.d("LoanAgreementStatusResponse : onError()");
    isLoadData = true;
    handleServiceFailError(context, errorResponse.error);
  }

  //Get Loan App Status After Webview
  Future<void> getLoanAppStatusAfterLoanAgreeWebview() async {
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String loanAppId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
    GetLoanStatusRequest getLoanStatusRequest =
        GetLoanStatusRequest(loanApplicationRefId: loanAppRefId, loanApplicationId: loanAppId);
    var jsonReq = jsonEncode(getLoanStatusRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, AppUtils.getManageLoanAppStatusParam('13'));
    ServiceManager.getInstance().getLoanAppStatus(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetLoanAppStatus1(response),
        onError: (error) => _onErrorGetLoanAppStatus1(error));
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
      Future.delayed(const Duration(seconds: 2))
          .then((value) => MoveStage.navigateNextStage(context, response?.getLoanStatusResObj().data?.currentStage));
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

      //   isLoadData = true;
      TGView.showSnackBar(context: context, message: _getLoanStatusRes?.message ?? "");
    }
  }

  _onErrorGetLoanAppStatus1(TGResponse errorResponse) {
    TGLog.d("LoanAppStatusResponseAfterLoanAgreeWebview : onError()");
    // isLoadData = true;
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
