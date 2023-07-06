import 'package:flutter/material.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_util.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/accountaggregatorntb/ui/aadetails.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import 'package:sbi_sahay_1_0/registration/mobile/gst_consent_of_gst/gst_consent_of_gst.dart';
import 'package:sbi_sahay_1_0/registration/mobile/gst_detail/gst_detail.dart';
import 'package:sbi_sahay_1_0/registration/mobile/login/login.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/welcome/ntbwelcome/mobileui/enablegstapintb.dart';
import 'package:sbi_sahay_1_0/welcome/ntbwelcome/mobileui/getstarted.dart';

import '../../loanprocess/mobile/aalist/ui/aa_error_screen.dart';

class StringAssets {
  // Bank name
  static const String pnbBank = 'PNB';
  static const String sbiBank = 'SBI';
  static const String punjabNationalBank = 'Punjab National Bank';
  static const String ibBank = 'IB';
  static const String indianBank = 'Indian Bank';
  static const String jakBank = 'JAK';
  static const String sidbiBank = 'SIDBI';
  static const String registrationCompleted = "RegistrationCompleted";
  static const String welcomePage = 'WelcomePage';
  static const String dashboardWithoutGST = 'dashboardWithoutGST';
  static const String cicConsent = 'CicConsent';
  static const String gstDetail = 'GstDetail';
  static const String moveNextStage = 'moveNextStage';
  static const String loanOfferList = "LoanOfferList";
  static const String dashBord = 'DashBoard';
  static const String financeInvoice = 'FinanceInvoice';
  static const String confirmDetails = 'ConfirmDetails';
  static const String ibWelcome = 'ibWelcome';
  static const String bankList = 'BankList';
  static const String aggregatorDetail = 'AggregatorDetail';
  static const String aggregatorList = 'AggregatorList';
  static const String personalInfo = 'PersonalInfo';
  static const String privacyAndSecurity = 'PrivacyAndSecurity';
  static const String aboutPage = 'aboutPage';
  static const String faqPage = 'faqPage';
  static const String contactSupport = 'contactSupport';
  static const String aaPage = 'AaPage';
  static const String aaCompletedWithMsg = 'AaCompletedWithMsg';
  static const String aaCompleted = 'AaCompleted';
  static const String progressLoaderLogin = 'ProgressLoaderLogin';
  static const String progressLoaderOfferIneligible = 'ProgressLoaderOfferIneligible';
  static const String progressLoaderOfferExpire = 'ProgressLoaderOfferExpire';
  static const String progressLoaderBureauFail = 'ProgressLoaderBureauFail';
  static const String showWebView = 'ShowWebView';
  static const String loginSteps = 'LoginSteps';
  static const String dashboardCount = 'DashboardCount';
}

initHandler(String? bankName, BuildContext context) {
  switch (bankName) {
    case StringAssets.pnbBank:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const GetStartedScreen(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );

      break;

    case StringAssets.ibBank:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const EnableGstApi(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
      break;
    default:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const GetStartedScreen(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
      break;
  }
}

Future<void> navigationHandler({
  required String bankName,
  required String currentScreen,
  required BuildContext context,
  required isCommon,
  String url = '',
  String appBarTitle = '',
}) async {
  TGLog.d("IN Navigation Handler------BankName: $bankName -------CurrentScreen: $currentScreen");

  if (isCommon) {
    switch (currentScreen) {}
  } else {
    switch (bankName) {
      case StringAssets.sbiBank:
        switch (currentScreen) {
          case StringAssets.welcomePage:
            String? accetoken = await Utils.getAccessToken(bankName);
            bool? isTCDone = await TGSharedPreferences.getInstance().get(PREF_ISTC_DONE) ?? false;
            bool? isGstConsentDone = await TGSharedPreferences.getInstance().get(PREF_ISGST_CONSENT);
            bool? isGstDetailDone = await TGSharedPreferences.getInstance().get(PREF_ISGSTDETAILDONE);
            if (isTCDone == false) {
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const EnableGstApi(),
                    ),
                    (route) => false);
              }
            } else if (accetoken == null) {
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const LoginWithMobileNumber(),
                  ),
                  (route) => false, //if you want to disable back feature set to false
                );
              }
            } else if (isGstConsentDone == null || isGstConsentDone == false) {
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => GstConsent(),
                  ),
                  (route) => false, //if you want to disable back feature set to false
                );
              }
            } else if (isGstDetailDone == null || isGstDetailDone == false) {
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => GstDetailMain(),
                  ),
                  (route) => false, //if you want to disable back feature set to false
                );
              }
            } else if (isGstConsentDone && isGstDetailDone) {
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const DashboardWithGST(),
                  ),
                  (route) => false, //if you want to disable back feature set to false
                );
              }
            } else if (!isGstConsentDone && !isGstDetailDone) {
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => GstConsent(),
                    ),
                    (route) => false);
              }
            }

            break;
          case StringAssets.aaCompleted:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const AAErrorScreen(),
              ),
              (route) => false, //if you want to disable back feature set to false
            );
            break;
          case StringAssets.aaPage:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const AccountAggregatorDetails(),
              ),
              (route) => false, //if you want to disable back feature set to false
            );
            break;
          // case StringAssets.registrationCompleted:
          //   Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //       builder: (BuildContext context) => const IbDashboardWithoutGstPage(),
          //     ),
          //     (route) => false, //if you want to disable back feature set to false
          //   );
          //   break;
          // case StringAssets.ibWelcome:
          //   Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //       builder: (BuildContext context) => const IbGstConfirmPage(),
          //     ),
          //     (route) => false, //if you want to disable back feature set to false
          //   );
          //   break;
          // case StringAssets.aggregatorDetail:
          //   Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //       builder: (BuildContext context) => const IbBankListPage(),
          //     ),
          //     (route) => false, //if you want to disable back feature set to false
          //   );
          //   break;
          // case StringAssets.bankList:
          //   Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //       builder: (BuildContext context) => const IbAaListPage(),
          //     ),
          //     (route) => false, //if you want to disable back feature set to false
          //   );
          //   break;
          // case StringAssets.aaPage:
          //   Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //       builder: (BuildContext context) => const IbAaListPage(),
          //     ),
          //     (route) => false, //if you want to disable back feature set to false
          //   );
          //   break;
          // case StringAssets.aaCompletedWithMsg:
          //   Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //       builder: (BuildContext context) => const AAErrorScreen(msg: consent_fail),
          //     ),
          //     (route) => false, //if you want to disable back feature set to false
          //   );
          //   break;
          // case StringAssets.aaCompleted:
          //   Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //       builder: (BuildContext context) => const AAErrorScreen(),
          //     ),
          //     (route) => false, //if you want to disable back feature set to false
          //   );
          //   break;
          // case StringAssets.loginSteps:
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const IbSteps(),
          //     ),
          //   );
          //   break;
        }
        break;
    }
  }
}
