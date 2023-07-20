import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_aa_list_response_main.dart';
import 'package:gstmobileservices/model/models/get_disbursed_acc_res_main.dart';
import 'package:gstmobileservices/model/models/get_loan_app_status_main.dart';
import 'package:gstmobileservices/model/requestmodel/get_loan_app_status_request.dart';
import 'package:gstmobileservices/model/requestmodel/set_disbursed_acc_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_loan_app_status_response.dart';
import 'package:gstmobileservices/model/responsemodel/set_disbursed_acc_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/erros_handle_util.dart';
import 'package:gstmobileservices/util/jumpingdot_util.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:sbi_sahay_1_0/documentation/mobile/loanagreement/ui/loanageementscreen.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusConstants.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/internetcheckdialog.dart';
import 'package:sbi_sahay_1_0/utils/progressLoader.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';
import 'package:sbi_sahay_1_0/widgets/app_drawer.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/constants/prefrenceconstants.dart';
import '../../../../utils/strings/strings.dart';
import '../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';

class LoanDepositeAcc extends StatelessWidget {
  const LoanDepositeAcc({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return const SafeArea(child: LoanDepositeAccView());
    });
  }
}

class LoanDepositeAccView extends StatefulWidget {
  const LoanDepositeAccView({Key? key}) : super(key: key);

  @override
  State<LoanDepositeAccView> createState() => _LoanDepositeAccViewState();
}

class _LoanDepositeAccViewState extends State<LoanDepositeAccView> {
  TextEditingController accNuumberController = TextEditingController(text: '');
  TextEditingController ifscNoController = TextEditingController(text: '');
  bool _autoValidate = true;
  int typeListlen = 0;
  late List<GetAAListObj> typeListDetails;
  bool isAANextClick = false;
  int listLength = 3;
  String isCheckedGroup = 'BankGroupName';
  GetDisbursedAccResMain? _getDisbursedAccRes;
  GetDisbursedAccObj? _selectedAcc;
  GetLoanStatusResMain? _getLoanStatusRes;

  //List<int> isCheckedList = [];
  int selectedValue = -1;

  bool isDataSet = false;
  bool isValidIFSCCode = false;
  bool isValidAccountNo = false;

  @override
  void initState() {
    super.initState();
  }

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
        drawer: const AppDrawer(),
        appBar: getAppBarWithStepDone("2", str_documentation, 0.50,
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
          absorbing: isDataSet,
          child: buildMainScreen(context),
        ),
        bottomNavigationBar: SizedBox(
          height: 0.15.sh,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
              child: buildBtnNextAcc(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMainScreen(BuildContext context) {
    return SingleChildScrollView(
      primary: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          buildBankName(),
          SizedBox(
            height: 24.h,
          ),
          buildMainScreenContent(),
        ],
      ),
    );
  }

  Widget buildBankName() {
    return Container(
      color: ThemeHelper.getInstance()!.colorScheme.secondaryContainer,
      height: 81.h,
      child: Padding(
        padding: EdgeInsets.only(left: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(color: ThemeHelper.getInstance()!.backgroundColor, shape: BoxShape.circle),
              width: 40.w,
              height: 40.h,
              child: Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppUtils.path(SMALLBANKLOGO),
                  height: 15.h,
                  width: 15.h,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              strSBI,
              style: ThemeHelper.getInstance()!.textTheme.headline1!.copyWith(
                    fontSize: 14.sp,
                    color: MyColors.black,
                  ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMainScreenContent() {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(
                "Select Loan Deposit A/c",
                style: ThemeHelper.getInstance()!.textTheme.headline2!.copyWith(color: MyColors.darkblack),
                textAlign: TextAlign.start,
              ),
            ]),
            SizedBox(height: 20.h),
            buildRowWidget(
                "Enter the complete current account number, which was fetched through Account Aggregator. The loan would be disbursed in this account."),
            SizedBox(height: 15.h),
            buildRowWidget("Please note the same account will be used for creating E-Mandate to auto-debit repayment."),
            SizedBox(
              height: 30.h,
            ),
            EnterAcc(),
            SizedBox(
              height: 16.h,
            ),
            iFSCcodeText()
          ],
        ),
      ),
    );
  }

  Widget EnterAcc() {
    return TextFormField(
        style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(color: MyColors.pnbTextcolor),
        onChanged: (content) {
          _checkValidAccountNo();
        },
        controller: accNuumberController,
        cursorColor: Colors.white,
        decoration: InputDecoration(
            labelStyle: TextStyle(color: MyColors.verylightGrayColor),
            labelText: str_enter_acc_no,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            floatingLabelStyle: ThemeHelper.getInstance()?.textTheme.bodyText2,
            enabledBorder: UnderlineInputBorder(
              //borderRadius: BorderRadius.all(Radius.circular(6.r)),
              borderSide: BorderSide(width: 1, color: ThemeHelper.getInstance()!.colorScheme.onSurface),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ThemeHelper.getInstance()!.colorScheme.onSurface, width: 1.0),
              // borderRadius: BorderRadius.circular(6.0.r),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: ThemeHelper.getInstance()!.colorScheme.onSurface),
              //borderRadius: BorderRadius.all(Radius.circular(6.r))
            ),
            counterText: ''),
        keyboardType: TextInputType.text,
        maxLength: 15,
        inputFormatters: [
          UpperCaseTextFormatter(),
          // FilteringTextInputFormatter.allow(RegExp("^[0-9]{9,18}\$")),
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter User name';
          }
          return null;
        });
  }

  Widget iFSCcodeText() {
    return TextFormField(
        style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(color: MyColors.pnbTextcolor),
        onChanged: (content) {
          _checkValidIFSCCode();
        },
        inputFormatters: [
          UpperCaseTextFormatter(),
          // FilteringTextInputFormatter.allow(RegExp("^[A-Za-z]{4}\d{7}\$")),
        ],
        autofocus: _autoValidate,
        controller: ifscNoController,
        cursorColor: Colors.white,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            floatingLabelStyle: ThemeHelper.getInstance()?.textTheme.bodyText2,
            labelText: str_IFSC_Code,
            // hintText: "SBIN0003471",
            labelStyle: TextStyle(color: MyColors.verylightGrayColor),
            //str_IFSC_Code,
            enabledBorder: UnderlineInputBorder(
              // borderRadius: BorderRadius.all(Radius.circular(6.r)),
              borderSide: BorderSide(width: 1, color: ThemeHelper.getInstance()!.colorScheme.onSurface),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ThemeHelper.getInstance()!.colorScheme.onSurface, width: 1.0),
              // borderRadius: BorderRadius.circular(6.0.r),
            ),
            // focusColor: ThemeHelper.getInstance()!.colorScheme.onSurface,
            // fillColor: ThemeHelper.getInstance()!.colorScheme.onSurface,
            border: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: ThemeHelper.getInstance()!.colorScheme.onSurface),
              //borderRadius: BorderRadius.all(Radius.circular(6.r))
            ),
            counterText: ''),
        keyboardType: TextInputType.text,
        maxLength: 11,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter valid IFSC code';
          }
          return null;
        });
  }

  void _checkValidIFSCCode() {
    setState(() {
      if (ifscNoController.text.isNotEmpty) {
        isValidIFSCCode = true;
      } else {
        isValidIFSCCode = false;
      }
    });
  }

  void _checkValidAccountNo() {
    setState(() {
      if (accNuumberController.text.isNotEmpty) {
        isValidAccountNo = true;
      } else {
        isValidAccountNo = false;
      }
    });
  }

  Widget buildRowWidget(String text) => Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(AppUtils.path(IMG_GREENTICK_AA), height: 18.r, width: 18.r),
            SizedBox(width: 8.w),
            Expanded(
                child: Text(
              " $text",
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline3!
                  .copyWith(color: MyColors.lightGraySmallText, fontSize: 14.sp),
              maxLines: 4,
            )),
          ],
        ),
      );

  Widget buildBtnNextAcc(BuildContext context) {
    return isDataSet
        ? JumpingDots(
            color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary,
            radius: 10,
          )
        : AppButton(
            onPress: onPressProceedButton,
            title: str_proceed,
            isButtonEnable: isValidIFSCCode && isValidAccountNo,
          );
  }

  void onPressProceedButton() async {
    if (isValidIFSCCode && isValidAccountNo) {
      _selectedAcc = _getDisbursedAccRes?.data?[0];
      setState(() {
        isDataSet = true;
      });
      if (await TGNetUtil.isInternetAvailable()) {
        _setDisbursedAcc();
      } else {
        if (context.mounted) {
          showSnackBarForintenetConnection(context, _setDisbursedAcc);
        }
      }
    }
  }

  Future<void> _setDisbursedAcc() async {
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String offerId = await TGSharedPreferences.getInstance().get(PREF_OFFERID);
    String loanAppId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);
    SetDisbursedAccRequest setDisbursedAccRequest = SetDisbursedAccRequest(
      loanApplicationRefId: loanAppRefId,
      offerId: offerId,
      loanApplicationId: loanAppId,
      accountNumber: accNuumberController.text != '' ? '9846789878' : accNuumberController.text,
      accountId: ifscNoController.text != '' ? '32323' : ifscNoController.text,
    );
    var jsonReq = jsonEncode(setDisbursedAccRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_SET_DISBURSED_ACC);
    ServiceManager.getInstance().setLoanDisbursedAcc(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessSetDisbursedAcc(response),
        onError: (error) => _onErrorSetDisbursedAcc(error));
  }

  _onSuccessSetDisbursedAcc(SetDisbursedAccResponse? response) {
    TGLog.d("SetDisbursementResponse : onSuccess()");

    if (response?.getSetDisbAccObj().status == RES_SUCCESS) {
      _getLoanAppStatusAfterSetDisbAccApiCall();
    } else {
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(
          context, response?.getSetDisbAccObj().status, response?.getSetDisbAccObj().message, null);
    }
  }

  _onErrorSetDisbursedAcc(TGResponse errorResponse) {
    TGLog.d("SetDisbursementResponse : onError()");
    Navigator.pop(context);
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> _getLoanAppStatusAfterSetDisbAccApiCall() async {
    if (await TGNetUtil.isInternetAvailable()) {
      _getLoanAppStatusAfterSetDisburseAcc();
    } else {
      if (context.mounted) {
        showSnackBarForintenetConnection(context, _getLoanAppStatusAfterSetDisburseAcc);
      }
    }
  }

  Future<void> _getLoanAppStatusAfterSetDisburseAcc() async {
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    GetLoanStatusRequest getLoanStatusRequest = GetLoanStatusRequest(loanApplicationRefId: loanAppRefId);
    var jsonReq = jsonEncode(getLoanStatusRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, AppUtils.getManageLoanAppStatusParam('5'));
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
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoanAgreementMain(),
          ),
          (route) => false, //
        );
      } else if (_getLoanStatusRes?.data?.stageStatus == "HOLD") {
        Future.delayed(const Duration(seconds: 10), () {
          _getLoanAppStatusAfterSetDisbAccApiCall();
        });
      } else {
        _getLoanAppStatusAfterSetDisbAccApiCall();
      }
    } else {
      LoaderUtils.handleErrorResponse(context, response?.getLoanStatusResObj().status,
          response?.getLoanStatusResObj().message, response?.getLoanStatusResObj().data?.stageStatus);
    }
    setState(() {
      isDataSet = false;
    });
  }

  _onErrorGetLoanAppStatus(TGResponse errorResponse) {
    TGLog.d("LoanAppStatusResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
    setState(() {
      isDataSet = false;
    });
  }
}
