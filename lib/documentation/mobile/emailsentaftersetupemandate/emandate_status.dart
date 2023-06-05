import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/requestmodel/get_loan_app_status_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_loan_app_status_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:gstmobileservices/util/tg_view.dart';

import '../../../loader/redirecting_loader.dart';
import '../../../utils/Utils.dart';
import '../../../utils/colorutils/mycolors.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/constants/prefrenceconstants.dart';
import '../../../utils/constants/statusConstants.dart';
import '../../../utils/erros_handle.dart';
import '../../../utils/helpers/themhelper.dart';
import '../../../utils/internetcheckdialog.dart';
import '../../../utils/jumpingdott.dart';
import '../../../utils/movestageutils.dart';
import '../../../utils/strings/strings.dart';
import '../../../widgets/animation_routes/page_animation.dart';

class EmandateStatus extends StatelessWidget {
  const EmandateStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmandateStatusScreen();
  }
}

class EmandateStatusScreen extends StatefulWidget {
  const EmandateStatusScreen({super.key});

  @override
  State<StatefulWidget> createState() => _EmandateStatus();
}

class _EmandateStatus extends State<EmandateStatusScreen> {
  bool isLoaderStart = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: AbsorbPointer(
          absorbing: isLoaderStart,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  height: 250.h,
                  width: 250.w,
                  Utils.path(EMAILSEND),
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 10.h),
                Text(
                  'Email and SMS sent for \n setting up auto debit \n for repayment',
                  style: ThemeHelper.getInstance()?.textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                    'Complete the e-NACH(auto debit) process to proceed further. \n Ensure you have E-Mandate activated in your bank account. If not, then please \n login through net banking and activate E-Mandate',
                    style: ThemeHelper.getInstance()?.textTheme.headline3,
                    textAlign: TextAlign.center,
                    maxLines: 10),
                SizedBox(
                  height: 20.h,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50.h,
                  child: isLoaderStart
                      ? JumpingDots(
                          color: ThemeHelper.getInstance()?.primaryColor ??
                              MyColors.pnbcolorPrimary,
                          radius: 10,
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            if (await TGNetUtil.isInternetAvailable()) {
                              getLoanApplicaionStatusAPI();
                            } else {
                              showSnackBarForintenetConnection(
                                  context, getLoanApplicaionStatusAPI);
                            }
                            setState(() {
                              isLoaderStart = true;
                            });
                          },
                          child: Center(
                            child: Text(
                              str_check_status,
                              style:
                                  ThemeHelper.getInstance()?.textTheme.button,
                            ),
                          )),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Future<void> getLoanApplicaionStatusAPI() async {
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
        await getPayLoad(jsonReq, Utils.getManageLoanAppStatusParam('9'));

    ServiceManager.getInstance().getLoanAppStatus(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetLoanAppStatus(response),
        onError: (error) => _onErrorGetLoanAppStatus(error));
  }

  _onSuccessGetLoanAppStatus(GetLoanStatusResponse? response) async {
    TGLog.d("GetLoanAppStatusResponse : onSuccess()");

    var _getLoanStatusResMain = response?.getLoanStatusResObj();
    if (_getLoanStatusResMain?.status == RES_SUCCESS) {
      if (_getLoanStatusResMain?.data?.stageStatus == "PROCEED") {
        TGSharedPreferences.getInstance()
            .set(PREF_CURRENT_STAGE, _getLoanStatusResMain?.data?.currentStage);
        MoveStage.navigateNextStage(
            context, response?.getLoanStatusResObj().data?.currentStage);
      } else if (_getLoanStatusResMain?.data?.stageStatus == "HOLD") {
        await Future.delayed(Duration(seconds: 10));
        if (await TGNetUtil.isInternetAvailable()) {
          getLoanApplicaionStatusAPI();
        } else {
          showSnackBarForintenetConnection(
              context, getLoanApplicaionStatusAPI);
        }
      }
    } else {
      TGView.showSnackBar(
          context: context, message: _getLoanStatusResMain?.message ?? "");
    }
  }

  _onErrorGetLoanAppStatus(TGResponse errorResponse) {
    TGLog.d("GetLoanAppStatusResponse : onError()");
    setState(() {
      handleServiceFailError(context, errorResponse.error);
    });
  }
}
