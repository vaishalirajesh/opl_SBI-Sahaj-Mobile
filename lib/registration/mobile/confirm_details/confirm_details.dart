import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/fetch_gst_data_res_main.dart';
import 'package:gstmobileservices/model/models/gst_basic_data_response_main.dart';
import 'package:gstmobileservices/model/requestmodel/fetch_gst_data_status_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_gst_basic_data_request.dart';
import 'package:gstmobileservices/model/responsemodel/fetch_gst_data_status_response.dart';
import 'package:gstmobileservices/model/responsemodel/gst_basic_data_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusconstants.dart';
import 'package:sbi_sahay_1_0/utils/erros_handle.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';

import '../../../loanprocess/viemmodel/ConfirmDetailsVM.dart';
import '../../../utils/helpers/myfonts.dart';
import '../../../utils/helpers/themhelper.dart';
import '../../../utils/internetcheckdialog.dart';
import '../../../utils/progressLoader.dart';
import '../../../utils/strings/strings.dart';
import '../dashboardwithoutgst/mobile/dashboardwithoutgst.dart';
import '../registration_completed/registration_completed.dart';

class GstBasicDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConfirmDetailVM viewModel = ConfirmDetailVM();
    viewModel.setContext(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(child: GstBasicDetailsScreen());
      },
    );
  }
}

class GstBasicDetailsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GstBasicDetailsScreenState();
}

class _GstBasicDetailsScreenState extends State<GstBasicDetailsScreen> {
  //bool isLoaderRun = true;
  bool confirmGstDetail = false;
  GstBasicDataResMain? _gstBasicDataResMain = GstBasicDataResMain();
  FetchGstDataResMain? _fetchGstDataResMain;
  bool isLoader = true;
  String? strLegalName = "";

  bool isOpenDetails = false;

  @override
  void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       LoaderUtils.showLoaderwithmsg(context,
//           msg: str_Fetching_your_GST_business_details);
// // your code goes here
//     });
//     getGstDetailStatus();

    super.initState();
  }

  Future<void> getGstDetailStatus() async {
    if (await TGNetUtil.isInternetAvailable()) {
      gstDetailsStatusAPI();
    } else {
      showSnackBarForintenetConnection(context, gstDetailsStatusAPI);
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (isLoaderRun){
    //   return MobileLoaderWithoutProgess(context, Utils.path(LOANOFFERLOADER), str_Fetching_your_GST_business_details, str_Kindly_wait_for_60s);
    // }else {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        SystemNavigator.pop(animated: true);
        return true;
      },
      child: Scaffold(
        appBar: getAppBarWithStepDone('1', str_registration, 0.25,
            onClickAction: () => {
                  Navigator.pop(context, false),
                  SystemNavigator.pop(animated: true)
                }),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: SizedBox(
              //height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  (isOpenDetails)
                      ? Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child:  _buildMiddler(),
                        )
                      :  _buildOnlyPersonalDetialContainer(),
                  confirmGstDetailCheck(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomSheet(),
      ),
    );
    // }
  }

  _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0.h, bottom: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            str_Confirm_Details,
            style: ThemeHelper.getInstance()!.textTheme.headline2,
          ),
        ],
      ),
    );
  }

  _buildMiddler() {
    return GestureDetector(
        onTap: (){
      setState(() {
        isOpenDetails = false;
      });
    },
    child:Container(
      decoration: BoxDecoration(
          border:
              Border.all(color: ThemeHelper.getInstance()!.cardColor, width: 1),
          color: ThemeHelper.getInstance()?.backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(16.r))),
      width: 335.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
            ),
            _buildTopPersonal(),
            SizedBox(
              height: 20.h,
            ),
            _buildRow(
                str_Legal_Name,
                _gstBasicDataResMain?.data?.lgnm == null
                    ? "Manish Patel"
                    : _gstBasicDataResMain?.data?.lgnm),
            SizedBox(
              height: 10.h,
            ),
            _buildRow(
                str_Trade_Name,
                _gstBasicDataResMain?.data?.tradeNam == null
                    ? "Indo International"
                    : _gstBasicDataResMain?.data?.tradeNam),
            SizedBox(
              height: 10.h,
            ),
            _buildRow(
                str_Constitution,
                _gstBasicDataResMain?.data?.ctb == null
                    ? "Proprietorship"
                    : _gstBasicDataResMain?.data?.ctb),
            SizedBox(
              height: 10.h,
            ),
            _buildRow(
                str_Date_of_Registration,
                _gstBasicDataResMain?.data?.rgdt == null
                    ? "01/08/2018"
                    : _gstBasicDataResMain?.data?.rgdt),
            SizedBox(
              height: 10.h,
            ),
            _buildRow(
                str_GSTIN,
                _gstBasicDataResMain?.data?.gstin == null
                    ? "24ABCDE1234F3Z6"
                    : _gstBasicDataResMain?.data?.gstin),
            SizedBox(
              height: 10.h,
            ),
            _buildRow(
                str_GSTIN_Status,
                _gstBasicDataResMain?.data?.sts == null
                    ? "Active"
                    : _gstBasicDataResMain?.data?.sts),
            SizedBox(
              height: 10.h,
            ),
            _buildRow(
                str_Taxpayer_Type,
                _gstBasicDataResMain?.data?.dty == null
                    ? "Regular"
                    : _gstBasicDataResMain?.data?.dty),
            SizedBox(
              height: 10.h,
            ),
            _buildRow(
                str_Business_Activity,
                _gstBasicDataResMain?.data?.lgnm == null
                    ? "Service Provider and Others"
                    : _gstBasicDataResMain?.data?.lgnm),
            SizedBox(
              height: 10.h,
            ),
            _buildRow(
                str_Place_of_Business,
                _gstBasicDataResMain?.data?.stj == null
                    ? "108, Near Datta Mandir, Radha Apartment, Bhavnagar, Gujarat, 364001"
                    : _gstBasicDataResMain?.data?.stj),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    ));
  }

  Widget confirmGstDetailCheck() {
    return GestureDetector(
      onTap: () {
        setState(() {
          confirmGstDetail = !confirmGstDetail;
        });
      },
      child: Padding(
          padding: EdgeInsets.only(top: 21.0.h),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 20.w,
                  height: 20.h,
                  child: Checkbox(
                    checkColor: ThemeHelper.getInstance()!.backgroundColor,
                    activeColor: ThemeHelper.getInstance()!.primaryColor,
                    value: confirmGstDetail,
                    onChanged: (bool) {
                      setState(() {
                        confirmGstDetail = bool!;
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.r))),
                    side: BorderSide(
                        width: 1,
                        color: confirmGstDetail
                            ? ThemeHelper.getInstance()!.primaryColor
                            : ThemeHelper.getInstance()!.disabledColor),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    checkboxText,
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline4
                        ?.copyWith(fontFamily: MyFont.Nunito_Sans_Semi_bold),
                    maxLines: 5,
                  ),
                ),
              ])),
    );
  }

  _buildRow(String title, String? subTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 119.w,
            child: Text(
              title,
              style: ThemeHelper.getInstance()!.textTheme.bodyText2,
            )),
        SizedBox(height: 2.h),
        SizedBox(
            width: 148.w,
            child: Text(subTitle ?? "",
                style: ThemeHelper.getInstance()!.textTheme.headline3)),
      ],
    );
  }

  _buildTopPersonal() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 200.w,
            child: Text(
              "Personal Details",
              style: ThemeHelper.getInstance()!.textTheme.headline2,
            )),
        Spacer(),
        SizedBox(
            child: Text("+",
                style: ThemeHelper.getInstance()!.textTheme.headline3)),
      ],
    );
  }

  _buildOnlyPersonalDetialContainer() {
    return GestureDetector(
      onTap: (){
        setState(() {
          isOpenDetails = true;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            border:
            Border.all(color: ThemeHelper.getInstance()!.cardColor, width: 1),
            color: ThemeHelper.getInstance()?.backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(16.r))),
        width: 335.w,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              _buildTopPersonal(),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildBottomSheet() {
    return SizedBox(
      height: 110.h,
      child: Padding(
        padding: EdgeInsets.only(left: 20.0.w, right: 20.w, bottom: 30.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            /*Text(str_Add_Another_GSTIN,
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .headline1
                    ?.copyWith(fontSize: 16.sp)),
            SizedBox(
              height: 10.h,
            ),*/
            ElevatedButton(
              style: confirmGstDetail
                  ? ThemeHelper.getInstance()!.elevatedButtonTheme.style
                  : ThemeHelper.setPinkDisableButtonBig(),
              onPressed: () {
                if (confirmGstDetail) {
                  Navigator.pop(context);

                  TGSharedPreferences.getInstance()
                      .set(PREF_ISGSTDETAILDONE, true);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => DashboardWithoutGST(),
                    ),
                    (route) =>
                        false, //if you want to disable back feature set to false
                  );
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationCompleted(),));
                }
              },
              child: Text(str_Confirm),
            ),
          ],
        ),
      ),
    );
  }

  void hideLoader() {
    setState(() {
      isLoader = false;
    });
  }

  Future<void> gstDetailsStatusAPI() async {
    setState(() {
      isLoader = true;
    });
    String gstin = await TGSharedPreferences.getInstance().get(PREF_GSTIN);

    FetGstDataStatusRequest fetGstDataStatusRequest =
        FetGstDataStatusRequest(id: gstin);
    var jsonReq = jsonEncode(fetGstDataStatusRequest.toJson());
    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, URI_FETCH_GST_DATA_STATUS);
    ServiceManager.getInstance().fetchGstDataStatus(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessFetchGstDataStatus(response),
        onError: (error) => _onErrorFetchGstDataStatus(error));
  }

  _onSuccessFetchGstDataStatus(FetchGstDataStatusResponse? response) async {
    TGLog.d("FetchGstDataStatus : onSuccess()");

    _fetchGstDataResMain = response?.getFetchGstDataObj();

    if (_fetchGstDataResMain?.status == RES_DETAILS_FOUND) {
      if (_fetchGstDataResMain?.data?.status == "PROCEED") {
        if (await TGNetUtil.isInternetAvailable()) {
          getGSTBasicsDetails();
        } else {
          showSnackBarForintenetConnection(context, getGSTBasicsDetails);
        }
      } else if (_fetchGstDataResMain?.data?.status == "RETRY") {
        Future.delayed(Duration(seconds: 10), () {
          getGstDetailStatus();
        });
      } else {
        getGstDetailStatus();
      }
    } else {
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(
          context,
          response?.getFetchGstDataObj().status,
          response?.getFetchGstDataObj().message,
          null);
      hideLoader();
    }
  }

  _onErrorFetchGstDataStatus(TGResponse errorResponse) {
    TGLog.d("FetchGstDataStatus : onError()");
    Navigator.pop(context);
    handleServiceFailError(context, errorResponse.error);
    hideLoader();
  }

  Future<void> getGSTBasicsDetails() async {
    String gstin = await TGSharedPreferences.getInstance().get(PREF_GSTIN);

    GstBasicDataRequest getGstBasicDataRequest = GstBasicDataRequest(id: gstin);
    var jsonReq = jsonEncode(getGstBasicDataRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_GST_BASIC_DATA);
    TGLog.d("GST Detail Data : $jsonReq");
    ServiceManager.getInstance().getBasicGstDetails(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetGstBasicDetails(response),
        onError: (error) => _onErrorGetBasicGstDetails(error));
  }

  _onSuccessGetGstBasicDetails(GstBasicDataResponse? response) {
    TGLog.d("GetGstBasicDetails : onSuccess()");
    if (response?.getFetchGstDataObj().status == RES_DETAILS_FOUND) {
      Navigator.pop(context);
      setState(() {
        _gstBasicDataResMain = response?.getFetchGstDataObj();
        TGSharedPreferences.getInstance()
            .set(PREF_BUSINESSNAME, _gstBasicDataResMain?.data?.tradeNam);
        TGSharedPreferences.getInstance()
            .set(PREF_USERNAME, _gstBasicDataResMain?.data?.lgnm.toString());
        TGSharedPreferences.getInstance()
            .set(PREF_USERSTATE, _gstBasicDataResMain?.data?.stcd.toString());
        hideLoader();
      });
    } else if (response?.getFetchGstDataObj().status == RES_DETAILS_NOT_FOUND) {
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(
          context,
          response?.getFetchGstDataObj().status,
          response?.getFetchGstDataObj().message,
          null);
      hideLoader();
    } else {
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(
          context,
          response?.getFetchGstDataObj().status,
          response?.getFetchGstDataObj().message,
          null);
      hideLoader();
    }
  }

  _onErrorGetBasicGstDetails(TGResponse errorResponse) {
    Navigator.pop(context);
    TGLog.d("GetGstBasicDetails : onError()");
    handleServiceFailError(context, errorResponse.error);
    hideLoader();
  }
}
