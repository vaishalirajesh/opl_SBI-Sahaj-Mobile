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
import 'package:gstmobileservices/model/requestmodel/autologin_request.dart';
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
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:sbi_sahay_1_0/routes.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusconstants.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';
import 'package:uuid/uuid.dart';

import '../../../loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import '../../../utils/Utils.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/constants/prefrenceconstants.dart';
import '../../../utils/constants/session_keys.dart';
import '../../../utils/erros_handle.dart';
import '../../../utils/helpers/themhelper.dart';
import '../../../utils/internetcheckdialog.dart';
import '../../../utils/jumpingdott.dart';
import '../../../utils/progressloader.dart';
import '../../../utils/strings/strings.dart';
import '../../../widgets/otp_textfield_widget.dart';
import '../gst_consent_of_gst/gst_consent_of_gst.dart';
import '../loginotpverify/loginotpverify.dart';

class LoginWithMobileNumber extends StatelessWidget {
  const LoginWithMobileNumber({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(child: LoginWithMobileNumberScreen());
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

  List<String> buttonList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '',
    '0',
    '/'
  ];

  int counter = 0;
  bool isValidOTP = false;
  String otp = '';
  bool isClearOtp = false;
  bool isGetOTPLoaderStart = false;
  bool isVerifyOTPLoaderStart = false;


  onPressed(String text) {
    if (counter <= maxLength - 1 && text != '/') {
      counter++;
      mobileTextController.text = mobileTextController.text + text;
    } else if (counter > 0 && text == '/') {
      if (mobileTextController.text != null && counter > 0) {
        mobileTextController.text =
            mobileTextController.text.substring(0, counter - 1);
        counter--;
      }
    } else {
      var temp = text;
    }
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
            onClickAction: () => {
                  Navigator.pop(context, false),
                  SystemNavigator.pop(animated: true)
                }),
        body: AbsorbPointer(
          absorbing: isGetOTPLoaderStart,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: [
                  enterMobileLabel(),
                  //Flexible(child:  Spacer()),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Row(
                            children: [
                              Checkbox(
                                // checkColor: MyColors.colorAccent,
                                activeColor:
                                    ThemeHelper.getInstance()?.primaryColor,
                                value: isCheckedFirst,
                                onChanged: (bool) {
                                  setState(() {
                                    isCheckedFirst = bool!;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6))),
                                side: BorderSide(
                                    width: 1,
                                    color: isCheckedFirst
                                        ? ThemeHelper.getInstance()!
                                            .primaryColor
                                        : ThemeHelper.getInstance()!
                                            .disabledColor),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.only(top: 10.h),
                                child: Text.rich(TextSpan(
                                    text: str_i_login_check_part1,
                                    style: ThemeHelper.getInstance()!
                                        .textTheme
                                        .headline6!
                                        .copyWith(
                                          fontSize: 12.sp,
                                          color: MyColors.pnbcolorPrimary,
                                        ),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: str_i_login_checkpart2,
                                        style: ThemeHelper.getInstance()!
                                            .textTheme
                                            .headline6!
                                            .copyWith(
                                                fontSize: 12.sp,
                                                color: Colors.blue,
                                                decoration:
                                                    TextDecoration.underline),
                                      ),
                                      TextSpan(
                                        text: str_i_login_checkpart3,
                                        style: ThemeHelper.getInstance()!
                                            .textTheme
                                            .headline6!
                                            .copyWith(
                                                fontSize: 12.sp,
                                                color:
                                                    MyColors.pnbcolorPrimary),
                                      ),
                                      TextSpan(
                                          text: str_i_login_checkpart4,
                                          style: ThemeHelper.getInstance()!
                                              .textTheme
                                              .headline6!
                                              .copyWith(
                                                  fontSize: 12.sp,
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline))
                                    ])),
                              )),
                            ],
                          ),
                        ),
                        /*Padding(
                          padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Checkbox(
                                    // checkColor: MyColors.colorAccent,
                                    activeColor:
                                        ThemeHelper.getInstance()?.primaryColor,
                                    value: isCheckedSecond,
                                    onChanged: (bool) {
                                      setState(() {
                                        isCheckedSecond = bool!;
                                      });
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(6))),
                                    side: BorderSide(
                                        width: 1,
                                        color: isCheckedSecond
                                            ? ThemeHelper.getInstance()!
                                                .primaryColor
                                            : ThemeHelper.getInstance()!
                                                .disabledColor),
                                  ),
                                ],
                              ),
                              */ /*Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 5.0.h),
                                  child: Text(
                                    str_i_login_check2,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 4,
                                    style: ThemeHelper.getInstance()!
                                        .textTheme
                                        .headline6!
                                        .copyWith(
                                            fontSize: 12.sp,
                                            color: MyColors.pnbcolorPrimary),
                                  ),
                                ),
                              ),*/ /*
                            ],
                          ),
                        ),*/
                        Padding(
                          padding: EdgeInsets.only(bottom: 20.h, top: 20.h),
                          child: isGetOTPLoaderStart
                              ? JumpingDots(
                                  color:
                                      ThemeHelper.getInstance()?.primaryColor ??
                                          MyColors.pnbcolorPrimary,
                                  radius: 10,
                                )
                              : ElevatedButton(
                                  style: isCheckedFirst &&
                                          mobileTextController.text.length == 10
                                      ? ThemeHelper.getInstance()!
                                          .elevatedButtonTheme
                                          .style
                                      : ThemeHelper.setPinkDisableButtonBig(),
                                  onPressed: () async {
                                    //if (viewModel.isValidGSTINNumber && viewModel.isValidGSTUserName) {
                                    if (isCheckedFirst &&
                                        mobileTextController.text.length ==
                                            10) {
                                      setState(() {
                                        Navigator.pushNamed(context,
                                           MyRoutes.OtpVerifyLoginRoutes
                                        );
                                        //verifyOtpBottomDialog();
                                       // isGetOTPLoaderStart = true;
                                      });
                                    //   if (await TGNetUtil
                                    //       .isInternetAvailable()) {
                                    //     autoLoginRequest();
                                    //   } else {
                                    //     showSnackBarForintenetConnection(
                                    //         context, autoLoginRequest);
                                    //   }
                                    //}

                                    }
                                  },
                                  child: Text(str_next)),
                        )
                      ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget keyboardColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildButton(buttonList[0], 0),
            _buildButton(buttonList[1], 1),
            _buildButton(buttonList[2], 2)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildButton(buttonList[3], 3),
            _buildButton(buttonList[4], 4),
            _buildButton(buttonList[5], 5)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildButton(buttonList[6], 6),
            _buildButton(buttonList[7], 7),
            _buildButton(buttonList[8], 8)
          ],
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
    );
  }

  _buildButton(String text, int index) {
    return SizedBox(
        height: 60.h,
        child: IconButton(
            onPressed: () {
              onPressed(buttonList[index]);
            },
            icon: text == '/'
                ? Icon(
                    Icons.backspace,
                    color: MyColors.pnbcolorPrimary,
                  )
                : Text(
                    text,
                    style: ThemeHelper.getInstance()!
                        .textTheme
                        .headline1!
                        .copyWith(fontSize: 25),
                  )));
  }

  enterMobileLabel() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.only(top: 30.0.h, bottom: 9.h),
        child: Text(
          str_Enter_your_mobile_Details,
          style: ThemeHelper.getInstance()!.textTheme.headline1,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          bottom: 20.0.h,
        ),
        child: Text(
          str_we_will_send_you_otp_for_confirmation,
          style: ThemeHelper.getInstance()!.textTheme.headline3,
        ),
      ),
      mobileNumberTextFiled(),
    ]);
  }

  mobileNumberTextFiled() {
    var text;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
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
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline3!
                  .copyWith(color: MyColors.pnbcolorPrimary),
              onChanged: (String newVal) {
                setState(() {
                  if (newVal.length <= maxLength) {
                    text = newVal;
                  } else {
                    mobileTextController.text = text;
                  }
                });
              },
              //controller: viewModel.gstUsernameController,
              cursorColor: ThemeHelper.getInstance()!.colorScheme.onSurface,
              decoration: InputDecoration(
                  hintText: str_Mobile_number,
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6.r)),
                    borderSide: BorderSide(
                        width: 1,
                        color:
                            ThemeHelper.getInstance()!.colorScheme.onSurface),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: ThemeHelper.getInstance()!.colorScheme.onSurface,
                        width: 1.0),
                    borderRadius: BorderRadius.circular(6.0.r),
                  ),
                  // focusColor: ThemeHelper.getInstance()!.colorScheme.onSurface,
                  // fillColor: ThemeHelper.getInstance()!.colorScheme.onSurface,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color:
                              ThemeHelper.getInstance()!.colorScheme.onSurface),
                      borderRadius: BorderRadius.all(Radius.circular(6.r))),
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
          height: 20.h,
        ),
        keyboardColumn(),
      ],
    );
  }

  void verifyOtpBottomDialog() {
    isGetOTPLoaderStart = false;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModelState) {
            return Wrap(children: [verifyOtpContent(setModelState)]);
          });
        },
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        clipBehavior: Clip.antiAlias,
        isScrollControlled: true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget verifyOtpContent(StateSetter setModelState) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(50.0),
                  topRight: const Radius.circular(50.0))),
          child: Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(50.0),
                      topRight: const Radius.circular(50.0))),
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
                      style: ThemeHelper.getInstance()!.textTheme.headline1,
                    ),
                  ),
                  SizedBox(
                    height: 11.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                    child: Text(
                      "$str_OTP_sent_number${mobileTextController.text.substring(0, 7)} ***",
                      style: ThemeHelper.getInstance()!
                          .textTheme
                          .headline3!
                          .copyWith(fontSize: 15.sp),
                    ),
                  ),
                  SizedBox(
                    height: 31.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        str_enter_6_Digit_login,
                        style: ThemeHelper.getInstance()!.textTheme.headline4,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  otpTexFields(setModelState),
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
                            .copyWith(
                                fontSize: 14.sp, color: MyColors.pnbGreyColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 11.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigator.pop(context);
                      //getLoginOtp();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Utils.path(MOBILEResend),
                          height: 16.h,
                          width: 16.w,
                        ),
                        SizedBox(
                          width: 9.w,
                        ),
                        Text(str_Resend_OTP,
                            style: ThemeHelper.getInstance()!
                                .textTheme
                                .headline2!
                                .copyWith(
                                    fontSize: 16.sp,
                                    color: MyColors.pnbcolorPrimary))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: isVerifyOTPLoaderStart
                        ? JumpingDots(
                            color: ThemeHelper.getInstance()?.primaryColor ??
                                MyColors.pnbcolorPrimary,
                            radius: 10,
                          )
                        : ElevatedButton(
                            style: isValidOTP
                                ? ThemeHelper.getInstance()!
                                    .elevatedButtonTheme
                                    .style
                                : ThemeHelper.setPinkDisableButtonBig(),
                            onPressed: () {
                              setModelState(() {
                                isVerifyOTPLoaderStart = true;
                                if (isValidOTP) {
                                  //verifyLoginOtp();
                                }
                              });
                            },
                            child: Text(str_Verify),
                          ),
                  ),
                  SizedBox(
                    height: 52.h,
                  )
                ],
              )),
        ),
      );
    });
  }

  Widget otpTexFields(StateSetter setModelState) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
      child: OTPTextField(
        isClearOtp: isClearOtp,
        length: 6,
        width: MediaQuery.of(context).size.width,
        fieldWidth: 45.w,
        onChanged: (str) {
          setModelState(() {
            isValidOTP = false;
          });
        },
        onCompleted: (pin) {
          setModelState(() {
            otp = pin;
            if (otp.isNotEmpty) {
              isValidOTP = true;
            } else {
              isValidOTP = false;
            }
          });
        },
      ),
    );
  }

  // Future<void> autoLoginRequest() async {
  //   TGSession.getInstance()
  //       .set(SESSION_MOBILENUMBER, mobileTextController.text);
  //   String uuid = Uuid().v1().replaceAll("-", "").substring(0, 16);
  //
  //   AutoLoginRequest autoLoginRequest = AutoLoginRequest(
  //       mobile: mobileTextController.text,
  //       cifNo: "testingCIFNo",
  //       email: "w@c.com",
  //       deviceId: uuid,
  //       address: "sdasd");
  //
  //   var jsonRequest = jsonEncode(autoLoginRequest.toJson());
  //
  //   TGLog.d("Auto Login Request $jsonRequest");
  //
  //   TGPostRequest tgPostRequest = await getPayLoad(jsonRequest, URI_AUTOLOGIN);
  //
  //   ServiceManager.getInstance().autoLoginRequest(
  //       request: tgPostRequest,
  //       onSuccess: (response) => _onSuccessAutoLogin(response),
  //       onError: (error) => _onErrorAutoLogin(error));
  // }
  //
  // _onSuccessAutoLogin(VerifyOtpResponse response) async {
  //   TGLog.d("AutoLoginResponse : onSuccess()");
  //
  //   if (response?.getOtpReponseObj()?.status == RES_SUCCESS) {
  //     setState(() {
  //       TGSharedPreferences.getInstance().set(
  //           PREF_ACCESS_TOKEN, response?.getOtpReponseObj().data?.accessToken);
  //       TGSharedPreferences.getInstance()
  //           .set(PREF_MOBILE, mobileTextController.text);
  //       setAccessTokenInRequestHeader();
  //     });
  //
  //     if (await TGNetUtil.isInternetAvailable()) {
  //       getGstBasicDetails();
  //     } else {
  //       showSnackBarForintenetConnection(context, getGstBasicDetails);
  //     }
  //   } else {
  //     setState(() {
  //       isGetOTPLoaderStart = false;
  //     });
  //     LoaderUtils.handleErrorResponse(
  //         context,
  //         response?.getOtpReponseObj().status ?? 0,
  //         response?.getOtpReponseObj()?.message ?? "",
  //         null);
  //   }
  // }
  //
  // _onErrorAutoLogin(TGResponse errorResponse) {
  //   TGLog.d("AutoLoginResponse : onError()");
  //   setState(() {
  //     isGetOTPLoaderStart = false;
  //   });
  //   handleServiceFailError(context, errorResponse?.error);
  // }

  //Get GST Basic Detail API Call
  // Future<void> getGstBasicDetails() async {
  //   await Future.delayed(Duration(seconds: 2));
  //   TGGetRequest tgGetRequest = GetGstBasicDetailsRequest();
  //   ServiceManager.getInstance().getGstBasicDetails(
  //       request: tgGetRequest,
  //       onSuccess: (response) => _onSuccessGetGstBasicDetails(response),
  //       onError: (error) => _onErrorGetGstBasicDetails(error));
  // }
  //
  // _onSuccessGetGstBasicDetails(GetGstBasicDetailsResponse? response) async {
  //   TGLog.d("GetGstBasicDetailsResponse : onSuccess()");
  //   setState(() {
  //     _basicdetailsResponse = response?.getGstBasicDetailsRes();
  //   });
  //
  //   if (_basicdetailsResponse?.status == RES_DETAILS_FOUND) {
  //     if (_basicdetailsResponse?.data?.isNotEmpty == true) {
  //       if (_basicdetailsResponse?.data?[0].isOtpVerified == true) {
  //         if (_basicdetailsResponse?.data?[0]?.gstin?.isNotEmpty == true) {
  //           if (_basicdetailsResponse!.data![0].gstin!.length >= 12) {
  //             TGSharedPreferences.getInstance().set(PREF_BUSINESSNAME,
  //                 _basicdetailsResponse?.data?[0].gstBasicDetails?.tradeNam);
  //             TGSharedPreferences.getInstance()
  //                 .set(PREF_GSTIN, _basicdetailsResponse?.data?[0].gstin);
  //             TGSharedPreferences.getInstance().set(PREF_USERNAME,
  //                 _basicdetailsResponse?.data?[0].username.toString());
  //             TGSharedPreferences.getInstance().set(PREF_PANNO,
  //                 _basicdetailsResponse?.data?[0].gstin?.substring(2, 12));
  //           } else {
  //             TGSharedPreferences.getInstance()
  //                 .set(PREF_PANNO, _basicdetailsResponse?.data?[0].gstin);
  //           }
  //         }
  //
  //         TGSharedPreferences.getInstance().set(PREF_ISGST_CONSENT, true);
  //         TGSharedPreferences.getInstance().set(PREF_ISGSTDETAILDONE, true);
  //         //getUserLoanDetails();
  //         // Navigator.pushNamed(context, MyRoutes.DashboardWithGSTRoutes);
  //         Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(
  //               builder: (BuildContext context) => DashboardWithGST(),
  //             ),
  //                 (route) => false);
  //       } else {
  //         Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(
  //               builder: (BuildContext context) => GstConsent(),
  //             ),
  //                 (route) => false);
  //
  //         //Navigator.push(context, MaterialPageRoute(builder: (context) => GstConsent()));
  //       }
  //     } else {
  //       if (await TGNetUtil.isInternetAvailable()) {
  //         getUserLoanDetails();
  //       } else {
  //         showSnackBarForintenetConnection(context, getUserLoanDetails);
  //       }
  //     }
  //   } else if (_basicdetailsResponse?.status == RES_DETAILS_NOT_FOUND) {
  //     setState(() {
  //       isGetOTPLoaderStart = false;
  //     });
  //
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //           builder: (BuildContext context) => GstConsent(),
  //         ),
  //             (route) => false);
  //   } else {
  //     setState(() {
  //       isGetOTPLoaderStart = false;
  //     });
  //     LoaderUtils.handleErrorResponse(
  //         context,
  //         response?.getGstBasicDetailsRes().status,
  //         response?.getGstBasicDetailsRes().message,
  //         null);
  //   }
  // }
  //
  // _onErrorGetGstBasicDetails(TGResponse errorResponse) {
  //   setState(() {
  //     isGetOTPLoaderStart = false;
  //   });
  //   TGLog.d("GetGstBasicDetailsResponse : onError()");
  //   handleServiceFailError(context, errorResponse.error);
  // }
  //
  // Future<void> getUserLoanDetails() async {
  //   TGGetRequest tgGetRequest = GetLoanDetailByRefIdReq();
  //   ServiceManager.getInstance().getAllLoanDetailByRefId(
  //       request: tgGetRequest,
  //       onSuccess: (response) => _onSuccessGetAllLoanDetailByRefId(response),
  //       onError: (error) => _onErrorGetAllLoanDetailByRefId(error));
  // }
  //
  // _onSuccessGetAllLoanDetailByRefId(GetAllLoanDetailByRefIdResponse? response) {
  //   TGLog.d("UserLoanDetailsResponse : onSuccess()");
  //   _getAllLoanDetailRes = response?.getAllLoanDetailObj();
  //
  //   if (_getAllLoanDetailRes?.status == RES_SUCCESS) {
  //     if (_getAllLoanDetailRes?.data?.isEmpty == true) {
  //       Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(
  //             builder: (BuildContext context) => GstConsent(),
  //           ),
  //               (route) => false);
  //     } else {
  //       TGSharedPreferences.getInstance()
  //           .set(PREF_GSTIN, _getAllLoanDetailRes?.data?[0].gstin);
  //       TGSharedPreferences.getInstance().set(
  //           PREF_PANNO, _getAllLoanDetailRes?.data?[0].gstin?.substring(2, 12));
  //       TGSharedPreferences.getInstance().set(PREF_ISGST_CONSENT, true);
  //       TGSharedPreferences.getInstance().set(PREF_ISGSTDETAILDONE, true);
  //
  //       Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(
  //             builder: (BuildContext context) => DashboardWithGST(),
  //           ),
  //               (route) => false);
  //     }
  //   } else {
  //     setState(() {
  //       isGetOTPLoaderStart = false;
  //     });
  //     LoaderUtils.handleErrorResponse(
  //         context,
  //         response?.getAllLoanDetailObj().status,
  //         response?.getAllLoanDetailObj().message,
  //         null);
  //   }
  // }
  //
  // _onErrorGetAllLoanDetailByRefId(TGResponse errorResponse) {
  //   TGLog.d("UserLoanDetailsResponse : onError()");
  //   handleServiceFailError(context, errorResponse.error);
  //   setState(() {
  //     isGetOTPLoaderStart = false;
  //   });
  // }





  // Future<void> getLoginOtp() async {
  //   TGSession.getInstance()
  //       .set(SESSION_MOBILENUMBER, mobileTextController.text);
  //
  //   String uuid = Uuid().v1().replaceAll("-", "").substring(0, 16);
  //   CredBlock credBlock =
  //       CredBlock(appToken: uuid, otp: "", otpSessionKey: "", status: "");
  //
  //   RequestAuthUser requestAuthUser = RequestAuthUser(
  //       mobile: mobileTextController.text,
  //       credBlock: credBlock,
  //       deviceId: uuid);
  //   var jsonReq = jsonEncode(requestAuthUser.toJson());
  //
  //   TGLog.d("Get Login OTP Request : $jsonReq");
  //
  //   TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_GETOTP);
  //
  //   ServiceManager.getInstance().getotp(
  //       request: tgPostRequest,
  //       onSuccess: (response) => _onSuccessGetOTP(response),
  //       onError: (error) => _onErrorGetOTP(error));
  // }
  //
  // _onSuccessGetOTP(GetotpResponse? response) {
  //   TGLog.d("RegisterResponse : onSuccess()");
  //
  //   if (response?.getOtpReponseObj()?.status == RES_SUCCESS) {
  //     setState(() {
  //       isGetOTPLoaderStart = false;
  //       getOtpRes = response?.getOtpReponseObj();
  //
  //       TGSession.getInstance().set(
  //           SESSION_OTPSESSIONKEY, getOtpRes?.data?.credBlock?.otpSessionKey);
  //       TGSharedPreferences.getInstance()
  //           .set(PREF_MOBILE, mobileTextController.text);
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => OtpVerifyLogin()));
  //
  //       //   Navigator.pushNamed(context, MyRoutes.OtpVerifyLoginRoutes);
  //     });
  //   } else {
  //     LoaderUtils.handleErrorResponse(
  //         context,
  //         response?.getOtpReponseObj().status ?? 0,
  //         response?.getOtpReponseObj()?.message ?? "",
  //         null);
  //   }
  // }
  //
  // _onErrorGetOTP(TGResponse errorResponse) {
  //   TGLog.d("RegisterResponse : onError()");
  //   handleServiceFailError(context, errorResponse?.error);
  //   isGetOTPLoaderStart = false;
  // }

  // Future<void> verifyLoginOtp() async {
  //   String uuid = const Uuid().v1().replaceAll("-", "").substring(0, 16);
  //   CredBlock credBlock = CredBlock(
  //       appToken: uuid,
  //       otp: otp,
  //       otpSessionKey: getOtpRes?.data?.credBlock?.otpSessionKey,
  //       status: "");
  //
  //   RequestAuthUser requestAuthUser = RequestAuthUser(
  //       mobile: mobileTextController.text,
  //       credBlock: credBlock,
  //       deviceId: uuid);
  //   String jsonReq = jsonEncode(requestAuthUser.toJson());
  //
  //   TGLog.d("Verify-loginOTP Request : $jsonReq");
  //   TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_VERIFY_OTP);
  //
  //   ServiceManager.getInstance().verifyOtp(
  //       request: tgPostRequest,
  //       onSuccess: (response) => _onSuccessVerifyOtp(response),
  //       onError: (error) => _onErrorVerifyOtp(error));
  // }
  //
  // _onSuccessVerifyOtp(VerifyOtpResponse? response) async {
  //   TGLog.d("VerifyOTP : onSuccess()");
  //   verifyOtpResponse = response?.getOtpReponseObj();
  //   // Navigator.pop(context);
  //   if (verifyOtpResponse?.status == RES_SUCCESS) {
  //     TGSharedPreferences.getInstance()
  //         .set(PREF_ACCESS_TOKEN, verifyOtpResponse?.data?.accessToken);
  //     setAccessTokenInRequestHeader();
  //     getGstBasicDetails();
  //   } else {
  //     isVerifyOTPLoaderStart = false;
  //     TGView.showSnackBar(
  //         context: context,
  //         message: verifyOtpResponse?.message ?? "Incorrect Otp entered!");
  //   }
  // }
  //
  // _onErrorVerifyOtp(TGResponse? response) {
  //   TGLog.d("VerifyOTP : onError()");
  //   Navigator.pop(context);
  //   handleServiceFailError(context, response?.error);
  //   isVerifyOTPLoaderStart = false;
  // }


}
