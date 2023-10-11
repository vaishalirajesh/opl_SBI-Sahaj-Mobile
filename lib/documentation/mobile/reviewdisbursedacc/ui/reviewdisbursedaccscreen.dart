import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
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
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/constants/imageconstant.dart';
import 'package:sbi_sahay_1_0/utils/erros_handle.dart';
import 'package:sbi_sahay_1_0/utils/helpers/myfonts.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';

import '../../../../loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import '../../../../utils/colorutils/hexcolor.dart';
import '../../../../utils/colorutils/mycolors.dart';
import '../../../../utils/constants/prefrenceconstants.dart';
import '../../../../utils/constants/statusConstants.dart';
import '../../../../utils/helpers/themhelper.dart';
import '../../../../utils/internetcheckdialog.dart';
import '../../../../utils/jumpingdott.dart';
import '../../../../utils/movestageutils.dart';
import '../../../../utils/progressLoader.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_drawer.dart';

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
  GetLoanStatusResMain? _getLoanStatusRes;
  ShareGstInvoiceResMain? _setDisbursedAccRes;
  bool isListLoaded = false;
  bool isValidAccount = false;
  TextEditingController accountNumber = TextEditingController();

  var accountcontroller = TextEditingController();
  bool isSettingAccount = false;

  bool isValidAccountNumber = false;

  var ISFCCodeController = TextEditingController();

  bool isValidISFCCode = false;

  //bool isLoaderStart = false;

  @override
  void initState() {
    getDisbursedAccListApi();
    super.initState();
  }

  Future<void> getDisbursedAccListApi() async {
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget bodyScaffold(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      appBar: getAppBarWithStepDone(
        '3',
        str_documentation,
        0.75,
        onClickAction: () => {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => DashboardWithGST(),
            ),
            (route) => false, //if you want to disable back feature set to false
          )
        },
      ),
      body: Column(
        children: [
          Container(
            height: 70,
            width: 1.sw,
            color: MyColors.lightSKYColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SvgPicture.asset(
                          AppUtils.path(SBILOGOWITHTEXT),
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      "State Bank of India",
                      style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600),
                    )
                  ],
                )
              ],
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    str_review_loan_deposite_acc,
                    style: ThemeHelper.getInstance()?.textTheme.headline6?.copyWith(fontSize: 20.sp, color: MyColors.darkblack),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(AppUtils.path(GREENCONFORMTICK), height: 20, width: 20),
                      SizedBox(
                        width: 5.w,
                      ),
                      Flexible(
                          child: Text(
                        str_review_acc_txt_one,
                        style: ThemeHelper.getInstance()?.textTheme.headline3!.copyWith(color: MyColors.darkblack),
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
                      SvgPicture.asset(AppUtils.path(GREENCONFORMTICK), height: 20, width: 20),
                      SizedBox(
                        width: 5.w,
                      ),
                      Flexible(
                          child: Text(
                        str_review_acc_txt_two,
                        style: ThemeHelper.getInstance()?.textTheme.headline3!.copyWith(color: MyColors.darkblack),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Account',
                      style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(fontSize: 12.sp, color: MyColors.lightGraySmallText),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  isListLoaded
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            loandepositAccountCard(context),
                          ],
                        )
                      : JumpingDots(
                          color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary,
                          radius: 10,
                        ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter Current Account Number',
                          style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(fontSize: 12.sp, color: MyColors.lightGraySmallText),
                        ),
                        SizedBox(width: 10),
                        TextFormField(
                          cursorColor: Colors.grey,
                          controller: accountcontroller,
                          decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: MyColors.lightGreyDividerColor)),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: MyColors.lightGreyDividerColor))),
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(fontSize: 15.sp),
                          onChanged: (content) {
                            if (selected.data!.accountNumber!.lastChars(4) == content.lastChars(4)) {
                              isValidAccountNumber = true;
                              setState(() {});
                            } else {
                              isValidAccountNumber = false;
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'IFSC',
                          style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(fontSize: 12.sp, color: MyColors.lightGraySmallText),
                        ),
                        SizedBox(width: 10),
                        EnterISFCCode(context),
                      ],
                    ),
                  )
                  //Container()
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(height: 70, width: 1.sh - 100, child: buildBtnNextAcc(context)),
    );
  }

  Widget buildBtnNextAcc(BuildContext context) {
    return isSettingAccount
        ? JumpingDots(
            color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary,
            radius: 10,
          )
        : Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: AppButton(
              onPress: () {
                LoaderUtils.showLoaderwithmsg(context, msg: "Processing");
                setDisbursedAcc();
              },
              title: str_proceed,
              isButtonEnable: isValidAccountNumber && isValidISFCCode,
            ),
          );
  }

  GetDisbursedAccObj selected = GetDisbursedAccObj();

  Widget loandepositAccountCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: HexColor("#F1EBFA"),
      ),
      child: (isListLoaded)
          ? DropdownButtonHideUnderline(
              child: DropdownButton2<GetDisbursedAccObj>(
                isExpanded: false,
                value: selected,
                items: _getDisbursedAccRes!.data!
                    .map((GetDisbursedAccObj item) => DropdownMenuItem<GetDisbursedAccObj>(
                          value: item,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Current A/C",
                                    style: TextStyle(fontSize: 12, color: MyColors.darkblack),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    item?.data?.accountIFSC ?? "",
                                    style: ThemeHelper.getInstance()?.textTheme.bodyText1?.copyWith(fontSize: 12, color: MyColors.darkblack),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 100,
                              ),
                              Text(
                                item?.data?.accountNumber ?? "",
                                style: ThemeHelper.getInstance()?.textTheme.bodyText1?.copyWith(fontSize: 12, color: MyColors.darkblack),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (c) {
                  selected = c!;
                  setState(() {});
                },
                menuItemStyleData: MenuItemStyleData(
                  height: 50,
                ),
              ),
            )
          : Container(),
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
          bottomRight: Radius.circular(10),
        ),
      ),
    );

    return ElevatedButton(
        style: raisedButtonStyle,
        onPressed: () async {
          selected = _getDisbursedAccRes!.data![index]!;
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            LoaderUtils.showLoaderwithmsg(context, msg: "Please wait while we set the disbursement account detail");
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
            style: ThemeHelper.getInstance()?.textTheme.button?.copyWith(fontFamily: MyFont.Nunito_Sans_Regular, fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
        ));
  }

  void isValidAccNo(StateSetter setModelState) {
    if (accountNumber.text.isNotEmpty && selected?.data?.accountNumber?.isNotEmpty == true) {
      if (accountNumber.text.substring(accountNumber.text.length - 4) == selected?.data?.accountNumber?.substring(selected!.data!.accountNumber!.length - 4)) {
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
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String offerId = await TGSharedPreferences.getInstance().get(PREF_OFFERID);
    GetDisbursedAccRequest getDisbursedAccRequest = GetDisbursedAccRequest(
      loanApplicationRefId: loanAppRefId,
      offerId: offerId,
    );
    var jsonReq = jsonEncode(getDisbursedAccRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_GET_DISBURSED_ACC_LIST);
    ServiceManager.getInstance().getLoanDisbursedAcc(request: tgPostRequest, onSuccess: (response) => _onSuccessGetDisbursedAcc(response), onError: (error) => _onErrorGetDisbursedAcc(error));
  }

  _onSuccessGetDisbursedAcc(GetDisbursedAccResponse? response) {
    TGLog.d("GetDisbursedAccListResponse : onSuccess()");
    if (response?.getDisbursedAccResObj()?.status == RES_DETAILS_FOUND) {
      setState(() {
        var jsonString = jsonEncode(response?.getDisbursedAccResObj());
        TGLog.d(jsonString);
        _getDisbursedAccRes = response?.getDisbursedAccResObj();
        selected = _getDisbursedAccRes!.data!.first;
        isListLoaded = true;
      });
    } else if (response?.getDisbursedAccResObj()?.status == RES_DETAILS_NOT_FOUND) {
      Future.delayed(Duration(seconds: 5), () {
        getDisbursedAccListApi();
      });
    } else {
      LoaderUtils.handleErrorResponse(context, response?.getDisbursedAccResObj()?.status, response?.getDisbursedAccResObj()?.message, null);
    }
  }

  _onErrorGetDisbursedAcc(TGResponse errorResponse) {
    TGLog.d("GetDisbursedAccListResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> setDisbursedAcc() async {
    isSettingAccount = true;
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String offerId = await TGSharedPreferences.getInstance().get(PREF_OFFERID);
    String loanAppId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
    SetDisbursedAccRequest setDisbursedAccRequest = SetDisbursedAccRequest(loanApplicationRefId: loanAppRefId, offerId: offerId, loanApplicationId: loanAppId, accountNumber: selected?.data?.accountNumber, accountId: selected?.id);
    var jsonReq = jsonEncode(setDisbursedAccRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_SET_DISBURSED_ACC);
    ServiceManager.getInstance().setLoanDisbursedAcc(request: tgPostRequest, onSuccess: (response) => _onSuccessSetDisbursedAcc(response), onError: (error) => _onErrorSetDisbursedAcc(error));
  }

  _onSuccessSetDisbursedAcc(SetDisbursedAccResponse? response) {
    TGLog.d("SetDisbursementResponse : onSuccess()");
    if (response?.getSetDisbAccObj()?.status == RES_SUCCESS) {
      _setDisbursedAccRes = response?.getSetDisbAccObj();
      getLoanAppStatusAfterSetDisbAccApiCall();
    } else {
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(context, response?.getSetDisbAccObj().status, response?.getSetDisbAccObj().message, null);
    }
  }

  _onErrorSetDisbursedAcc(TGResponse errorResponse) {
    setState(() {
      isSettingAccount = false;
    });
    TGLog.d("SetDisbursementResponse : onError()");
    Navigator.pop(context);
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> getLoanAppStatusAfterSetDisburseAcc() async {
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    GetLoanStatusRequest getLoanStatusRequest = GetLoanStatusRequest(loanApplicationRefId: loanAppRefId);
    var jsonReq = jsonEncode(getLoanStatusRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, AppUtils.getManageLoanAppStatusParam('5'));
    ServiceManager.getInstance().getLoanAppStatus(request: tgPostRequest, onSuccess: (response) => _onSuccessGetLoanAppStatus(response), onError: (error) => _onErrorGetLoanAppStatus(error));
  }

  _onSuccessGetLoanAppStatus(GetLoanStatusResponse? response) {
    TGLog.d("LoanAppStatusResponse : onSuccess()");
    _getLoanStatusRes = response?.getLoanStatusResObj();
    if (_getLoanStatusRes?.status == RES_SUCCESS) {
      if (_getLoanStatusRes?.data?.stageStatus == "PROCEED") {
        Navigator.pop(context);
        MoveStage.navigateNextStage(context, _getLoanStatusRes?.data?.currentStage);
      } else if (_getLoanStatusRes?.data?.stageStatus == "HOLD") {
        Future.delayed(const Duration(seconds: 10), () {
          getLoanAppStatusAfterSetDisbAccApiCall();
        });
      } else {
        getLoanAppStatusAfterSetDisbAccApiCall();
      }
    } else {
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(context, response?.getLoanStatusResObj().status, response?.getLoanStatusResObj().message, response?.getLoanStatusResObj().data?.stageStatus);
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
      showSnackBarForintenetConnection(context, getLoanAppStatusAfterSetDisburseAcc);
    }
  }

  Widget EnterISFCCode(BuildContext context) {
    return Container(
        height: 70,
        child: TextFormField(
          controller: ISFCCodeController,
          onChanged: (content) {
            if (selected.data!.accountIFSC!.lastChars(4) == content.lastChars(4)) {
              isValidISFCCode = true;
              setState(() {});
            } else {
              isValidISFCCode = false;
              setState(() {});
            }
          },
          decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: MyColors.lightGreyDividerColor)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: MyColors.lightGreyDividerColor))),
          keyboardType: TextInputType.text,
          maxLines: 1,
          style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(fontSize: 15.sp),
        ));
  }
}

extension E on String {
  String lastChars(int n) => substring(length - n);
}
