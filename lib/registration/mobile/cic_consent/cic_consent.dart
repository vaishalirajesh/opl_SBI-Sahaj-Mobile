import 'dart:convert';

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
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:sbi_sahay_1_0/registration/mobile/gst_detail/gst_detail.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/internetcheckdialog.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';

import '../../../utils/Utils.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/constants/statusConstants.dart';
import '../../../utils/erros_handle.dart';
import '../../../utils/helpers/themhelper.dart';
import '../../../utils/jumpingdott.dart';
import '../../../utils/progressLoader.dart';
import '../../../utils/strings/strings.dart';
import '../../../widgets/titlebarmobile/titlebarwithoutstep.dart';

class CicConsent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CicConsentScreen();
      },
    );
  }
}

class CicConsentScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CicConsentScreenState();
}

class _CicConsentScreenState extends State<CicConsentScreen> {
  bool isConsentGiven = false;
  bool isLoaderStart = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, false);
          SystemNavigator.pop(animated: true);
          return true;
        },
        child: Scaffold(
          appBar: getAppBarWithStepDone('1', str_registration, 0.25,
              onClickAction: () => {Navigator.pop(context, false), SystemNavigator.pop(animated: true)}),
          body: AbsorbPointer(
            absorbing: isLoaderStart,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: SizedBox(
                      // height: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          ..._buildHeader(),
                          _buildMiddler(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomSheet(),
        ),
      ),
    );
  }

  _buildHeader() {
    return [
      Padding(
        padding: EdgeInsets.only(top: 30.0.h, bottom: 20.h),
        child: Text(
          str_give_consent,
          style: ThemeHelper.getInstance()!.textTheme.headline2,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          bottom: 15.0.h,
        ),
        child: Text(
          str_Allow_Lenders_to_fetch_CIC_data,
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
        padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(str_Credit_Information_Company_Consent, style: ThemeHelper.getInstance()!.textTheme.bodyText1),
            SizedBox(
              height: 10.h,
            ),
            Text(
              str_give_consent_long_sentence,
              style: ThemeHelper.getInstance()!.textTheme.displaySmall?.copyWith(fontSize: 14.sp),
            )
          ],
        ),
      ),
    );
  }

  _buildBottomSheet() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isConsentGiven = !isConsentGiven;
            });
          },
          child: Padding(
            padding: EdgeInsets.only(top: 10.h, bottom: 10.h, left: 20.w, right: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h, right: 10.w),
                  child: SizedBox(
                    height: 20.h,
                    width: 20.w,
                    child: Theme(
                      data: ThemeData(useMaterial3: true),
                      child: Checkbox(
                        activeColor: ThemeHelper.getInstance()?.primaryColor,
                        value: isConsentGiven,
                        onChanged: (bool) {
                          setState(() {
                            isConsentGiven = bool!;
                          });
                        },
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(2),
                          ),
                        ),
                        side: BorderSide(
                            width: 1,
                            color: isConsentGiven
                                ? ThemeHelper.getInstance()!.primaryColor
                                : ThemeHelper.getInstance()!.primaryColor),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Text(
                    str_CIC_Terms,
                    style: ThemeHelper.getInstance()!.textTheme.headline3?.copyWith(fontSize: 14.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 30.h),
          child: isLoaderStart
              ? JumpingDots(
                  color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary,
                  radius: 10,
                )
              : AppButton(
                  onPress: onPressConsentButton,
                  title: str_give_consent,
                  isButtonEnable: isConsentGiven,
                ),
        ),

        //SizedBox(height: 49.h,)
      ],
    );
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
                  Utils.path(MOBILEMAIL),
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
    if (isConsentGiven) {
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
        onSuccess: (response) => _onSuccessSaveConsent(response),
        onError: (errorResponse) => _onErrorSaveConsent(errorResponse));
  }

  _onSuccessSaveConsent(SaveConsentApprovalResponse response) {
    TGLog.d("SaveConsent() : Success");
    var saveConsentRes = response.saveConsentMainObj();
    if (saveConsentRes?.status == RES_SUCCESS) {
      setState(() {
        isLoaderStart = false;
      });
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

  _onErrorSaveConsent(TGResponse errorResponse) {
    TGLog.d("SaveConsent() : Error");
    setState(() {
      _modalBottomSheetMenu();
      isLoaderStart = false;
      handleServiceFailError(context, errorResponse.error);
    });
  }
}
