import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_loan_app_status_main.dart';
import 'package:gstmobileservices/model/models/share_gst_invoice_res_main.dart';
import 'package:gstmobileservices/model/requestmodel/generate_loan_offer_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_loan_app_status_request.dart';
import 'package:gstmobileservices/model/responsemodel/generate_loan_offer_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_loan_app_status_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:lottie/lottie.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusconstants.dart';
import 'package:sbi_sahay_1_0/utils/erros_handle.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';

import '../../../../routes.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/internetcheckdialog.dart';
import '../../../../utils/movestageutils.dart';
import '../../../../utils/progressLoader.dart';
import '../../../../widgets/loaderscreen/mobileloader/loaderwithprogressbar.dart';
import '../../dashboardwithgst/mobile/dashboardwithgst.dart';

class InfoShare extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SafeArea(child: InfoSharedScreenUI());
    });
  }
}

class InfoSharedScreenUI extends StatefulWidget {
  const InfoSharedScreenUI({Key? key}) : super(key: key);

  @override
  State<InfoSharedScreenUI> createState() => _InfoSharedScreenUIState();
}

class _InfoSharedScreenUIState extends State<InfoSharedScreenUI> {
  ShareGstInvoiceResMain? _shareGstInvoiceRes;
  GetLoanStatusResMain? _getLoanStatusRes;


  //bool setIsLoader = false;
  @override
  Widget build(BuildContext context) {
    // if(setIsLoader)
    // {
    //   return MobileLoaderWithProgess(context, Utils.path(LOANOFFERLOADER), str_regain_figure, str_fetch_loan_offer_from_lender);
    // }
    // else
    // {
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
          appBar: getAppBarWithBackBtn(onClickAction: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => DashboardWithGST(),
              ),
              (route) =>
                  false, //if you want to disable back feature set to false
            );
          }),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    height: 159.h,
                    width: 250.w,
                    Utils.path(INFOSHARELOADER),
                    fit: BoxFit.fitHeight,
                  ),
                  // Lottie.asset(Utils.path(INFOSHARELOADER),
                  //     height: 159.h ,//80.w,
                  //     width: 250.w,//80.w,
                  //     repeat: true,
                  //     reverse: false,
                  //     animate: true,
                  //     frameRate: FrameRate.max,
                  //     fit: BoxFit.cover
                  // ),
                  Text(
                    str_info_share,
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline1
                        ?.copyWith(fontSize: 32.sp),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    str_info_share_txt,
                    style: ThemeHelper.getInstance()?.textTheme.headline3,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  GetLoanOfferBtnUI(context)
                ],
              ),
            ),
          ),
        ));
    //}
  }

  Widget GetLoanOfferBtnUI(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
          onPressed: () async {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              LoaderUtils.showLoaderwithmsg(context,
                  msg: "Please Wait....\n$str_fetch_loan_offer_from_lender");
            });

            if (await TGNetUtil.isInternetAvailable()) {
              generateLoanOffer();
            } else {
              showSnackBarForintenetConnection(context, generateLoanOffer);
            }
          },
          child: Center(
            child: Text(
              str_get_loan_offers,
              style: ThemeHelper.getInstance()?.textTheme.button,
            ),
          )),
    );
  }



  Future<void> generateLoanOffer() async {
    String loanAppRefId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    GenerateLoanOfferRequest generateLoanOfferRequest =
        GenerateLoanOfferRequest(loanApplicationRefId: loanAppRefId);
    var jsonReq = jsonEncode(generateLoanOfferRequest.toJson());
    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, URI_GENERATE_LOAN_OFFERS);
    ServiceManager.getInstance().generateLoanOffer(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGenerateLoanOffer(response),
        onError: (error) => _onErrorGenerateLoanOffer(error));
  }

  _onSuccessGenerateLoanOffer(GenerateLoanOfferResponse? response)  {
    TGLog.d("GenerateLoanOfferResponse : onSuccess()");
    _shareGstInvoiceRes = response?.getGenerateOfferResObj();
    if (_shareGstInvoiceRes?.status == RES_SUCCESS) {
      getLoanAppStatusAfterGenerateOfferAPI();
    } else {
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(
          context,
          response?.getGenerateOfferResObj().status,
          response?.getGenerateOfferResObj().message,
          null);
    }
  }

  _onErrorGenerateLoanOffer(TGResponse errorResponse) {
    TGLog.d("GenerateLoanOfferResponse : onError()");
    Navigator.pop(context);
  }

  Future<void> getLoanAppStatusAfterGenerateOffer() async {
    String loanAppRefId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    GetLoanStatusRequest getLoanStatusRequest =
        GetLoanStatusRequest(loanApplicationRefId: loanAppRefId);
    var jsonReq = jsonEncode(getLoanStatusRequest.toJson());
    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, Utils.getManageLoanAppStatusParam('3'));
    ServiceManager.getInstance().getLoanAppStatus(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetLoanAppStatus(response),
        onError: (error) => _onErrorGetLoanAppStatus(error));
  }

  _onSuccessGetLoanAppStatus(GetLoanStatusResponse? response)  {
    TGLog.d("LoanAppStatusResponse : onSuccess()");
    _getLoanStatusRes = response?.getLoanStatusResObj();

    if (_getLoanStatusRes?.status == RES_SUCCESS) {
      if (_getLoanStatusRes?.data?.stageStatus == "PROCEED") {
        Navigator.pop(context);
        MoveStage.navigateNextStage(
            context, _getLoanStatusRes?.data?.currentStage);
        //Navigator.pushNamed(context, MyRoutes.loanOfferListRoutes);
      } else if (_getLoanStatusRes?.data?.stageStatus == "HOLD") {
        Future.delayed(const Duration(seconds: 10), ()  {
          getLoanAppStatusAfterGenerateOfferAPI();
        });
      } else {
        getLoanAppStatusAfterGenerateOfferAPI();
      }
    } else {
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(
          context,
          response?.getLoanStatusResObj().status,
          response?.getLoanStatusResObj().message,
          response?.getLoanStatusResObj().data?.stageStatus);
    }
  }

  _onErrorGetLoanAppStatus(TGResponse errorResponse) {
    TGLog.d("LoanAppStatusResponse : onError()");
    Navigator.pop(context);
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> getLoanAppStatusAfterGenerateOfferAPI() async
  {
    if (await TGNetUtil.isInternetAvailable()) {
      getLoanAppStatusAfterGenerateOffer();
    } else {
      showSnackBarForintenetConnection(
          context, getLoanAppStatusAfterGenerateOffer);
    }
  }
}
