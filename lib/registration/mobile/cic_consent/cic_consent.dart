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
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:sbi_sahay_1_0/registration/mobile/dashboardwithoutgst/mobile/dashboardwithoutgst.dart';
import 'package:sbi_sahay_1_0/routes.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';

import '../../../loanprocess/mobile/gstinvoiceslist/ui/gstinvoicelist.dart';
import '../../../utils/Utils.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/constants/statusConstants.dart';
import '../../../utils/erros_handle.dart';
import '../../../utils/helpers/themhelper.dart';
import '../../../utils/internetcheckdialog.dart';
import '../../../utils/jumpingdott.dart';
import '../../../utils/progressLoader.dart';
import '../../../utils/strings/strings.dart';
import '../../../widgets/animation_routes/page_animation.dart';
import '../../../widgets/backbutton.dart';
import '../../../widgets/titlebarmobile/titlebarwithoutstep.dart';
import '../gst_detail/gst_detail.dart';

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
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => DashboardWithoutGST(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
          return true;
        },
        child: Scaffold(
          appBar: getAppBarWithStep('1', str_registration, 0.25,
              onClickAction: () => {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            DashboardWithoutGST(),
                      ),
                      (route) =>
                          false, //if you want to disable back feature set to false
                    )
                  }),
          body: AbsorbPointer(
            absorbing: isLoaderStart,
            child: Stack(children: [
              SingleChildScrollView(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SizedBox(
                  // height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ..._buildHeader(),
                      _buildMiddler(),
                      //     Spacer(),
                      // _buildBottomSheet(viewModel)
                    ],
                  ),
                ),
              )),
              Align(
                  alignment: Alignment.bottomCenter, child: _buildBottomSheet())
            ]),
          ),
          //bottomNavigationBar: _buildBottomSheet(viewModel),
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
          style: ThemeHelper.getInstance()!.textTheme.headline1,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          bottom: 15.0.h,
        ),
        child: Text(
          str_Allow_Lenders_to_fetch_CIC_data,
          style: ThemeHelper.getInstance()!.textTheme.headline3,
        ),
      )
    ];
  }

  _buildMiddler() {
    return Container(
      decoration: BoxDecoration(
          color: ThemeHelper.getInstance()?.colorScheme.secondary,
          borderRadius: BorderRadius.all(Radius.circular(16.r))),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16.0.h, bottom: 10.h),
              child: Text(str_Credit_Information_Company_Consent,
                  style: ThemeHelper.getInstance()!.textTheme.bodyText1),
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 17.h),
                child: Text(
                  str_give_consent_long_sentence,
                  style: ThemeHelper.getInstance()!
                      .textTheme
                      .bodyText2
                      ?.copyWith(fontSize: 13.sp),
                ))
          ],
        ),
      ),
    );
  }

  _buildBottomSheet() {
    return Container(
      height: 145.h,
      child: Column(
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
              padding: EdgeInsets.only(
                  top: 10.h, bottom: 10.h, left: 20.w, right: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h, right: 10.w),
                    child: SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: Checkbox(
                        // checkColor: MyColors.colorAccent,
                        activeColor: ThemeHelper.getInstance()?.primaryColor,
                        value: isConsentGiven,
                        onChanged: (bool) {
                          setState(() {
                            isConsentGiven = bool!;
                          });
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        side: BorderSide(
                            width: 1,
                            color: isConsentGiven
                                ? ThemeHelper.getInstance()!.primaryColor
                                : ThemeHelper.getInstance()!.disabledColor),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Text(
                      str_CIC_Terms,
                      style: ThemeHelper.getInstance()!
                          .textTheme
                          .headline5!
                          .copyWith(color: MyColors.pnbcolorPrimary),
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
                      color: ThemeHelper.getInstance()?.primaryColor ??
                          MyColors.pnbcolorPrimary,
                      radius: 10,
                    )
                  : ElevatedButton(
                      style: isConsentGiven
                          ? ThemeHelper.getInstance()!.elevatedButtonTheme.style
                          : ThemeHelper.setPinkDisableButtonBig(),
                      onPressed: () async {
                        if (isConsentGiven) {
                          setState(() {
                            isLoaderStart = true;
                          });

                          if (await TGNetUtil.isInternetAvailable()) {
                            saveCicConsent();
                          } else {
                            showSnackBarForintenetConnection(
                                context, saveCicConsent);
                          }
                        }
                      },
                      child: Text(str_give_consent),
                    )),

          //SizedBox(height: 49.h,)
        ],
      ),
    );
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Wrap(children: [BottomPopupTC()]);
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        clipBehavior: Clip.antiAlias,
        isScrollControlled: true);
  }

  Widget BottomPopupTC() {
    return Container(
      height: 275.h,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(50.0),
              topRight: const Radius.circular(50.0))),
      //could change this to Color(0xFF737373),
      //so you don't have to change MaterialApp canvasColor
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(50.0),
                  topRight: const Radius.circular(50.0))),
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
                    borderRadius: BorderRadius.all(Radius.circular(2.5.r))),
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
                  onPressed: () {
                    Navigator.pop(context);
                    //   Navigator.pushNamed(context, MyRoutes.GSTInvoicesListRoutes);
                    // Navigator.of(context).push(CustomRightToLeftPageRoute(child: GSTInvoicesList(), ));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GSTInvoicesList()));
                  },
                  child: Text(str_ok),
                ),
              ),
            ],
          )),
    );
  }

  Future<void> saveCicConsent() async {
    RequestSaveConsent requestSaveConsent = RequestSaveConsent(
      isConsentApproval: true,
      consentApprovalType: "BUREAU",
    );

    var jsonRequest = jsonEncode(requestSaveConsent.toJson());
    TGPostRequest tgPostRequest =
        await getPayLoad(jsonRequest, URI_CONSENT_APPROVAL);

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
      // Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GSTInvoicesList(),
          ));
    } else {
      setState(() {
        isLoaderStart = false;
      });
      LoaderUtils.handleErrorResponse(
          context,
          response?.saveConsentMainObj().status,
          response?.saveConsentMainObj().message,
          null);
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
