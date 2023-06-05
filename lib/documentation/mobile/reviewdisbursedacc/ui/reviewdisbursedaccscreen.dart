import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_disbursed_acc_res_main.dart';
import 'package:gstmobileservices/model/models/get_loan_app_status_main.dart';
import 'package:gstmobileservices/model/models/share_gst_invoice_res_main.dart';
import 'package:gstmobileservices/model/requestmodel/get_disbursed_acc_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_loan_app_status_request.dart';
import 'package:gstmobileservices/model/requestmodel/set_disbursed_acc_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_disbursed_acc_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_loan_app_status_response.dart';
import 'package:gstmobileservices/model/responsemodel/set_disbursed_acc_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/constants/imageconstant.dart';
import 'package:sbi_sahay_1_0/utils/erros_handle.dart';
import 'package:sbi_sahay_1_0/utils/helpers/myfonts.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';

import '../../../../loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import '../../../../routes.dart';
import '../../../../utils/colorutils/mycolors.dart';
import '../../../../utils/constants/prefrenceconstants.dart';
import '../../../../utils/constants/stageconstants.dart';
import '../../../../utils/constants/statusConstants.dart';
import '../../../../utils/helpers/themhelper.dart';
import '../../../../utils/internetcheckdialog.dart';
import '../../../../utils/jumpingdott.dart';
import '../../../../utils/movestageutils.dart';
import '../../../../utils/progressLoader.dart';

class ReviewDisbursedAccMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SafeArea(child: ReviewDisbursedAccMains());
    });
  }
}

class ReviewDisbursedAccMains extends StatefulWidget {
  @override
  ReviewDisbursedAccMainBody createState() => new ReviewDisbursedAccMainBody();
}

class ReviewDisbursedAccMainBody extends State<ReviewDisbursedAccMains> {
  GetDisbursedAccResMain? _getDisbursedAccRes;
  GetDisbursedAccObj? selectedAcc;
  GetLoanStatusResMain? _getLoanStatusRes;
  ShareGstInvoiceResMain? _setDisbursedAccRes;
  bool isListLoaded = false;
  bool isValidAccount = false;
  TextEditingController accountNumber = TextEditingController();

  //bool isLoaderStart = false;

  @override
  void initState() {
    getDisbursedAccListApi();
    super.initState();
  }

  Future<void> getDisbursedAccListApi() async
  {
    if (await TGNetUtil.isInternetAvailable()) {
      getDisbursedAccList();
    } else {
      showSnackBarForintenetConnection(context, getDisbursedAccList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => DashboardWithGST(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
          return true;
        },
        child: bodyScaffold(context));
  }

  Widget bodyScaffold(BuildContext context) {
    return Scaffold(
      appBar: getAppBarWithStep('3', str_documentation, 0.75,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                str_review_loan_deposite_acc,
                style: ThemeHelper.getInstance()?.textTheme.headline1,
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    str_ol,
                    style: ThemeHelper.getInstance()?.textTheme.headline3,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Flexible(
                      child: Text(
                    str_review_acc_txt_one,
                    style: ThemeHelper.getInstance()?.textTheme.headline3,
                    maxLines: 5,
                  )),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    str_ol,
                    style: ThemeHelper.getInstance()?.textTheme.headline3,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Flexible(
                      child: Text(
                    str_review_acc_txt_two,
                    style: ThemeHelper.getInstance()?.textTheme.headline3,
                  )),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),

              isListLoaded
                  ? loanDepositeAccList(context)
                  : JumpingDots(
                      color: ThemeHelper.getInstance()?.primaryColor ??
                          MyColors.pnbcolorPrimary,
                      radius: 10,
                    )
              //Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget loanDepositeAccList(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: _getDisbursedAccRes?.data?.length,
      itemBuilder: (context, index) {
        return Padding(
          /* key: ValueKey(_getDisbursedAccRes?.data?[index].data?.accountNumber),*/
          padding: EdgeInsets.only(bottom: 20.h),
          child: loandepositAccountCard(context, index),
        );
      },
    );
  }

  Widget loandepositAccountCard(BuildContext context, int index) {
    return Card(
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
                      height: 15.h,
                      width: 15.h,
                    ))),
                SizedBox(
                  width: 15.w,
                ),
                Expanded(
                  child: Text(
                    _getDisbursedAccRes?.data?[index].data?.fipName ?? "",
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .bodyText2
                        ?.copyWith(
                            color: ThemeHelper.getInstance()?.indicatorColor,
                            fontFamily: MyFont.Nunito_Sans_Bold),
                    maxLines: 3,
                    overflow: TextOverflow.visible,
                  ),
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
              /*crossAxisAlignment: CrossAxisAlignment.start,*/
              children: [
                Text(str_ac_no,
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .bodyText2
                        ?.copyWith(color: MyColors.pnbCardMediumTextColor)),
                Text(
                  _getDisbursedAccRes?.data?[index].data?.maskedAccountNumber ??
                      "",
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
                  _getDisbursedAccRes?.data?[index].data?.accountIFSC ?? "",
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
          Container(
            height: 33.h,
            child: proccedButton(context, index),
          )
        ],
      ),
    );
  }

  Widget proccedButton(BuildContext context, int index) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      shadowColor: Colors.transparent,
      foregroundColor: ThemeHelper.getInstance()?.primaryColor,
      backgroundColor: ThemeHelper.getInstance()?.primaryColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
    );

    return ElevatedButton(
        style: raisedButtonStyle,
        onPressed: () async {
          selectedAcc = _getDisbursedAccRes?.data?[index];
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            LoaderUtils.showLoaderwithmsg(context,
                msg:
                    "Please wait while we set the disbursement account detail");
          });
          if (await TGNetUtil.isInternetAvailable()) {
            setDisbursedAcc();
          } else {
            showSnackBarForintenetConnection(context, setDisbursedAcc);
          }
        },
        child: Center(
          child: Text(
            str_proceed,
            style: ThemeHelper.getInstance()?.textTheme.button?.copyWith(
                fontFamily: MyFont.Nunito_Sans_Regular, fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
        ));
  }

  // void showAddAccDialog()
  // {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setModelState) {
  //             return AlertDialog(
  //               insetPadding: EdgeInsets.zero,
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.all(Radius.circular(30.0.r))),
  //               content: addAccountNumberUI(setModelState),
  //             );});
  //     },
  //   );
  //
  // }
  // Widget addAccountNumberUI(StateSetter setModelState)
  // {
  //   return SizedBox(
  //     height: 250.h,
  //     width: 300.w,
  //     child: Padding(
  //         padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 10.w),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text('Loan Deposit A/c',style: ThemeHelper.getInstance()?.textTheme.headline1,textAlign: TextAlign.start,),
  //             SizedBox(height: 15.h,),
  //             TextFormField(
  //             controller: accountNumber,
  //             onChanged: (content) {
  //               isValidAccNo(setModelState);
  //             },
  //             decoration: const InputDecoration(
  //                 border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.all(Radius.circular(12))),
  //                 counterText: '',hintText: 'Enter Your Loan Deposit A/c number'),
  //             keyboardType: TextInputType.number,
  //             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //             maxLines: 1,
  //             validator: (value) {
  //               if (!isValidAccount) {
  //
  //               }
  //               return null;
  //             }),
  //
  //
  //             SizedBox(height: 15.h,),
  //         SizedBox(
  //         width: MediaQuery
  //         .of(context)
  //         .size
  //         .width,
  //     height: 50.h,
  //     child:isLoaderStart ? JumpingDots(color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary, radius: 10,) : ElevatedButton(
  //         style: isValidAccount
  //             ? ThemeHelper.getInstance()!.elevatedButtonTheme.style
  //             : ThemeHelper.setPinkDisableButtonBig(),
  //         onPressed: () {
  //           if(isValidAccount)
  //           {
  //             Navigator.pop(context);
  //             accountNumber.text = '';
  //             setState(() {
  //               isLoaderStart = true;
  //               setDisbursedAcc();
  //             });
  //           }
  //           else
  //           {
  //             Navigator.pop(context);
  //             accountNumber.text = '';
  //             TGView.showSnackBar(context: context, message: "Please enter valid account number");
  //           }
  //         },
  //         child: Center(child: Text(str_agree, style: ThemeHelper
  //             .getInstance()
  //             ?.textTheme
  //             .button,),)),
  //   )
  //           ],
  //         ),
  //     ),
  //   );
  // }

  void isValidAccNo(StateSetter setModelState) {
    if (accountNumber.text.isNotEmpty &&
        selectedAcc?.data?.accountNumber?.isNotEmpty == true) {
      if (accountNumber.text.substring(accountNumber.text.length - 4) ==
          selectedAcc?.data?.accountNumber
              ?.substring(selectedAcc!.data!.accountNumber!.length - 4)) {
        setModelState(() {
          isValidAccount = true;
        });
      } else {
        setModelState(() {
          isValidAccount = false;
        });
      }
    } else {
      setModelState(() {
        isValidAccount = false;
      });
    }
  }

  void showCircularProgress() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: ThemeHelper.getInstance()?.colorScheme.primary,
              strokeWidth: 3.w,
              color: ThemeHelper.getInstance()?.colorScheme.primary,
            ),
          );
        });
  }


  Future<void> getDisbursedAccList() async {
    String loanAppRefId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String offerId = await TGSharedPreferences.getInstance().get(PREF_OFFERID);
    GetDisbursedAccRequest getDisbursedAccRequest = GetDisbursedAccRequest(
      loanApplicationRefId: loanAppRefId,
      offerId: offerId,
    );
    var jsonReq = jsonEncode(getDisbursedAccRequest.toJson());
    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, URI_GET_DISBURSED_ACC_LIST);
    ServiceManager.getInstance().getLoanDisbursedAcc(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetDisbursedAcc(response),
        onError: (error) => _onErrorGetDisbursedAcc(error));
  }

  _onSuccessGetDisbursedAcc(GetDisbursedAccResponse? response) {
    TGLog.d("GetDisbursedAccListResponse : onSuccess()");
    if (response?.getDisbursedAccResObj()?.status == RES_DETAILS_FOUND) {
      setState(() {
        var jsonString = jsonEncode(response?.getDisbursedAccResObj());
        TGLog.d(jsonString);
        _getDisbursedAccRes = response?.getDisbursedAccResObj();
        isListLoaded = true;
      });
    } else if (response?.getDisbursedAccResObj()?.status ==
        RES_DETAILS_NOT_FOUND) {
      Future.delayed(Duration(seconds: 5), () {
        getDisbursedAccListApi();
      });
    } else {
      LoaderUtils.handleErrorResponse(
          context,
          response?.getDisbursedAccResObj()?.status,
          response?.getDisbursedAccResObj()?.message,
          null);
    }
  }

  _onErrorGetDisbursedAcc(TGResponse errorResponse) {
    TGLog.d("GetDisbursedAccListResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> setDisbursedAcc() async {
    String loanAppRefId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String offerId = await TGSharedPreferences.getInstance().get(PREF_OFFERID);
    String loanAppId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
    SetDisbursedAccRequest setDisbursedAccRequest = SetDisbursedAccRequest(
        loanApplicationRefId: loanAppRefId,
        offerId: offerId,
        loanApplicationId: loanAppId,
        accountNumber: selectedAcc?.data?.accountNumber,
        accountId: selectedAcc?.id);
    var jsonReq = jsonEncode(setDisbursedAccRequest.toJson());
    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, URI_SET_DISBURSED_ACC);
    ServiceManager.getInstance().setLoanDisbursedAcc(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessSetDisbursedAcc(response),
        onError: (error) => _onErrorSetDisbursedAcc(error));
  }

  _onSuccessSetDisbursedAcc(SetDisbursedAccResponse? response) {
    TGLog.d("SetDisbursementResponse : onSuccess()");

    if (response?.getSetDisbAccObj()?.status == RES_SUCCESS) {
      _setDisbursedAccRes = response?.getSetDisbAccObj();
      getLoanAppStatusAfterSetDisbAccApiCall();
    } else {
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(
          context,
          response?.getSetDisbAccObj().status,
          response?.getSetDisbAccObj().message,
          null);
    }
  }

  _onErrorSetDisbursedAcc(TGResponse errorResponse) {
    TGLog.d("SetDisbursementResponse : onError()");
    Navigator.pop(context);
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> getLoanAppStatusAfterSetDisburseAcc() async {
    String loanAppRefId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    GetLoanStatusRequest getLoanStatusRequest =
        GetLoanStatusRequest(loanApplicationRefId: loanAppRefId);
    var jsonReq = jsonEncode(getLoanStatusRequest.toJson());
    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, Utils.getManageLoanAppStatusParam('5'));
    ServiceManager.getInstance().getLoanAppStatus(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetLoanAppStatus(response),
        onError: (error) => _onErrorGetLoanAppStatus(error));
  }

  _onSuccessGetLoanAppStatus(GetLoanStatusResponse? response) {
    TGLog.d("LoanAppStatusResponse : onSuccess()");
    _getLoanStatusRes = response?.getLoanStatusResObj();
    if (_getLoanStatusRes?.status == RES_SUCCESS) {
      if (_getLoanStatusRes?.data?.stageStatus == "PROCEED") {
        Navigator.pop(context);
        MoveStage.navigateNextStage(
            context, _getLoanStatusRes?.data?.currentStage);
      } else if (_getLoanStatusRes?.data?.stageStatus == "HOLD") {
        Future.delayed(const Duration(seconds: 10), () {
          getLoanAppStatusAfterSetDisbAccApiCall();
        });
      } else {
        getLoanAppStatusAfterSetDisbAccApiCall();
      }
    } else {
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(
          context,
          response?.getLoanStatusResObj().status,
          response?.getLoanStatusResObj().message,
          response?.getLoanStatusResObj().data?.stageStatus);
    }
  }

  _onErrorGetLoanAppStatus(TGResponse errorResponse) {
    TGLog.d("LoanAppStatusResponse : onError()");
    Navigator.pop(context);
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> getLoanAppStatusAfterSetDisbAccApiCall() async {
    if (await TGNetUtil.isInternetAvailable()) {
      getLoanAppStatusAfterSetDisburseAcc();
    } else {
      showSnackBarForintenetConnection(
          context, getLoanAppStatusAfterSetDisburseAcc);
    }
  }
}
