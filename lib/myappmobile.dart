import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/common/app_constants.dart';
import 'package:gstmobileservices/common/app_init.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/util/tg_flavor.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/banklist/mobile/banklistloader.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/loanofferlist/ui/loanofferlistscreen.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/transactions/ui/transactionscreen.dart';
import 'package:sbi_sahay_1_0/payment/ui/prepaynow.dart';
import 'package:sbi_sahay_1_0/personalinfo/ui/personalinfo.dart';
import 'package:sbi_sahay_1_0/registration/mobile/cic_consent/cic_consent.dart';
import 'package:sbi_sahay_1_0/registration/mobile/confirm_details/confirm_details.dart';
import 'package:sbi_sahay_1_0/registration/mobile/dashboardwithoutgst/mobile/dashboardwithoutgst.dart';
import 'package:sbi_sahay_1_0/registration/mobile/gst_consent_of_gst/gst_consent_of_gst.dart';
import 'package:sbi_sahay_1_0/registration/mobile/gst_detail/gst_detail.dart';
import 'package:sbi_sahay_1_0/registration/mobile/gst_detail/gstotpverify.dart';
import 'package:sbi_sahay_1_0/registration/mobile/gst_detail/laoderfetchgstdetails.dart';
import 'package:sbi_sahay_1_0/registration/mobile/login/login.dart';
import 'package:sbi_sahay_1_0/registration/mobile/loginotpverify/loginotpverify.dart';
import 'package:sbi_sahay_1_0/registration/mobile/registration_completed/registration_completed.dart';
import 'package:sbi_sahay_1_0/registration/mobile/signupdetails/signup.dart';
import 'package:sbi_sahay_1_0/registration/mobile/welcome/welcome_screen.dart';
import 'package:sbi_sahay_1_0/routes.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/locale/localehelper.dart';
import 'package:sbi_sahay_1_0/utils/locale/tg_locale.dart';

import 'package:sbi_sahay_1_0/welcome/gstconsentconfirmthanks/mobile/gstconsentconfirmthanks.dart';
import 'package:sbi_sahay_1_0/welcome/ntbwelcome/mobileui/enablegstapintb.dart';
import 'package:sbi_sahay_1_0/welcome/ntbwelcome/mobileui/getstarted.dart';
import 'package:sbi_sahay_1_0/welcome/ntbwelcome/mobileui/startregistration.dart';
import 'package:sbi_sahay_1_0/welcome/termscondition/mobile/termscondition.dart';

import 'disbursed/mobile/loanreview/ui/loanreviewscreen.dart';
import 'disbursed/mobile/proceedtodisbursed/ui/loaderprepareloandisbursement.dart';
import 'disbursed/mobile/proceedtodisbursed/ui/proceedtodisbscreen.dart';
import 'documentation/mobile/emailsentaftersetupemandate/emandate_status.dart';
import 'documentation/mobile/loanagreement/ui/loanageementscreen.dart';
import 'documentation/mobile/reviewdisbursedacc/ui/reviewdisbursedaccscreen.dart';
import 'documentation/mobile/setupemandate/ui/setupemandate.dart';
import 'hidescrollbar.dart';
import 'loader/aaaftercallback_loader.dart';
import 'loader/redirecting_loader.dart';
import 'loanprocess/mobile/aalist/ui/accountaggregatorlist.dart';
import 'loanprocess/mobile/accountaggregatorntb/ui/aadetails.dart';
import 'loanprocess/mobile/accountaggregatorntb/ui/accountaggregatorwebview.dart';
import 'loanprocess/mobile/banklist/mobile/banklist.dart';
import 'loanprocess/mobile/congratulations_final/ui/congratulationfinalscreen.dart';
import 'loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import 'loanprocess/mobile/dispute/ui/disputeprogress/ui/disputeprogressscreen.dart';
import 'loanprocess/mobile/dispute/ui/disputeresolved/ui/disputeresolvedscreen.dart';
import 'loanprocess/mobile/dispute/ui/disputetracker/ui/disputetrackerscreen.dart';
import 'loanprocess/mobile/dispute/ui/raisedispute/ui/raisedisputescreen.dart';
import 'loanprocess/mobile/dispute/ui/submitdispute/ui/submitdisputescreen.dart';
import 'loanprocess/mobile/emailafterloanagreement/mobile/email_sent_after_loan_agreement.dart';
import 'loanprocess/mobile/gstinvoiceslist/ui/filtergstinvoicelist.dart';
import 'loanprocess/mobile/gstinvoiceslist/ui/gstinvoicelist.dart';
import 'loanprocess/mobile/gstinvoiceslist/ui/gstinvoicelistrefresh.dart';
import 'loanprocess/mobile/important_sms/important_sms.dart';
import 'loanprocess/mobile/infosharedscreen/ui/infosharedscreen.dart';
import 'loanprocess/mobile/kfs/kfs_screen.dart';
import 'loanprocess/mobile/loanaggrementcompleted/ui/esigncompleted.dart';
import 'loanprocess/mobile/loanaggrementcompleted/ui/loanaggrementcompleted.dart';
import 'loanprocess/mobile/loandepositeaccount/loandepositeaccnt.dart';
import 'loanprocess/mobile/loanoffer/loanofferscreen.dart';
import 'loanprocess/mobile/profile/ui/contactsupport/contactlendersupport/ui/lendersupportscreen.dart';
import 'loanprocess/mobile/profile/ui/contactsupport/ui/contactsupportscreen.dart';
import 'loanprocess/mobile/profile/ui/faq/ui/faq.dart';
import 'loanprocess/mobile/profile/ui/newprofile.dart';
import 'loanprocess/mobile/profile/ui/profilescreen.dart';
import 'loanstatus/mobile/paymentsuccess.dart';
import 'notificationprefrence/ui/notificationprefrence.dart';

class MyAppForMobileApp extends StatefulWidget {
  const MyAppForMobileApp({super.key});
  static _MyAppForMobileAppState? _state;
  // static void setLocale(Locale locale) async {
  //   TGLog.d("TGPortalApp.setLocale : " + locale.toString());
  //   _state?.setLocale(locale);
  // }
  @override
  State<MyAppForMobileApp> createState() => _MyAppForMobileAppState();

}

class _MyAppForMobileAppState extends State<MyAppForMobileApp> {

  // setLocale(Locale locale) {
  //   setState(() {
  //     TGLocale.currentLocale = locale;
  //     TGLog.d("_TGPortalAppState.setLocale = " + TGLocale.currentLocale.toString());
  //   });
  // }

  @override
  void didChangeDependencies() {
    TGLog.d("main.didDependencyChange");
    super.didChangeDependencies();
  }
  @override
  void initState() {
    TGLog.d('main.initState()');
    super.initState();
    _initFlavor();
    _init();

  }
  @override
  Widget build(BuildContext context) {
    // ThemeHelper.setTheme(PnbThemes.pnbThemeMobile);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: DashboardWithGST(),
          locale: LocaleHelper.currentLocale,
          theme: ThemeHelper.getInstance(),
          scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
          routes: {
           // MyRoutes.splashRoutes: (context) => SplashMain(),







            MyRoutes.welcomeRoutes: (context) => WelcomePage(),
            MyRoutes.tcRouted: (context) => TCview(),
            MyRoutes.GetStartedScrRoutes: (context) => const GetStartedScreen(),
            MyRoutes.signUpViewRoutes: (context) => SignUpView(),
            MyRoutes.EnableGstApiRoutes: (context) => const EnableGstApi(),
            MyRoutes.StartRegistrationNtbRoutes: (context) => const StartRegistrationNtb(),
            MyRoutes.GstConfirmThanksRoutes: (context) => GstConsentConform(),
            MyRoutes.loginRoutes: (context) => LoginWithMobileNumber(),
            MyRoutes.gstConsentGst: (context) => GstConsent(),
            MyRoutes.gstDetail: (context) => GstDetailMain(),
            MyRoutes.confirmGSTDetailRoutes: (context) => GstBasicDetails(),
            MyRoutes.registrationCompleted: (context) => RegistrationCompleted(),
            MyRoutes.DashboardWithoutGSTRoutes: (context) => DashboardWithoutGST(),
            MyRoutes.gstConsent: (context) => CicConsent(),
            MyRoutes.GSTInvoicesListRoutes: (context) => GSTInvoicesList(),
           // MyRoutes.LoaderShareInvoicesRoutes: (context) => const LoaderShareInvoices(),
            MyRoutes.AccountAggregatorDetailsRoutes: (context) => const AccountAggregatorDetails(),
            MyRoutes.BankListRoutes: (context) => const BankList(),
            MyRoutes.BankListLoaderRoutes: (context) => const BankListLoader(),
            MyRoutes.AAListRoutes: (context) => const AAList(),
            MyRoutes.LoaderRedirectedLoaderRoutes: (context) => const RedirectedLoader(),
            MyRoutes.AAWebView: (context) =>  AccountAggregatorWebview(),
            MyRoutes.AAWebViewCallBack: (context) =>  AAAfterCallBack(),
            MyRoutes.infoShareRoutes: (context) => InfoShare(),
            MyRoutes.loanOfferListRoutes: (context) => LoanOfferList(),
           // MyRoutes.accVerificationRoutes: (context) => AccVerification(),
            MyRoutes.DashboardWithGSTRoutes: (context) => DashboardWithGST(),
            MyRoutes.TransactionRoutes: (context) => TransactionsView(),
           // MyRoutes.loanOfferSelectedRoutes: (context) => CongratulationsMain(),
            MyRoutes.LoanOfferScreenRoutes: (context) => LoanOfferScreen(),
            MyRoutes.KfsScreenRoutes: (context) => KfsScreen(),
            MyRoutes.reviewDisbursedAccRoutes: (context) => ReviewDisbursedAccMain(),
            MyRoutes.loanAgreementRoutes: (context) => LoanAgreementMain(),
            MyRoutes.loanReviewRoutes: (context) => LoanReviewMain(),
            MyRoutes.proceedToDisbursedRoutes: (context) => ProceedToDisburseMain(),
            MyRoutes.DisbursementSuccessMessage: (context) => ImportantSMSMain(),
            MyRoutes.LoanAggCompeletedRoutes: (context) => LoanAggCompeleted(),
            MyRoutes.LoanAgreementRoutes: (context) => LoanAgreementMain(),
            MyRoutes.EmailSentRoutes: (context) => EmailSentAfterLoanAgreement(),
            MyRoutes.LoanDetailsRoutes: (context) => CongratulationsFinalMain(),
            MyRoutes.ContactSupportRoutes: (context) => ContactSupportMain(),
            MyRoutes.LenderContactSupportRoutes: (context) => LenderSupportMain(),
            MyRoutes.RaiseDisputeRoutes: (context) => RaiseDisputeMain(),
            MyRoutes.TrackDisputeRoutes: (context) => TrackDisputeMain(),
            MyRoutes.DisputeInProgressRoutes: (context) => DisputeProgessMain(),
            MyRoutes.DisputeSubmitRoutes: (context) => SubmitDisputeMain(),
            MyRoutes.DisputeResolvedRoutes: (context) => DisputeResolvedMain(),
            MyRoutes.PaymentSuccessRoutes: (context) => PaymentSuccess(),
            MyRoutes.PrepayNowRoutes: (context) => PayNow(),
            MyRoutes.PersonalInfoDetailsRoutes: (context) => PersonalInfoDetails(),
            MyRoutes.NotiPrefrencesRoutes: (context) => NotiPrefrences(),
            MyRoutes.FAQRoutes: (context) => FAQMain(),
            MyRoutes.SetupEmandateRoutes: (context) => const SetupEmandate(),
            MyRoutes.EmandateStatusRoutes: (context) => const EmandateStatus(),
            MyRoutes.LoaderFetchGstDetailsRoutes: (context) => const LoaderFetchGstDetails(),
            MyRoutes.LoaderPrepareLoanDisbursmentRoutes: (context) => const LoaderPrepareLoanDisbursment(),
            MyRoutes.OtpVerifyLoginRoutes: (context) => const OtpVerifyLogin(),
            MyRoutes.OtpVerifyGSTRoutes: (context) => const OtpVerifyGST(),
            MyRoutes.GSTInvoiceListRefreshRoutes: (context) => const GSTInvoiceListRefresh(),
            MyRoutes.GSTInvoiceListFilterRoutes: (context) => const GSTInvoiceListFilter(),
            MyRoutes.loanDepositeAccRoutes: (context) => LoanDepositeAcc(),

            MyRoutes.profileViewRoutes: (context) => ProfileView(),

            MyRoutes.newProfileViewRoutes: (context) => NewProfileView(),






            // MyRoutes.StartRegistrationRoutes : (context) => StartRegistration()
          },

          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
    );
  }





  Future<void> _initFlavor() async{
    TGFlavor.init("packages/gstmobileservices/$CONFIG_FLAVORS_FILE");
  }

  Future<void> _init() async {
    TGLog.d("_init: Start");
    await Future.delayed(Duration(seconds: 2));
    await initService();
    TGLog.d("_init: End");
  }

}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    String? route;
    Map? queryParameters;
    if (settings.name != null) {
      var uriData = Uri.parse(settings.name!);
      route = uriData.path;
      // if (route == MyRoutes.aarepponse || route == MyRoutes.ConsentMonitoring) {
      //   queryParameters = uriData.queryParameters;
      // }
    }

    return MaterialPageRoute(
      builder: (context) {
        if (route == MyRoutes.ddeResponse) {
          /* Call after Loan Agreement Process*/
          return ESignCompletedMain();
        } else {
          return Container();
        }
      },
      settings: settings,
    );
  }





}