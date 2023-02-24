import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_disbursed_acc_detail_res_main.dart';
import 'package:gstmobileservices/model/models/get_disbursed_acc_res_main.dart';
import 'package:gstmobileservices/model/models/get_loan_app_status_main.dart';
import 'package:gstmobileservices/model/models/share_gst_invoice_res_main.dart';
import 'package:gstmobileservices/model/requestmodel/get_disbursed_acc_detail_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_loan_app_status_request.dart';
import 'package:gstmobileservices/model/requestmodel/loan_agreement_status_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_disbursed_acc_detail_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_loan_app_status_response.dart';
import 'package:gstmobileservices/model/responsemodel/loan_agreement_status_response.dart';
import 'package:gstmobileservices/model/responsemodel/trigger_disbursed_request_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:provider/provider.dart';
import 'package:sbi_sahay_1_0/disbursed/mobile/proceedtodisbursed/viewmodel/proceedtodisbursedviewmodel.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusconstants.dart';
import 'package:sbi_sahay_1_0/utils/erros_handle.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';

import '../../../../routes.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/colorutils/mycolors.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/constants/prefrenceconstants.dart';
import '../../../../utils/helpers/myfonts.dart';
import '../../../../utils/helpers/themhelper.dart';
import '../../../../utils/internetcheckdialog.dart';
import '../../../../utils/jumpingdott.dart';
import '../../../../utils/movestageutils.dart';
import '../../../../utils/progressLoader.dart';
import '../../../../widgets/loaderscreen/mobileloader/loaderwithoutprogressbar.dart';
import '../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';
import '../../dashboardwithgst/mobile/dashboardwithgst.dart';
import '../../emailafterloanagreement/mobile/email_sent_after_loan_agreement.dart';

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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      LoaderUtils.showLoaderwithmsg(context,
          msg:
              "Waiting for Digital Document Execution Status \n $str_Kindly_wait_for_60s");
// your code goes here
    });
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      getLoanAgreementStatus();
    });
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
              child: Container()));
    });
    return Container();
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

  _onSuccessLoanAgreementStatus(LoanAgreementStatusResponse? response)  {
    TGLog.d("LoanAgreementStatusResponse : onSuccess()");
    if (response?.getLoanAgreementResObj()?.status == RES_SUCCESS) {
      getLoanAppStatusAfterWebviewAPI();
    } else {
      Navigator.pop(context);
      TGView.showSnackBar(
          context: context,
          message: response?.getLoanAgreementResObj()?.message ?? "");
    }
  }

  _onErrorLoanAgreementStatus(TGResponse errorResponse) {
    TGLog.d("LoanAgreementStatusResponse : onError()");
    Navigator.pop(context);
    handleServiceFailError(context, errorResponse.error);
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
    GetLoanStatusResMain? _getLoanStatusRes;

    TGLog.d("LoanAppStatusResponseAfterLoanAgreeWebview : onSuccess()");
    _getLoanStatusRes = response?.getLoanStatusResObj();
    if (_getLoanStatusRes?.data?.stageStatus == "PROCEED") {
      //  Navigator.pushNamed(context, MyRoutes.EmailSentRoutes);
      //  Navigator.of(context).push(CustomRightToLeftPageRoute(child: EmailSentAfterLoanAgreement(), ));
      // Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => EmailSentAfterLoanAgreement(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
    } else if (_getLoanStatusRes?.data?.stageStatus == "HOLD") {
      Future.delayed(const Duration(seconds: 10), () async {
        // getLoanAppStatusAfterPostLoanAgreeReq();
        getLoanAppStatusAfterWebviewAPI();
      });
    } else {
      Navigator.pop(context);
      TGView.showSnackBar(
          context: context, message: _getLoanStatusRes?.message ?? "");
    }
  }

  _onErrorGetLoanAppStatus1(TGResponse errorResponse) {
    TGLog.d("LoanAppStatusResponseAfterLoanAgreeWebview : onError()");
    Navigator.pop(context);
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> getLoanAppStatusAfterWebviewAPI() async
  {
    if (await TGNetUtil.isInternetAvailable()) {
      getLoanAppStatusAfterLoanAgreeWebview();
    } else {
      showSnackBarForintenetConnection(
          context, getLoanAppStatusAfterLoanAgreeWebview);
    };
  }
}
