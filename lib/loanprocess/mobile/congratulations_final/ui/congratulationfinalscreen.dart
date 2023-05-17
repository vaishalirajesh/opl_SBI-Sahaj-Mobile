import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_disbursement_detail_res_main.dart';
import 'package:gstmobileservices/model/requestmodel/get_disbursed_acc_detail_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_disburse_detail_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/erros_handle.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';

import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/constants/prefrenceconstants.dart';
import '../../../../utils/constants/statusConstants.dart';
import '../../../../utils/internetcheckdialog.dart';
import '../../../../utils/progressLoader.dart';
import '../../../../utils/strings/strings.dart';
import '../../dashboardwithgst/mobile/dashboardwithgst.dart';

class CongratulationsFinalMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CongratulationsFinalMains();
  }
}

class CongratulationsFinalMains extends StatefulWidget {
  @override
  CongratulationsFinalMainBody createState() => new CongratulationsFinalMainBody();
}

class CongratulationsFinalMainBody extends State<CongratulationsFinalMains> {
  GetDisburseDetailResMain? _getDisburseDetailResMain;

  GetDisbursementData? dictDisbData;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      LoaderUtils.showLoaderwithmsg(context, msg: "Getting Disbursement Details Wait a Moment.....");
      if (await TGNetUtil.isInternetAvailable()) {
        getDisbursementDetailAPI();
      } else {
        showSnackBarForintenetConnection(context, getDisbursementDetailAPI);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SafeArea(
          child: WillPopScope(
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
              child: CongratulationsFinalScreen(context)));
    });
    return CongratulationsFinalScreen(context);
    ;
  }

  Widget CongratulationsFinalScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getInstance()?.backgroundColor,
      body: CongratulationsFinalScreenContent(context),
      bottomNavigationBar: _bottomSheet(context),
    );
  }

  Widget CongratulationsFinalScreenContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 19.0.w),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.0.h),
                child: Image.asset(
                  height: 127.h,
                  width: 166.w,
                  Utils.path(RUPEELOADE),
                  fit: BoxFit.fitHeight,
                ),
              ),
              // Lottie.asset(Utils.path(RUPEELOADE),
              //     height: 127.h,
              //     //80.w,
              //     width: 166.w,
              //     //80.w,
              //     repeat: true,
              //     reverse: false,
              //     animate: true,
              //     frameRate: FrameRate.max,
              //     fit: BoxFit.cover
              // ),
              _buildTopContent(context),

              ..._buildTableData(context)
            ]),
      ),
    );
  }

  _buildTopContent(BuildContext context) {
    return Column(
      children: [
        Text(
          str_Congratulations_with_extre,
          style: ThemeHelper.getInstance()!.textTheme.headline1,
        ),
        SizedBox(
          height: 10.h,
        ),
        /*Text(
        str_const_long_sentence, textAlign: TextAlign.center, style: ThemeHelper
          .getInstance()!
          .textTheme
          .headline4!
          .copyWith(fontSize: 12.sp, color: MyColors.pnbsmallbodyTextColor),)*/
      ],
    );
  }

  _buildTableData(BuildContext context) {
    return [
      SizedBox(
        height: 40.h,
      ),
      _buildTableRowData(str_Status, dictDisbData?.status ?? ""),
      Divider(),
      _buildTableRowData(str_Lender, dictDisbData?.lender ?? ""),
      Divider(),
      _buildTableRowData(str_Total_Loan, Utils.convertIndianCurrency(dictDisbData?.totalLoan) ?? ""),
      Divider(),
      _buildTableRowData(str_Deposit_Account, dictDisbData?.depositAccount ?? ""),
      Divider(),
      _buildTableRowData(str_Total_Repayment, Utils.convertIndianCurrency(dictDisbData?.totalRepayment) ?? ""),
      Divider(),
      _buildTableRowData(str_Due_Date, dictDisbData?.dueDate ?? ""),
      Divider(),
      _buildTableRowData(str_Loan_ID, dictDisbData?.loanId ?? ""),
      SizedBox(
        height: 50.h,
      )
    ];
  }

  _buildTableRowData(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Text(
              title,
              style: ThemeHelper.getInstance()!.textTheme.headline2!.copyWith(color: MyColors.black, fontSize: 16.sp),
            ),
          ),
          Flexible(
            flex: 1,
            child: Text(
              value,
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline2!
                  .copyWith(color: MyColors.pnbcolorPrimary, fontSize: 16.sp),
              maxLines: 5,
            ),
          ),
        ],
      ),
    );
  }

  _bottomSheet(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      child: Container(
          height: 94.h,
          width: 367.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                  onPressed: () {
                    //    Navigator.pushNamed(context, MyRoutes.DashboardWithGSTRoutes);
                    //   Navigator.of(context).push(CustomRightToLeftPageRoute(child: DashboardWithGST(), ));
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => DashboardWithGST(),
                      ),
                      (route) => false, //if you want to disable back feature set to false
                    );
                  },
                  child: Text(str_Finance_other_Invoice))
            ],
          )),
    );
  }

  //API

  Future<void> getDisbursementDetailAPI() async {
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String loanAppID = await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);

    GetDisbursedAccDetailRequest getDisbursedAccDetail = GetDisbursedAccDetailRequest(
      loanApplicationRefId: loanAppRefId,
      loanApplicationId: loanAppID,
    );
    var jsonReq = jsonEncode(getDisbursedAccDetail.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_GET_DISBURSED_DETAIL);
    ServiceManager.getInstance().getDisbursementDetail(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessTriggerDisbursement(response),
        onError: (error) => _onErrorTriggerDisbursement(error));
  }

  _onSuccessTriggerDisbursement(GetDisburseDetailResponse? response) {
    TGLog.d("TriggerDisbursementResponse : onSuccess()");

    if (response?.getDisburseDetailResOnj().status == RES_DETAILS_FOUND) {
      _getDisburseDetailResMain = response?.getDisburseDetailResOnj();
      Navigator.pop(context);
      setState(() {
        dictDisbData = _getDisburseDetailResMain?.data;
      });
    } else {
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(
          context, response?.getDisburseDetailResOnj().status, response?.getDisburseDetailResOnj().message, null);
    }
  }

  _onErrorTriggerDisbursement(TGResponse errorResponse) {
    Navigator.pop(context);
    TGLog.d("TriggerDisbursementResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
  }
