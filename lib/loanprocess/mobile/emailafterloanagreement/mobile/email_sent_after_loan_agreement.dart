import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/requestmodel/get_loan_app_status_request.dart';
import 'package:gstmobileservices/model/requestmodel/grant_loan_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_loan_app_status_response.dart';
import 'package:gstmobileservices/model/responsemodel/grant_loan_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:sbi_sahay_1_0/utils/erros_handle.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/colorutils/mycolors.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/constants/prefrenceconstants.dart';
import '../../../../utils/constants/statusConstants.dart';
import '../../../../utils/helpers/themhelper.dart';
import '../../../../utils/internetcheckdialog.dart';
import '../../../../utils/jumpingdott.dart';
import '../../../../utils/movestageutils.dart';
import '../../../../utils/progressLoader.dart';
import '../../../../utils/strings/strings.dart';
import '../../dashboardwithgst/mobile/dashboardwithgst.dart';

class EmailSentAfterLoanAgreement extends StatelessWidget {
  const EmailSentAfterLoanAgreement({super.key});

  @override
  Widget build(BuildContext context) {
    return EmailSentAfterLoanAgreementScreen();
  }
}

class EmailSentAfterLoanAgreementScreen extends StatefulWidget {
  const EmailSentAfterLoanAgreementScreen({super.key});

  @override
  State<StatefulWidget> createState() => _EmailSentAfterLoanAgreementScreen();
}

class _EmailSentAfterLoanAgreementScreen extends State<EmailSentAfterLoanAgreementScreen> {
  bool isLoaderStart = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (isLoaderStart) {
            return false;
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const DashboardWithGST(),
              ),
              (route) => false, //if you want to disable back feature set to false
            );
            return true;
          }
        },
        child: Scaffold(
          body: AbsorbPointer(
            absorbing: isLoaderStart,
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
                      SizedBox(height: 25.h), //40
                      Center(
                          child: Column(children: [
                        Text(
                          str_lonaAgg_titel,
                          style: ThemeHelper.getInstance()?.textTheme.headline2?.copyWith(color: MyColors.darkblack),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 18.h),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Text(
                            str_lonaAgg_disc,
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
      ),
    );
  }

  Widget BtnCheckOut() {
    return isLoaderStart
        ? JumpingDots(
            color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary,
            radius: 10,
          )
        : AppButton(
            onPress: () async {
              setState(() {
                isLoaderStart = true;
              });
              if (await TGNetUtil.isInternetAvailable()) {
                grantLoanRequest();
              } else {
                showSnackBarForintenetConnection(context, grantLoanRequest);
              }
            },
            title: str_Proceed,
          );
  }

//   SizedBox(
//   width: MediaQuery.of(context).size.width,
//   height: 50.h,
//   child: isLoaderStart
//   ? JumpingDots(
//   color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary,
//   radius: 10,
//   )
//       : ElevatedButton(
//   onPressed: () async {
//   setState(() {
//   isLoaderStart = true;
//   });
//   if (await TGNetUtil.isInternetAvailable()) {
//   grantLoanRequest();
//   } else {
//   showSnackBarForintenetConnection(context, grantLoanRequest);
//   }
// },
// child: Center(
// child: Text(
// str_Proceed,
// style: ThemeHelper.getInstance()?.textTheme.button,
// ),
// )),
// )

  //Grant Loan
  Future<void> grantLoanRequest() async {
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String loanAppId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
    GrantLoanRequest grantLoanRequest = GrantLoanRequest(
      loanApplicationRefId: loanAppRefId,
      loanApplicationId: loanAppId,
    );
    var jsonReq = jsonEncode(grantLoanRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_GRANT_LOAN_REQUEST);
    ServiceManager.getInstance().grantLoanrequest(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGrantLoan(response),
        onError: (error) => _onErrorGrantLoan(error));
  }

  _onSuccessGrantLoan(GrantLoanResponse? response) async {
    TGLog.d("GrantLoanResponse : onSuccess()");

    if (response?.getGrantLoanResObj()?.status == RES_SUCCESS) {
      if (await TGNetUtil.isInternetAvailable()) {
        getLoanAppStatusAfterGrantLoan();
      } else {
        showSnackBarForintenetConnection(context, getLoanAppStatusAfterGrantLoan);
      }
    } else {
      setState(() {
        isLoaderStart = false;
      });
      LoaderUtils.handleErrorResponse(
          context, response?.getGrantLoanResObj().status, response?.getGrantLoanResObj().message, null);
    }
  }

  _onErrorGrantLoan(TGResponse errorResponse) {
    TGLog.d("GrantLoanResponse : onError()");
    setState(() {
      isLoaderStart = false;
    });
    handleServiceFailError(context, errorResponse.error);
  }

  //LoanAppStatusAfterGrantLoan
  Future<void> getLoanAppStatusAfterGrantLoan() async {
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String loanAppId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
    GetLoanStatusRequest getLoanStatusRequest =
        GetLoanStatusRequest(loanApplicationRefId: loanAppRefId, loanApplicationId: loanAppId);
    var jsonReq = jsonEncode(getLoanStatusRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, AppUtils.getManageLoanAppStatusParam('10'));
    ServiceManager.getInstance().getLoanAppStatus(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessLoanAppStatusGrantLoan(response),
        onError: (error) => _onErrorLoanAppStatusGrantLoan(error));
  }

  _onSuccessLoanAppStatusGrantLoan(GetLoanStatusResponse? response) async {
    TGLog.d("LoanAppStatusGrantLoanResponse : onSuccess()");
    if (response?.getLoanStatusResObj()?.status == RES_SUCCESS) {
      if (response?.getLoanStatusResObj().data?.stageStatus == "PROCEED") {
        setState(() {
          isLoaderStart = false;
        });
        MoveStage.navigateNextStage(context, response?.getLoanStatusResObj().data?.currentStage);
        /*if(response?.getLoanStatusResObj()?.data?.currentStage == STAGE_E_MANDATE)
      {
          Navigator.pushNamed(context, MyRoutes.SetupEmandateRoutes);
      }*/
      } else if (response?.getLoanStatusResObj().data?.stageStatus == "HOLD") {
        await Future.delayed(Duration(seconds: 10));
        if (await TGNetUtil.isInternetAvailable()) {
          getLoanAppStatusAfterGrantLoan();
        } else {
          showSnackBarForintenetConnection(context, getLoanAppStatusAfterGrantLoan);
        }
      }
    } else {
      setState(() {
        isLoaderStart = false;
      });
      LoaderUtils.handleErrorResponse(context, response?.getLoanStatusResObj().status,
          response?.getLoanStatusResObj().message, response?.getLoanStatusResObj().data?.stageStatus);
    }
  }

  _onErrorLoanAppStatusGrantLoan(TGResponse errorResponse) {
    TGLog.d("LoanAppStatusGrantLoanResponse : onError()");
    setState(() {
      isLoaderStart = false;
      handleServiceFailError(context, errorResponse.error);
    });
  }
}
