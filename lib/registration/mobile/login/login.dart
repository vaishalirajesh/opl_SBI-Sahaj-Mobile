import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/common/app_functions.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_gst_basic_details_res_main.dart';
import 'package:gstmobileservices/model/models/get_loandetail_by_refid_res_main.dart';
import 'package:gstmobileservices/model/models/get_otp_main.dart';
import 'package:gstmobileservices/model/models/verify_otp_response_main.dart';
import 'package:gstmobileservices/model/requestmodel/autologin_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_all_loan_detail_by_refid_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_gst_basic_details_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_otp_request.dart';
import 'package:gstmobileservices/model/requestmodel/save_consent_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_all_loan_detail_by_refid_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_gst_basic_details_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_otp_response.dart';
import 'package:gstmobileservices/model/responsemodel/save_consent_response.dart';
import 'package:gstmobileservices/model/responsemodel/verify_otp_response.dart';
import 'package:gstmobileservices/service/request/tg_get_request.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_session.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/erros_handle_util.dart';
import 'package:gstmobileservices/util/tg_flavor.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:gstmobileservices/util/tg_util.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import 'package:sbi_sahay_1_0/registration/mobile/gst_consent_of_gst/gst_consent_of_gst.dart';
import 'package:sbi_sahay_1_0/routes.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/constants/session_keys.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusConstants.dart';
import 'package:sbi_sahay_1_0/utils/internetcheckdialog.dart';
import 'package:sbi_sahay_1_0/utils/progressLoader.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/helpers/myfonts.dart';
import '../../../utils/helpers/themhelper.dart';
import '../../../utils/jumpingdott.dart';
import '../../../utils/strings/strings.dart';

class LoginWithMobileNumber extends StatelessWidget {
  const LoginWithMobileNumber({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return const SafeArea(child: LoginWithMobileNumberScreen());
      },
    );
  }
}

class LoginWithMobileNumberScreen extends StatefulWidget {
  const LoginWithMobileNumberScreen({super.key});

  @override
  LoignWithMobileState createState() => LoignWithMobileState();
}

class LoignWithMobileState extends State<LoginWithMobileNumberScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isCheckedFirst = false;
  int maxLength = 10;
  GetOtpResponseMain? getOtpRes;
  VerifyOtpMain? verifyOtpResponse;
  GetGstBasicdetailsResMain? _basicdetailsResponse;
  GetAllLoanDetailByRefIdResMain? _getAllLoanDetailRes;

  TextEditingController mobileTextController = TextEditingController();

  List<String> buttonList = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '/'];

  int counter = 0;
  bool isValidOTP = false;
  String otp = '';
  bool isClearOtp = false;
  bool _isGetOTPLoaderStart = false;

  String text = "";
  String uuid = Uuid().v1().replaceAll("-", "").substring(0, 16);

  onPressed(String text) {
    if (counter <= maxLength - 1 && text != '/') {
      counter++;
      mobileTextController.text = mobileTextController.text + text;
    } else if (counter > 0 && text == '/') {
      if (mobileTextController.text != null && counter > 0) {
        mobileTextController.text = mobileTextController.text.substring(0, counter - 1);
        counter--;
      }
    } else {
      var temp = text;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return loginContent();
  }

  Widget loginContent() {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        SystemNavigator.pop(animated: true);
        return true;
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: getAppBarWithStepDone('1', str_registration, 0.25,
            onClickAction: () => {Navigator.pop(context, false), SystemNavigator.pop(animated: true)}),
        body: AbsorbPointer(
          absorbing: _isGetOTPLoaderStart,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Padding(
                        padding: EdgeInsets.only(top: 30.0.h, bottom: 9.h),
                        child: Text(
                          str_Enter_your_mobile_Details,
                          style: ThemeHelper.getInstance()!.textTheme.headline2,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 20.0.h,
                        ),
                        child: Text(
                          str_we_will_send_you_otp_for_confirmation,
                          style: ThemeHelper.getInstance()!.textTheme.headline3?.copyWith(fontSize: 14.sp),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              //  viewModel.display();
                            },
                            child: TextFormField(
                                readOnly: true,
                                maxLength: 5,
                                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                controller: mobileTextController,
                                style:
                                    ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(color: MyColors.darkblack),
                                onChanged: (String newVal) {
                                  setState(() {
                                    if (newVal.length <= maxLength) {
                                      text = newVal;
                                    } else {
                                      mobileTextController.text = text;
                                    }
                                  });
                                },
                                cursorColor: ThemeHelper.getInstance()!.colorScheme.onSurface,
                                decoration: InputDecoration(
                                    labelText: "Enter your Mobile Number",
                                    labelStyle: ThemeHelper.getInstance()!
                                        .textTheme
                                        .headline3!
                                        .copyWith(color: MyColors.verylightGrayColor),
                                    contentPadding: EdgeInsets.only(top: 5.h),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(width: 1, color: ThemeHelper.getInstance()!.colorScheme.onSurface),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ThemeHelper.getInstance()!.colorScheme.onSurface, width: 1.0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(width: 1, color: ThemeHelper.getInstance()!.colorScheme.onSurface),
                                    ),
                                    counterText: ''),
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Mobile Number';
                                  }
                                  return null;
                                }),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          keyboardColumn(),
                        ],
                      ),
                    ])),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.h, left: 10.w, right: 20.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 40.h,
                              width: 40.w,
                              child: Theme(
                                data: ThemeData(useMaterial3: true),
                                child: Checkbox(
                                  // checkColor: MyColors.colorAccent,
                                  activeColor: ThemeHelper.getInstance()?.primaryColor,
                                  value: isCheckedFirst,
                                  onChanged: (isCheck) {
                                    setState(() {
                                      isCheckedFirst = isCheck!;
                                    });
                                  },
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(2),
                                    ),
                                  ),
                                  side: BorderSide(
                                      width: 1,
                                      color: isCheckedFirst
                                          ? ThemeHelper.getInstance()!.primaryColor
                                          : ThemeHelper.getInstance()!.primaryColor),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 10.h,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    isCheckedFirst = !isCheckedFirst;
                                    setState(() {});
                                  },
                                  child: Text.rich(
                                    TextSpan(
                                      text: str_i_login_check_part1,
                                      style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(
                                            fontSize: 14.sp,
                                          ),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: str_i_login_checkpart2,
                                          style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(
                                                fontSize: 14.sp,
                                                color: MyColors.hyperlinkcolornew,
                                              ),
                                        ),
                                        TextSpan(
                                          text: str_i_login_checkpart3,
                                          style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(
                                                fontSize: 14.sp,
                                              ),
                                        ),
                                        TextSpan(
                                          text: str_i_login_checkpart4,
                                          style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(
                                                fontSize: 14.sp,
                                                color: MyColors.hyperlinkcolornew,
                                              ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20.h, top: 20.h, left: 10.w),
                          child: _isGetOTPLoaderStart
                              ? JumpingDots(
                                  color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary,
                                  radius: 10,
                                )
                              : AppButton(
                                  onPress: onPressNextButton,
                                  title: str_next,
                                  isButtonEnable: isCheckedFirst && mobileTextController.text.length == 10,
                                ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onPressNextButton() async {
    if (isCheckedFirst && mobileTextController.text.length == 10) {
      setState(() {
        _isGetOTPLoaderStart = true;
      });
      if (await TGNetUtil.isInternetAvailable()) {
        _autoLoginRequest();
      } else {
        if (context.mounted) {
          showSnackBarForintenetConnection(context, getLoginOtp);
        }
      }
    }
  }

  Future<void> onUpdateTAndCChecked() async {
    RequestSaveConsent requestSaveConsent = RequestSaveConsent(
      appVersion: "1.0",
      consentApprovalType: CONSENT_TYPE_T_AND_C,
      isConsentApproval: true,
      mobileFcmToken: "",
      device: '',
      deviceId: uuid,
      deviceOs: '',
      deviceOsVersion: '',
      deviceType: '',
    );
    var jsonRequest = jsonEncode(requestSaveConsent.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonRequest, URI_CONSENT_APPROVAL);
    ServiceManager.getInstance().saveConsent(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessSaveConsent(response),
        onError: (errorResponse) => _onErrorSaveConsent(errorResponse));
  }

  _onSuccessSaveConsent(SaveConsentApprovalResponse response) async {
    TGLog.d("SaveTAndCConsent() : Success");
    if (response.saveConsentMainObj().status == RES_SUCCESS) {
      if (await TGNetUtil.isInternetAvailable()) {
        _getGstBasicDetails();
      } else {
        if (context.mounted) {
          showSnackBarForintenetConnection(context, _getGstBasicDetails);
        }
      }
    } else if (response.saveConsentMainObj().status == RES_UNAUTHORISED) {
      TGView.showSnackBar(context: context, message: response.saveConsentMainObj().message ?? "");
    } else {
      // isButtonChecked.value = false;
      LoaderUtils.handleErrorResponse(
          context, response.saveConsentMainObj().status, response.saveConsentMainObj().message, null);
      setState(() {
        _isGetOTPLoaderStart = false;
      });
    }
  }

  _onErrorSaveConsent(TGResponse errorResponse) {
    setState(() {
      _isGetOTPLoaderStart = false;
    });
    TGLog.d("SaveTAndCConsent() : Error");
  }

  Future<void> _autoLoginRequest() async {
    TGSession.getInstance().set(SESSION_MOBILENUMBER, mobileTextController.text);
    AutoLoginRequest autoLoginRequest = AutoLoginRequest(
      mobile: mobileTextController.text,
      cifNo: "testingCIFNo",
      email: "w@c.com",
      deviceId: uuid,
      address: "address",
      pan: "",
    );

    var jsonRequest = jsonEncode(autoLoginRequest.toJson());

    TGLog.d("Auto Login Request $jsonRequest");

    TGPostRequest tgPostRequest = await getPayLoad(jsonRequest, URI_AUTOLOGIN);

    ServiceManager.getInstance().autoLoginRequest(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessAutoLogin(response),
        onError: (error) => _onErrorAutoLogin(error));
  }

  _onSuccessAutoLogin(VerifyOtpResponse response) async {
    TGLog.d("AutoLoginResponse : onSuccess()");

    if (response?.getOtpReponseObj()?.status == RES_SUCCESS) {
      Utils.setAccessToken(TGFlavor.param("bankName"), response?.getOtpReponseObj().data?.accessToken);
      TGSharedPreferences.getInstance().set(PREF_MOBILE, mobileTextController.text);
      setAccessTokenInRequestHeader();
      if (await TGNetUtil.isInternetAvailable()) {
        onUpdateTAndCChecked();
      } else {
        showSnackBarForintenetConnection(context, onUpdateTAndCChecked);
      }
    } else {
      setState(() {
        _isGetOTPLoaderStart = false;
      });
      LoaderUtils.handleErrorResponse(
          context, response?.getOtpReponseObj().status ?? 0, response?.getOtpReponseObj()?.message ?? "", null);
    }
  }

  _onErrorAutoLogin(TGResponse errorResponse) {
    TGLog.d("AutoLoginResponse : onError()");
    setState(() {
      _isGetOTPLoaderStart = false;
    });
    handleServiceFailError(context, errorResponse?.error);
  }

  //Get GST Basic Detail API Call
  Future<void> _getGstBasicDetails() async {
    await Future.delayed(const Duration(seconds: 2));
    TGGetRequest tgGetRequest = GetGstBasicDetailsRequest();
    ServiceManager.getInstance().getGstBasicDetails(
        request: tgGetRequest,
        onSuccess: (response) => _onSuccessGetGstBasicDetails(response),
        onError: (error) => _onErrorGetGstBasicDetails(error));
  }

  _onSuccessGetGstBasicDetails(GetGstBasicDetailsResponse? response) {
    TGLog.d("GetGstBasicDetailsResponse : onSuccess()");
    setState(() {
      _basicdetailsResponse = response?.getGstBasicDetailsRes();
    });
    if (_basicdetailsResponse?.status == RES_DETAILS_FOUND) {
      if (_basicdetailsResponse?.data?.isNotEmpty == true) {
        if (_basicdetailsResponse?.data?[0].isOtpVerified == true) {
          if (_basicdetailsResponse?.data?[0]?.gstin?.isNotEmpty == true) {
            var gstin = _basicdetailsResponse!.data![0].gstin!;
            if (_basicdetailsResponse!.data![0].gstin!.length >= 12) {
              TGSharedPreferences.getInstance()
                  .set(PREF_BUSINESSNAME, _basicdetailsResponse?.data?[0].gstBasicDetails?.tradeNam);
              TGSharedPreferences.getInstance().set(PREF_GSTIN, _basicdetailsResponse?.data?[0].gstin);
              TGSharedPreferences.getInstance().set(PREF_USERNAME, _basicdetailsResponse?.data?[0].username.toString());
              TGSharedPreferences.getInstance()
                  .set(PREF_PANNO, _basicdetailsResponse?.data?[0].gstin?.substring(2, 12));
            } else {
              TGSharedPreferences.getInstance().set(PREF_PANNO, _basicdetailsResponse?.data?[0].gstin);
            }
            TGSharedPreferences.getInstance().set(PREF_ISGST_CONSENT, true);
            TGSharedPreferences.getInstance().set(PREF_ISGSTDETAILDONE, true);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const DashboardWithGST(),
                ),
                (route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => GstConsent(),
                ),
                (route) => false);
          }
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => GstConsent(),
              ),
              (route) => false);
        }
      } else {
        _getUserLoanDetails();
      }
    } else if (_basicdetailsResponse?.status == RES_DETAILS_NOT_FOUND) {
      setState(() {});
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => GstConsent(),
          ),
          (route) => false);
    } else {
      setState(() {});
      LoaderUtils.handleErrorResponse(
          context, response?.getGstBasicDetailsRes().status, response?.getGstBasicDetailsRes().message, null);
    }
  }

  _onErrorGetGstBasicDetails(TGResponse errorResponse) {
    setState(() {
      _isGetOTPLoaderStart = false;
    });
    TGLog.d("GetGstBasicDetailsResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
  }

  Widget keyboardColumn() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildButton(buttonList[0], 0), _buildButton(buttonList[1], 1), _buildButton(buttonList[2], 2)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildButton(buttonList[3], 3), _buildButton(buttonList[4], 4), _buildButton(buttonList[5], 5)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildButton(buttonList[6], 6), _buildButton(buttonList[7], 7), _buildButton(buttonList[8], 8)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildButton(buttonList[9], 9),
              _buildButton(buttonList[10], 10),
              _buildButton(buttonList[11], 11)
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _getUserLoanDetails() async {
    TGGetRequest tgGetRequest = GetLoanDetailByRefIdReq();
    ServiceManager.getInstance().getAllLoanDetailByRefId(
        request: tgGetRequest,
        onSuccess: (response) => _onSuccessGetAllLoanDetailByRefId(response),
        onError: (error) => _onErrorGetAllLoanDetailByRefId(error));
  }

  _onSuccessGetAllLoanDetailByRefId(GetAllLoanDetailByRefIdResponse? response) {
    TGLog.d("UserLoanDetailsResponse : onSuccess()");
    _getAllLoanDetailRes = response?.getAllLoanDetailObj();

    if (_getAllLoanDetailRes?.status == RES_SUCCESS) {
      if (_getAllLoanDetailRes?.data?.isEmpty == true) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => GstConsent(),
            ),
            (route) => false);
      } else {
        TGSharedPreferences.getInstance().set(PREF_GSTIN, _getAllLoanDetailRes?.data?[0].gstin);
        TGSharedPreferences.getInstance().set(PREF_PANNO, _getAllLoanDetailRes?.data?[0].gstin?.substring(2, 12));
        TGSession.getInstance().set(SESSION_GSTIN, _getAllLoanDetailRes?.data?[0].gstin);
        TGSession.getInstance().set(SESSION_PANNO, _getAllLoanDetailRes?.data?[0].gstin?.substring(2, 12));
        TGSession.getInstance().set(SESSION_BUSINESSNAME, _getAllLoanDetailRes?.data?[0].tradeNam);
        TGSharedPreferences.getInstance().set(PREF_ISGST_CONSENT, true);
        TGSharedPreferences.getInstance().set(PREF_ISGSTDETAILDONE, true);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const DashboardWithGst(),
            ),
            (route) => false);
      }
    } else {
      setState(() {
        _isGetOTPLoaderStart = false;
      });

      LoaderUtils.handleErrorResponse(
          context, response?.getAllLoanDetailObj().status, response?.getAllLoanDetailObj().message, null);
    }
  }

  _onErrorGetAllLoanDetailByRefId(TGResponse errorResponse) {
    TGLog.d("UserLoanDetailsResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
    setState(() {
      _isGetOTPLoaderStart = false;
    });
  }

  _buildButton(String text, int index) {
    return SizedBox(
      height: 70.h,
      child: IconButton(
        onPressed: () {
          onPressed(buttonList[index]);
        },
        icon: text == '/'
            ? Icon(
                Icons.backspace_outlined,
                color: MyColors.backBtnColorloginKeyboardNo,
              )
            : Text(
                text,
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .headline1!
                    .copyWith(fontSize: 25, color: Colors.black, fontFamily: MyFont.Nunito_Sans_Bold),
              ),
      ),
    );
  }

  enterMobileLabel() {}

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> getLoginOtp() async {
    String uuid = Uuid().v1().replaceAll("-", "").substring(0, 16);
    CredBlock credBlock = CredBlock(appToken: uuid, otp: "", otpSessionKey: "", status: "");

    RequestAuthUser requestAuthUser =
        RequestAuthUser(mobile: mobileTextController.text, credBlock: credBlock, deviceId: uuid);
    var jsonReq = jsonEncode(requestAuthUser.toJson());

    TGLog.d("Get GST OTP Request : $jsonReq");

    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_GETOTP);

    ServiceManager.getInstance().getotp(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetOTP(response),
        onError: (error) => _onErrorGetOTP(error));
  }

  _onSuccessGetOTP(GetotpResponse? response) {
    TGLog.d("Get GST OTP : onSuccess()");
    TGSession.getInstance().set(SESSION_MOBILENUMBER, mobileTextController.text);
    TGSession.getInstance().set(SESSION_OTPSESSIONKEY, response?.getOtpReponseObj().data?.credBlock?.otpSessionKey);
    setState(() {
      getOtpRes = response?.getOtpReponseObj();
      _isGetOTPLoaderStart = false;
      isClearOtp = false;
    });
    Navigator.pushReplacementNamed(context, MyRoutes.OtpVerifyLoginRoutes);
  }

  _onErrorGetOTP(TGResponse errorResponse) {
    TGLog.d("Get GST OTP : onError()");
    handleServiceFailError(context, errorResponse?.error);
    _isGetOTPLoaderStart = false;
  }
}
