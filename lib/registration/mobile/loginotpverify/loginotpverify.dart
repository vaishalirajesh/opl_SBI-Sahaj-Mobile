import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/common/app_functions.dart';
import 'package:gstmobileservices/common/keys.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_gst_basic_details_res_main.dart';
import 'package:gstmobileservices/model/models/get_loandetail_by_refid_res_main.dart';
import 'package:gstmobileservices/model/models/get_otp_main.dart';
import 'package:gstmobileservices/model/models/verify_otp_response_main.dart';
import 'package:gstmobileservices/model/requestmodel/get_all_loan_detail_by_refid_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_gst_basic_details_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_otp_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_all_loan_detail_by_refid_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_gst_basic_details_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_otp_response.dart';
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
import 'package:gstmobileservices/util/jumpingdot_util.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:pinput/pinput.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import 'package:sbi_sahay_1_0/registration/mobile/gst_consent_of_gst/gst_consent_of_gst.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusConstants.dart';
import 'package:sbi_sahay_1_0/utils/progressLoader.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/Utils.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/constants/session_keys.dart';
import '../../../utils/helpers/themhelper.dart';
import '../../../utils/internetcheckdialog.dart';
import '../../../utils/strings/strings.dart';
import '../../../widgets/otp_textfield_widget.dart';

class OtpVerifyLogin extends StatelessWidget {
  const OtpVerifyLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            SystemNavigator.pop(animated: true);
            return true;
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: getAppBarWithStepDone('', str_registration, 1,
                onClickAction: () => {
                      Navigator.pop(context),
                      SystemNavigator.pop(animated: true),
                    }),
            body: const OtpVerifyLoginScreen(),
          ),
        );
      },
    );
  }
}

class OtpVerifyLoginScreen extends StatefulWidget {
  const OtpVerifyLoginScreen({super.key});

  @override
  OtpVerifyLoginScreenState createState() => OtpVerifyLoginScreenState();
}

class OtpVerifyLoginScreenState extends State<OtpVerifyLoginScreen> {
  GetOtpResponseMain? getOtpRes;
  VerifyOtpMain? verifyOtpResponse;
  GetGstBasicdetailsResMain? _basicdetailsResponse;
  GetAllLoanDetailByRefIdResMain? _getAllLoanDetailRes;

  int counter = 0;
  bool isValidOTP = false;
  String otp = '';
  String firstletter = "";
  String secondletter = "";
  String thirdletter = "";
  String forthletter = "";
  String fifthletter = "";
  String sixthletter = "";
  bool isClearOtp = false;
  bool isGetOTPLoaderStart = false;
  bool isVerifyOTPLoaderStart = false;
  String gstin = '';
  var strMobile = ""; //TGSession.getInstance().get(SESSION_MOBILENUMBER); //"";
  var otpSessionKey = TGSession.getInstance().get(SESSION_OTPSESSIONKEY); //"";

  void checkOtp() {
    isValidOTP = firstletter.isNotEmpty &&
        secondletter.isNotEmpty &&
        thirdletter.isNotEmpty &&
        forthletter.isNotEmpty &&
        fifthletter.isNotEmpty &&
        sixthletter.isNotEmpty;
  }

  @override
  void initState() {
    strMobile = TGSession.getInstance().get(SESSION_MOBILENUMBER);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return verifyOtpContent();
  }

  Widget verifyOtpContent() {
    return AbsorbPointer(
      absorbing: isVerifyOTPLoaderStart,
      child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.r),
                topRight: Radius.circular(50.r),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.r),
                  topRight: Radius.circular(50.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                    child: Text(
                      str_Verify_mobile_number,
                      style: ThemeHelper.getInstance()!.textTheme.headline2,
                    ),
                  ),
                  SizedBox(
                    height: 11.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                    child: Row(
                      children: [
                        Text(
                          "$str_OTP_sent_number",
                          style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp),
                        ),
                        Text(
                          "${strMobile.substring(0, 7)} ***",
                          style: ThemeHelper.getInstance()!
                              .textTheme
                              .headline3!
                              .copyWith(fontSize: 14.sp, color: MyColors.hyperlinkcolornew),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 31.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          str_enter_6_Digit_login,
                          style: ThemeHelper.getInstance()!.textTheme.headline4,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  otpTexFields(),
                  SizedBox(
                    height: 16.h,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       str_Didnt_received_OTP_yet,
                  //       style: ThemeHelper.getInstance()!
                  //           .textTheme
                  //           .bodyText1!
                  //           .copyWith(
                  //               fontSize: 14.sp, color: MyColors.pnbGreyColor),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: 10.h,
                  ),
                  GestureDetector(
                    onTap: isVerifyOTPLoaderStart || isGetOTPLoaderStart
                        ? null
                        : () {
                            // Navigator.pop(context);
                            setState(() {
                              otp = '';
                              isClearOtp = true;
                              isGetOTPLoaderStart = true;
                            });
                            getLoginOtp();
                          },
                    child: Padding(
                      padding: EdgeInsets.only(right: 20.w, top: 10.h, bottom: 10.h, left: 10.w),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              Utils.path(MOBILEResend),
                              height: 16.h,
                              width: 16.w,
                              color: isVerifyOTPLoaderStart || isGetOTPLoaderStart
                                  ? MyColors.verylightGrayColor
                                  : MyColors.pnbcolorPrimary,
                            ),
                            SizedBox(
                              width: 9.w,
                            ),
                            Text(
                              str_Resend_OTP,
                              style: ThemeHelper.getInstance()!.textTheme.headline6?.copyWith(
                                    color: isVerifyOTPLoaderStart || isGetOTPLoaderStart
                                        ? MyColors.verylightGrayColor
                                        : MyColors.pnbcolorPrimary,
                                  ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 25.r),
            child: isVerifyOTPLoaderStart || isGetOTPLoaderStart
                ? SizedBox(
                    height: 100.h,
                    child: JumpingDots(
                      color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary,
                      radius: 10,
                    ),
                  )
                : AppButton(
                    onPress: onPressVerifyButton,
                    title: str_Verify,
                    isButtonEnable: isValidOTP,
                  ),
          ),
        );
      }),
    );
  }

  Widget otpTexFields() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
      child: OTPTextField(
        otpFieldStyle: OtpFieldStyle(focusBorderColor: MyColors.darkblack //(here)
            ),
        isClearOtp: isClearOtp,
        length: 6,
        width: MediaQuery.of(context).size.width,
        fieldWidth: 45.w,
        onChanged: (str) {
          // setModelState((){
          isValidOTP = false;
          //});
        },
        onCompleted: (pin) {
          // setModelState((){
          otp = pin;
          setState(() {
            if (otp.isNotEmpty) {
              isValidOTP = true;
            } else {
              isValidOTP = false;
            }
          });

          // });
        },
        style: TextStyle(color: MyColors.darkblack),
      ),
    );
  }

  Widget animatedBorders() {
    final pinputController = TextEditingController();
    final focusNode = FocusNode();
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: ThemeHelper.getInstance()?.textTheme.bodyText1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: ThemeHelper.getInstance()!.colorScheme.onSurface),
      ),
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
      child: Pinput(
        autofocus: true,
        defaultPinTheme: defaultPinTheme,
        length: 6,
        focusNode: focusNode,
        onSubmitted: (String pin) {
          otp = pin;
          setState(() {
            if (otp.isNotEmpty) {
              isValidOTP = true;
            } else {
              isValidOTP = false;
            }
          });
        },
        controller: pinputController,
      ),
    );
  }

  void onPressVerifyButton() async {
    setState(() {
      if (isValidOTP) {
        isVerifyOTPLoaderStart = true;
      }
    });
    if (isValidOTP) {
      if (await TGNetUtil.isInternetAvailable()) {
        verifyLoginOtp();
      } else {
        if (context.mounted) {
          showSnackBarForintenetConnection(
            context,
            verifyLoginOtp,
          );
        }
      }
    }
  }

  Future<void> verifyLoginOtp() async {
    setState(() {
      isVerifyOTPLoaderStart = true;
    });

    String uuid = const Uuid().v1().replaceAll("-", "").substring(0, 16);
    CredBlock credBlock = CredBlock(
        appToken: uuid,
        otp: otp,
        otpSessionKey: getOtpRes != null ? getOtpRes?.data?.credBlock?.otpSessionKey : otpSessionKey,
        status: "");

    RequestAuthUser requestAuthUser = RequestAuthUser(mobile: strMobile, credBlock: credBlock, deviceId: uuid);
    String jsonReq = jsonEncode(requestAuthUser.toJson());

    TGLog.d("Verify GST OTP Request : $jsonReq");
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_VERIFY_OTP);

    ServiceManager.getInstance().verifyOtp(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessVerifyOtp(response),
        onError: (error) => _onErrorVerifyOtp(error));
  }

  _onSuccessVerifyOtp(VerifyOtpResponse? response) {
    TGLog.d("VerifyOTP  GST OTP : onSuccess()");
    isGetOTPLoaderStart = false;
    verifyOtpResponse = response?.getOtpReponseObj();
    //Navigator.pop(context);
    if (verifyOtpResponse?.status == RES_SUCCESS) {
      TGSharedPreferences.getInstance().set(PREF_ACCESS_TOKEN, verifyOtpResponse?.data?.accessToken);
      TGSharedPreferences.getInstance().set(PREF_ACCESS_TOKEN_SBI, verifyOtpResponse?.data?.accessToken);
      setAccessTokenInRequestHeader();
      getGstBasicDetails();
    } else if (verifyOtpResponse?.message == 'Incorrect OTP') {
      setState(() {
        isVerifyOTPLoaderStart = false;
      });
      TGView.showSnackBar(context: context, message: verifyOtpResponse?.message ?? "");
    } else {
      setState(() {
        isVerifyOTPLoaderStart = false;
      });
      LoaderUtils.handleErrorResponse(
          context, response?.getOtpReponseObj().status, response?.getOtpReponseObj().message, null);
    }
  }

  _onErrorVerifyOtp(TGResponse? response) {
    TGLog.d("Verify GST OTP : onError()");
    // Navigator.pop(context);
    handleServiceFailError(context, response?.error);
    setState(() {
      isVerifyOTPLoaderStart = false;
    });
  }

  Future<void> getGstBasicDetails() async {
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
      isVerifyOTPLoaderStart = false;
      _basicdetailsResponse = response?.getGstBasicDetailsRes();
    });

    if (_basicdetailsResponse?.status == RES_DETAILS_FOUND) {
      if (_basicdetailsResponse?.data?.isNotEmpty == true) {
        if (_basicdetailsResponse?.data?[0].isOtpVerified == true) {
          if (_basicdetailsResponse?.data?[0]?.gstin?.isNotEmpty == true) {
            gstin = _basicdetailsResponse!.data![0].gstin!;
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
        getUserLoanDetails();
      }
    } else if (_basicdetailsResponse?.status == RES_DETAILS_NOT_FOUND) {
      setState(() {
        isVerifyOTPLoaderStart = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => GstConsent(),
          ),
          (route) => false);
    } else {
      setState(() {
        isVerifyOTPLoaderStart = false;
      });
      LoaderUtils.handleErrorResponse(
          context, response?.getGstBasicDetailsRes().status, response?.getGstBasicDetailsRes().message, null);
    }
  }

  _onErrorGetGstBasicDetails(TGResponse errorResponse) {
    setState(() {
      isVerifyOTPLoaderStart = false;
    });
    TGLog.d("GetGstBasicDetailsResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> getUserLoanDetails() async {
    TGGetRequest tgGetRequest = GetLoanDetailByRefIdReq();
    ServiceManager.getInstance().getAllLoanDetailByRefId(
        request: tgGetRequest,
        onSuccess: (response) => _onSuccessGetAllLoanDetailByRefId(response),
        onError: (error) => _onErrorGetAllLoanDetailByRefId(error));
  }

  _onSuccessGetAllLoanDetailByRefId(GetAllLoanDetailByRefIdResponse? response) {
    TGLog.d("UserLoanDetailsResponse : onSuccess()");
    setState(() {
      isVerifyOTPLoaderStart = false;
    });
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
        TGSharedPreferences.getInstance().set(PREF_ISGST_CONSENT, true);
        TGSharedPreferences.getInstance().set(PREF_ISGSTDETAILDONE, true);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const DashboardWithGST(),
            ),
            (route) => false);
      }
    } else {
      setState(() {
        isVerifyOTPLoaderStart = false;
      });
      LoaderUtils.handleErrorResponse(
          context, response?.getAllLoanDetailObj().status, response?.getAllLoanDetailObj().message, null);
    }
  }

  _onErrorGetAllLoanDetailByRefId(TGResponse errorResponse) {
    TGLog.d("UserLoanDetailsResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
    setState(() {
      isVerifyOTPLoaderStart = false;
    });
  }

  Future<void> getLoginOtp() async {
    String uuid = Uuid().v1().replaceAll("-", "").substring(0, 16);
    CredBlock credBlock = CredBlock(appToken: uuid, otp: "", otpSessionKey: "", status: "");

    RequestAuthUser requestAuthUser = RequestAuthUser(mobile: strMobile, credBlock: credBlock, deviceId: uuid);
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

    showSnackBar();
    setState(() {
      getOtpRes = response?.getOtpReponseObj();
      isGetOTPLoaderStart = false;
      isClearOtp = false;
    });
  }

  _onErrorGetOTP(TGResponse errorResponse) {
    TGLog.d("Get GST OTP : onError()");
    handleServiceFailError(context, errorResponse?.error);
    isGetOTPLoaderStart = false;
  }

  // Show snack bar for resend OTP
  void showSnackBar() {
    final snackBar = SnackBar(
      content: const Text(resendOTPMsg),
      backgroundColor: ThemeHelper.getInstance()!.colorScheme.primary,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.fromLTRB(20.r, 20.r, 20.r, 0.15.sh),
      // elevation: 1000,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
