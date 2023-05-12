import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_gst_otp_res_main.dart';
import 'package:gstmobileservices/model/requestmodel/get_gst_otp_request.dart';
import 'package:gstmobileservices/model/requestmodel/verify_gst_otp_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_gst_otp_response.dart';
import 'package:gstmobileservices/model/responsemodel/verify_gst_otp_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_session.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';

import '../../../utils/Utils.dart';
import '../../../utils/colorutils/mycolors.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/constants/session_keys.dart';
import '../../../utils/constants/statusConstants.dart';
import '../../../utils/erros_handle.dart';
import '../../../utils/helpers/themhelper.dart';
import '../../../utils/internetcheckdialog.dart';
import '../../../utils/jumpingdott.dart';
import '../../../utils/progressLoader.dart';
import '../../../utils/strings/strings.dart';
import '../../../widgets/otp_textfield_widget.dart';
import '../../../widgets/titlebarmobile/titlebarwithoutstep.dart';
import '../gstinvoiceslist/ui/gstinvoicelist.dart';

class RefreshGstOtpVerify extends StatelessWidget {
  const RefreshGstOtpVerify({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: VerifyGstOtpScreen());
  }
}

class VerifyGstOtpScreen extends StatefulWidget {
  const VerifyGstOtpScreen({super.key});

  @override
  State<VerifyGstOtpScreen> createState() => VerifyGstOtpScreenState();
}

class VerifyGstOtpScreenState extends State<VerifyGstOtpScreen> {
  GstOtpResponseMain? _gstOtpResponse = GstOtpResponseMain();
  GstOtpResponseMain? _verifyOtpResponse;

  String strGSTIN = TGSession.getInstance().get("otp_gstin"); //"";
  String strGSTINUserName = TGSession.getInstance().get("otp_GSTINUserName"); //"";
  String otpSessionKey = TGSession.getInstance().get(SESSION_OTPSESSIONKEY);

  bool isLoader = false;
  bool isClearOtp = false;
  bool isValidOTP = false;

  String otp = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: getAppBarWithStep('1', str_registration, 0.25, onClickAction: () => {Navigator.pop(context)}),
        body: BottomPopupTC(),
      ),
    );
  }

  Widget BottomPopupTC() {
    return AbsorbPointer(
      absorbing: isLoader,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(50.0),
                  topRight: const Radius.circular(50.0))), //could change this to Color(0xFF737373),
          //so you don't have to change MaterialApp canvasColor
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: const Radius.circular(50.0), topRight: const Radius.circular(50.0))),
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
                      str_Verify_GSTIN,
                      style: ThemeHelper.getInstance()!.textTheme.headline1,
                    ),
                  ),
                  SizedBox(
                    height: 11.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                    child: Text(
                      str_OTP_sent + strGSTIN,
                      style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 15.sp),
                    ),
                  ),
                  SizedBox(
                    height: 31.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        str_enter_6_Digit,
                        style: ThemeHelper.getInstance()!.textTheme.headline4,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  SetUpOtpTextFieldForGSTDetail(),
                  SizedBox(
                    height: 16.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        str_Didnt_received_OTP_yet,
                        style: ThemeHelper.getInstance()!
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 14.sp, color: MyColors.pnbGreyColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 11.h,
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        otp = '';
                        isClearOtp = true;
                        isLoader = true;
                      });
                      if (await TGNetUtil.isInternetAvailable()) {
                        getGstOtp();
                      } else {
                        showSnackBarForintenetConnection(context, getGstOtp);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Utils.path(MOBILEResend),
                          height: 16.h,
                          width: 16.w,
                        ),
                        SizedBox(
                          width: 9.w,
                        ),
                        Text(str_Resend_OTP, style: ThemeHelper.getInstance()!.textTheme.headline6)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: isLoader
                        ? JumpingDots(
                            color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary,
                            radius: 10,
                          )
                        : AppButton(
                            onPress: () async {
                              if (isValidOTP) {
                                isShowLaoder();
                                if (await TGNetUtil.isInternetAvailable()) {
                                  verifyGstOtp();
                                } else {
                                  if (context.mounted) {
                                    showSnackBarForintenetConnection(context, verifyGstOtp);
                                  }
                                }
                              }
                            },
                            title: str_Verify,
                            isButtonEnable: isValidOTP,
                          ),
                  ),
                  /* SizedBox(
                    height: 52.h,
                  )*/
                ],
              )),
        ),
      ),
    );
  }

  Widget SetUpOtpTextFieldForGSTDetail() {
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
          setState(() {
            isValidOTP = false;
          });
        },
        onCompleted: (pin) {
          setState(() {
            otp = pin;
            if (otp.isNotEmpty) {
              isValidOTP = true;
            } else {
              isValidOTP = false;
            }
          });
        },
        style: TextStyle(color: MyColors.darkblack),
      ),
    );
  }

  void isShowLaoder() {
    setState(() {
      isLoader = true;
    });
  }

  void HideLaoder() {
    setState(() {
      isClearOtp = false;
      isLoader = false;
    });
  }

  Future<void> getGstOtp() async {
    GstOtpRequest gstOtpRequest = GstOtpRequest(id: strGSTIN, userName: strGSTINUserName, requestType: 'OTPREQUEST');

    var jsonReq = jsonEncode(gstOtpRequest.toJson());

    TGLog.d("GST OTP Request : $jsonReq");

    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_GET_GSTOTP);

    ServiceManager.getInstance().getGstOtp(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetGstOTP(response),
        onError: (error) => _onErrorGetGstOTP(error));
  }

  _onSuccessGetGstOTP(GstOtpRespose? response) {
    TGLog.d("RegisterResponse : onSuccess()");
    _gstOtpResponse = response?.getOtpReponseObj();
    if (_gstOtpResponse?.status == RES_SUCCESS) {
      setState(() {
        isClearOtp = false;
        isLoader = false;
      });
    } else if (_gstOtpResponse?.status == RES_GST_APIDENIED || _gstOtpResponse?.status == UNKNOWN) {
      TGView.showSnackBar(context: context, message: response?.getOtpReponseObj()?.message ?? "");
      setState(() {
        isClearOtp = false;
        isLoader = false;
      });
    } else {
      LoaderUtils.handleErrorResponse(
          context, response?.getOtpReponseObj().status, response?.getOtpReponseObj().message, null);
      setState(() {
        HideLaoder();
      });
    }

    // setState(() {
    //   isSetLoader = false;
    // });
  }

  _onErrorGetGstOTP(TGResponse errorResponse) {
    TGLog.d("RegisterResponse : onError()");
    setState(() {
      handleServiceFailError(context, errorResponse.error);
      isClearOtp = false;
      isLoader = false;
    });
  }

  Future<void> verifyGstOtp() async {
    VerifyGstOtpRequest verifyGstOtpRequest =
        VerifyGstOtpRequest(id: strGSTIN, otp: otp, sessionKey: _gstOtpResponse?.data?.sessionKey ?? otpSessionKey);

    var jsonReq = jsonEncode(verifyGstOtpRequest.toJson());

    TGLog.d("Verify GST OTP Requesr : $jsonReq");

    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_VERIFY_GSTOTP);

    ServiceManager.getInstance().verifyGstOtp(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessVerifyGstOTP(response),
        onError: (error) => _onErrorVerifyGstOTP(error));
  }

  _onSuccessVerifyGstOTP(VerifyGstOtpResponse? response) {
    TGLog.d("RegisterResponse : onSuccess()");
    _verifyOtpResponse = response?.getOtpReponseObj();

    if (_verifyOtpResponse?.status == RES_SUCCESS) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GSTInvoicesList(),
          ));
      HideLaoder();
    } else if (_verifyOtpResponse?.status == RES_GST_APIDENIED) {
      TGView.showSnackBar(context: context, message: _verifyOtpResponse?.message ?? "");
      HideLaoder();
    } else {
      LoaderUtils.handleErrorResponse(
          context, response?.getOtpReponseObj().status, response?.getOtpReponseObj().message, null);
      HideLaoder();
    }
  }

  _onErrorVerifyGstOTP(TGResponse errorResponse) {
    TGLog.d("RegisterResponse : onError()");
    setState(() {
      HideLaoder();
      handleServiceFailError(context, errorResponse.error);
    });
  }
}
