import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusconstants.dart';
import 'package:sbi_sahay_1_0/utils/erros_handle.dart';
import 'package:sbi_sahay_1_0/utils/internetcheckdialog.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';

import '../../../routes.dart';
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
          str_gst_data_consent_gst,
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
          color: ThemeHelper.getInstance()?.cardColor, borderRadius: BorderRadius.all(Radius.circular(16.r))),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
    );
  }

  _buildBottomSheet() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isGstConsentGiven = !isGstConsentGiven;
              });
            },
            child: Padding(
              padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
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
            padding: EdgeInsets.only(bottom: 40.h),
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
      ),
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
      // Navigator.pop(context);

      setState(() {
        isLoaderStart = false;
      });
      TGSharedPreferences.getInstance().set(PREF_ISGST_CONSENT, true);
      Navigator.pushReplacementNamed(context, MyRoutes.gstConsent);
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
}
