import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:sbi_sahay_1_0/utils/constants/statusconstants.dart';
import 'package:sbi_sahay_1_0/utils/erros_handle.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';
import 'package:sbi_sahay_1_0/widgets/app_drawer.dart';
import 'package:sbi_sahay_1_0/widgets/info_loader.dart';

import '../../../../loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/colorutils/mycolors.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/constants/prefrenceconstants.dart';
import '../../../../utils/helpers/myfonts.dart';
import '../../../../utils/helpers/themhelper.dart';
import '../../../../utils/internetcheckdialog.dart';
import '../../../../utils/progressLoader.dart';
import '../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';

class ProceedToDisburseMain extends StatelessWidget {
  const ProceedToDisburseMain({super.key});

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
  bool isLoaderTriggred = false;
  bool isLoadData = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
    return !isLoadData
        ? const ShowInfoLoader(
            msg: str_consent_monitering,
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
                        builder: (BuildContext context) => const DashboardWithGST(),
                      ),
                      (route) => false, //if you want to disable back feature set to false
                    );
                    return true;
                  }
                },
                child: SetContent(context),
              ),
            );
          });
  }

  Widget SetContent(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          drawer: const AppDrawer(),
          appBar: getAppBarWithStepDone('3', str_documentation, 0.75,
              onClickAction: () => {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const DashboardWithGST(),
                      ),
                      (route) => false, //if you want to disable back feature set to false
                    )
                  }),
          body: AbsorbPointer(
            absorbing: isLoaderTriggred,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                proceedToDisbContent(context),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 30.w),
                        child: DisbCheckboxUI(context),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      ReqForDisbButtonUI(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isLoaderTriggred)
          ShowInfoLoader(
            msg: str_request_disbursedment,
            subMsg: str_share_feedback,
            isTransparentColor: isLoaderTriggred,
          ),
      ],
    );
  }

  Widget proceedToDisbContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TopTextCard(),
        SizedBox(height: 18.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            str_proceed_to_disb,
            style: ThemeHelper.getInstance()?.textTheme.headline2,
          ),
        ),
        SizedBox(
          height: 12.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            "$str_the_loan_amt${AppUtils.convertIndianCurrency(strAmount)}$str_disb_amt",
            style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(fontSize: 14.sp),
            maxLines: 5,
          ),
        ),
        SizedBox(
          height: 28.h,
        ),
        loanDisbCard(context)
      ],
    );
  }

  Widget loanDisbCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: ThemeHelper.getInstance()!.cardColor, width: 1),
          color: ThemeHelper.getInstance()?.backgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(16.r),
          ),
        ),
        //width: 335.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: 40.h,
                    width: 40.w,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: ThemeHelper.getInstance()?.backgroundColor),
                    child: Center(
                        child: SvgPicture.asset(
                      AppUtils.path(SMALLBANKLOGO),
                      height: 18.h,
                      width: 18.w,
                    ))),
                Text(
                  dictData?.data?.accountHolderName ?? "-",
                  style: ThemeHelper.getInstance()
                      ?.textTheme
                      .bodyText2
                      ?.copyWith(color: MyColors.black, fontFamily: MyFont.Roboto_Medium),
                )
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(str_ac_no,
                          style: ThemeHelper.getInstance()
                              ?.textTheme
                              .headline3
                              ?.copyWith(color: MyColors.lightGraySmallText, fontSize: 12.sp)),
                      Text(
                        dictData?.data?.maskedAccountNumber ?? '',
                        style: ThemeHelper.getInstance()
                            ?.textTheme
                            .headline2
                            ?.copyWith(color: MyColors.black, fontSize: 14.sp),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        str_ifsc,
                        style: ThemeHelper.getInstance()
                            ?.textTheme
                            .headline3
                            ?.copyWith(color: MyColors.lightGraySmallText, fontSize: 12.sp),
                      ),
                      Text(
                        dictData?.data?.accountIFSC ?? '',
                        style: ThemeHelper.getInstance()
                            ?.textTheme
                            .headline2
                            ?.copyWith(color: MyColors.black, fontSize: 14.sp),
                      )
                    ],
                  ),
                ),
              ],
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
            SizedBox(
              width: 20.w,
              height: 20.h,
              child: Theme(
                data: ThemeData(
                  useMaterial3: true,
                  primaryColor: ThemeHelper.getInstance()!.primaryColor,
                ),
                child: Checkbox(
                  checkColor: ThemeHelper.getInstance()!.backgroundColor,
                  activeColor: ThemeHelper.getInstance()!.primaryColor,
                  value: isChecked,
                  onChanged: (bool) {
                    setIsChecked(bool!);
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.r))),
                  side: BorderSide(
                      width: 1,
                      color: isChecked
                          ? ThemeHelper.getInstance()!.primaryColor
                          : ThemeHelper.getInstance()!.primaryColor),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                str_disb_check_txt,
                style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(fontSize: 14.sp),
                maxLines: 5,
              ),
            ),
          ]),
    );
  }

  Widget ReqForDisbButtonUI(BuildContext context) {
    // return isTriggerdLoader
    //     ? JumpingDots(
    //         color: ThemeHelper.getInstance()?.primaryColor ??
    //             MyColors.pnbcolorPrimary,
    //         radius: 10,
    //       )
    //     : Container();

    return AppButton(
      onPress: onPressProceedButton,
      title: str_req_for_disb,
      isButtonEnable: isChecked,
    );
  }

  Widget buildRatingDialog() {
    return Material(
      child: Container(
        color: MyColors.black.withOpacity(0.5),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(12.r),
            ),
            color: ThemeHelper.getInstance()?.backgroundColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                alignment: FractionalOffset.topRight,
                child: GestureDetector(
                  child: Icon(
                    Icons.close,
                    color: MyColors.pnbcolorPrimary,
                    size: 24.r,
                  ),
                  onTap: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Text(
                  "Please rate us to serve you better",
                  style: ThemeHelper.getInstance()
                      ?.textTheme
                      .headline2
                      ?.copyWith(color: MyColors.lightGraySmallText, fontSize: 16.sp),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "Excellent!",
                style: ThemeHelper.getInstance()
                    ?.textTheme
                    .headline2
                    ?.copyWith(fontSize: 20.sp, color: MyColors.pnbcolorPrimary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              // RatingBarWidget(
              //   onRatingChanged: (double value) {},
              // ),
              SizedBox(height: 30.h),
              FeedbackTextFieldUI(),
              SizedBox(height: 30.h),
              submitButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget TopTextCard() {
    return Container(
      color: MyColors.veryLightgreenbg,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppUtils.path(FILLGREENCONFORMTICK),
                height: 18.h,
                width: 18.w,
              ),
              SizedBox(
                width: 8.w,
              ),
              Expanded(
                child: RichText(
                  maxLines: 5,
                  text: TextSpan(
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .bodyText1
                        ?.copyWith(color: ThemeHelper.getInstance()?.indicatorColor, fontFamily: MyFont.Roboto_Medium),
                    children: [
                      TextSpan(
                        text: str_congratulation,
                        style: ThemeHelper.getInstance()
                            ?.textTheme
                            .headline2
                            ?.copyWith(fontSize: 14.sp, color: MyColors.pnbGreenColor),
                      ),
                      TextSpan(
                        text: str_doc_process_complete,
                        style: ThemeHelper.getInstance()
                            ?.textTheme
                            .headline3
                            ?.copyWith(color: MyColors.pnbGreenColor, fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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

  Widget FeedbackTextFieldUI() {
    return Container(
        height: 35.h,
        child: TextFormField(
            onChanged: (content) {},
            cursorColor: MyColors.pnbDarkGreyTextColor,
            decoration: InputDecoration(
                labelText: "Please provide feedback",
                labelStyle:
                    ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(color: MyColors.verylightGrayColor),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: MyColors.pnbCheckBoxcolor)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: MyColors.pnbCheckBoxcolor))),
            keyboardType: TextInputType.text,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("(?!^ +\$)^[a-zA-Z ]+\$"), replacementString: "")
            ],
            maxLines: 1,
            style: ThemeHelper.getInstance()?.textTheme.headline2,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "";
              }
              return null;
            }));
  }

  Widget submitButton() {
    return AppButton(
      onPress: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const DashboardWithGST(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );
      },
      title: "Submit",
    );
  }

  //API
  Future<void> getDisbursedAccountDetailAPI() async {
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String loanAppID = await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);

    GetDisbursedAccDetailRequest getDisbursedAccDetail = GetDisbursedAccDetailRequest(
      loanApplicationRefId: loanAppRefId,
      loanApplicationId: loanAppID,
    );
    var jsonReq = jsonEncode(getDisbursedAccDetail.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_GET_DISBURSED_ACC_DETAIL);
    ServiceManager.getInstance().getDisbursedAccDetail(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetDisbursedAccDetail(response),
        onError: (error) => _onErrorGetDisbursedAccDetail(error));
  }

  _onSuccessGetDisbursedAccDetail(GetDisbursedAccDetailResponse? response) {
    TGLog.d("GetDisbursedAccDetailResponse : onSuccess()");

    _getDisbursedAccDetailResMain = response?.getDisbursedAccDetailResObj();

    if (_getDisbursedAccDetailResMain?.status == RES_DETAILS_FOUND) {
      setState(() {
        isLoading = false;
        dictData = _getDisbursedAccDetailResMain?.data?.accountDetailsModel;
        strAmount = _getDisbursedAccDetailResMain?.data?.disbursementAmount ?? "";
      });
    } else if (_getDisbursedAccDetailResMain?.status == RES_DETAILS_NOT_FOUND) {
      //after 5 second
      Future.delayed(const Duration(seconds: 5), () async {
        if (await TGNetUtil.isInternetAvailable()) {
          getDisbursedAccountDetailAPI();
        } else {
          showSnackBarForintenetConnection(context, getDisbursedAccountDetailAPI);
        }
      });
    } else {
      setState(() {
        isLoading = false;
      });
      LoaderUtils.handleErrorResponse(context, response?.getDisbursedAccDetailResObj().status,
          response?.getDisbursedAccDetailResObj().message, null);
    }
    setState(() {
      isLoadData = true;
    });
  }

  _onErrorGetDisbursedAccDetail(TGResponse errorResponse) {
    TGLog.d("GetDisbursedAccDetailResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
    setState(() {
      isLoadData = true;
    });
  }

  void onPressProceedButton() async {
    if (isChecked) {
      setState(() {
        isLoaderTriggred = true;
      });
      if (await TGNetUtil.isInternetAvailable()) {
        triggerDisbursementRequestAPI();
      } else {
        if (context.mounted) {
          showSnackBarForintenetConnection(context, triggerDisbursementRequestAPI);
        }
      }
    }
  }

  Future<void> triggerDisbursementRequestAPI() async {
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String loanAppID = await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);

    GetDisbursedAccDetailRequest getDisbursedAccDetail =
        GetDisbursedAccDetailRequest(loanApplicationRefId: loanAppRefId, loanApplicationId: loanAppID);
    var jsonReq = jsonEncode(getDisbursedAccDetail.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_TRIGGER_DISBURSED_REQ);
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
        isLoaderTriggred = false;
      });
      LoaderUtils.handleErrorResponse(
          context, response?.getTriggerDisburseReqObj().status, response?.getTriggerDisburseReqObj().message, null);
    }
  }

  _onErrorTriggerDisbursement(TGResponse errorResponse) {
    TGLog.d("TriggerDisbursementResponse : onError()");
    setState(() {
      isLoaderTriggred = false;
    });

    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> loanAppStatusApiCall() async {
    if (await TGNetUtil.isInternetAvailable()) {
      getLoanApplicaionStatusAPI();
    } else {
      if (mounted) {
        showSnackBarForintenetConnection(context, getLoanApplicaionStatusAPI);
      }
    }
  }

  Future<void> getLoanApplicaionStatusAPI() async {
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String? loanApplicationId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);

    GetLoanStatusRequest getLoanStatusRequest;
    if (loanApplicationId != null) {
      getLoanStatusRequest =
          GetLoanStatusRequest(loanApplicationRefId: loanAppRefId, loanApplicationId: loanApplicationId);
    } else {
      getLoanStatusRequest = GetLoanStatusRequest(loanApplicationRefId: loanAppRefId);
    }

    var jsonReq = jsonEncode(getLoanStatusRequest.toJson());

    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, AppUtils.getManageLoanAppStatusParam('11'));
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
        isLoaderTriggred = false;
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const DashboardWithGST(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
    } else if (_getLoanStatusResMain?.data?.stageStatus == "HOLD") {
      await Future.delayed(const Duration(seconds: 10));
      loanAppStatusApiCall();
    } else {
      setState(() {
        isLoaderTriggred = false;
      });
      LoaderUtils.handleErrorResponse(context, response?.getLoanStatusResObj().status,
          response?.getLoanStatusResObj().message, response?.getLoanStatusResObj().data?.stageStatus);
    }
  }

  _onErrorGetLoanAppStatus(TGResponse errorResponse) {
    TGLog.d("GetLoanAppStatusResponse : onError()");
    setState(() {
      isLoaderTriggred = false;
    });

    handleServiceFailError(context, errorResponse.error);
  }
}
