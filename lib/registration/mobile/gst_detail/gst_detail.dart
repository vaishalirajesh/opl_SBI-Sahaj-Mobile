import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/fetch_gst_data_res_main.dart';
import 'package:gstmobileservices/model/models/get_gst_otp_res_main.dart';
import 'package:gstmobileservices/model/requestmodel/get_gst_otp_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_gst_otp_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_session.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:sbi_sahay_1_0/registration/mobile/gst_detail/gstotpverify.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusconstants.dart';
import 'package:sbi_sahay_1_0/utils/internetcheckdialog.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';

import '../../../utils/Utils.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/constants/session_keys.dart';
import '../../../utils/erros_handle.dart';
import '../../../utils/helpers/themhelper.dart';
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
  final List<FocusNode?> _focusNodes = List<FocusNode?>.filled(6, null, growable: false);

  FetchGstDataResMain? _fetchGstDataResMain;

  bool isClearOtp = false;

  @override
  void initState() {
    // pinController = TextEditingController(text: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return setGstDetailContent(context);
  }

  Widget setGstDetailContent(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        SystemNavigator.pop(animated: true);
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: getAppBarWithStepDone('1', str_registration, 0.25,
            onClickAction: () => {Navigator.pop(context), SystemNavigator.pop(animated: true)}),
        body: AbsorbPointer(
          absorbing: isLoader,
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
          style: ThemeHelper.getInstance()!.textTheme.headline2,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          bottom: 20.0.h,
        ),
        child: Text(
          str_Kindly_enter_your_GST_Username_GSTIN_to_link_with_Sahay_GST_Account,
          style: ThemeHelper.getInstance()!.textTheme.headline3?.copyWith(fontSize: 14.sp),
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
              style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp),
              onChanged: (content) {
                CheckValidGSTUserName();
              },
              controller: gstUsernameController,
              cursorColor: ThemeHelper.getInstance()!.colorScheme.onSurface,
              decoration: InputDecoration(
                  labelStyle: TextStyle(color: MyColors.lightGraySmallText),
                  labelText: str_GST_User_Name,
                  suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.info_outline,
                        color: MyColors.lightGraySmallText,
                      )),
                  //hintText: str_GST_User_Name,
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
              maxLength: 15,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter User name';
                }
                return null;
              }),
        ),
        isValidGSTUserName ? gstNumberField() : Container(),
        SizedBox(
          height: 30.h,
        ),
        nextButton(),
      ],
    );
  }

  Widget gstNumberField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 10.h,
      ),
      TextFormField(
          style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 16.sp),
          onChanged: (content) {
            CheckValidGSTInNumber();
          },
          controller: gstinNoController,
          cursorColor: ThemeHelper.getInstance()!.colorScheme.onSurface,
          decoration: InputDecoration(
              labelStyle: TextStyle(color: MyColors.lightGraySmallText),
              labelText: str_15_Digit_GSTIN,
              // hintText: str_15_Digit_GSTIN,
              enabledBorder: UnderlineInputBorder(
                //borderRadius: BorderRadius.all(Radius.circular(6.r)),
                borderSide: BorderSide(width: 1, color: ThemeHelper.getInstance()!.colorScheme.onSurface),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ThemeHelper.getInstance()!.colorScheme.onSurface, width: 1.0),
                //borderRadius: BorderRadius.circular(6.0.r),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(width: 1, color: ThemeHelper.getInstance()!.colorScheme.onSurface),
                //borderRadius: BorderRadius.all(Radius.circular(6.r))
              ),
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
      Text(
        str_Sample_20AAAAAA1234AA1Z5,
        style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(fontSize: 12.sp),
      ),
      SizedBox(
        height: 30.h,
      ),
    ]);
  }

  Widget nextButton() {
    return isLoader
        ? JumpingDots(
            color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary,
            radius: 10,
          )
        : AppButton(
            onPress: gstinNoController.text.isNotEmpty && isValidGSTINNumber ? onPressNextButton : () {},
            title: str_next,
            isButtonEnable: gstinNoController.text.isNotEmpty && isValidGSTINNumber,
          );
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

  Widget SetUpOtpTextFieldForGSTDetail(StateSetter setModelState) {
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
        style: TextStyle(color: ThemeHelper.getInstance()?.colorScheme.primary),
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
      throw Exception("Provided position is out of bounds for the OtpTextField");
    }
    final focusNode = _focusNodes[position];

    if (focusNode != null) {
      focusNode.requestFocus();
    }
  }

  void setIsLoader() {
    Future.delayed(Duration(seconds: 0), () {
      setState(() {
        isLoader = true;
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
      final alphanumeric = RegExp('\\d{2}[A-Z]{5}\\d{4}[A-Z]{1}[A-Z\\d]{1}[Z]{1}[A-Z\\d]{1}');
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

  void onPressNextButton() async {
    if (gstinNoController.text.isNotEmpty && gstUsernameController.text.isNotEmpty && isValidGSTINNumber) {
      _isShowLoader();
      TGSharedPreferences.getInstance().set(PREF_GSTIN, gstinNoController.text);
      TGSharedPreferences.getInstance().set(PREF_PANNO, gstinNoController.text.substring(2, 12));
      if (await TGNetUtil.isInternetAvailable()) {
        getGstOtp();
      } else {
        if (context.mounted) {
          showSnackBarForintenetConnection(context, getGstOtp);
        }
      }
    }
  }

  Future<void> getGstOtp() async {
    TGSession.getInstance().set("otp_gstin", gstinNoController.text);
    TGSession.getInstance().set("otp_GSTINUserName", gstUsernameController.text); //"";

    GstOtpRequest gstOtpRequest =
        GstOtpRequest(id: gstinNoController.text, userName: gstUsernameController.text, requestType: 'OTPREQUEST');

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
      TGSession.getInstance().set(SESSION_OTPSESSIONKEY, _gstOtpResponse?.data?.sessionKey);
      setState(() {
        isLoader = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OtpVerifyGST(),
        ),
      );
      //_modalBottomSheetMenu();
    } else if (_gstOtpResponse?.status == RES_GST_APIDENIED) {
      TGView.showSnackBar(context: context, message: "Please enable GST API");
      setState(() {
        isLoader = false;
      });
    } else {
      LoaderUtils.handleErrorResponse(
          context, response?.getOtpReponseObj().status, response?.getOtpReponseObj().message, null);
      setState(() {
        isLoader = false;
      });
    }
  }

  _onErrorGetGstOTP(TGResponse errorResponse) {
    TGLog.d("RegisterResponse : onError()");
    setState(() {
      isLoader = false;
      handleServiceFailError(context, errorResponse.error);
    });
  }

  void _isShowLoader() {
    setState(() {
      isLoader = true;
    });
  }

  void _hideLaoder() {
    setState(() {
      isLoader = false;
    });
  }
}
