import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_aa_list_response_main.dart';
import 'package:gstmobileservices/model/models/get_consent_handle_url_response_main.dart';
import 'package:gstmobileservices/model/requestmodel/consent_handle_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_aa_list_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_consent_handle_url_request.dart';
import 'package:gstmobileservices/model/responsemodel/consent_handle_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_aa_list_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_consent_handle_url_response.dart';
import 'package:gstmobileservices/service/request/tg_get_request.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/erros_handle.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/jumpingdott.dart';
import 'package:sbi_sahay_1_0/utils/progressLoader.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';
import 'package:sbi_sahay_1_0/widgets/info_loader.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/constants/statusConstants.dart';
import '../../../../utils/internetcheckdialog.dart';
import '../../../../utils/strings/strings.dart';
import '../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';
import '../../accountaggregatorntb/launchAaUrl/aalaunchurlmain.dart'
    if (dart.library.html) '../../accountaggregatorntb/launchAaUrl/aaloaunchurlweb.dart'
    if (dart.library.io) '../../accountaggregatorntb/launchAaUrl/aalaunchurlmobile.dart';

class AAList extends StatelessWidget {
  const AAList({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return const SafeArea(child: AAListView());
    });
  }
}

class AAListView extends StatefulWidget {
  const AAListView({Key? key}) : super(key: key);

  @override
  State<AAListView> createState() => _AAListViewState();
}

class _AAListViewState extends State<AAListView> {
  GetAAListResMain? typeList;
  int typeListlen = 0;
  bool isAANextClick = false;
  int listLength = 3;
  String isCheckedGroup = 'BankGroupName';
  late List<GetAAListObj> _aaListObj;
  late List<GetAAListObj> _searchResult;
  final TextEditingController _searchController = TextEditingController();
  GetConsentHandleUrlResMain? _consentUrlData;
  String bankName = '';
  bool isBankNameFetched = true;

  //List<int> isCheckedList = [];
  int selectedValue = -1;

  bool isLoaderStart = true;
  bool isShowLoader = false;

  @override
  void initState() {
    _aaListObj = [];
    _aaListObj = [];
    _searchResult = [];
    getAAListApiCall();
    super.initState();
  }

  Future<void> getAAListApiCall() async {
    if (await TGNetUtil.isInternetAvailable()) {
      getAccountAggregatorListApi();
    } else {
      if (context.mounted) {
        showSnackBarForintenetConnection(context, getAccountAggregatorListApi);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const DashboardWithGst(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );
        return true;
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: getAppBarWithStepDone("2", str_loan_approve_process, 0.50,
                onClickAction: () => {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const DashboardWithGst(),
                        ),
                        (route) => false, //if you want to disable back feature set to false
                      )
                    }),
            body: AbsorbPointer(
              absorbing: isLoaderStart,
              child: Stack(
                children: [
                  buildMainScreen(context),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
                      child: buildBtnNextAcc(context),
                    ),
                  )
                ],
              ),
            ),
          ),
          if (isShowLoader)
            ShowInfoLoader(
              msg: str_aa_redirect,
              isTransparentColor: isShowLoader,
            )
        ],
      ),
    );
  }

  Widget buildMainScreen(BuildContext context) {
    return SingleChildScrollView(
      primary: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          buildBankName(),
          SizedBox(
            height: 20.h,
          ),
          buildMainScreenContent(),
          Container(
            child: isLoaderStart
                ? JumpingDots(
                    color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary,
                    radius: 10,
                  )
                : buildListOfAA(),
          ),
          SizedBox(
            height: 100.h,
          )
        ],
      ),
    );
  }

  Widget buildBankName() {
    return Container(
      color: ThemeHelper.getInstance()!.colorScheme.secondaryContainer,
      height: 81.h,
      child: Padding(
        padding: EdgeInsets.only(left: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(color: ThemeHelper.getInstance()!.backgroundColor, shape: BoxShape.circle),
              width: 40.w,
              height: 40.h,
              child: Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  Utils.path(SMALLBANKLOGO),
                  height: 15.h,
                  width: 15.h,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              strSBI,
              style: ThemeHelper.getInstance()!.textTheme.headline1!.copyWith(
                    fontSize: 14.sp,
                    color: MyColors.black,
                  ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMainScreenContent() {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(str_aa_steps_txt,
                  style: ThemeHelper.getInstance()!.textTheme.headline2!, textAlign: TextAlign.start),
            ]),
            SizedBox(height: 15.h),
            Text(str_aa_step_one,
                style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp),
                textAlign: TextAlign.start),
            SizedBox(height: 10.h),
            Text(str_aa_step_two,
                style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp),
                textAlign: TextAlign.start),
            SizedBox(height: 10.h),
            Text(str_aa_step_three,
                style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp),
                textAlign: TextAlign.start),
            SizedBox(height: 10.h),
            Text(str_aa_step_four,
                style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp),
                textAlign: TextAlign.start),
            SizedBox(height: 10.h),
            Text(str_aa_step_five,
                style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp),
                textAlign: TextAlign.start),
            SizedBox(height: 36.h),
            Text(str_select_aa, style: ThemeHelper.getInstance()!.textTheme.headline2!, textAlign: TextAlign.start),
            SizedBox(height: 10.h),
            Text(
              str_select_aa_txt,
              style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14.sp),
            ),
            SizedBox(height: 20.h),
            buildSearchBar(),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return SizedBox(
      height: 35.h,
      child: TextField(
        style: ThemeHelper.getInstance()!.textTheme.button?.copyWith(color: MyColors.black),
        controller: _searchController,
        onChanged: (_) {
          setState(() {
            _searchResult = _aaListObj
                .where((bankList) =>
                    bankList.name?.toLowerCase().contains(_searchController.text.toLowerCase()) == true ||
                    bankList.code?.toString().toLowerCase().contains(_searchController.text.toString().toLowerCase()) ==
                        true)
                .toList();
          });
        },
        decoration: InputDecoration(
          fillColor: ThemeHelper.getInstance()!.backgroundColor,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ThemeHelper.getInstance()!.colorScheme.onSurface, width: 1.0),
            // borderRadius: BorderRadius.all(Radius.circular(7.r))
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ThemeHelper.getInstance()!.colorScheme.onSurface, width: 1.0),
            // borderRadius: BorderRadius.all(Radius.circular(7.r))
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
          prefixIcon: Icon(Icons.search, color: MyColors.lightGraySmallText.withOpacity(0.3)),
          // hintText: "Search...",
          labelText: str_Search,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintStyle: ThemeHelper.getInstance()!.textTheme.button,
          filled: true,
          labelStyle: ThemeHelper.getInstance()!
              .textTheme
              .headline3!
              .copyWith(color: MyColors.lightGraySmallText.withOpacity(0.3)),
          //    fillColor: searchbarBGColor.withOpacity(0.37),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: ThemeHelper.getInstance()!.colorScheme.onSurface, width: 1.0),
            // borderRadius: BorderRadius.all(
            //   Radius.circular(7.r),
            // ),
          ),
        ),
      ),
    );
  }

  Widget buildListOfAA() {
    if (_searchController.text.isNotEmpty) {
      return _searchResult?.length != 0
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: _searchResult.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    changeState(index);
                    TGSharedPreferences.getInstance().set(PREF_AAID, _searchResult[index].aaId);
                    TGSharedPreferences.getInstance().set(PREF_AACODE, _searchResult[index].code);
                  },
                  child: Column(
                    children: [
                      ListTile(
                        leading: buildCheckboxWidgetCustom1(index),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(Utils.path(IMG_NADL), height: 21.h, width: 60.w),
                            Text("${_searchResult?[index].name}",
                                style: ThemeHelper.getInstance()!.textTheme.displayMedium!.copyWith(fontSize: 12.sp)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: const Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : SizedBox(
              height: 100.h,
              child: const Center(child: Text(str_no_account)),
            );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        //scrollDirection: Axis.vertical,
        itemCount: _aaListObj.length ?? 0,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              //changeState(index);
              setState(() {
                selectedValue = index;
              });
              TGSharedPreferences.getInstance().set(PREF_AAID, _aaListObj[index].aaId);
              TGSharedPreferences.getInstance().set(PREF_AACODE, _aaListObj[index].code);
            },
            child: Column(
              children: [
                ListTile(
                  leading: buildCheckboxWidgetCustom1(index),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Image.asset(Utils.path(IMG_NADL), height: 21.h, width: 60.w),
                      Text("${_aaListObj?[index].name}",
                          style: ThemeHelper.getInstance()!.textTheme.displayMedium!.copyWith(fontSize: 12.sp)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: const Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Widget buildCheckboxWidgetCustom1(int index) {
    return Radio<int>(
      value: index,
      groupValue: selectedValue,
      activeColor: ThemeHelper.getInstance()!.primaryColor,
      onChanged: (value) {
        changeState(index);
      },
    );
  }

  void changeState(int index) {
    setState(() {
      selectedValue = index;
    });
  }

  Widget buildBtnNextAcc(BuildContext context) {
    return AppButton(
      onPress: onPressProceed,
      title: str_proceed,
      isButtonEnable: selectedValue > -1,
    );
  }

  Future<void> onPressProceed() async {
    if (selectedValue == -1) {
      TGView.showSnackBar(context: context, message: 'Please select Account Aggregator to continue');
    } else {
      setState(() {
        isShowLoader = true;
      });
      if (await TGNetUtil.isInternetAvailable()) {
        _postConsentHandleRequest();
      } else {
        if (context.mounted) {
          showSnackBarForintenetConnection(context, _postConsentHandleRequest);
        }
      }
    }
  }

  void setNextAAClick() {
    isAANextClick = true;
    setState(() {});
  }

  //..22) Get Account Aggregator List
  Future<void> getAccountAggregatorListApi() async {
    TGLog.d("Enter : getBankByCodeApi()");
    TGGetRequest tgGetRequest = GetAAListRequest();
    ServiceManager.getInstance().getAAList(
        request: tgGetRequest,
        onSuccess: (response) => _onSuccessGetAAList(response),
        onError: (error) => _onErrorGetAAList(error));
    TGLog.d("Exit : getBankByCodeApi()");
  }

  _onSuccessGetAAList(GetAAListResponse? response) {
    TGLog.d("GetAppRefId : onSuccess()");
    if (response?.getAAListResObj().status == RES_DETAILS_FOUND) {
      setState(() {
        isLoaderStart = false;
        if (response?.getAAListResObj().data?.isNotEmpty == true) {
          _aaListObj = response?.getAAListResObj().data ?? [];
        }
      });
    } else {
      isLoaderStart = false;

      LoaderUtils.handleErrorResponse(
          context, response?.getAAListResObj().status, response?.getAAListResObj().message, null);

      // TGView.showSnackBar(context: context, message: response?.getAAListResObj().message ?? "No Data Found");
      // setState(() {
      //   isLoaderStart = false;
      // });
    }
  }

  _onErrorGetAAList(TGResponse errorResponse) {
    TGLog.d("GetAppRefId : onError()");
    setState(() {
      isLoaderStart = false;
      handleServiceFailError(context, errorResponse.error);
    });
  }

  Future<void> _postConsentHandleRequest() async {
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    TGSharedPreferences.getInstance().set(PREF_AACODE, _aaListObj[selectedValue].code.toString());
    TGSharedPreferences.getInstance().set(PREF_AAID, _aaListObj[selectedValue].aaId.toString());

    ConsentHandleRequest consentHandleRequest = ConsentHandleRequest(
        loanApplicationRefId: loanAppRefId,
        aaCode: _aaListObj[selectedValue].code.toString(),
        aaId: _aaListObj[selectedValue].aaId.toString(),
        consentFetchType: 'ONE_TIME');

    var jsonReq = jsonEncode(consentHandleRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_CONSENT_HANDLE);

    ServiceManager.getInstance().consentHandleRequest(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessConsentHandle(response),
        onError: (error) => _onErrorConsentHandle(error));
  }

  _onSuccessConsentHandle(ConsentHandleResponse? response) async {
    TGLog.d("ConsentHandleResponse : onSuccess()");
    if (response?.getConsentHandleResObj().status == RES_SUCCESS) {
      TGSharedPreferences.getInstance().set(PREF_CONSENT_AAID, response?.getConsentHandleResObj().data?.consentAggId);
      if (await TGNetUtil.isInternetAvailable()) {
        _getConsentHandleUrl();
      } else {
        showSnackBarForintenetConnection(context, _getConsentHandleUrl);
      }
    } else {
      setState(() {
        isShowLoader = false;
      });
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(
          context, response?.getConsentHandleResObj().status, response?.getConsentHandleResObj().message, null);
    }
  }

  _onErrorConsentHandle(TGResponse errorResponse) {
    TGLog.d("ConsentHandleResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
    setState(() {
      isShowLoader = false;
    });
  }

  Future<void> _getConsentHandleUrl() async {
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    String consentAggId = await TGSharedPreferences.getInstance().get(PREF_CONSENT_AAID) ?? '';
    GetConsentHandleUrlReq getConsentHandleUrlReq =
        GetConsentHandleUrlReq(loanApplicationRefId: loanAppRefId, consentAggId: consentAggId);

    var jsonReq = jsonEncode(getConsentHandleUrlReq.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_GET_CONSENT_URL);

    ServiceManager.getInstance().consentHandleUrl(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetConsentHandleUrl(response),
        onError: (error) => _onErrorGetConsentHandleUrl(error));
  }

  _onSuccessGetConsentHandleUrl(GetConsentHandleUrlResponse? response) async {
    TGLog.d("GetConsentHandleUrl : onSuccess()");
    if (response?.getConsentHandleUrlObj().status == RES_SUCCESS) {
      TGLog.d("GetConsentHandleUrl : on launch URL --${response?.getConsentHandleUrlObj().data?.url}()");

      String url = response?.getConsentHandleUrlObj().data?.url ?? "";
      // // TODO : Remove navigation and add URL lunch
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const AaCompletedPage(
      //       str: {},
      //     ),
      //   ),
      //   (route) => false,
      // );
      //redurectURL(url);
      launchAa(url);
      // AppConstant.AAWEBREDIRCTIONURL = url;
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (BuildContext context) => AccountAggregatorWebview(),
      //     ));
    } else if (response?.getConsentHandleUrlObj().status == RES_RETRY_URL) {
      if (await TGNetUtil.isInternetAvailable()) {
        _getConsentHandleUrl();
      } else {
        showSnackBarForintenetConnection(context, _getConsentHandleUrl);
      }
    } else {
      setState(() {
        isShowLoader = false;
      });
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(
          context, response?.getConsentHandleUrlObj().status, response?.getConsentHandleUrlObj().message, null);
    }
  }

  _onErrorGetConsentHandleUrl(TGResponse errorResponse) {
    TGLog.d("GetConsentHandleUrl : onError()");
    handleServiceFailError(context, errorResponse.error);
    setState(() {
      isShowLoader = false;
    });
  }
}
// Future<void> redurectURL(String? url) async {
//   await launchUrl(
//     Uri.parse(url ?? ""),
//     mode: LaunchMode.externalApplication,
//     webOnlyWindowName: '_self',
//
//   );
//   //launchUrl(Uri.parse(url ?? ""));
// }
