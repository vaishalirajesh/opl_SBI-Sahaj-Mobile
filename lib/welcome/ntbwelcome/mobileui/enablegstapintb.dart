import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/requestmodel/save_consent_request.dart';
import 'package:gstmobileservices/model/responsemodel/save_consent_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/jumpingdot_util.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/internetcheckdialog.dart';
import 'package:sbi_sahay_1_0/welcome/ntbwelcome/mobileui/startregistration.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/Utils.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/constants/statusconstants.dart';
import '../../../utils/progressLoader.dart';
import '../../../utils/strings/strings.dart';
import '../../../widgets/titlebarmobile/titlebarwithoutstep.dart';

class EnableGstApi extends StatelessWidget {
  const EnableGstApi({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return const SafeArea(
          child: EnableGstApiScreen(),
        );
      },
    );
  }
}

class EnableGstApiScreen extends StatefulWidget {
  const EnableGstApiScreen({Key? key}) : super(key: key);

  @override
  State<EnableGstApiScreen> createState() => _EnableGstApiScreenState();
}

class _EnableGstApiScreenState extends State<EnableGstApiScreen> {
  bool isCheckFirst = false;
  bool isCheckSecond = false;
  String uuid = Uuid().v1().replaceAll("-", "").substring(0, 16);
  bool isLoaderStart = false;

  void changestateConfirmViewSecondCheckBox(bool value) {
    setState(() {
      isCheckSecond = value;
    });
  }

  void changestateConfirmViewFirstCheckBox(bool value) {
    setState(() {
      isCheckFirst = value;
    });
  }

  @override
  void initState() {
    getDeviceInfo();
    super.initState();
  }

  Future<void> getDeviceInfo() async {}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        SystemNavigator.pop(animated: true);
        return true;
      },
      child: Scaffold(
        appBar: getAppBarWithBackBtn(
            onClickAction: () => {Navigator.pop(context, false), SystemNavigator.pop(animated: true)}),
        body: SingleChildScrollView(
          primary: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSetupView(),
            ],
          ),
        ),
        bottomNavigationBar: buildBottomView(),
      ),
    );
  }

  Widget buildBottomView() {
    return Container(
      color: ThemeHelper.getInstance()!.backgroundColor,
      height: 200.h,
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            SizedBox(
              height: 20.h,
            ),
            buildConfirmViewBottomText(),
            SizedBox(
              height: 30.h,
            ),
            buildConfirmButton(context),
          ],
        ),
      ),
    );
  }

  Widget buildSetupView() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildConfirmViewTitle(str_confirmView_title),
          buildImageContainer(IMG_TWO_PERSON),
          buildCheckboxWidgetConfirm(),
        ],
      ),
    );
  }

  Widget buildConfirmViewTitle(String text) => Padding(
        padding: EdgeInsets.only(top: 15.h, bottom: 70.h),
        child: Text(
          text,
          style: ThemeHelper.getInstance()!.textTheme.headline1!.copyWith(fontSize: 16.sp, color: MyColors.darkblack),
          // textAlign: TextAlign.left,
        ),
      );

  buildImageContainer(String path) => Padding(
        padding: EdgeInsets.only(bottom: 70.h, top: 10.h),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            // height: 240.h,
            // width: 230.w,
            decoration: BoxDecoration(
              color: ThemeHelper.getInstance()!.cardColor,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              Utils.path(IMG_TWO_PERSON),
              // width: 100.w,
              // height: 80.h,
            ),
          ),
        ),
      );

  Widget buildCheckboxWidgetConfirm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 20.w,
              height: 20.h,
              child: Theme(
                data: ThemeData(useMaterial3: true),
                child: Checkbox(
                  // checkColor: MyColors.colorAccent,
                  activeColor: ThemeHelper.getInstance()?.primaryColor,
                  value: isCheckFirst,
                  onChanged: (value) {
                    changestateConfirmViewFirstCheckBox(value!);
                    setState(() {});
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(2.r),
                    ),
                  ),
                  side: BorderSide(
                      width: 1,
                      color: isCheckFirst
                          ? ThemeHelper.getInstance()!.primaryColor
                          : ThemeHelper.getInstance()!.primaryColor),
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  changestateConfirmViewFirstCheckBox(!isCheckFirst);
                  setState(() {});
                },
                child: Text(
                  str_confirm_check1,
                  style: ThemeHelper.getInstance()!
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 14.sp, color: MyColors.lightBlackText),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 20.w,
              height: 20.h,
              child: Theme(
                data: ThemeData(useMaterial3: true),
                child: Checkbox(
                  // checkColor: MyColors.colorAccent,
                  activeColor: ThemeHelper.getInstance()?.primaryColor,
                  value: isCheckSecond,
                  onChanged: (value) {
                    changestateConfirmViewSecondCheckBox(value!);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(2.r),
                    ),
                  ),
                  side: BorderSide(
                      width: 1,
                      color: isCheckSecond
                          ? ThemeHelper.getInstance()!.primaryColor
                          : ThemeHelper.getInstance()!.primaryColor),
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  changestateConfirmViewSecondCheckBox(!isCheckSecond);
                  setState(() {});
                },
                child: Text(str_confirm_check2,
                    style: ThemeHelper.getInstance()!
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14.sp, color: MyColors.lightBlackText),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget buildConfirmViewBottomText() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: str_confirm_bottom1,
              style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp, color: MyColors.black),
            ),
            TextSpan(
                text: str_confirm_bottom2,
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .headline3!
                    .copyWith(fontSize: 14.sp, color: MyColors.hyperlinkcolornew, decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showGeneralDialog(
                      context: context,
                      barrierColor: Colors.white,
                      barrierDismissible: false,
                      barrierLabel: 'Dialog',
                      transitionDuration: Duration(milliseconds: 400),
                      pageBuilder: (_, __, ___) {
                        return GstApiSteps();
                      },
                    );
                  }),
            TextSpan(
                text: str_confirm_bottom3,
                style:
                    ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp, color: MyColors.black)),
            TextSpan(
                text: str_confirm_bottom4,
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .headline3!
                    .copyWith(fontSize: 14.sp, color: MyColors.hyperlinkcolornew, decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri.parse("https://www.youtube.com/watch?v=vcxK5Ppd4R4"));
                  }),
            TextSpan(
                text: str_confirm_bottom5,
                style:
                    ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp, color: MyColors.black)),
            TextSpan(
                text: str_confirm_bottom6,
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .headline3!
                    .copyWith(fontSize: 14.sp, color: MyColors.hyperlinkcolornew, decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri.parse("https://services.gst.gov.in/services/login"));
                  }),
            TextSpan(
                text: str_confirm_bottom7,
                style:
                    ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp, color: MyColors.black)),
          ],
        ),
      ),
    );
  }

  Widget buildConfirmButton(BuildContext context) {
    return isLoaderStart
        ? SizedBox(
            height: 50.h,
            child: JumpingDots(
              color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary,
              radius: 10,
            ),
          )
        : AppButton(
            onPress: () {
              if (isCheckFirst && isCheckSecond) {
                onPressConfirm();
              }
            },
            title: str_Confirm,
            isButtonEnable: isCheckFirst && isCheckSecond,
          );
  }

  void onPressConfirm() async {
    setState(() {
      isLoaderStart = true;
    });
    if (isCheckFirst && isCheckSecond) {
      if (await TGNetUtil.isInternetAvailable()) {
        onUpdateConstitutionChecked();
      } else {
        showSnackBarForintenetConnection(context, onUpdateConstitutionChecked);
      }
    }
  }

  Future<void> onUpdateConstitutionChecked() async {
    RequestSaveConsent requestSaveConsent = RequestSaveConsent(
      appVersion: "1.0",
      consentApprovalType: CONSENT_TYPE_USR_TYP_CONFIRM,
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
    TGLog.d("SaveConstitutionConsent() : Success");
    if (response.saveConsentMainObj().status == RES_SUCCESS) {
      if (await TGNetUtil.isInternetAvailable()) {
        onUpdateGstCheckBox();
      } else {
        showSnackBarForintenetConnection(context, onUpdateGstCheckBox);
      }
    } else if (response.saveConsentMainObj().status == RES_UNAUTHORISED) {
      setState(() {
        isLoaderStart = false;
      });
      TGView.showSnackBar(context: context, message: response.saveConsentMainObj().message ?? "");
    } else {
      // isButtonChecked.value = false;
      LoaderUtils.handleErrorResponse(
          context, response.saveConsentMainObj().status, response.saveConsentMainObj().message, null);
      setState(() {
        isLoaderStart = false;
      });
    }
  }

  _onErrorSaveConsent(TGResponse errorResponse) {
    isCheckSecond = false;
    setState(() {
      isLoaderStart = false;
    });
    TGLog.d("SaveConstitutionConsent() : Error");
  }

  Future<void> onUpdateGstCheckBox() async {
    RequestSaveConsent requestSaveConsent = RequestSaveConsent(
      appVersion: "1.0",
      consentApprovalType: CONSENT_TYPE_GST_API_ACCESS,
      deviceId: uuid,
      deviceOs: '',
      deviceOsVersion: '',
      deviceType: '',
      isConsentApproval: true,
      mobileFcmToken: "",
    );
    var payload = await getPayLoad(jsonEncode(requestSaveConsent.toJson()), URI_CONSENT_APPROVAL);
    ServiceManager.getInstance().saveConsent(
        request: payload,
        onSuccess: (response) => _onSuccessSaveConsentForGST(response),
        onError: (errorResponse) => _onErrorSaveConsent2(errorResponse));
  }

  _onSuccessSaveConsentForGST(SaveConsentApprovalResponse response) {
    TGLog.d("SaveGSTConsent() : Success");
    if (response.saveConsentMainObj().status == RES_SUCCESS) {
      TGSharedPreferences.getInstance().set(PREF_ISTC_DONE, true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const StartRegistrationNtb(),
        ),
      );
    } else if (response.saveConsentMainObj().status == RES_UNAUTHORISED) {
      setState(() {
        isLoaderStart = false;
      });
      TGView.showSnackBar(context: context, message: response.saveConsentMainObj().message ?? "");
    } else {
      LoaderUtils.handleErrorResponse(
          context, response.saveConsentMainObj().status, response.saveConsentMainObj().message, null);
      setState(() {
        isLoaderStart = false;
      });
    }
  }

  _onErrorSaveConsent2(TGResponse errorResponse) {
    isCheckFirst = false;
    setState(() {
      isLoaderStart = false;
    });
    TGLog.d("SaveGSTConsent() : Error");
  }
}

class GstApiSteps extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GstApiStepsState();
}

class _GstApiStepsState extends State<GstApiSteps> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: SafeArea(
          child: Scaffold(
        backgroundColor: MyColors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.h),
          child: Container(
            height: 80.h,
            decoration: BoxDecoration(color: ThemeHelper.getInstance()!.colorScheme.background, boxShadow: [
              BoxShadow(
                color: ThemeHelper.getInstance()!.dividerColor,
                offset: const Offset(0, 2.0),
                blurRadius: 4.0,
              )
            ]),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20.w,
                  ),
                  Icon(
                    Icons.close,
                    size: 25.h,
                    color: MyColors.black,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    "Steps",
                    style: ThemeHelper.getInstance()?.textTheme.displayLarge?.copyWith(color: MyColors.black),
                  )
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: ThemeHelper.getInstance()!.colorScheme.background,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        Utils.path(SAHAYLOGO),
                        height: 50.h,
                        width: 90.w,
                      ),
                      Icon(
                        Icons.search_rounded,
                        size: 30.h,
                        color: MyColors.PnbGrayTextColor,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      str_enable_gst_api,
                      style: ThemeHelper.getInstance()?.textTheme.displayLarge,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    _apiStepUi(str_gst_api_step1),
                    SizedBox(
                      height: 20.h,
                    ),
                    _apiStepUi(str_gst_api_step2),
                    SizedBox(
                      height: 20.h,
                    ),
                    _apiStepUi(str_gst_api_step3),
                    SizedBox(
                      height: 20.h,
                    ),
                    _apiStepUi(str_gst_api_step4),
                    SizedBox(
                      height: 20.h,
                    ),
                    _apiStepUi(str_gst_api_step5),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  String str_enable_gst_api = 'How to Enable API Access in Your GST Account?';

  String str_gst_api_step1 =
      'Visit www.gst.gov.in, click on the "login" button and insert your credential to log in to your GST account.';
  String str_gst_api_step2 = 'After logging in, click on the "View Profile" link located on the right side.';
  String str_gst_api_step3 = 'Under Quick links, click on the "Manage API Access" link.';
  String str_gst_api_step4 =
      'Click on the "Yes" button next to the "Enable API Request", select "Duration" from the dropdown provided and click on "Confirm" button.';
  String str_gst_api_step5 =
      'Insert your GST Number and Username, you will receive OTP on the mobile number registered with GST Account.';

  Widget _apiStepUi(String step) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          str_ol,
          style: ThemeHelper.getInstance()?.textTheme.displayMedium,
        ),
        SizedBox(
          width: 5.w,
        ),
        Flexible(
            child: Text(
          step,
          style: ThemeHelper.getInstance()?.textTheme.displayMedium,
        )),
      ],
    );
  }
}
