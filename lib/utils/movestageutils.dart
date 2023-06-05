import 'package:flutter/material.dart';
import 'package:gstmobileservices/model/models/get_loandetail_by_refid_res_main.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/loanofferlist/ui/loan_offer_pop_up.dart';

import '../disbursed/mobile/loanreview/ui/loanreviewscreen.dart';
import '../disbursed/mobile/proceedtodisbursed/ui/proceedtodisbscreen.dart';
import '../documentation/mobile/loanagreement/ui/loanageementscreen.dart';
import '../documentation/mobile/reviewdisbursedacc/ui/reviewdisbursedaccscreen.dart';
import '../documentation/mobile/setupemandate/ui/setupemandate.dart';
import '../loader/redirecting_loader.dart';
import '../loanprocess/mobile/accountaggregatorntb/ui/aadetails.dart';
import '../loanprocess/mobile/congratulations_final/ui/congratulationfinalscreen.dart';
import '../loanprocess/mobile/emailafterloanagreement/mobile/email_sent_after_loan_agreement.dart';
import '../loanprocess/mobile/gstinvoiceslist/ui/gstinvoicelist.dart';
import '../loanprocess/mobile/infosharedscreen/ui/infosharedscreen.dart';
import '../loanprocess/mobile/loanofferlist/ui/loanofferlistscreen.dart';
import '../registration/mobile/cic_consent/cic_consent.dart';
import 'constants/prefrenceconstants.dart';
import 'constants/stageconstants.dart';

class MoveStage {
  static void movetoStage(BuildContext context, LoanDetailData? loanDetailsData) async {
    await TGSharedPreferences.getInstance().set(PREF_LOANAPPREFID, loanDetailsData?.loanAppRefNo);
    await TGSharedPreferences.getInstance().set(PREF_CURRENT_STAGE, loanDetailsData?.currentApplicationStage);
    await TGSharedPreferences.getInstance().set(PREF_GSTIN, loanDetailsData?.gstin);
    TGSharedPreferences.getInstance().set(PREF_CURRENT_STAGE, loanDetailsData?.currentApplicationStage);
    bool? isCicConsentDone = await TGSharedPreferences.getInstance().get(PREF_ISCIC_CONSENT);

    if (loanDetailsData?.currentApplicationStage != STAGE_DISBURSEMENT_STATUS) {
      if (loanDetailsData?.currentApplicationStage == STAGE_INITIATED &&
          loanDetailsData?.nextApplicationStage == STAGE_SHARE_INVOICE) {
        if (isCicConsentDone == null || isCicConsentDone == false) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => CicConsent(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const GSTInvoicesList(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
        }

        //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GSTInvoicesList()));
      } else if (loanDetailsData?.currentApplicationStage == STAGE_INITIATED) {
        if (isCicConsentDone == null || isCicConsentDone == false) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => CicConsent(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const GSTInvoicesList(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
        }

        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GSTInvoicesList()));
      } else if (loanDetailsData?.currentApplicationStage == STAGE_SHARE_INVOICE) {
        if (isCicConsentDone == null || isCicConsentDone == false) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => CicConsent(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const GSTInvoicesList(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
        }

        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GSTInvoicesList()));
      } else if (loanDetailsData?.currentApplicationStage == STAGE_CONSENT) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const AccountAggregatorDetails(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );

        ///Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AccountAggregatorDetails()));
      } else if (loanDetailsData?.currentApplicationStage == STAGE_LIST_OFFER) {
        await TGSharedPreferences.getInstance().set(PREF_AAID, loanDetailsData?.aaId);
        await TGSharedPreferences.getInstance().set(PREF_AACODE, loanDetailsData?.aaCode);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoanOfferList(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );

        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoanOfferList()));

        //Navigator.pushNamed(context, MyRoutes.loanOfferListRoutes);
      } else if (loanDetailsData?.currentApplicationStage == STAGE_LOAN_OFFER) {
        await TGSharedPreferences.getInstance().set(PREF_AAID, loanDetailsData?.aaId);
        await TGSharedPreferences.getInstance().set(PREF_AACODE, loanDetailsData?.aaCode);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => InfoShare(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );
        //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InfoShare()));
      } else if (loanDetailsData?.currentApplicationStage == STAGE_SET_DISBURSEMENT_ACC) {
        await TGSharedPreferences.getInstance().set(PREF_AAID, loanDetailsData?.aaId);
        await TGSharedPreferences.getInstance().set(PREF_AACODE, loanDetailsData?.aaCode);
        await TGSharedPreferences.getInstance().set(PREF_LOANAPPID, loanDetailsData?.loanApplicationId);
        await TGSharedPreferences.getInstance().set(PREF_OFFERID, loanDetailsData?.offerId);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ReviewDisbursedAccMain(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );

        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ReviewDisbursedAccMain()));
      } else if (loanDetailsData?.currentApplicationStage == STAGE_SIGN_AGGREEMENT) {
        await TGSharedPreferences.getInstance().set(PREF_AAID, loanDetailsData?.aaId);
        await TGSharedPreferences.getInstance().set(PREF_AACODE, loanDetailsData?.aaCode);
        await TGSharedPreferences.getInstance().set(PREF_LOANAPPID, loanDetailsData?.loanApplicationId);
        await TGSharedPreferences.getInstance().set(PREF_OFFERID, loanDetailsData?.offerId);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoanAgreementMain(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );

        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoanAgreementMain()));
      } else if (loanDetailsData?.currentApplicationStage == STAGE_SIGN_AGGREEMENT_STATUS) {
        await TGSharedPreferences.getInstance().set(PREF_AAID, loanDetailsData?.aaId);
        await TGSharedPreferences.getInstance().set(PREF_OFFERID, loanDetailsData?.offerId);
        await TGSharedPreferences.getInstance().set(PREF_AACODE, loanDetailsData?.aaCode);
        await TGSharedPreferences.getInstance().set(PREF_LOANAPPID, loanDetailsData?.loanApplicationId);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoanAgreementMain(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );

        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoanAgreementMain()));
      } else if (loanDetailsData?.currentApplicationStage == STAGE_GRANT_LOAN) {
        await TGSharedPreferences.getInstance().set(PREF_AAID, loanDetailsData?.aaId);
        await TGSharedPreferences.getInstance().set(PREF_OFFERID, loanDetailsData?.offerId);
        await TGSharedPreferences.getInstance().set(PREF_AACODE, loanDetailsData?.aaCode);
        await TGSharedPreferences.getInstance().set(PREF_LOANAPPID, loanDetailsData?.loanApplicationId);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const EmailSentAfterLoanAgreement(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );

        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EmailSentAfterLoanAgreement()));
      } else if (loanDetailsData?.currentApplicationStage == STAGE_E_MANDATE) {
        await TGSharedPreferences.getInstance().set(PREF_AAID, loanDetailsData?.aaId);
        await TGSharedPreferences.getInstance().set(PREF_OFFERID, loanDetailsData?.offerId);
        await TGSharedPreferences.getInstance().set(PREF_AACODE, loanDetailsData?.aaCode);
        await TGSharedPreferences.getInstance().set(PREF_LOANAPPID, loanDetailsData?.loanApplicationId);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const SetupEmandate(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );

        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SetupEmandate()));
      } else if (loanDetailsData?.currentApplicationStage == STAGE_E_MANDATE_STATUS) {
        await TGSharedPreferences.getInstance().set(PREF_AAID, loanDetailsData?.aaId);
        await TGSharedPreferences.getInstance().set(PREF_OFFERID, loanDetailsData?.offerId);
        await TGSharedPreferences.getInstance().set(PREF_AACODE, loanDetailsData?.aaCode);
        await TGSharedPreferences.getInstance().set(PREF_LOANAPPID, loanDetailsData?.loanApplicationId);
        await TGSharedPreferences.getInstance().set(PREF_REPAYMENTPLANID, loanDetailsData?.repaymentPlanId);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const SetupEmandate(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );

        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SetupEmandate()));
      } else if (loanDetailsData?.currentApplicationStage == STAGE_CONSENT_MONITORING) {
        await TGSharedPreferences.getInstance().set(PREF_AAID, loanDetailsData?.aaId);
        await TGSharedPreferences.getInstance().set(PREF_AACODE, loanDetailsData?.aaCode);
        await TGSharedPreferences.getInstance().set(PREF_LOANAPPID, loanDetailsData?.loanApplicationId);
        //Navigator.pushNamed(context, MyRoutes.ConsentMonitoring);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const RedirectedLoader(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );

        //   Navigator.pushNamed(context, MyRoutes.proceedToDisbursedRoutes);
      } else if (loanDetailsData?.currentApplicationStage == STAGE_DISBURSEMENT) {
        await TGSharedPreferences.getInstance().set(PREF_LOANAPPID, loanDetailsData?.loanApplicationId);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const ProceedToDisburseMain(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );

        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProceedToDisburseMain()));
      } else if (loanDetailsData?.currentApplicationStage == STAGE_DISBURSEMENT_STATUS) {
        await TGSharedPreferences.getInstance().set(PREF_LOANAPPID, loanDetailsData?.loanApplicationId);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoanReviewMain(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );

        //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoanReviewMain()));

        // Navigator.pushNamed(context, MyRoutes.reviewDisbursedAccRoutes);
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => CongratulationsFinalMain(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );

        //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CongratulationsFinalMain()));
      }
    } else {
      await TGSharedPreferences.getInstance().set(PREF_LOANAPPID, loanDetailsData?.loanApplicationId);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => CongratulationsFinalMain(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );

      //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CongratulationsFinalMain()));
    }
  }

  static void navigateNextStage(BuildContext context, String? currentAppStage) {
    TGSharedPreferences.getInstance().set(PREF_CURRENT_STAGE, currentAppStage);

    if (currentAppStage == STAGE_INITIATED) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const GSTInvoicesList(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GSTInvoicesList()));
    } else if (currentAppStage == STAGE_SHARE_INVOICE) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const GSTInvoicesList(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );

      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GSTInvoicesList()));
    } else if (currentAppStage == STAGE_CONSENT) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const AccountAggregatorDetails(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );

      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AccountAggregatorDetails()));
    } else if (currentAppStage == STAGE_LIST_OFFER) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const LoanOfferDialog(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );

      //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoanOfferList()));
    } else if (currentAppStage == STAGE_LOAN_OFFER) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoanOfferDialog(),
        ),
        (route) => false,
      );

      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InfoShare()));
    } else if (currentAppStage == STAGE_SET_DISBURSEMENT_ACC) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoanOfferDialog(),
        ),
        (route) => false,
      );
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ReviewDisbursedAccMain()));
    } else if (currentAppStage == STAGE_SIGN_AGGREEMENT) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoanAgreementMain(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoanAgreementMain()));
    } else if (currentAppStage == STAGE_SIGN_AGGREEMENT_STATUS) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoanAgreementMain(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );

      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoanAgreementMain()));
    } else if (currentAppStage == STAGE_GRANT_LOAN) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const SetupEmandate(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );

      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EmailSentAfterLoanAgreement()));
    } else if (currentAppStage == STAGE_E_MANDATE) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const ProceedToDisburseMain(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
      //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SetupEmandate()));
    } else if (currentAppStage == STAGE_E_MANDATE_STATUS) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const SetupEmandate(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );

      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SetupEmandate()));
    } else if (currentAppStage == STAGE_CONSENT_MONITORING) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const RedirectedLoader(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );

      //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RedirectedLoader()));
    } else if (currentAppStage == STAGE_DISBURSEMENT) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const ProceedToDisburseMain(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );

      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProceedToDisburseMain()));
      // Navigator.pushNamed(context, MyRoutes.proceedToDisbursedRoutes);
    } else if (currentAppStage == STAGE_DISBURSEMENT_STATUS) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LoanReviewMain(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );

      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoanReviewMain()));
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => CongratulationsFinalMain(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );

      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CongratulationsFinalMain()));
    }
  }
}
