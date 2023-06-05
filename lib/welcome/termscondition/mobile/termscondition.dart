import 'dart:convert';

import 'package:flutter/cupertino.dart';
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
import 'package:sbi_sahay_1_0/routes.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';

import '../../../utils/Utils.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/constants/prefrenceconstants.dart';
import '../../../utils/helpers/themhelper.dart';
import '../../../utils/internetcheckdialog.dart';
import '../../../utils/jumpingdott.dart';
import '../../../utils/locale/locales.dart';
import '../../../utils/locale/tg_locale.dart';
import '../../../utils/strings/strings.dart';
import '../../../widgets/animation_routes/page_animation.dart';
import '../../../widgets/backbutton.dart';
import '../../../widgets/titlebarmobile/titlebarwithoutstep.dart';
import '../../gstconsentconfirmthanks/mobile/gstconsentconfirmthanks.dart';
import '../../ntbwelcome/mobileui/getstarted.dart';

class TCview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return TermsConditionScreen();
      },
    );
  }
}

class TermsConditionScreen extends StatefulWidget {
  @override
  TermsConditionState createState() => TermsConditionState();
}

class TermsConditionState extends State<TermsConditionScreen> {
  bool isTermsConditionAgree = false;
  bool isLoaderStart = false;
  DateTime backPressedTime = DateTime.now();

  @override
  void initState() {
    TGSharedPreferences.getInstance().removeAllListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop(animated: true);
          Navigator.pop(context, false);
          return true;
        },
        child: Scaffold(
          appBar: getAppBarWithTitle(str_tc,
              onClickAction: () => {
                    SystemNavigator.pop(animated: true),
                    Navigator.pop(context, false)
                  }),
          body: AbsorbPointer(
            absorbing: isLoaderStart,
            child: Stack(
              children: [
                SingleChildScrollView(
                    primary: true,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TermsConditionText(),
                        ])),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: TermsConditionBottom())
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget TermsConditionText() {
    return Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            Text(str_tc, style: ThemeHelper.getInstance()?.textTheme.headline1),
            SizedBox(height: 20.h),
            Text(
              str_tc_txt,
              style: ThemeHelper.getInstance()
                  ?.textTheme
                  .bodyText2
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 150.h),
          ],
        )));
  }

  Widget TermsConditionBottom() {
    return Container(
        color: ThemeHelper.getInstance()!.backgroundColor,
        height: 120.h,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              TermsConditionCheckbox(),
              SizedBox(height: 20.h),
              TermsAgreeButton(),
              //SizedBox(height: 20.h)
            ]));
  }

  Widget TermsAgreeButton() {
    return Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child:isLoaderStart ? JumpingDots(color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary, radius: 10,) : ElevatedButton(
            style: isTermsConditionAgree
                ? ThemeHelper.getInstance()!.elevatedButtonTheme.style
                : ThemeHelper.setPinkDisableButtonBig(),
            onPressed: () async {
              if (isTermsConditionAgree) {
                setState(() {
                  isLoaderStart = true;
                });


                if( await TGNetUtil.isInternetAvailable()){
                    saveGstConsentApi();
                }else{
                  showSnackBarForintenetConnection(context,saveGstConsentApi);
                }


              }
            },
            child:  Text(
              str_AGREE,
            )));
  }

  Widget TermsConditionCheckbox() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isTermsConditionAgree = !isTermsConditionAgree;
        });
      },
      child: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 20.w,
                  height: 20.h,
                  child: Checkbox(
                    // checkColor: MyColors.colorAccent,
                    activeColor: ThemeHelper.getInstance()?.primaryColor,
                    value: isTermsConditionAgree,
                    onChanged: (bool) {
                      setState(() {
                        isTermsConditionAgree = bool!;
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    side: BorderSide(
                        width: 1,
                        color: isTermsConditionAgree
                            ? ThemeHelper.getInstance()!.primaryColor
                            : ThemeHelper.getInstance()!.disabledColor),
                  ),
                ),
                SizedBox(width: 10.w),
                Flexible(
                    child: Text(
                  str_iagree_tc,
                  style: ThemeHelper.getInstance()?.textTheme.bodyText1,
                  maxLines: 3,
                  textAlign: TextAlign.left,
                )),
              ])),
    );
  }

//popup
  Widget SahayProceedBottomDialog() {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          SizedBox(
            height: 52.h,
          ),
          SvgPicture.asset(Utils.path(MAIL), height: 58.h, width: 58.w),
          SizedBox(
            height: 20.h,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 46.w),
              child: Text(
                CANNOTPROCEEDGSTSAHAY,
                style: ThemeHelper.getInstance()!.textTheme.headline2,
                textAlign: TextAlign.center,
                maxLines: 3,
              )),
          SizedBox(
            height: 40.h,
          ),
          OkButton(),
          SizedBox(
            height: 50.h,
          )
        ]));
  }

  Widget OkButton() {
    return Padding(
      padding: EdgeInsets.all(20.h),
      child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => GetStartedScreen()));
          },
          child: Text(
            OK,
            style: ThemeHelper.getInstance()!.textTheme.button,
          ),
          style: ThemeHelper.getInstance()!.elevatedButtonTheme.style),
    );
  }

  Future<void> saveGstConsentApi() async {
    RequestSaveConsent requestSaveConsent =
        RequestSaveConsent(isConsentApproval: true, consentApprovalType: 'GST');

    var jsonRequest = jsonEncode(requestSaveConsent.toJson());

    TGPostRequest tgPostRequest =
        await getPayLoad(jsonRequest, URI_CONSENT_APPROVAL);

    ServiceManager.getInstance().saveConsent(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessSaveConsent(response),
        onError: (errorResponse) => _onErrorSaveConsent(errorResponse));
  }

  _onSuccessSaveConsent(SaveConsentApprovalResponse response)
  {
      TGLog.d("SaveConsent : Success()");
      setState(() {
          isLoaderStart = false;
      });

    TGSharedPreferences.getInstance().set(PREF_ISTC_DONE, true);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => GstConsentConform()));
  }

  _onErrorSaveConsent(TGResponse errorResponse) {
    TGLog.d("SaveConsent : Error()");
    setState(() {
      isLoaderStart = false;
    });
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Wrap(children: [SahayProceedBottomDialog()]);
        },
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        clipBehavior: Clip.antiAlias,
        isScrollControlled: true);
  }
}
