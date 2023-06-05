import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/common/tg_log.dart';
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
import 'package:sbi_sahay_1_0/loanprocess/mobile/refreshgstinvoice/refreshgstotpverify.dart';

import '../../../utils/Utils.dart';
import '../../../utils/colorutils/mycolors.dart';
import '../../../utils/constants/prefrenceconstants.dart';
import '../../../utils/constants/session_keys.dart';
import '../../../utils/constants/statusConstants.dart';
import '../../../utils/erros_handle.dart';
import '../../../utils/helpers/themhelper.dart';
import '../../../utils/internetcheckdialog.dart';
import '../../../utils/jumpingdott.dart';
import '../../../utils/progressLoader.dart';
import '../../../utils/strings/strings.dart';
import '../../../widgets/titlebarmobile/titlebarwithoutstep.dart';

class RefreshGstUsername extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(child: GstUsernameScreen());
      },
    );
  }
}

class GstUsernameScreen extends StatefulWidget {
  const GstUsernameScreen({Key? key}) : super(key: key);

  @override
  State<GstUsernameScreen> createState() => _GstUsernameScreenState();
}

class _GstUsernameScreenState extends State<GstUsernameScreen> {
  GstOtpResponseMain? _gstOtpResponse;

  TextEditingController gstUsernameController = TextEditingController();
  TextEditingController gstinNoController = TextEditingController();

  bool flag = false;
  bool isValidGSTUserName = false;
  bool isValidGSTINNumber = false;
  bool isSetLoader = false;

  @override
  Widget build(BuildContext context) {
    return SetGstDetailContent(context);
  }

  Widget SetGstDetailContent(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: getAppBarWithStep('1', str_registration, 0.25,
            onClickAction: () => {}),
        body: Padding(
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
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6.r)),
                    borderSide: BorderSide(
                        width: 1,
                        color:
                            ThemeHelper.getInstance()!.colorScheme.onSurface),
                  ),
                  focusedBorder: OutlineInputBorder(
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
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.r)),
                borderSide: BorderSide(
                    width: 1,
                    color: ThemeHelper.getInstance()!.colorScheme.onSurface),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ThemeHelper.getInstance()!.colorScheme.onSurface,
                    width: 1.0),
                borderRadius: BorderRadius.circular(6.0.r),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1,
                      color: ThemeHelper.getInstance()!.colorScheme.onSurface),
                  borderRadius: BorderRadius.all(Radius.circular(6.r))),
              counterText: ''),
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            UpperCaseTextFormatter(),
            FilteringTextInputFormatter.allow(RegExp("(?!^ +\$)^[A-Z0-9 _]+\$"),
                replacementString: ""),
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
            onPressed: () async {
              if (gstinNoController.text.isNotEmpty &&
                  gstUsernameController.text.isNotEmpty &&
                  isValidGSTINNumber) {
                setState(() {
                  isSetLoader = true;
                  TGSharedPreferences.getInstance()
                      .set(PREF_GSTIN, gstinNoController.text);
                  TGSharedPreferences.getInstance()
                      .set(PREF_PANNO, gstinNoController.text.substring(2, 12));
                });

                if (await TGNetUtil.isInternetAvailable()) {
                  getGstOtp();
                } else {
                  showSnackBarForintenetConnection(context, getGstOtp);
                }
              }
            },
            child: Text(str_next));
  }

  void display() {
    setState(() {
      flag = true;
    });
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
      TGSession.getInstance()
          .set(SESSION_OTPSESSIONKEY, _gstOtpResponse?.data?.sessionKey);
      setState(() {
        isSetLoader = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RefreshGstOtpVerify(),
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
