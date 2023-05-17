import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusconstants.dart';
import 'package:sbi_sahay_1_0/utils/erros_handle.dart';
import 'package:sbi_sahay_1_0/utils/helpers/myfonts.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';
import 'package:sbi_sahay_1_0/widgets/info_loader.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';

import '../../../loanprocess/viemmodel/ConfirmDetailsVM.dart';
import '../../../utils/Utils.dart';
import '../../../utils/colorutils/mycolors.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/helpers/themhelper.dart';
import '../../../utils/internetcheckdialog.dart';
import '../../../utils/progressLoader.dart';
import '../../../utils/strings/strings.dart';
import '../dashboardwithoutgst/mobile/dashboardwithoutgst.dart';

class GstBasicDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConfirmDetailVM viewModel = ConfirmDetailVM();
    viewModel.setContext(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return const SafeArea(child: GstBasicDetailsScreen());
      },
    );
  }
}

class GstBasicDetailsScreen extends StatefulWidget {
  const GstBasicDetailsScreen({super.key});

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

  bool isOpenDetails = true;
  bool isLoadData = false;

  @override
  void initState() {
    getGstDetailStatus();
    super.initState();
  }

  Future<void> getGstDetailStatus() async {
    if (await TGNetUtil.isInternetAvailable()) {
      gstDetailsStatusAPI();
    } else {
      if (mounted) {
        showSnackBarForintenetConnection(context, gstDetailsStatusAPI);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        SystemNavigator.pop(animated: true);
        return true;
      },
      child: !isLoadData
          ? const ShowInfoLoader(
              msg: str_Fetching_your_GST_business_details,
              subMsg: '',
            )
          : Scaffold(
              appBar: getAppBarWithStepDone('1', str_registration, 0.25,
                  onClickAction: () => {
                        Navigator.pop(context, false),
                        SystemNavigator.pop(animated: true),
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
                        _buildMiddler(),

                        // (isOpenDetails)
                        //     ? Padding(
                        //         padding: EdgeInsets.only(top: 10.h),
                        //         child:  _buildMiddler(),
                        //       )
                        //     :  _buildOnlyPersonalDetialContainer(),
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
        onTap: () {
          setState(() {
            isOpenDetails = !isOpenDetails;
          });
        },
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3), //color of shadow
                  spreadRadius: 1, //spread radius
                  blurRadius: 3, // blur radius
                  offset: const Offset(0, 1), // changes position of shadow
                )
              ],
              border: Border.all(color: ThemeHelper.getInstance()!.cardColor, width: 1),
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
                isOpenDetails ? ExpandedView() : Container()

                // _buildRow(
                //     str_Legal_Name,
                //     _gstBasicDataResMain?.data?.lgnm == null
                //         ? "Manish Patel"
                //         : _gstBasicDataResMain?.data?.lgnm),
                // SizedBox(
                //   height: 24.h,
                // ),
                // _buildRow(
                //     str_Trade_Name,
                //     _gstBasicDataResMain?.data?.tradeNam == null
                //         ? "Indo International"
                //         : _gstBasicDataResMain?.data?.tradeNam),
                // SizedBox(
                //   height: 24.h,
                // ),
                // _buildRow(
                //     str_Constitution,
                //     _gstBasicDataResMain?.data?.ctb == null
                //         ? "Proprietorship"
                //         : _gstBasicDataResMain?.data?.ctb),
                // SizedBox(
                //   height: 24.h,
                // ),
                // _buildRow(
                //     str_Date_of_Registration,
                //     _gstBasicDataResMain?.data?.rgdt == null
                //         ? "01/08/2018"
                //         : _gstBasicDataResMain?.data?.rgdt),
                // SizedBox(
                //   height: 24.h,
                // ),
                // _buildRow(
                //     str_GSTIN,
                //     _gstBasicDataResMain?.data?.gstin == null
                //         ? "24ABCDE1234F3Z6"
                //         : _gstBasicDataResMain?.data?.gstin),
                // SizedBox(
                //   height: 24.h,
                // ),
                // _buildRow(
                //     str_GSTIN_Status,
                //     _gstBasicDataResMain?.data?.sts == null
                //         ? "Active"
                //         : _gstBasicDataResMain?.data?.sts),
                // SizedBox(
                //   height: 24.h,
                // ),
                // _buildRow(
                //     str_Taxpayer_Type,
                //     _gstBasicDataResMain?.data?.dty == null
                //         ? "Regular"
                //         : _gstBasicDataResMain?.data?.dty),
                // SizedBox(
                //   height: 24.h,
                // ),
                // _buildRow(
                //     str_Business_Activity,
                //     _gstBasicDataResMain?.data?.lgnm == null
                //         ? "Service Provider and Others"
                //         : _gstBasicDataResMain?.data?.lgnm),
                // SizedBox(
                //   height: 24.h,
                // ),
                // _buildRow(
                //     str_Place_of_Business,
                //     _gstBasicDataResMain?.data?.stj == null
                //         ? "108, Near Datta Mandir, Radha Apartment, Bhavnagar, Gujarat, 364001"
                //         : _gstBasicDataResMain?.data?.stj),
                // SizedBox(
                //   height: 20.h,
                // ) ,
              ],
            ),
          ),
        ));
  }

  Widget ExpandedView() {
    return Column(
      children: [
        _buildRow(str_Legal_Name, _gstBasicDataResMain?.data?.lgnm ?? "Manish Patel"),
        SizedBox(
          height: 24.h,
        ),
        _buildRow(str_Trade_Name, _gstBasicDataResMain?.data?.tradeNam ?? "Indo International"),
        SizedBox(
          height: 24.h,
        ),
        _buildRow(str_Constitution, _gstBasicDataResMain?.data?.ctb ?? "Proprietorship"),
        SizedBox(
          height: 24.h,
        ),
        _buildRow(str_Date_of_Registration, _gstBasicDataResMain?.data?.rgdt ?? "01/08/2018"),
        SizedBox(
          height: 24.h,
        ),
        _buildRow(str_GSTIN, _gstBasicDataResMain?.data?.gstin ?? "24ABCDE1234F3Z6"),
        SizedBox(
          height: 24.h,
        ),
        _buildRow(str_GSTIN_Status, _gstBasicDataResMain?.data?.sts ?? "Active"),
        SizedBox(
          height: 24.h,
        ),
        _buildRow(str_Taxpayer_Type, _gstBasicDataResMain?.data?.dty ?? "Regular"),
        SizedBox(
          height: 24.h,
        ),
        _buildRow(str_Business_Activity, _gstBasicDataResMain?.data?.lgnm ?? "Service Provider and Others"),
        SizedBox(
          height: 24.h,
        ),
        _buildRow(str_Place_of_Business,
            _gstBasicDataResMain?.data?.stj ?? "108, Near Datta Mandir, Radha Apartment, Bhavnagar, Gujarat, 364001"),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
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
                  child: Theme(
                    data: ThemeData(useMaterial3: true),
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
                        borderRadius: BorderRadius.all(
                          Radius.circular(2.r),
                        ),
                      ),
                      side: BorderSide(
                          width: 1,
                          color: confirmGstDetail
                              ? ThemeHelper.getInstance()!.primaryColor
                              : ThemeHelper.getInstance()!.primaryColor),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    checkboxText,
                    style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(fontSize: 14.sp),
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
              style: ThemeHelper.getInstance()!.textTheme.headline3?.copyWith(
                    color: MyColors.lightGraySmallText,
                    fontSize: 12.sp,
                  ),
            )),
        SizedBox(height: 2.h),
        SizedBox(
          width: 148.w,
          child: Text(
            subTitle ?? "",
            style: ThemeHelper.getInstance()!.textTheme.headline3?.copyWith(color: MyColors.darkblack),
          ),
        ),
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
        const Spacer(),
        SvgPicture.asset(
          isOpenDetails ? Utils.path(IMG_UP_ARROW) : Utils.path(IMG_DOWN_ARROW),
          height: 20.h,
          width: 20.w,
        ),
      ],
    );
  }

  _buildBottomSheet() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0.w, right: 20.w, bottom: 30.h, top: 20.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(
            onPress: onPressConfirmButton,
            title: str_Confirm,
            isButtonEnable: confirmGstDetail,
          ),
        ],
      ),
    );
  }

  Widget popUpViewForRgistrationCompleted() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.white,
            ),
            height: 300.h,
            width: 335.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 35.h), //40
                Center(
                  child: SvgPicture.asset(Utils.path(GREENCONFORMTICKREGISTRATIONCOMPLETED),
                      height: 52.h, //,
                      width: 52.w, //134.8,
                      allowDrawingOutsideViewBox: true),
                ),
                SizedBox(height: 20.h), //40
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Registration completed",
                        style: ThemeHelper.getInstance()?.textTheme.headline2?.copyWith(color: MyColors.darkblack),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12.h),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Text(
                          "Welcome, Indo International. Let’s start the journey",
                          textAlign: TextAlign.center,
                          style: ThemeHelper.getInstance()
                              ?.textTheme
                              .headline3
                              ?.copyWith(fontSize: 14.sp, color: MyColors.darkblack, fontFamily: MyFont.Roboto_Regular),
                        ),
                      ),
                    ],
                  ),
                ),
                //38
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: btnProceed(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget btnProceed() {
    return AppButton(
      onPress: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => DashboardWithoutGST(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );
      },
      title: str_proceed,
    );
  }

  void onPressConfirmButton() {
    if (confirmGstDetail) {
      TGSharedPreferences.getInstance().set(PREF_ISGSTDETAILDONE, true);
      showDialog(
        context: context,
        builder: (_) => popUpViewForRgistrationCompleted(),
      );
      // Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationCompleted(),));
    }
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
    FetGstDataStatusRequest fetGstDataStatusRequest = FetGstDataStatusRequest(id: gstin);
    var jsonReq = jsonEncode(fetGstDataStatusRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_FETCH_GST_DATA_STATUS);
    TGLog.d("FetchGstDataStatus  request: $tgPostRequest");

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
          if (mounted) {
            showSnackBarForintenetConnection(context, getGSTBasicsDetails);
          }
        }
      } else if (_fetchGstDataResMain?.data?.status == "RETRY") {
        Future.delayed(const Duration(seconds: 10), () {
          getGstDetailStatus();
        });
      } else {
        getGstDetailStatus();
      }
    } else {
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(
          context, response?.getFetchGstDataObj().status, response?.getFetchGstDataObj().message, null);
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
      setState(() {
        _gstBasicDataResMain = response?.getFetchGstDataObj();
        TGSharedPreferences.getInstance().set(PREF_BUSINESSNAME, _gstBasicDataResMain?.data?.tradeNam);
        TGSharedPreferences.getInstance().set(PREF_USERNAME, _gstBasicDataResMain?.data?.lgnm.toString());
        TGSharedPreferences.getInstance().set(PREF_USERSTATE, _gstBasicDataResMain?.data?.stcd.toString());
        hideLoader();
      });
    } else if (response?.getFetchGstDataObj().status == RES_DETAILS_NOT_FOUND) {
      LoaderUtils.handleErrorResponse(
          context, response?.getFetchGstDataObj().status, response?.getFetchGstDataObj().message, null);
      hideLoader();
    } else {
      LoaderUtils.handleErrorResponse(
          context, response?.getFetchGstDataObj().status, response?.getFetchGstDataObj().message, null);
      hideLoader();
    }
    isLoadData = true;
  }

  _onErrorGetBasicGstDetails(TGResponse errorResponse) {
    TGLog.d("GetGstBasicDetails : onError()");
    handleServiceFailError(context, errorResponse.error);
    hideLoader();
    isLoadData = true;
  }
}
