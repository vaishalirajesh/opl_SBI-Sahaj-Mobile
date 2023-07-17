import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_gst_basic_details_res_main.dart';
import 'package:gstmobileservices/model/models/get_loandetail_by_refid_res_main.dart';
import 'package:gstmobileservices/model/requestmodel/get_all_loan_detail_by_refid_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_gst_basic_details_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_all_loan_detail_by_refid_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_gst_basic_details_response.dart';
import 'package:gstmobileservices/service/request/tg_get_request.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/singleton/tg_session.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/erros_handle_util.dart';
import 'package:gstmobileservices/util/jumpingdot_util.dart';
import 'package:gstmobileservices/util/tg_flavor.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import 'package:sbi_sahay_1_0/registration/mobile/gst_consent_of_gst/gst_consent_of_gst.dart';
import 'package:sbi_sahay_1_0/registration/mobile/login/login.dart';
import 'package:sbi_sahay_1_0/registration/mobile/signupdetails/signup.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/constants/session_keys.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusConstants.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/internetcheckdialog.dart';
import 'package:sbi_sahay_1_0/utils/progressLoader.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/Utils.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/strings/strings.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return const SafeArea(child: GetStarted());
      },
    );
  }
}

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  bool isLoaderStart = false;
  GetGstBasicdetailsResMain? _basicdetailsResponse;
  GetAllLoanDetailByRefIdResMain? _getAllLoanDetailRes;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: AbsorbPointer(
          absorbing: isLoaderStart,
          child: ListView(
            children: [
              pNBLogo(),
              sahayLogo(),
              cardViewSetup(),
            ],
          ),
        ),
        bottomNavigationBar: AbsorbPointer(
          absorbing: isLoaderStart,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 10.h,
              ),
              getStartedBTN(context),
              SizedBox(
                height: 10.h,
              ),
              loginButton(context),
              SizedBox(
                height: 15.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getStartedBTN(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
      ),
      child: isLoaderStart
          ? SizedBox(
              height: 50.h,
              child: JumpingDots(
                color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary,
                radius: 10,
              ),
            )
          : AppButton(
              onPress: () {
                setState(() {
                  isLoaderStart = true;
                });
                // getUserData();
                Future.delayed(const Duration(seconds: 2), () {
                  TGLog.d('Bank name--${TGFlavor.param("bankName")}');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpView(),
                    ),
                  );
                });
              },
              title: str_get_started,
            ),
    );
  }

  void getUserData() async {
    if (await TGNetUtil.isInternetAvailable()) {
      _getGstBasicDetails();
    } else {
      if (context.mounted) {
        showSnackBarForintenetConnection(context, _getGstBasicDetails);
      }
    }
  }

  //Get GST Basic Detail API Call
  Future<void> _getGstBasicDetails() async {
    await Future.delayed(const Duration(seconds: 2));
    TGGetRequest tgGetRequest = GetGstBasicDetailsRequest();
    ServiceManager.getInstance().getGstBasicDetails(
        request: tgGetRequest,
        onSuccess: (response) => _onSuccessGetGstBasicDetails(response),
        onError: (error) => _onErrorGetGstBasicDetails(error));
  }

  _onSuccessGetGstBasicDetails(GetGstBasicDetailsResponse? response) async {
    TGLog.d("GetGstBasicDetailsResponse : onSuccess()");
    setState(() {
      _basicdetailsResponse = response?.getGstBasicDetailsRes();
    });
    if (_basicdetailsResponse?.status == RES_DETAILS_FOUND) {
      if (_basicdetailsResponse?.data?.isNotEmpty == true) {
        if (_basicdetailsResponse?.data?[0].isOtpVerified == true) {
          if (_basicdetailsResponse?.data?[0]?.gstin?.isNotEmpty == true) {
            var gstin = _basicdetailsResponse!.data![0].gstin!;
            if (_basicdetailsResponse!.data![0].gstin!.length >= 12) {
              TGSharedPreferences.getInstance()
                  .set(PREF_BUSINESSNAME, _basicdetailsResponse?.data?[0].gstBasicDetails?.tradeNam);
              TGSharedPreferences.getInstance().set(PREF_GSTIN, _basicdetailsResponse?.data?[0].gstin);
              TGSharedPreferences.getInstance().set(PREF_USERNAME, _basicdetailsResponse?.data?[0].username.toString());
              TGSharedPreferences.getInstance()
                  .set(PREF_PANNO, _basicdetailsResponse?.data?[0].gstin?.substring(2, 12));
            } else {
              TGSharedPreferences.getInstance().set(PREF_PANNO, _basicdetailsResponse?.data?[0].gstin);
            }
            TGSharedPreferences.getInstance().set(PREF_ISGST_CONSENT, true);
            TGSharedPreferences.getInstance().set(PREF_ISGSTDETAILDONE, true);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const DashboardWithGST(),
                ),
                (route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => GstConsent(),
                ),
                (route) => false);
          }
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => GstConsent(),
              ),
              (route) => false);
        }
      } else {
        if (await TGNetUtil.isInternetAvailable()) {
          _getUserLoanDetails();
        } else {
          if (context.mounted) {
            showSnackBarForintenetConnection(context, _getUserLoanDetails);
          }
        }
      }
    } else if (_basicdetailsResponse?.status == RES_DETAILS_NOT_FOUND) {
      setState(() {});
      TGLog.d('Bank name--${TGFlavor.param("bankName")}');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SignUpView(),
        ),
      );
    } else {
      setState(() {});
      LoaderUtils.handleErrorResponse(
          context, response?.getGstBasicDetailsRes().status, response?.getGstBasicDetailsRes().message, null);
    }
  }

  _onErrorGetGstBasicDetails(TGResponse errorResponse) {
    setState(() {
      isLoaderStart = false;
    });
    TGLog.d("GetGstBasicDetailsResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> _getUserLoanDetails() async {
    TGGetRequest tgGetRequest = GetLoanDetailByRefIdReq();
    ServiceManager.getInstance().getAllLoanDetailByRefId(
        request: tgGetRequest,
        onSuccess: (response) => _onSuccessGetAllLoanDetailByRefId(response),
        onError: (error) => _onErrorGetAllLoanDetailByRefId(error));
  }

  _onSuccessGetAllLoanDetailByRefId(GetAllLoanDetailByRefIdResponse? response) {
    TGLog.d("UserLoanDetailsResponse : onSuccess()");
    _getAllLoanDetailRes = response?.getAllLoanDetailObj();

    if (_getAllLoanDetailRes?.status == RES_SUCCESS) {
      if (_getAllLoanDetailRes?.data?.isEmpty == true) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => GstConsent(),
            ),
            (route) => false);
      } else {
        TGSharedPreferences.getInstance().set(PREF_GSTIN, _getAllLoanDetailRes?.data?[0].gstin);
        TGSharedPreferences.getInstance().set(PREF_PANNO, _getAllLoanDetailRes?.data?[0].gstin?.substring(2, 12));
        TGSession.getInstance().set(SESSION_GSTIN, _getAllLoanDetailRes?.data?[0].gstin);
        TGSession.getInstance().set(SESSION_PANNO, _getAllLoanDetailRes?.data?[0].gstin?.substring(2, 12));
        TGSession.getInstance().set(SESSION_BUSINESSNAME, _getAllLoanDetailRes?.data?[0].tradeNam);
        TGSharedPreferences.getInstance().set(PREF_ISGST_CONSENT, true);
        TGSharedPreferences.getInstance().set(PREF_ISGSTDETAILDONE, true);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const DashboardWithGst(),
            ),
            (route) => false);
      }
    } else {
      setState(() {
        isLoaderStart = false;
      });

      LoaderUtils.handleErrorResponse(
          context, response?.getAllLoanDetailObj().status, response?.getAllLoanDetailObj().message, null);
    }
  }

  _onErrorGetAllLoanDetailByRefId(TGResponse errorResponse) {
    TGLog.d("UserLoanDetailsResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
    setState(() {
      isLoaderStart = false;
    });
  }
}

Widget sahayLogo() {
  return Padding(
    padding: EdgeInsets.only(bottom: 45.h),
    child: Center(
      child: SvgPicture.asset(
        Utils.path(IMG_SAHAY_LOGO),
        height: 110,
        width: 150,
        allowDrawingOutsideViewBox: true,
        //color: Colors.black,
      ),
    ),
  );
}

Widget pNBLogo() {
  return Padding(
    padding: EdgeInsets.only(top: 50.h, bottom: 60.h),
    child: Center(
      child: SvgPicture.asset(
        Utils.path(BANKLOGOSQUARE),
        width: 180.w,
        height: 50.h,
      ),
    ),
  );
}

Widget cardViewSetup() {
  return Container(
    // height: 200.h,
    padding: EdgeInsets.symmetric(vertical: 20.r),
    margin: EdgeInsets.only(bottom: 50.h, left: 20.w, right: 20.w),
    decoration: BoxDecoration(
      color: ThemeHelper.getInstance()!.cardColor,
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
    ),
    child: Center(
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: str_gst_sahay,
                style: ThemeHelper.getInstance()!.textTheme.button!.copyWith(color: MyColors.pnbsmallbodyTextColor),
              ),
              TextSpan(
                text: str_disc,
                style: ThemeHelper.getInstance()!.textTheme.headline3!,
              ),
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri.parse("https://www.youtube.com/watch?v=vcxK5Ppd4R4"));
                  },
                text: strVideo,
                style: ThemeHelper.getInstance()!.textTheme.button!.copyWith(
                      color: MyColors.hyperlinkcolornew,
                      decoration: TextDecoration.underline,
                    ),
              ),
              TextSpan(text: strLast, style: ThemeHelper.getInstance()!.textTheme.headline3!),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget loginButton(BuildContext context) {
  return TextButton(
    onPressed: () {
      //action
    },
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: str_all_have_acc,
            style: ThemeHelper.getInstance()!
                .textTheme
                .headline3!
                .copyWith(fontSize: 14.sp, color: MyColors.lightBlackText),
          ),
          TextSpan(
              text: str_logintc,
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline3!
                  .copyWith(fontSize: 14.sp, color: MyColors.hyperlinkcolornew),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  TGLog.d("On tap login");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginWithMobileNumber(),
                    ),
                  );
                }),
        ],
      ),
    ),
  );
}
