import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/common/keys.dart';
import 'package:gstmobileservices/singleton/tg_session.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/aalist/ui/aa_error_screen.dart';
import 'package:sbi_sahay_1_0/registration/mobile/login_restriction/login_restriction.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusConstants.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';
import 'package:sbi_sahay_1_0/widgets/gst_enable_dialog.dart';
import 'package:sbi_sahay_1_0/widgets/offer_expire_dialog.dart';

import '../loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import 'colorutils/mycolors.dart';
import 'constants/session_keys.dart';
import 'constants/statusconstants.dart' as LOCALCONST;
import 'helpers/themhelper.dart';

class LoaderUtils {
  static final LoaderUtils _instance = LoaderUtils.internal();

  LoaderUtils.internal();

  factory LoaderUtils() => _instance;

  static Future<void> showLoaderwithmsg(BuildContext context, {required String msg}) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              TGView.showSnackBar(context: context, message: str_back_press_alert_msg);
              return false;
            },
            child: Scaffold(
              backgroundColor: MyColors.darkblack,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            backgroundColor: MyColors.pnbcolorPrimary,
                            strokeWidth: 4.w,
                            color: MyColorsSBI.sbicolorDisableColor,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
                      child: Center(
                        child: Text(
                          msg,
                          textAlign: TextAlign.center,
                          style: ThemeHelper.getInstance()?.textTheme.button?.copyWith(
                                color: ThemeHelper.getInstance()?.colorScheme.background,
                              ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  static void showOfferExpired(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => DashboardWithGST()),
                (route) => false, //if you want to disable back feature set to false
              );

              return true;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 100.h),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_outlined,
                        color: ThemeHelper.getInstance()?.primaryColor,
                        size: 50.h,
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        "Sorry!",
                        style: ThemeHelper?.getInstance()?.textTheme.headline1,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        'It seems this offer is expired. Request you to start new loan process once new GST return is filled.',
                        style: ThemeHelper.getInstance()?.textTheme.bodyText2,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) => const DashboardWithGST()),
                              (route) => false, //if you want to disable back feature set to false
                            );
                          },
                          child: Center(
                            child: Text(
                              str_back_home,
                              style: ThemeHelper.getInstance()?.textTheme.button,
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  static void showOfferIneligible(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => DashboardWithGST(),
                ),
                (route) => false, //if you want to disable back feature set to false
              );

              return true;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 100.h),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_outlined,
                        color: ThemeHelper.getInstance()?.primaryColor,
                        size: 50.h,
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        "Sorry!",
                        style: ThemeHelper?.getInstance()?.textTheme.headline1,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        'Lender has not reverted with offer for your shared GST invoices. Request you to start new loan process once new GST return is filed',
                        style: ThemeHelper.getInstance()?.textTheme.bodyText2,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => DashboardWithGST(),
                              ),
                              (route) => false, //if you want to disable back feature set to false
                            );
                          },
                          child: Center(
                            child: Text(
                              str_back_home,
                              style: ThemeHelper.getInstance()?.textTheme.button,
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  static void showBureauFail(BuildContext context, String? message) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => DashboardWithGST(),
                ),
                (route) => false, //if you want to disable back feature set to false
              );

              return true;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 100.h),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_outlined,
                        color: ThemeHelper.getInstance()?.primaryColor,
                        size: 50.h,
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        "Sorry!",
                        style: ThemeHelper?.getInstance()?.textTheme.headline1,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        message ?? '',
                        style: ThemeHelper.getInstance()?.textTheme.bodyText2,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => DashboardWithGST(),
                              ),
                              (route) => false, //if you want to disable back feature set to false
                            );
                          },
                          child: Center(
                            child: Text(
                              str_back_home,
                              style: ThemeHelper.getInstance()?.textTheme.button,
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  static Future<void> handleErrorResponse(
      BuildContext context, int? status, String? message, String? stageStatus) async {
    if (status == RES_OFFER_EXPIRED) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const OfferExpireDialog(),
          ),
          (route) => false);
    } else if (status == RES_OFFER_INELIGIBLE) {
      showOfferIneligible(context);
    } else if (status == ACTION_REQUIRED) {
      showBureauFail(context, message);
    } else if (stageStatus != null && stageStatus == "ACTION_REQUIRED") {
      showBureauFail(context, message);
    } else if (status == RES_UNAUTHORISED) {
      await TGSharedPreferences.getInstance().remove(PREF_ACCESS_TOKEN_SBI);
      SystemNavigator.pop(animated: true);
    } else if (status == CONSENT_REJECTION) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const AAErrorScreen(msg: consent_fail),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
    } else if (status == LOCALCONST.UNLINK_ACCOUNT_AGGREGATOR) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const AAErrorScreen(msg: unlinked_account_aggregator_msg),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
    } else if (status == LOCALCONST.RES_RESTRICT_LOGIN) {
      TGSession.getInstance().set(SESSION_ERROR_MSG, message);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const RestrictLogin(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
    } else if (status == LOCALCONST.RES_GST_APIDENIED) {
      showDialog(context: context, builder: (_) => const GSTEnableDialog());
    } else {
      TGView.showSnackBar(context: context, message: message ?? "");
    }
  }
}

//showDialog(context: context, builder: (BuildContext context) => errorDialog);}
