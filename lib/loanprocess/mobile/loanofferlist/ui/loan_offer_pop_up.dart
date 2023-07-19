import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_loan_app_status_main.dart';
import 'package:gstmobileservices/model/models/share_gst_invoice_res_main.dart';
import 'package:gstmobileservices/model/requestmodel/generate_loan_offer_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_loan_app_status_request.dart';
import 'package:gstmobileservices/model/responsemodel/generate_loan_offer_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_loan_app_status_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/jumpingdot_util.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import 'package:sbi_sahay_1_0/utils/constants/imageconstant.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/colorutils/mycolors.dart';
import '../../../../utils/constants/prefrenceconstants.dart';
import '../../../../utils/constants/statusConstants.dart';
import '../../../../utils/erros_handle.dart';
import '../../../../utils/internetcheckdialog.dart';
import '../../../../utils/movestageutils.dart';
import '../../../../utils/progressLoader.dart';
import '../../../../utils/strings/strings.dart';
import '../../../../widgets/app_button.dart';

class LoanOfferDialog extends StatefulWidget {
  const LoanOfferDialog({Key? key}) : super(key: key);

  @override
  State<LoanOfferDialog> createState() => _LoanOfferDialogState();
}

class _LoanOfferDialogState extends State<LoanOfferDialog> {
  ShareGstInvoiceResMain? _shareGstInvoiceRes;
  GetLoanStatusResMain? _getLoanStatusRes;
  late Timer timer;
  bool isStartTimer = true;
  bool isLoanDataFeched = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const DashboardWithGST(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );
        return true;
      },
      child: Scaffold(
        body: AbsorbPointer(
          absorbing: isLoanDataFeched,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.white,
                ),
                // height: 400.h,
                width: 335.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 40.h), //40
                    Center(
                        child: SvgPicture.asset(AppUtils.path(GREENCONFORMTICK),
                            height: 52.h, //,
                            width: 52.w, //134.8,
                            allowDrawingOutsideViewBox: true)),
                    SizedBox(height: 30.h), //40
                    Center(
                        child: Column(children: [
                      Text(
                        "Loan Offers are ready",
                        style: ThemeHelper.getInstance()?.textTheme.headline1?.copyWith(color: MyColors.darkblack),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 18.h),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Text(
                          "Information sharing to get loan offers from lender is completed. Initiate loan process with lender now.",
                          textAlign: TextAlign.center,
                          style: ThemeHelper.getInstance()?.textTheme.bodyText2,
                        ),
                      ),
                    ])),
                    //38
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: BtnCheckOut(),
                    ),
                    SizedBox(height: 30.h), //40
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget BtnCheckOut() {
    return isLoanDataFeched
        ? JumpingDots(
            color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary,
            radius: 10,
          )
        : AppButton(
            onPress: () async {
              // WidgetsBinding.instance.addPostFrameCallback((_) async {
              //   const ShowInfoLoader(
              //     msg: str_get_best_offer,
              //     isTransparentColor: false,
              //   );
              //   // LoaderUtils.showLoaderwithmsg(context, GETLOANOFFER, str_fetch_loan_offer_from_lender, msg: str_get_best_offer);
              // });

              if (await TGNetUtil.isInternetAvailable()) {
                _generateLoanOffer();
              } else {
                if (context.mounted) {
                  showSnackBarForintenetConnection(context, _generateLoanOffer);
                }
              }

              // Navigator.pushAndRemoveUntil(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => LoanOfferList(),
              //   ),
              //   (route) => false,
              // );
            },
            title: str_Checkit_out,
          );
  }

  Future<void> _generateLoanOffer() async {
    isLoanDataFeched = true;
    setState(() {});
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    GenerateLoanOfferRequest generateLoanOfferRequest = GenerateLoanOfferRequest(loanApplicationRefId: loanAppRefId);
    var jsonReq = jsonEncode(
      generateLoanOfferRequest.toJson(),
    );
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_GENERATE_LOAN_OFFERS);
    ServiceManager.getInstance().generateLoanOffer(
      request: tgPostRequest,
      onSuccess: (response) => _onSuccessGenerateLoanOffer(response),
      onError: (error) => _onErrorGenerateLoanOffer(error),
    );
  }

  _onSuccessGenerateLoanOffer(GenerateLoanOfferResponse? response) {
    TGLog.d("GenerateLoanOfferResponse : onSuccess()");
    _shareGstInvoiceRes = response?.getGenerateOfferResObj();
    if (_shareGstInvoiceRes?.status == RES_SUCCESS) {
      if (isStartTimer) {
        startTimer();
      }
      _getLoanAppStatusAfterGenerateOfferAPI();
    } else {
      isLoanDataFeched = false;
      setState(() {});
      LoaderUtils.handleErrorResponse(
          context, response?.getGenerateOfferResObj().status, response?.getGenerateOfferResObj().message, null);
    }
  }

  _onErrorGenerateLoanOffer(TGResponse errorResponse) {
    TGLog.d("GenerateLoanOfferResponse : onError()");
    isLoanDataFeched = false;
    setState(() {});
  }

  Future<void> _getLoanAppStatusAfterGenerateOffer() async {
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    GetLoanStatusRequest getLoanStatusRequest = GetLoanStatusRequest(loanApplicationRefId: loanAppRefId);
    var jsonReq = jsonEncode(
      getLoanStatusRequest.toJson(),
    );
    TGPostRequest tgPostRequest = await getPayLoad(
      jsonReq,
      AppUtils.getManageLoanAppStatusParam('3'),
    );
    ServiceManager.getInstance().getLoanAppStatus(
      request: tgPostRequest,
      onSuccess: (response) => _onSuccessGetLoanAppStatus(response),
      onError: (error) => _onErrorGetLoanAppStatus(error),
    );
  }

  _onSuccessGetLoanAppStatus(GetLoanStatusResponse? response) {
    TGLog.d("LoanAppStatusResponse : onSuccess()");
    _getLoanStatusRes = response?.getLoanStatusResObj();
    if (_getLoanStatusRes?.status == RES_SUCCESS) {
      if (_getLoanStatusRes?.data?.stageStatus == "PROCEED") {
        MoveStage.navigateNextStage(context, _getLoanStatusRes?.data?.currentStage);
        timer.cancel();
        //Navigator.pushNamed(context, MyRoutes.loanOfferListRoutes);
      } else if (_getLoanStatusRes?.data?.stageStatus == "HOLD") {
        Future.delayed(const Duration(seconds: 10), () {
          _getLoanAppStatusAfterGenerateOfferAPI();
        });
      } else {
        _getLoanAppStatusAfterGenerateOfferAPI();
      }
    } else {
      timer.cancel();
      isLoanDataFeched = false;
      setState(() {});
      LoaderUtils.handleErrorResponse(context, response?.getLoanStatusResObj().status,
          response?.getLoanStatusResObj().message, response?.getLoanStatusResObj().data?.stageStatus);
    }
  }

  _onErrorGetLoanAppStatus(TGResponse errorResponse) {
    timer.cancel();
    isLoanDataFeched = false;
    setState(() {});
    TGLog.d("LoanAppStatusResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> _getLoanAppStatusAfterGenerateOfferAPI() async {
    if (await TGNetUtil.isInternetAvailable()) {
      _getLoanAppStatusAfterGenerateOffer();
    } else {
      if (context.mounted) {
        showSnackBarForintenetConnection(context, _getLoanAppStatusAfterGenerateOffer);
      }
    }
  }

  void startTimer() {
    isStartTimer = false;
    timer = Timer.periodic(const Duration(seconds: 60), (_) => stopTimer());
  }

  void stopTimer() {
    TGView.showSnackBarWithDuration(
        context: context,
        message: "It is taking more time than as usual, kindly wait",
        duration: const Duration(seconds: 10));
  }
}
