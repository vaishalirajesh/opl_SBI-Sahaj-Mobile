import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gstmobileservices/common/app_init.dart';
import 'package:gstmobileservices/common/tg_log.dart';
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
import 'package:gstmobileservices/util/erros_handle_util.dart';
import 'package:gstmobileservices/util/tg_flavor.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/loanofferlist/ui/loan_offer_pop_up.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';
import 'package:sbi_sahay_1_0/widgets/info_loader.dart';

import '../../../utils/Utils.dart';
import '../../../utils/constants/prefrenceconstants.dart';
import '../../../utils/constants/statusConstants.dart';
import '../../../utils/internetcheckdialog.dart';
import '../../../utils/progressLoader.dart';

class AaCompletedPage extends StatefulWidget {
  const AaCompletedPage({required this.str, Key? key}) : super(key: key);
  final Map<dynamic, dynamic> str;

  @override
  State<StatefulWidget> createState() => _AaCompletedState();
}

class _AaCompletedState extends State<AaCompletedPage> {
  String? ecres;
  String? resdate;
  String? fi;
  String? loanAppRefId;
  String? loanAppId;
  String? consentAggId;
  int? consentStatus;

  @override
  void initState() {
    super.initState();
    ecres = widget.str['ecres'];
    resdate = widget.str['resdate'];
    fi = widget.str['fi'];
    _init();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // loanAppId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
      if (mounted) {
        setState(() async {
          loanAppId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
        });
      }
    });
  }

  Future<void> _init() async {
    TGLog.d("_init: Start");
    await Future.delayed(const Duration(seconds: 1));
    initService();
    if (TGFlavor.applyMock() == true) {
      await Future.delayed(const Duration(seconds: 7));
    } else {
      await Future.delayed(const Duration(seconds: 2));
    }
    _getRedirectionalUrlReq();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const DashboardWithGst(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
          return true;
        },
        child: Scaffold(
          body: loanAppId == "" || loanAppId == null
              ? const ShowInfoLoader(
                  msg: str_fetching_bank_account_details,
                )
              : Container(),
        ),
      ),
    );
  }

  Future<void> _getRedirectionalUrlReq() async {
    loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID) ?? '';
    consentAggId = await TGSharedPreferences.getInstance().get(PREF_CONSENT_AAID) ?? '';
    loanAppId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPID) ?? '';
    GetRedirectionalUrlRequest getRedirectionalUrlRequest = GetRedirectionalUrlRequest(
        loanApplicationRefId: loanAppRefId,
        consentAggId: consentAggId,
        consentFetchType: loanAppId == "" || loanAppId == null ? 'ONE_TIME' : 'PERIODIC',
        aaRedirectionDecReq:
            GetRedirectionalUrlObj(webRedirectionURL: WebRedirectionURL(ecres: ecres, resdate: resdate, fi: fi)));

    var jsonReq = jsonEncode(getRedirectionalUrlRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_GET_REDIRECTIONAL_URL);

    ServiceManager.getInstance().getRedirectionalUrl(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetRedirectionUrl(response),
        onError: (error) => _onErrorGetRedirectionUrl(error));
  }

  _onSuccessGetRedirectionUrl(GetRedirectionalUrlResponse? response) {
    TGLog.d("GetRedirectionalUrlResponse : onSuccess()");

    if (response?.getRedirectionalUrlResObj().status == RES_SUCCESS) {
      consentStatus = RES_SUCCESS;

      if (loanAppId == "" || loanAppId == null) {
        Future.delayed(const Duration(seconds: 60), () {
          _callConsentStatusReq();
        });
      } else {
        Future.delayed(const Duration(seconds: 15), () {
          _callConsentStatusReq();
        });
      }
    } else if (response?.getRedirectionalUrlResObj().status == CONSENT_REJECTION) {
      consentStatus = CONSENT_REJECTION;
      _callConsentStatusReq();
    } else {
      LoaderUtils.handleErrorResponse(
          context, response?.getRedirectionalUrlResObj().status, response?.getRedirectionalUrlResObj().message, null);
    }
  }

  _onErrorGetRedirectionUrl(TGResponse errorResponse) {
    TGLog.d("GetRedirectionalUrlResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> _callConsentStatusReq() async {
    if (await TGNetUtil.isInternetAvailable()) {
      _getConsentStatusRequest();
    } else {
      showSnackBarForintenetConnection(context, _getConsentStatusRequest);
    }
  }

  Future<void> _getConsentStatusRequest() async {
    ConsentStatusRequest consentStatusRequest = ConsentStatusRequest(
        loanApplicationRefId: loanAppRefId,
        consentAggId: consentAggId,
        consentFetchType: loanAppId == "" || loanAppId == null ? 'ONE_TIME' : 'PERIODIC',
        webRedirectionData: WebRedirectionURL(ecres: ecres, resdate: resdate, fi: fi));
    var jsonReq = jsonEncode(consentStatusRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_CONSENT_STATUS_REQUEST);

    ServiceManager.getInstance().getConsentStatus(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetConsentStatus(response),
        onError: (error) => _onErrorGetConsentStatus(error));
  }

  _onSuccessGetConsentStatus(ConsentStatusResponse? response) {
    TGLog.d("ConsentStatusResponse : onSuccess()");
    if (response?.getConsentStatusResObj().status == RES_SUCCESS) {
      if (consentStatus == RES_SUCCESS) {
        _loanAppStatusAfterConsentStatus();
      } else if (consentStatus == CONSENT_REJECTION) {
        LoaderUtils.handleErrorResponse(context, consentStatus, response?.getConsentStatusResObj().message, null);
      } else {
        // TODO : Add showing error popup for account aggregator fail
        // navigationHandler(
        //   bankName: TGFlavor.param("bankName"),
        //   currentScreen: StringAssets.aaCompleted,
        //   context: context,
        //   isCommon: false,
        // );
      }
    } else {
      LoaderUtils.handleErrorResponse(
          context, response?.getConsentStatusResObj().status, response?.getConsentStatusResObj().message, null);
    }
  }

  _onErrorGetConsentStatus(TGResponse errorResponse) {
    TGLog.d("ConsentStatusResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> _getLoanAppStatusAfterConsentStatus() async {
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String? loanAppId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
    GetLoanStatusRequest getLoanStatusRequest =
        GetLoanStatusRequest(loanApplicationRefId: loanAppRefId, loanApplicationId: loanAppId ?? "");
    var jsonReq = jsonEncode(getLoanStatusRequest.toJson());
    TGPostRequest tgPostRequest;
    if (loanAppId == null || loanAppId == "") {
      tgPostRequest = await getPayLoad(jsonReq, Utils.getManageLoanAppStatusParam('2'));
    } else {
      tgPostRequest = await getPayLoad(jsonReq, Utils.getManageLoanAppStatusParam('4'));
    }
    ServiceManager.getInstance().getLoanAppStatus(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetLoanAppStatusAfterConsentStatus(response),
        onError: (error) => _onErrorGetLoanAppStatus(error));
  }

  _onSuccessGetLoanAppStatusAfterConsentStatus(GetLoanStatusResponse? response) async {
    TGLog.d("LoanAppStatusResponse : onSuccess()");
    if (response?.getLoanStatusResObj().status == RES_SUCCESS) {
      if (response?.getLoanStatusResObj().data?.stageStatus == "PROCEED") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoanOfferDialog(),
          ),
          (route) => false,
        );
      } else if (response?.getLoanStatusResObj().data?.stageStatus == "HOLD") {
        Future.delayed(const Duration(seconds: 10), () {
          _loanAppStatusAfterConsentStatus();
        });
      } else {
        _loanAppStatusAfterConsentStatus();
      }
    } else {
      LoaderUtils.handleErrorResponse(context, response?.getLoanStatusResObj().status,
          response?.getLoanStatusResObj().message, response?.getLoanStatusResObj().data?.stageStatus);
    }
  }

  _onErrorGetLoanAppStatus(TGResponse errorResponse) {
    TGLog.d("LoanAppStatusResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> _loanAppStatusAfterConsentStatus() async {
    if (await TGNetUtil.isInternetAvailable()) {
      _getLoanAppStatusAfterConsentStatus();
    } else {
      showSnackBarForintenetConnection(context, _getLoanAppStatusAfterConsentStatus);
    }
  }
}
