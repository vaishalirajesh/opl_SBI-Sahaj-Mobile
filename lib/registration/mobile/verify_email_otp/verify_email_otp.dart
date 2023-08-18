import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_email_otp_response_main.dart';
import 'package:gstmobileservices/model/models/verify_email_otp_response_main.dart';
import 'package:gstmobileservices/model/requestmodel/get_email_otp_request.dart';
import 'package:gstmobileservices/model/requestmodel/verify_email_otp_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_email_otp_response.dart';
import 'package:gstmobileservices/model/responsemodel/verify_email_otp_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_session.dart';
import 'package:gstmobileservices/util/erros_handle_util.dart';
import 'package:gstmobileservices/util/jumpingdot_util.dart';
import 'package:gstmobileservices/util/showcustomesnackbar.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/imageconstant.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusConstants.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/internetcheckdialog.dart';
import 'package:sbi_sahay_1_0/utils/progressLoader.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';

import '../../../utils/constants/session_keys.dart';
import '../../../widgets/otp_textfield_widget.dart';

class OTPVerifyEmail extends StatelessWidget {
  const OTPVerifyEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, false);
            return true;
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: getAppBarWithBackBtn(onClickAction: () => {Navigator.pop(context, false)}),
            body: const OTPVerifyEmailScreen(),
          ),
        );
      },
    );
  }
}

class OTPVerifyEmailScreen extends StatefulWidget {
  const OTPVerifyEmailScreen({super.key});

  @override
  OTPVerifyEmailScreenState createState() => OTPVerifyEmailScreenState();
}

class OTPVerifyEmailScreenState extends State<OTPVerifyEmailScreen> {
  int counter = 0;
  bool isValidOTP = false;
  String otp = '';
  bool isClearOtp = false;
  bool isGetOTPLoaderStart = false;
  bool isVerifyOTPLoaderStart = false;
  String gstin = "";
  var strEmail = ""; //"";
  var otpSessionKey = ""; //"";
  bool isOpenEnablePopUp = false;
  EmailOtpResponseMain? verifyEmailResponse;
  bool isOTPVerified = false;
  GetEmailOtpResponseMain? getOtpResponse;

  @override
  void initState() {
    strEmail = TGSession.getInstance().get(SESSION_EMAIL);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return verifyOtpContent();
  }

  Widget verifyOtpContent() {
    return SafeArea(
      child: AbsorbPointer(
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
                        "Verify Email ID",
                        style: ThemeHelper.getInstance()!.textTheme.headline2,
                      ),
                    ),
                    SizedBox(
                      height: 11.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                      child: RichText(
                        text: TextSpan(
                          text: "OTP sent to ",
                          style: ThemeHelper.getInstance()!.textTheme.subtitle1!,
                          children: [
                            TextSpan(
                              text: strEmail,
                              style: ThemeHelper.getInstance()
                                  ?.textTheme
                                  .subtitle1
                                  ?.copyWith(fontSize: 14.sp, color: MyColors.hyperlinkcolornew),
                            ),
                          ],
                        ),
                      ),
                      // Text(
                      //   "$strEmail",
                      //   style: ThemeHelper.getInstance()!.textTheme.subtitle1!,
                      // ),
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
                                isValidOTP = false;
                              });
                              getEmailOtp();
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
                                AppUtils.path(MOBILEResend),
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
                                style: ThemeHelper.getInstance()!.textTheme.subtitle1?.copyWith(
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
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: ThemeHelper.getInstance()!.cardColor, width: 1)),
                color: ThemeHelper.getInstance()?.backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3), //color of shadow
                    spreadRadius: 1, //spread radius
                    blurRadius: 3, // blur radius
                    offset: const Offset(0, 1), // changes position of shadow
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 20.r, bottom: 20, left: 20.w, right: 20.w),
                child: isVerifyOTPLoaderStart || isGetOTPLoaderStart
                    ? SizedBox(
                        height: 50.h,
                        child: JumpingDots(
                          color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary,
                          radius: 10,
                        ),
                      )
                    : AppButton(
                        onPress: () {
                          onPressVerifyButton();
                        },
                        title: str_Verify,
                        isButtonEnable: isValidOTP,
                      ),
              ),
            ),
          );
        }),
      ),
    );
  }

  void onPressVerifyButton() async {
    setState(() {
      if (isValidOTP) {
        isVerifyOTPLoaderStart = true;
        verifyEmailOtp();
      }
    });
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
          setState(() {});
          //});
        },
        onCompleted: (pin) {
          // setModelState((){
          isClearOtp = false;
          otp = pin;
          setState(() {
            if (otp.isNotEmpty && otp.length >= 6) {
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

  void verifyEmailOtp() async {
    if (await TGNetUtil.isInternetAvailable()) {
      verifyOTP();
    } else {
      if (context.mounted) {
        showSnackBarForintenetConnection(context, verifyOTP);
      }
    }
  }

  Future<void> verifyOTP() async {
    isValidOTP = false;
    if (otpSessionKey.isEmpty) {
      otpSessionKey = await TGSession.getInstance().get(SESSION_OTPSESSIONKEY);
    }
    VerifyEmailOTPRequest verifyEmailOTP = VerifyEmailOTPRequest(otp: otp, sessionKey: otpSessionKey);
    var jsonReq = jsonEncode(verifyEmailOTP.toJson());
    TGLog.d("verifyEmailOTP Request : $jsonReq");
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_SBI_VERIFY_EMAIL);
    ServiceManager.getInstance().verifyEmailOtp(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessVerifyOTP(response),
        onError: (errorResponse) => _onErrorVerifyOTP(errorResponse));
  }

  _onSuccessVerifyOTP(VerifyEmailOtpResponse response) {
    TGLog.d("verifyEmailOTP() : Success---$response");
    verifyEmailResponse = response.getOtpReponseObj();
    if (verifyEmailResponse?.status == RES_SUCCESS) {
      Navigator.pop(context, true);
    } else {
      isVerifyOTPLoaderStart = false;
      isClearOtp = true;
      setState(() {});
      LoaderUtils.handleErrorResponse(
          context, response.getOtpReponseObj().status, response.getOtpReponseObj().message, null);
    }
  }

  _onErrorVerifyOTP(TGResponse errorResponse) {
    TGLog.d("verifyEmailOTP() : Error");
    isVerifyOTPLoaderStart = false;
    isClearOtp = true;
    setState(() {});
    handleServiceFailError(context, errorResponse.error);
  }

  void getEmailOtp() async {
    if (await TGNetUtil.isInternetAvailable()) {
      getOTP();
    } else {
      if (context.mounted) {
        showSnackBarForintenetConnection(context, getOTP);
      }
    }
  }

  Future<void> getOTP() async {
    var username = TGSession.getInstance().get(SESSION_USERNAME);
    GetEmailOTPRequest getEmailOTP = GetEmailOTPRequest(emailId: strEmail, customerName: username);
    var jsonReq = jsonEncode(getEmailOTP.toJson());
    TGLog.d("GetEmailOtp Request : $jsonReq");
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_SBI_GET_EMAIL_OTP);
    ServiceManager.getInstance().getEmailOtp(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetOTP(response),
        onError: (errorResponse) => _onErrorGetOTP(errorResponse));
  }

  _onSuccessGetOTP(GetEmailOtpRespose response) {
    TGLog.d("GetEmailOtp() : Success---$response");
    getOtpResponse = response.getOtpReponseObj();
    if (getOtpResponse?.status == RES_SUCCESS) {
      otpSessionKey = getOtpResponse?.data ?? '';
      showSnackBar(context, "OTP resend successfully");
    } else {
      LoaderUtils.handleErrorResponse(
          context, response?.getOtpReponseObj().status, response?.getOtpReponseObj().message, null);
    }
    isGetOTPLoaderStart = false;
    isClearOtp = false;
    setState(() {});
  }

  _onErrorGetOTP(TGResponse errorResponse) {
    isGetOTPLoaderStart = false;
    isClearOtp = false;
    setState(() {});
    TGLog.d("GetEmailOtp() : Error");
    handleServiceFailError(context, errorResponse.error);
  }
}
