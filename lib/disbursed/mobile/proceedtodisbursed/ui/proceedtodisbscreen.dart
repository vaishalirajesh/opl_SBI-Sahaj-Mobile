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
import 'package:gstmobileservices/model/responsemodel/get_disbursed_acc_detail_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_loan_app_status_response.dart';
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

import '../../../../loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
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

class ProceedToDisburseMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProceedToDisburseMains();
  }
}

class ProceedToDisburseMains extends StatefulWidget {
  @override
  ProceedToDisburseMainBody createState() => new ProceedToDisburseMainBody();
}

class ProceedToDisburseMainBody extends State<ProceedToDisburseMains> {
  var isChecked = false;
  // var isLoader = true;
  var strAmount = "";

  GetDisbursedAccDetailResMain? _getDisbursedAccDetailResMain;
  ShareGstInvoiceResMain? _shareGstInvoiceResMain;
  GetLoanStatusResMain? _getLoanStatusResMain;
  GetDisbursedAccObj? dictData;
  bool isLoading = true;
  bool isTriggerdLoader = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      LoaderUtils.showLoaderwithmsg(context,
          msg: "Please wait... \n Getting Information For Disbursement...");
      if (await TGNetUtil.isInternetAvailable()) {
        getDisbursedAccountDetailAPI();
      } else {
        showSnackBarForintenetConnection(context, getDisbursedAccountDetailAPI);
      }
    });

    super.initState();
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
              child: SetContent(context)));
    });
    return SetContent(context);
    ;
  }

  Widget SetContent(BuildContext context) {
    // if (isLoader) {
    //   return MobileLoaderWithoutProgess(
    //       context, Utils.path(LOADING_STOP_WATCH), strConsent_for_monitoring_getting_generated,
    //       str_Kindly_wait_for_60s);
    // }
    // else {
    return Scaffold(
      appBar: getAppBarWithStepDone('3', str_documentation, 0.75,
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
        absorbing: isTriggerdLoader,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProceedToDisbContent(context),
            Padding(
              padding: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 30.w),
                    child: DisbCheckboxUI(context),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  ReqForDisbButtonUI(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // }
    //}
  }

  Widget ProceedToDisbContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TopTextCard(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Text(
            str_proceed_to_disb,
            style: ThemeHelper.getInstance()?.textTheme.headline1,
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            str_the_loan_amt +
                Utils.convertIndianCurrency(strAmount) +
                str_disb_amt,
            style: ThemeHelper.getInstance()?.textTheme.headline3,
            maxLines: 5,
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        LoanDisbCard(context)
      ],
    );
  }

  Widget LoanDisbCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.all(Radius.circular(12.r))),
        shadowColor: ThemeHelper.getInstance()?.shadowColor,
        elevation: 2,
        child: Column(
          children: [
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ThemeHelper.getInstance()?.backgroundColor),
                      child: Center(
                          child: SvgPicture.asset(
                        Utils.path(SMALLBANKLOGO),
                        height: 18.h,
                        width: 18.w,
                      ))),
                  SizedBox(
                    width: 15.w,
                  ),
                  Text(
                    dictData?.data?.accountHolderName ?? "",
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .bodyText2
                        ?.copyWith(
                            color: MyColors.black,
                            fontFamily: MyFont.Nunito_Sans_Bold),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(str_ac_no,
                      style: ThemeHelper.getInstance()
                          ?.textTheme
                          .bodyText2
                          ?.copyWith(color: MyColors.pnbCardMediumTextColor)),
                  Text(
                    dictData?.data?.maskedAccountNumber ?? "",
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .bodyText2
                        ?.copyWith(
                            color: MyColors.black,
                            fontFamily: MyFont.Nunito_Sans_Bold),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(str_ifsc,
                      style: ThemeHelper.getInstance()
                          ?.textTheme
                          .bodyText2
                          ?.copyWith(color: MyColors.pnbCardMediumTextColor)),
                  Text(
                    dictData?.data?.accountIFSC ?? "",
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .bodyText2
                        ?.copyWith(
                            color: MyColors.black,
                            fontFamily: MyFont.Nunito_Sans_Bold),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget DisbCheckboxUI(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
      },
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 20.w,
              height: 20.h,
              child: Checkbox(
                checkColor: ThemeHelper.getInstance()!.backgroundColor,
                activeColor: ThemeHelper.getInstance()!.primaryColor,
                value: isChecked,
                onChanged: (bool) {
                  setIsChecked(bool!);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6.r))),
                side: BorderSide(
                    width: 1,
                    color: isChecked
                        ? ThemeHelper.getInstance()!.primaryColor
                        : ThemeHelper.getInstance()!.disabledColor),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                str_disb_check_txt,
                style: ThemeHelper.getInstance()
                    ?.textTheme
                    .headline4
                    ?.copyWith(fontFamily: MyFont.Nunito_Sans_Semi_bold),
                maxLines: 5,
              ),
            ),
          ]),
    );
  }

  Widget ReqForDisbButtonUI(BuildContext context) {
    return isTriggerdLoader
        ? JumpingDots(
            color: ThemeHelper.getInstance()?.primaryColor ??
                MyColors.pnbcolorPrimary,
            radius: 10,
          )
        : ElevatedButton(
            style: isChecked
                ? ThemeHelper.getInstance()!.elevatedButtonTheme.style
                : ThemeHelper.setPinkDisableButtonBig(),
            onPressed: () async {
              if (isChecked) {
                setState(() {
                  isTriggerdLoader = true;
                });
                if (await TGNetUtil.isInternetAvailable()) {
                  triggerDisbursementRequestAPI();
                } else {
                  showSnackBarForintenetConnection(
                      context, triggerDisbursementRequestAPI);
                }

                // viewModel.navigateToDisbursedScreen();
              }
            },
            child: Center(
              child: Text(
                str_req_for_disb,
                style: ThemeHelper.getInstance()?.textTheme.button,
              ),
            ));
  }

  Widget TopTextCard() {
    return Container(
      color: MyColors.pnbPinkColor,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: RichText(
            maxLines: 5,
            text: TextSpan(
              style: ThemeHelper.getInstance()?.textTheme.bodyText1?.copyWith(
                  color: ThemeHelper.getInstance()?.indicatorColor,
                  fontFamily: MyFont.Nunito_Sans_Semi_bold),
              children: [
                TextSpan(
                  text: str_congratulation,
                  style: ThemeHelper.getInstance()
                      ?.textTheme
                      .bodyText1
                      ?.copyWith(fontSize: 13.sp),
                ),
                TextSpan(
                  text: str_doc_process_complete,
                  style: ThemeHelper.getInstance()
                      ?.textTheme
                      .bodyText2
                      ?.copyWith(
                          color: ThemeHelper.getInstance()?.indicatorColor,
                          fontSize: 13.sp),
                ),
              ],
            ),
          )),
    );
  }

  //model

  void setIsChecked(bool bool) {
    setState(() {
      isChecked = bool;
    });
    //notifyListeners();
  }

  //API
  Future<void> getDisbursedAccountDetailAPI() async {
    String loanAppRefId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String loanAppID =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);

    GetDisbursedAccDetailRequest getDisbursedAccDetail =
        GetDisbursedAccDetailRequest(
      loanApplicationRefId: loanAppRefId,
      loanApplicationId: loanAppID,
    );
    var jsonReq = jsonEncode(getDisbursedAccDetail.toJson());
    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, URI_GET_DISBURSED_ACC_DETAIL);
    ServiceManager.getInstance().getDisbursedAccDetail(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetDisbursedAccDetail(response),
        onError: (error) => _onErrorGetDisbursedAccDetail(error));
  }

  _onSuccessGetDisbursedAccDetail(GetDisbursedAccDetailResponse? response) {
    TGLog.d("GetDisbursedAccDetailResponse : onSuccess()");

    _getDisbursedAccDetailResMain = response?.getDisbursedAccDetailResObj();

    if (_getDisbursedAccDetailResMain?.status == RES_DETAILS_FOUND) {
      Navigator.pop(context);
      setState(() {
        isLoading = false;
        dictData = _getDisbursedAccDetailResMain?.data?.accountDetailsModel;
        strAmount =
            _getDisbursedAccDetailResMain?.data?.disbursementAmount ?? "";
      });
    } else if (_getDisbursedAccDetailResMain?.status == RES_DETAILS_NOT_FOUND) {
      //after 5 second
      Future.delayed(const Duration(seconds: 5), () async {
        if (await TGNetUtil.isInternetAvailable()) {
          getDisbursedAccountDetailAPI();
        } else {
          showSnackBarForintenetConnection(
              context, getDisbursedAccountDetailAPI);
        }
      });
    } else {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(
          context,
          response?.getDisbursedAccDetailResObj().status,
          response?.getDisbursedAccDetailResObj().message,
          null);
    }
  }

  _onErrorGetDisbursedAccDetail(TGResponse errorResponse) {
    setState(() {
      isLoading = false;
    });
    TGLog.d("GetDisbursedAccDetailResponse : onError()");
    Navigator.pop(context);
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> triggerDisbursementRequestAPI() async {
    String loanAppRefId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String loanAppID =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);

    GetDisbursedAccDetailRequest getDisbursedAccDetail =
        GetDisbursedAccDetailRequest(
            loanApplicationRefId: loanAppRefId, loanApplicationId: loanAppID);
    var jsonReq = jsonEncode(getDisbursedAccDetail.toJson());
    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, URI_TRIGGER_DISBURSED_REQ);
    ServiceManager.getInstance().triggerDisbursementReq(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessTriggerDisbursement(response),
        onError: (error) => _onErrorTriggerDisbursement(error));
  }

  _onSuccessTriggerDisbursement(TriggerDisbursedReqResponse? response) {
    TGLog.d("TriggerDisbursementResponse : onSuccess()");
    _shareGstInvoiceResMain = response?.getTriggerDisburseReqObj();

    if (_shareGstInvoiceResMain?.status == RES_SUCCESS) {
      loanAppStatusApiCall();
    } else {
      setState(() {
        isTriggerdLoader = false;
      });
      LoaderUtils.handleErrorResponse(
          context,
          response?.getTriggerDisburseReqObj().status,
          response?.getTriggerDisburseReqObj().message,
          null);
    }
  }

  _onErrorTriggerDisbursement(TGResponse errorResponse) {
    TGLog.d("TriggerDisbursementResponse : onError()");
    setState(() {
      isTriggerdLoader = false;
    });

    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> loanAppStatusApiCall() async
  {
    if (await TGNetUtil.isInternetAvailable()) {
      getLoanApplicaionStatusAPI();
    } else {
      showSnackBarForintenetConnection(
          context, getLoanApplicaionStatusAPI);
    }
  }
  Future<void> getLoanApplicaionStatusAPI() async {
    //String loanApplicationReferenceID = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String loanAppRefId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String? loanApplicationId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);

    GetLoanStatusRequest getLoanStatusRequest;
    if (loanApplicationId != null) {
      getLoanStatusRequest = GetLoanStatusRequest(
          loanApplicationRefId: loanAppRefId,
          loanApplicationId: loanApplicationId);
    } else {
      getLoanStatusRequest =
          GetLoanStatusRequest(loanApplicationRefId: loanAppRefId);
    }

    var jsonReq = jsonEncode(getLoanStatusRequest.toJson());

    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, Utils.getManageLoanAppStatusParam('11'));
    ServiceManager.getInstance().getLoanAppStatus(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetLoanAppStatus(response),
        onError: (error) => _onErrorGetLoanAppStatus(error));
  }

  _onSuccessGetLoanAppStatus(GetLoanStatusResponse? response) async {
    TGLog.d("GetLoanAppStatusResponse : onSuccess()");
    _getLoanStatusResMain = response?.getLoanStatusResObj();

    if (_getLoanStatusResMain?.data?.stageStatus == "PROCEED") {
      setState(() {
        isTriggerdLoader = false;
      });
      MoveStage.navigateNextStage(
          context, _getLoanStatusResMain?.data?.currentStage);
    } else if (_getLoanStatusResMain?.data?.stageStatus == "HOLD") {
      await Future.delayed(Duration(seconds: 10));
      loanAppStatusApiCall();
    } else {
      setState(() {
        isTriggerdLoader = false;
      });
      LoaderUtils.handleErrorResponse(
          context,
          response?.getLoanStatusResObj().status,
          response?.getLoanStatusResObj().message,
          response?.getLoanStatusResObj().data?.stageStatus);
    }
    //if(_getLoanStatusResMain?.status == 1000){

    //Navigator.pushNamed(context, MyRoutes.DisbursementSuccessMessage);
    // }
  }

  _onErrorGetLoanAppStatus(TGResponse errorResponse) {
    TGLog.d("GetLoanAppStatusResponse : onError()");
    setState(() {
      isTriggerdLoader = false;
    });

    handleServiceFailError(context, errorResponse.error);
  }
}
