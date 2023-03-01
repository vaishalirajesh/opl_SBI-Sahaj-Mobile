import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/fetch_gst_data_res_main.dart';
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
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:sbi_sahay_1_0/registration/mobile/gst_detail/gstotpverify.dart';
import 'package:sbi_sahay_1_0/routes.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusconstants.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';

import '../../../utils/Utils.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/constants/prefrenceconstants.dart';
import '../../../utils/constants/session_keys.dart';
import '../../../utils/erros_handle.dart';
import '../../../utils/helpers/themhelper.dart';
import '../../../utils/internetcheckdialog.dart';
import '../../../utils/jumpingdott.dart';
import '../../../utils/progressLoader.dart';
import '../../../utils/showcustomesnackbar.dart';
import '../../../utils/strings/strings.dart';
import '../../../widgets/otp_textfield_widget.dart';
import '../confirm_details/confirm_details.dart';

class GstDetailMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(child: GstDetailScreen());
      },
    );
  }
}

class GstDetailScreen extends StatefulWidget {
  const GstDetailScreen({Key? key}) : super(key: key);

  @override
  State<GstDetailScreen> createState() => _GstDetailScreenState();
}

class _GstDetailScreenState extends State<GstDetailScreen> {
  GstOtpResponseMain? _gstOtpResponse;
  GstOtpResponseMain? _verifyOtpResponse;

  TextEditingController gstUsernameController = TextEditingController();
  TextEditingController gstinNoController = TextEditingController();

  TextEditingController gstinOTPController = TextEditingController();

  bool isgstopshown = false;

  bool ispopupshow = false;

  bool isLoader = false;
  bool isSetLoader = false;
  bool flag = false;
  bool isValidGSTUserName = false;
  bool isValidGSTINNumber = false;

  String otp = '';
  bool isValidOTP = false;

  String firstletter = "";
  String secondletter = "";
  String thirdletter = "";
  String forthletter = "";
  String fifthletter = "";
  String sixthletter = "";
  final List<FocusNode?> _focusNodes =
      List<FocusNode?>.filled(6, null, growable: false);

  FetchGstDataResMain? _fetchGstDataResMain;

  bool isClearOtp = false;

  @override
  Widget build(BuildContext context) {
    return SetGstDetailContent(context);
  }

  Widget SetGstDetailContent(BuildContext context) {
    // if (isSetLoader) {
    //   return MobileLoaderWithoutProgess(
    //       context,
    //       Utils.path(LOANOFFERLOADER),
    //       str_Fetching_your_GST_business_details,
    //       str_Kindly_wait_for_60s);
    // } else {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        SystemNavigator.pop(animated: true);
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: getAppBarWithStepDone('1', str_registration, 0.25,
            onClickAction: () =>
                {Navigator.pop(context), SystemNavigator.pop(animated: true)}),
        body: AbsorbPointer(
          absorbing: isSetLoader,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._buildHeader(),
                  _buildMiddler(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    //}
  }

  _buildHeader() {
    return [
      Padding(
        padding: EdgeInsets.only(top: 30.0.h, bottom: 9.h),
        child: Text(
          str_Enter_GST_Details,
          style: ThemeHelper.getInstance()!.textTheme.headline1,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          bottom: 20.0.h,
        ),
        child: Text(
          str_Kindly_enter_your_GST_Username_GSTIN_to_link_with_Sahay_GST_Account,
          style: ThemeHelper.getInstance()!.textTheme.headline3,
        ),
      )
    ];
  }

  _buildMiddler() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            display();
          },
          child: TextFormField(
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline3!
                  .copyWith(color: MyColors.pnbcolorPrimary),
              onChanged: (content) {
                CheckValidGSTUserName();
              },
              controller: gstUsernameController,
              cursorColor: ThemeHelper.getInstance()!.colorScheme.onSurface,
              decoration: InputDecoration(
                  hintText: str_GST_User_Name,
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
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color:
                              ThemeHelper.getInstance()!.colorScheme.onSurface),
                      borderRadius: BorderRadius.all(Radius.circular(6.r))),
                  counterText: ''),
              keyboardType: TextInputType.text,
              maxLength: 15,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter User name';
                }
                return null;
              }),
        ),
        isValidGSTUserName ? gstNumberField() : Container(),
        isValidGSTUserName ? nextButton() : Container(),
      ],
    );
  }

  Widget gstNumberField() {
    return Column(children: [
      SizedBox(
        height: 10.h,
      ),
      TextFormField(
          style: ThemeHelper.getInstance()!
              .textTheme
              .headline3!
              .copyWith(color: MyColors.pnbcolorPrimary),
          onChanged: (content) {
            CheckValidGSTInNumber();
          },
          controller: gstinNoController,
          cursorColor: ThemeHelper.getInstance()!.colorScheme.onSurface,
          decoration: InputDecoration(
              hintText: str_15_Digit_GSTIN,
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.r)),
                borderSide: BorderSide(
                    width: 1,
                    color: ThemeHelper.getInstance()!.colorScheme.onSurface),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: ThemeHelper.getInstance()!.colorScheme.onSurface,
                    width: 1.0),
                borderRadius: BorderRadius.circular(6.0.r),
              ),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(
                      width: 1,
                      color: ThemeHelper.getInstance()!.colorScheme.onSurface),
                  borderRadius: BorderRadius.all(Radius.circular(6.r))),
              counterText: ''),
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            UpperCaseTextFormatter(),
            FilteringTextInputFormatter.allow(RegExp("(?!^ +\$)^[A-Z0-9 _]+\$"))
          ],
          maxLength: 15,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter GSTIN number';
            }
            return null;
          }),
      SizedBox(
        height: 10.h,
      ),
      Text(str_Sample_20AAAAAA1234AA1Z5),
      SizedBox(
        height: 30.h,
      ),
    ]);
  }

  Widget nextButton() {
    return isSetLoader
        ? JumpingDots(
            color: ThemeHelper.getInstance()?.primaryColor ??
                MyColors.pnbcolorPrimary,
            radius: 10,
          )
        : ElevatedButton(
            style: gstinNoController.text.isNotEmpty && isValidGSTINNumber
                ? ThemeHelper.getInstance()!.elevatedButtonTheme.style
                : ThemeHelper.setPinkDisableButtonBig(),
            onPressed: () {

              Navigator.pushNamed(
                  context,
                  MyRoutes.OtpVerifyGSTRoutes);
              // if (gstinNoController.text.isNotEmpty &&
              //     gstUsernameController.text.isNotEmpty &&
              //     isValidGSTINNumber) {

                // setState(() async {
                //   isSetLoader = true;
                //   TGSharedPreferences.getInstance()
                //       .set(PREF_GSTIN, gstinNoController.text);
                //   TGSharedPreferences.getInstance()
                //       .set(PREF_PANNO, gstinNoController.text.substring(2, 12));
                //   if (await TGNetUtil.isInternetAvailable()) {
                //     getGstOtp();
                //   } else {
                //     showSnackBarForintenetConnection(context, getGstOtp);
                //   }
                // });
             // }
            },
            child: Text(str_next));
  }

  _buildBottomSheet() {
    return Padding(
      padding: EdgeInsets.only(bottom: 49.h),
      child: Container(
        width: 133.w,
        height: 23.h,
        alignment: Alignment.center,
        child: Image.asset(
          Utils.path(MOBILEGoodAndService),
          height: 23.h,
          width: 133.w,
        ),
      ),
    );
  }

  // void _modalBottomSheetMenu() {
  //
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return StatefulBuilder(
  //             builder: (BuildContext context, StateSetter setModelState) {
  //               return Wrap(children: [BottomPopupTC(setModelState)]);});
  //
  //       },
  //       shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(25), topRight: Radius.circular(25))),
  //       clipBehavior: Clip.antiAlias,
  //       isScrollControlled: true);
  // }
  //
  // Widget BottomPopupTC(StateSetter setModelState) {
  //   return Padding(
  //     padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
  //     child: Container(
  //       decoration: new BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: new BorderRadius.only(
  //               topLeft: const Radius.circular(50.0),
  //               topRight: const Radius.circular(
  //                   50.0))), //could change this to Color(0xFF737373),
  //       //so you don't have to change MaterialApp canvasColor
  //       child: Container(
  //           decoration: new BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: new BorderRadius.only(
  //                   topLeft: const Radius.circular(50.0),
  //                   topRight: const Radius.circular(50.0))),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               SizedBox(
  //                 height: 30.h,
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 20.0.w),
  //                 child: Text(
  //                   str_Verify_GSTIN,
  //                   style: ThemeHelper
  //                       .getInstance()!
  //                       .textTheme
  //                       .headline1,
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 11.h,
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 20.0.w),
  //                 child: Text(
  //                   str_OTP_sent + gstinNoController.text,
  //                   style: ThemeHelper
  //                       .getInstance()!
  //                       .textTheme
  //                       .headline3!
  //                       .copyWith(fontSize: 15.sp),
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 31.h,
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     str_enter_6_Digit,
  //                     style: ThemeHelper
  //                         .getInstance()!
  //                         .textTheme
  //                         .headline4,
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(
  //                 height: 16.h,
  //               ),
  //               SetUpOtpTextFieldForGSTDetail(setModelState),
  //               SizedBox(
  //                 height: 16.h,
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     str_Didnt_received_OTP_yet,
  //                     style: ThemeHelper
  //                         .getInstance()!
  //                         .textTheme
  //                         .bodyText1!
  //                         .copyWith(
  //                         fontSize: 14.sp, color: MyColors.pnbGreyColor),
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(
  //                 height: 11.h,
  //               ),
  //               GestureDetector(
  //                 onTap: () {
  //                   Navigator.pop(context);
  //                   getGstOtp();
  //                 },
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     SvgPicture.asset(
  //                       Utils.path(MOBILEResend),
  //                       height: 16.h,
  //                       width: 16.w,
  //                     ),
  //                     SizedBox(
  //                       width: 9.w,
  //                     ),
  //                     Text(str_Resend_OTP, style: ThemeHelper
  //                         .getInstance()!
  //                         .textTheme
  //                         .headline2!
  //                         .copyWith(
  //                         fontSize: 16.sp, color: MyColors.pnbcolorPrimary))
  //                   ],
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 30.h,
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 20.w),
  //                 child:isLoader ? JumpingDots(color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary, radius: 10,) : ElevatedButton(
  //                   style: isValidOTP
  //                       ? ThemeHelper.getInstance()!.elevatedButtonTheme.style
  //                       : ThemeHelper.setPinkDisableButtonBig(),
  //                   onPressed: () {
  //                     setModelState(() {
  //                       if (isValidOTP) {
  //                         isShowLaoder();
  //                         verifyGstOtp();
  //                       }
  //                     });
  //
  //                   },
  //                   child: Text(str_Verify),
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 52.h,
  //               )
  //             ],
  //           )),
  //     ),
  //   );
  // }

  Widget SetUpOtpTextFieldForGSTDetail(StateSetter setModelState) {
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

  void display() {
    setState(() {
      flag = true;
    });
  }

  void setFocus(int position) {
    const maxIndex = 5;
    if (position > maxIndex) {
      throw Exception(
          "Provided position is out of bounds for the OtpTextField");
    }
    final focusNode = _focusNodes[position];

    if (focusNode != null) {
      focusNode.requestFocus();
    }
  }

  void setIsLoader() {
    Future.delayed(Duration(seconds: 0), () {
      setState(() {
        isSetLoader = true;
      });
    });
  }

  void checkOtp() {
    isValidOTP = firstletter.isNotEmpty &&
        secondletter.isNotEmpty &&
        thirdletter.isNotEmpty &&
        forthletter.isNotEmpty &&
        fifthletter.isNotEmpty &&
        sixthletter.isNotEmpty;
    setState(() {});
  }

  void changeState() {
    setState(() {
      isgstopshown = true;
    });
  }

  void changeStateisgstopshownFalse() {
    setState(() {
      isgstopshown = false;
    });
  }

  void isShowLaoder() {
    setState(() {
      isLoader = true;
    });
  }

  void HideLaoder() {
    setState(() {
      isLoader = false;
    });
  }

  void showpopup() {
    setState(() {
      ispopupshow = true;
    });
  }

  void removepopup() {
    setState(() {
      ispopupshow = false;
    });
  }

  void navigateToGstDetailScreen() {
    // Navigator.pushNamed(context, MyRoutes.LoaderFetchGstDetailsRoutes);
//      Navigator.pushNamed(context, MyRoutes.confirmGSTDetailRoutes);
    // Navigator.of(context).push(CustomRightToLeftPageRoute(child: GstBasicDetails(), ));
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GstBasicDetails(),
        ));
  }

  void CheckValidGSTUserName() {
    //final alphanumeric = RegExp(r'^.*[!&^%$#@*()/]+.*$');
    setState(() {
      if (gstUsernameController.text.isNotEmpty) {
        isValidGSTUserName = true;
      } else {
        isValidGSTUserName = false;
      }
    });
  }

  void CheckValidGSTInNumber() {
    setState(() {
      final alphanumeric =
          RegExp('\\d{2}[A-Z]{5}\\d{4}[A-Z]{1}[A-Z\\d]{1}[Z]{1}[A-Z\\d]{1}');
      if (alphanumeric.hasMatch(gstinNoController.text) &&
          gstinNoController.text.isNotEmpty &&
          gstinNoController.text.length == 15) {
        isValidGSTINNumber = true;
      } else {
        isValidGSTINNumber = false;
      }
    });
  }

  bool isValidGstUserName(BuildContext context) {
    if (gstUsernameController.text.isEmpty) {
      showSnackBar(context, "Please Enter gst user Name");
      return false;
    } else if (gstUsernameController.text.length <= 5) {
      showSnackBar(context, "Please Valid gst user Name");
      return false;
    }

    return true;
  }

  bool isValidGstInNumber(BuildContext context) {
    if (gstinNoController.text.isEmpty) {
      showSnackBar(context, "Please Enter gst number");
      return false;
    } else if (gstinNoController.text.length <= 14) {
      showSnackBar(context, "Please Valid gst number");
      return false;
    }
    return true;
  }

  Future<void> getGstOtp() async {
    TGSession.getInstance().set("otp_gstin", gstinNoController.text);
    TGSession.getInstance()
        .set("otp_GSTINUserName", gstUsernameController.text); //"";

    GstOtpRequest gstOtpRequest = GstOtpRequest(
        id: gstinNoController.text,
        userName: gstUsernameController.text,
        requestType: 'OTPREQUEST');

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
      //    Navigator.of(context).push(CustomRightToLeftPageRoute(child: OtpVerifyGST(), ));
      TGSession.getInstance()
          .set(SESSION_OTPSESSIONKEY, _gstOtpResponse?.data?.sessionKey);
      setState(() {
        isSetLoader = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerifyGST(),
          ));
      //_modalBottomSheetMenu();
    } else if (_gstOtpResponse?.status == RES_GST_APIDENIED) {
      TGView.showSnackBar(context: context, message: "Please enable GST API");
      setState(() {
        isSetLoader = false;
      });
    } else {
      LoaderUtils.handleErrorResponse(
          context,
          response?.getOtpReponseObj().status,
          response?.getOtpReponseObj().message,
          null);
      setState(() {
        isSetLoader = false;
      });
    }
  }

  _onErrorGetGstOTP(TGResponse errorResponse) {
    TGLog.d("RegisterResponse : onError()");
    setState(() {
      isSetLoader = false;
      handleServiceFailError(context, errorResponse.error);
    });
  }

}
