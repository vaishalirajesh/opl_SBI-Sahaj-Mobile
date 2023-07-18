import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/save_consent_main.dart';
import 'package:gstmobileservices/model/requestmodel/save_consent_request.dart';
import 'package:gstmobileservices/model/responsemodel/save_consent_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:sbi_sahay_1_0/registration/mobile/gst_detail/gst_detail.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/imageconstant.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusconstants.dart';
import 'package:sbi_sahay_1_0/utils/erros_handle.dart';
import 'package:sbi_sahay_1_0/utils/internetcheckdialog.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';

import '../../../utils/constants/prefrenceconstants.dart';
import '../../../utils/helpers/themhelper.dart';
import '../../../utils/jumpingdott.dart';
import '../../../utils/progressLoader.dart';
import '../../../utils/strings/strings.dart';
import '../../../widgets/titlebarmobile/titlebarwithoutstep.dart';

class GstConsent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(child: GstConsentScreen());
      },
    );
  }
}

class GstConsentScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GstConsentScreenState();
}

class _GstConsentScreenState extends State<GstConsentScreen> {
  SaveConsentMain? saveConsentRes;
  bool isGstConsentGiven = false;
  bool isLoaderStart = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        SystemNavigator.pop(animated: true);
        return true;
      },
      child: Scaffold(
        appBar: getAppBarWithStepDone('1', str_registration, 0.25,
            onClickAction: () => {Navigator.pop(context), SystemNavigator.pop(animated: true)}),
        body: AbsorbPointer(
          absorbing: isLoaderStart,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ..._buildHeader(),
                  _buildMiddler(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomSheet(),
      ),
    );
  }

  _buildHeader() {
    return [
      Padding(
        padding: EdgeInsets.only(top: 30.0.h, bottom: 20.h),
        child: Text(
          str_gst_data_consent_gst_cic,
          style: ThemeHelper.getInstance()!.textTheme.headline2,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          bottom: 15.0.h,
        ),
        child: Text(
          str_Allow_Sahay_to_fetch_your_GST_Data,
          style: ThemeHelper.getInstance()!.textTheme.headline3?.copyWith(fontSize: 14.sp),
        ),
      )
    ];
  }

  _buildMiddler() {
    return Container(
      decoration: BoxDecoration(
        color: ThemeHelper.getInstance()?.cardColor,
        borderRadius: BorderRadius.all(
          Radius.circular(16.r),
        ),
      ),
      margin: EdgeInsets.only(bottom: 20.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(str_gst_data_consent, style: ThemeHelper.getInstance()!.textTheme.bodyText1),
              SizedBox(height: 10.h),
              Text(
                str_gst_data_consent_long_sentence,
                style: ThemeHelper.getInstance()!.textTheme.displaySmall?.copyWith(fontSize: 14.sp),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildBottomSheet() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: ThemeHelper.getInstance()!.cardColor, width: 1),
            color: MyColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), //color of shadow
                spreadRadius: 1, //spread radius
                blurRadius: 3, // blur radius
                offset: const Offset(0, 1), // changes position of shadow
              )
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: GestureDetector(
            onTap: () {
              setState(() {
                isGstConsentGiven = !isGstConsentGiven;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: Theme(
                    data: ThemeData(useMaterial3: true),
                    child: Checkbox(
                      // checkColor: MyColors.colorAccent,
                      activeColor: ThemeHelper.getInstance()?.primaryColor,
                      value: isGstConsentGiven,
                      onChanged: (bool) {
                        setState(() {
                          isGstConsentGiven = bool!;
                        });
                      },
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
                      side: BorderSide(
                          width: 1,
                          color: isGstConsentGiven
                              ? ThemeHelper.getInstance()!.primaryColor
                              : ThemeHelper.getInstance()!.primaryColor),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3.h, left: 8.w),
                  child: Text(
                    str_i_understand_and_agree_to_sahays_terms,
                    style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w, top: 10.h),
          child: isLoaderStart
              ? SizedBox(
                  height: 60.h,
                  child: JumpingDots(
                    color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary,
                    radius: 10,
                  ),
                )
              : AppButton(
                  onPress: onPressGiveConsentButton,
                  title: str_give_consent,
                  isButtonEnable: isGstConsentGiven,
                ),
        ),
      ],
    );
  }

  void onPressGiveConsentButton() async {
    if (isGstConsentGiven) {
      setState(() {
        isLoaderStart = true;
      });
      if (await TGNetUtil.isInternetAvailable()) {
        saveGstConsent();
      } else {
        if (context.mounted) {
          showSnackBarForintenetConnection(context, saveGstConsent);
        }
      }
    }
  }

  Future<void> saveGstConsent() async {
    RequestSaveConsent requestSaveConsent = RequestSaveConsent(
      isConsentApproval: true,
      consentApprovalType: "GST",
    );

    var jsonRequest = jsonEncode(requestSaveConsent.toJson());

    TGLog.d("GST Consent Request : $jsonRequest");
    TGPostRequest tgPostRequest = await getPayLoad(jsonRequest, URI_CONSENT_APPROVAL);

    ServiceManager.getInstance().saveConsent(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessSaveConsent(response),
        onError: (errorResponse) => _onErrorSaveConsent(errorResponse));
  }

  _onSuccessSaveConsent(SaveConsentApprovalResponse response) {
    TGLog.d("SaveConsent() : Success");
    saveConsentRes = response.saveConsentMainObj();
    if (saveConsentRes?.status == RES_SUCCESS) {
      TGSharedPreferences.getInstance().set(PREF_ISGST_CONSENT, true);
      getCICConsent();
    } else {
      setState(() {
        isLoaderStart = false;
      });
      LoaderUtils.handleErrorResponse(
          context, response?.saveConsentMainObj().status, response?.saveConsentMainObj().message, null);
    }
  }

  _onErrorSaveConsent(TGResponse errorResponse) {
    TGLog.d("SaveConsent() : Error");
    setState(() {
      isLoaderStart = false;
    });
    handleServiceFailError(context, errorResponse.error);
  }

  void getCICConsent() async {
    if (await TGNetUtil.isInternetAvailable()) {
      saveCicConsent();
    } else {
      if (context.mounted) {
        showSnackBarForintenetConnection(context, saveCicConsent);
      }
    }
  }

  Future<void> saveCicConsent() async {
    RequestSaveConsent requestSaveConsent = RequestSaveConsent(
      isConsentApproval: true,
      consentApprovalType: "BUREAU",
    );

    var jsonRequest = jsonEncode(requestSaveConsent.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonRequest, URI_CONSENT_APPROVAL);
    TGLog.d("CIC Consent Request : $jsonRequest");

    ServiceManager.getInstance().saveConsent(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessSaveCICConsent(response),
        onError: (errorResponse) => _onErrorSaveCICConsent(errorResponse));
  }

  _onSuccessSaveCICConsent(SaveConsentApprovalResponse response) {
    TGLog.d("SaveConsent() : Success");
    var saveConsentRes = response.saveConsentMainObj();
    if (saveConsentRes?.status == RES_SUCCESS) {
      TGSharedPreferences.getInstance().set(PREF_ISCIC_CONSENT, true);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => GstDetailMain(),
        ),
        (route) => false,
      );
    } else {
      setState(() {
        isLoaderStart = false;
      });
      LoaderUtils.handleErrorResponse(
          context, response?.saveConsentMainObj().status, response?.saveConsentMainObj().message, null);
    }
  }

  _onErrorSaveCICConsent(TGResponse errorResponse) {
    TGLog.d("SaveConsent() : Error");
    setState(() {
      _modalBottomSheetMenu();
      isLoaderStart = false;
      handleServiceFailError(context, errorResponse.error);
    });
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Wrap(children: [BottomPopupTC()]);
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        isScrollControlled: true);
  }

  Widget BottomPopupTC() {
    return Container(
      height: 275.h,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.0),
          topRight: Radius.circular(50.0),
        ),
      ),
      //could change this to Color(0xFF737373),
      //so you don't have to change MaterialApp canvasColor
      child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Container(
                height: 5.h,
                width: 80.w,
                decoration: BoxDecoration(
                  color: ThemeHelper.getInstance()!.colorScheme.onBackground,
                  borderRadius: BorderRadius.all(
                    Radius.circular(2.5.r),
                  ),
                ),
              ),
              SizedBox(
                height: 35.h,
              ),
              Container(
                width: 58.w,
                height: 58.h,
                child: SvgPicture.asset(
                  AppUtils.path(MOBILEMAIL),
                  height: 50.h,
                  width: 50.w,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                str_You_cannot_procced_further_as_bureau_data_is_adverse,
                textAlign: TextAlign.center,
                style: ThemeHelper.getInstance()!.textTheme.headline2,
              ),
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: ElevatedButton(
                  onPressed: onPressConsentButton,
                  child: const Text(str_ok),
                ),
              ),
            ],
          )),
    );
  }

  void onPressConsentButton() async {
    if (isGstConsentGiven) {
      setState(() {
        isLoaderStart = true;
      });
      if (await TGNetUtil.isInternetAvailable()) {
        saveCicConsent();
      } else {
        if (context.mounted) {
          showSnackBarForintenetConnection(context, saveCicConsent);
        }
      }
    }
  }
}
