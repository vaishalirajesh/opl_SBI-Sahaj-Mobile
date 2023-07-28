import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/common/app_functions.dart';
import 'package:gstmobileservices/common/keys.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/requestmodel/autologin_request.dart';
import 'package:gstmobileservices/model/responsemodel/verify_otp_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_session.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/erros_handle_util.dart';
import 'package:gstmobileservices/util/jumpingdot_util.dart';
import 'package:gstmobileservices/util/tg_flavor.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:gstmobileservices/util/tg_util.dart';
import 'package:sbi_sahay_1_0/registration/mobile/login/login.dart';
import 'package:sbi_sahay_1_0/registration/mobile/signupdetails/signup.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/constants/session_keys.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusConstants.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/internetcheckdialog.dart';
import 'package:sbi_sahay_1_0/utils/progressLoader.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/Utils.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/strings/strings.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return const SafeArea(child: GetStarted());
      },
    );
  }
}

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  bool isLoaderStart = false;
  String uuid = Uuid().v1().replaceAll("-", "").substring(0, 16);
  bool isShowDialog = false;
  bool isValidMobile = false;
  String strMobile = '';
  String ssomobileNumber = '';

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      await TGSharedPreferences.getInstance().remove(PREF_ACCESS_TOKEN_SBI);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isShowDialog) {
          isShowDialog = false;
          setState(() {});
          return false;
        } else {
          SystemNavigator.pop(animated: true);
          return true;
        }
      },
      child: Stack(
        children: [
          Scaffold(
            body: AbsorbPointer(
              absorbing: isLoaderStart,
              child: ListView(
                children: [
                  pNBLogo(),
                  sahayLogo(),
                  cardViewSetup(),
                ],
              ),
            ),
            bottomNavigationBar: AbsorbPointer(
              absorbing: isLoaderStart,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  getStartedBTN(context),
                  SizedBox(
                    height: 10.h,
                  ),
                  // loginButton(context),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
            ),
          ),
          if (isShowDialog) buildDialog()
        ],
      ),
    );
  }

  Widget getStartedBTN(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
      ),
      child: isLoaderStart
          ? SizedBox(
              height: 50.h,
              child: JumpingDots(
                color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary,
                radius: 10,
              ),
            )
          : AppButton(
              onPress: showMobileDialog,
              title: str_get_started,
            ),
    );
  }

  void showMobileDialog() {
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (BuildContext context) => const OfferExpireDialog(),
    //     ),
    //     (route) => false);
    // return;
    isShowDialog = true;
    setState(() {});
  }

  Widget buildDialog() {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.white,
            ),
            // height: 400.h,
            width: 335.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 40.h), //40
                //40
                Center(
                  child: Text(
                    "Add Mobile Number",
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline1
                        ?.copyWith(color: MyColors.darkblack, fontSize: 18.sp),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: TextFormField(
                        onChanged: (content) {
                          strMobile = content;
                          if (strMobile.length == 10) {
                            isValidMobile = true;
                          } else {
                            isValidMobile = false;
                          }
                          setState(() {});
                        },
                        cursorColor: MyColors.black,
                        decoration: InputDecoration(
                            labelText: "Contact Number",
                            labelStyle: ThemeHelper.getInstance()!
                                .textTheme
                                .headline3!
                                .copyWith(color: MyColors.verylightGrayColor),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1, color: ThemeHelper.getInstance()!.colorScheme.onSurface),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1, color: ThemeHelper.getInstance()!.colorScheme.onSurface),
                            ),
                            counterText: ''),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        maxLines: 1,
                        maxLength: 10,
                        style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(color: MyColors.darkblack),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "";
                          }
                          return null;
                        })),
                //38
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: BtnCheckOut(),
                ),
                SizedBox(height: 30.h), //40
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget BtnCheckOut() {
    return AppButton(
      onPress: () async {
        if (isValidMobile) {
          onPressGetStartedButton();
        }
      },
      title: str_Proceed,
      isButtonEnable: isValidMobile,
    );
  }

  void onPressGetStartedButton() async {
    setState(() {
      isShowDialog = false;
      isLoaderStart = true;
    });
    if (await TGNetUtil.isInternetAvailable()) {
      _autoLoginRequest();
    } else {
      if (context.mounted) {
        showSnackBarForintenetConnection(context, _autoLoginRequest);
      }
    }
  }

  Future<void> _autoLoginRequest() async {
    String? actulssMobielMumber = await TGSession.getInstance().get(SESSION_SSOMOBILE) ?? '';
    if (actulssMobielMumber!.isNotEmpty) {
      ssomobileNumber = actulssMobielMumber!.substring(actulssMobielMumber.length - 10);
    }
    String? ssoemail = await TGSession.getInstance().get(SESSION_SSOEMAIL) ?? '';
    String? ssoaddress = await TGSession.getInstance().get(SESSION_SSOADDRESS) ?? '';
    String? ssocifnumber = await TGSession.getInstance().get(SESSION_SSOCIFNO) ?? '';
    String? ssopannumber = await TGSession.getInstance().get(SESSION_SSOPANNO) ?? '';
    TGLog.d(
        "SSO data -------Mobile---'$ssomobileNumber'  Pan---'$ssopannumber'-----Address---'$ssoaddress' CIfNo---'$ssocifnumber'---email---'$ssoemail'-- ");
    TGSession.getInstance().set(SESSION_MOBILENUMBER, ssomobileNumber.isNotEmpty ? ssomobileNumber : strMobile);

    // If data will get from sso then call APi with that parameter else pass static user input
    AutoLoginRequest autoLoginRequest = AutoLoginRequest(
      mobile: ssomobileNumber.isNotEmpty ? ssomobileNumber : strMobile,
      cifNo: ssocifnumber!.isNotEmpty ? ssocifnumber : "testingCIFNo",
      email: ssoemail!.isNotEmpty ? ssoemail : "opltest@gamil.com",
      deviceId: uuid,
      address: ssoaddress!.isNotEmpty ? ssoaddress : "address",
      pan: ssopannumber!.isNotEmpty ? ssopannumber : '',
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
      TGSharedPreferences.getInstance().set(PREF_MOBILE, ssomobileNumber.isNotEmpty ? ssomobileNumber : strMobile);
      setAccessTokenInRequestHeader();
      TGLog.d('Bank name--${TGFlavor.param("bankName")}');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SignUpView(),
        ),
      );
    } else {
      setState(() {
        isLoaderStart = false;
      });
      LoaderUtils.handleErrorResponse(
          context, response?.getOtpReponseObj().status ?? 0, response?.getOtpReponseObj()?.message ?? "", null);
    }
  }

  _onErrorAutoLogin(TGResponse errorResponse) {
    TGLog.d("AutoLoginResponse : onError()");
    setState(() {
      isLoaderStart = false;
    });
    handleServiceFailError(context, errorResponse?.error);
  }
}

Widget sahayLogo() {
  return Padding(
    padding: EdgeInsets.only(bottom: 45.h),
    child: Center(
      child: SvgPicture.asset(
        AppUtils.path(IMG_SAHAY_LOGO),
        height: 110,
        width: 150,
        allowDrawingOutsideViewBox: true,
        //color: Colors.black,
      ),
    ),
  );
}

Widget pNBLogo() {
  return Padding(
    padding: EdgeInsets.only(top: 50.h, bottom: 60.h),
    child: Center(
      child: SvgPicture.asset(
        AppUtils.path(BANKLOGOSQUARE),
        width: 180.w,
        height: 50.h,
      ),
    ),
  );
}

Widget cardViewSetup() {
  return Container(
    // height: 200.h,
    padding: EdgeInsets.symmetric(vertical: 20.r),
    margin: EdgeInsets.only(bottom: 50.h, left: 20.w, right: 20.w),
    decoration: BoxDecoration(
      color: ThemeHelper.getInstance()!.cardColor,
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
    ),
    child: Center(
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: str_gst_sahay,
                style: ThemeHelper.getInstance()!.textTheme.button!.copyWith(color: MyColors.pnbsmallbodyTextColor),
              ),
              TextSpan(
                text: str_disc,
                style: ThemeHelper.getInstance()!.textTheme.headline3!,
              ),
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri.parse("https://www.youtube.com/watch?v=vcxK5Ppd4R4"));
                  },
                text: strVideo,
                style: ThemeHelper.getInstance()!.textTheme.button!.copyWith(
                      color: MyColors.hyperlinkcolornew,
                      decoration: TextDecoration.underline,
                    ),
              ),
              TextSpan(text: strLast, style: ThemeHelper.getInstance()!.textTheme.headline3!),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget loginButton(BuildContext context) {
  return TextButton(
    onPressed: () {
      //action
    },
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: str_all_have_acc,
            style: ThemeHelper.getInstance()!
                .textTheme
                .headline3!
                .copyWith(fontSize: 14.sp, color: MyColors.lightBlackText),
          ),
          TextSpan(
              text: str_logintc,
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline3!
                  .copyWith(fontSize: 14.sp, color: MyColors.hyperlinkcolornew),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  TGLog.d("On tap login");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginWithMobileNumber(),
                    ),
                  );
                }),
        ],
      ),
    ),
  );
}
