import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_email_otp_response_main.dart';
import 'package:gstmobileservices/model/models/get_gst_basic_details_res_main.dart';
import 'package:gstmobileservices/model/models/get_loandetail_by_refid_res_main.dart';
import 'package:gstmobileservices/model/models/get_user_basic_detail_res_main.dart';
import 'package:gstmobileservices/model/requestmodel/get_all_loan_detail_by_refid_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_email_otp_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_gst_basic_details_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_user_basic_detail_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_all_loan_detail_by_refid_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_email_otp_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_gst_basic_details_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_user_basic_detail_response.dart';
import 'package:gstmobileservices/service/request/tg_get_request.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_session.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/erros_handle_util.dart';
import 'package:gstmobileservices/util/jumpingdot_util.dart';
import 'package:gstmobileservices/util/showcustomesnackbar.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import 'package:sbi_sahay_1_0/registration/mobile/gst_consent_of_gst/gst_consent_of_gst.dart';
import 'package:sbi_sahay_1_0/registration/mobile/verify_email_otp/verify_email_otp.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/imageconstant.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/constants/session_keys.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusConstants.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/internetcheckdialog.dart';
import 'package:sbi_sahay_1_0/utils/progressLoader.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';
import 'package:sbi_sahay_1_0/welcome/ntbwelcome/mobileui/enablegstapintb.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';
import 'package:sbi_sahay_1_0/widgets/info_loader.dart';

import '../../../utils/constants/constant.dart';
import '../../../widgets/titlebarmobile/titlebarwithoutstep.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return const SafeArea(
          child: SignUpViewBody(),
        );
      },
    );
  }
}

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({Key? key}) : super(key: key);

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {
  @override
  bool isCheck = false;
  List<String> genders = ['Male', 'Female', 'Prefer not to say'];
  String selectedGender = "Male";
  bool isEmailVerified = false;
  GetEmailOtpResponseMain? getOtpResponse;
  bool isLoaderStart = false;
  GetGstBasicdetailsResMain? _basicdetailsResponse;
  GetAllLoanDetailByRefIdResMain? _getAllLoanDetailRes;
  bool isUserDataLoaded = false;
  UserBasicDetailResponseMain? userBasicDetailResponseMain;
  bool isValidEmail = false;
  String strEmail = "";
  String strMobile = "";
  String strUserName = "";
  bool hidePassword = true;
  bool hideMobile = true;
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  @override
  void initState() {
    getUserDetail();
    super.initState();
  }

  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(
          child: WillPopScope(
            onWillPop: () async {
              SystemNavigator.pop(animated: true);
              return true;
            },
            child: !isUserDataLoaded
                ? const ShowInfoLoader(
                    isTransparentColor: true,
                    msg: 'Getting user basic details',
                  )
                : Scaffold(
                    appBar: getAppBarWithBackBtn(onClickAction: () => {Navigator.pop(context, false)}),
                    body: SingleChildScrollView(
                      primary: true,
                      child: SignUpScreenContent(),
                    ),
                    bottomNavigationBar: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          confirmGstDetailCheck(),
                          SizedBox(
                            height: 10.h,
                          ),
                          SignUpButtonUI()
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  void onPressEmail() {
    if (isValidEmail) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OTPVerifyEmail(),
        ),
      ).then((value) {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        setState(() {
          isEmailVerified = value ?? false;
        });
      });
      TGSession.getInstance().set(SESSION_EMAIL, strEmail);
      getEmailOtp();
    } else {
      showSnackBar(context, "Please enter valid email");
    }
  }

  Widget SignUpScreenContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Text(
              "Please provide the basic details",
              style: ThemeHelper.getInstance()?.textTheme.headline2,
            ),
            SizedBox(
              height: 20.h,
            ),
            TextFieldUI(initialValue: userBasicDetailResponseMain?.data?.firtName ?? '', label: "First Name"),
            SizedBox(
              height: 20.h,
            ),
            TextFieldUI(initialValue: userBasicDetailResponseMain?.data?.lastName ?? '', label: "Last Name"),
            SizedBox(
              height: 20.h,
            ),
            Text(
              'Gender',
              style: ThemeHelper.getInstance()
                  ?.textTheme
                  .headline3
                  ?.copyWith(fontSize: 12.sp, color: MyColors.lightGraySmallText),
            ),
            GenderTextField("Gender", context),
            SizedBox(
              height: 20.h,
            ),
            buildMobileWidget(),
            SizedBox(
              height: 20.h,
            ),
            buildEmailWidget(),
            SizedBox(
              height: 5.h,
            ),
            isEmailVerified
                ? Padding(
                    padding: EdgeInsets.only(bottom: 5.h, top: 5.h, left: 5.w),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          height: 16.r,
                          width: 16.r,
                          AppUtils.path(SUCCESSEMAIL),
                          fit: BoxFit.fitHeight,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          'Email ID Verified',
                          style: ThemeHelper.getInstance()?.textTheme.subtitle1?.copyWith(
                                color: MyColors.sbiSuccessGreenColor,
                              ),
                        ),
                      ],
                    ),
                  )
                : Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: onPressEmail,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 5.h, top: 5.h, left: 5.w),
                        child: Text(
                          'Verify E-mail ID',
                          style: ThemeHelper.getInstance()?.textTheme.subtitle1?.copyWith(
                                color: MyColors.hyperlinkcolornew,
                              ),
                        ),
                      ),
                    ),
                  ),
            SizedBox(
              height: 10.h,
            ),
            TextFieldUI(
                initialValue: userBasicDetailResponseMain?.data?.pinCode ?? '',
                label: "PIN Code of Current Residential Address"),
            SizedBox(
              height: 20.h,
            ),
            TextFieldUI(initialValue: userBasicDetailResponseMain?.data?.city ?? '', label: "City"),
            SizedBox(
              height: 20.h,
            ),
            TextFieldUI(initialValue: userBasicDetailResponseMain?.data?.branch ?? '', label: "Your Preferred Branch"),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget TextFieldUI({required String label, String initialValue = ""}) {
    return TextFormField(
        onChanged: (content) {},
        enabled: false,
        initialValue: initialValue,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: ThemeHelper.getInstance()
                ?.textTheme
                .headline3
                ?.copyWith(fontSize: 12.sp, color: MyColors.lightGraySmallText),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: MyColors.lightGreyDividerColor)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: MyColors.lightGreyDividerColor))),
        keyboardType: TextInputType.text,
        maxLines: 1,
        style: ThemeHelper.getInstance()?.textTheme.headline3,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        });
  }

  Widget SignUpButtonUI() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: isLoaderStart
          ? SizedBox(
              height: 60.h,
              child: JumpingDots(
                color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary,
                radius: 10,
              ),
            )
          : AppButton(
              onPress: onPressNext,
              title: str_next,
              isButtonEnable: isCheck && isEmailVerified,
            ),
    );
  }

  void onPressNext() {
    if (isCheck && isEmailVerified) {
      isLoaderStart = true;
      setState(() {});
      getGstBasicDetail();
    }
  }

  Widget confirmGstDetailCheck() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isCheck = !isCheck;
        });
      },
      child: Padding(
          padding: EdgeInsets.only(top: 21.0.h),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: Theme(
                    data: ThemeData(useMaterial3: true),
                    child: Checkbox(
                      checkColor: ThemeHelper.getInstance()!.backgroundColor,
                      activeColor: ThemeHelper.getInstance()!.primaryColor,
                      value: isCheck,
                      onChanged: (bool) {
                        setState(() {
                          isCheck = bool!;
                        });
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.r))),
                      side: BorderSide(
                          width: 1,
                          color: isCheck
                              ? ThemeHelper.getInstance()!.primaryColor
                              : ThemeHelper.getInstance()!.primaryColor),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    "I hereby authorize State Bank of India and/or its representatives to call me, SMS me with reference to my loan application. This consent will supersede any registration for any Do Not Call (DNC) / National Do Not Call (NDNC).",
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline3
                        ?.copyWith(fontSize: 14.sp, color: MyColors.lightBlackText),
                    maxLines: 5,
                  ),
                ),
              ])),
    );
  }

  Widget GenderTextField(String label, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      height: 30.h,
      width: MediaQuery.of(context).size.width - 20,
      padding: EdgeInsets.zero,
      color: Colors.white,
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: DropdownButton<String>(
          value: selectedGender,
          items: genders.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                margin: EdgeInsets.all(3.r),
                color: Colors.white,
                width: MediaQuery.of(context).size.width - 86,
                child: Text(
                  value,
                  style: ThemeHelper.getInstance()?.textTheme.headline3,
                ),
              ),
            );
          }).toList(),
          onChanged: null,
          icon: null,
          isDense: true,
          underline: Container(
            height: 1,
            color: MyColors.lightGreyDividerColor,
          ),
          isExpanded: true,
        ),
      ),
    );
  }

  Widget buildEmailWidget() {
    return TextFormField(
        onChanged: (content) {
          String pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = RegExp(pattern);
          isValidEmail = regex.hasMatch(content);
          TGLog.d("Is Valid emial---------$isValidEmail");
          strEmail = content;
          setState(() {});
        },
        initialValue: strEmail ?? '',
        obscureText: hidePassword,
        obscuringCharacter: 'X',
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          labelText: "Email Id",
          labelStyle: ThemeHelper.getInstance()
              ?.textTheme
              .headline3
              ?.copyWith(fontSize: 12.sp, color: MyColors.lightGraySmallText),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: MyColors.lightGreyDividerColor)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: MyColors.lightGreyDividerColor)),
          suffixIcon: IconButton(
            icon: hidePassword
                ? Icon(
                    Icons.visibility_off_outlined,
                    color: hidePassword ? MyColors.pnbTextcolor : MyColors.black,
                  )
                : Icon(
                    Icons.visibility_outlined,
                    color: hidePassword ? MyColors.pnbTextcolor : MyColors.black,
                  ),
            onPressed: () {
              setState(
                () {
                  hidePassword = !hidePassword;
                },
              );
            },
            focusColor: MyColors.black,
            disabledColor: MyColors.pnbTextcolor,
          ),
          suffixIconColor: MyColors.black,
        ),
        style: ThemeHelper.getInstance()?.textTheme.headline3,
        keyboardType: TextInputType.visiblePassword,
        maxLines: 1,
        validator: (value) {
          if (value == null || value.isEmpty || isValidEmail) {
            return 'Please enter valid email';
          }
          return null;
        });
  }

  Widget buildMobileWidget() {
    return TextFormField(
        onChanged: (content) {
          setState(() {});
        },
        obscureText: hideMobile,
        obscuringCharacter: 'X',
        initialValue: userBasicDetailResponseMain?.data?.userName ?? '',
        readOnly: true,
        cursorColor: Colors.grey,
        style: ThemeHelper.getInstance()?.textTheme.headline3,
        decoration: InputDecoration(
          labelText: "Contact Number",
          labelStyle: ThemeHelper.getInstance()
              ?.textTheme
              .headline3
              ?.copyWith(fontSize: 12.sp, color: MyColors.lightGraySmallText),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: MyColors.lightGreyDividerColor)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: MyColors.lightGreyDividerColor)),
          suffixIcon: IconButton(
            icon: hideMobile
                ? Icon(
                    Icons.visibility_off_outlined,
                    color: hideMobile ? MyColors.pnbTextcolor : MyColors.black,
                  )
                : Icon(
                    Icons.visibility_outlined,
                    color: hideMobile ? MyColors.pnbTextcolor : MyColors.black,
                  ),
            onPressed: () {
              setState(
                () {
                  hideMobile = !hideMobile;
                },
              );
            },
            focusColor: MyColors.black,
            disabledColor: MyColors.pnbTextcolor,
          ),
          suffixIconColor: MyColors.black,
        ),
        keyboardType: TextInputType.visiblePassword,
        maxLines: 1,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter mobile number';
          }
          return null;
        },
        inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly]);
  }

  void getGstBasicDetail() async {
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
      bool? isAPIAccess = await TGSharedPreferences.getInstance().get(CONSENT_TYPE_GST_API_ACCESS);
      if (isAPIAccess == false || isAPIAccess == null) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => EnableGstApi(),
              ),
              (route) => false);
        }
      } else {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => GstConsent(),
              ),
              (route) => false);
        }
      }
    } else {
      setState(() {
        isLoaderStart = false;
      });
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

  void getUserDetail() async {
    if (await TGNetUtil.isInternetAvailable()) {
      getUserBasicDetail();
    } else {
      if (context.mounted) {
        showSnackBarForintenetConnection(context, getUserBasicDetail);
      }
    }
  }

  Future<void> getUserBasicDetail() async {
    GetUserBasicDetailRequest getUserBasicDetailRequest = GetUserBasicDetailRequest();
    ServiceManager.getInstance().getUserBasicDetail(
        request: getUserBasicDetailRequest,
        onSuccess: (response) => _onSuccessSaveConsent(response),
        onError: (errorResponse) => _onErrorSaveConsent(errorResponse));
  }

  _onSuccessSaveConsent(GetBasicDetailResponse response) {
    TGLog.d("getUserBasicDetail() : Success---$response");
    if (response.getBankListResObj().status == RES_DETAILS_FOUND) {
      userBasicDetailResponseMain = response.getBankListResObj();
      strEmail = userBasicDetailResponseMain?.data?.email ?? '';
      RegExp regex = new RegExp(pattern);
      isValidEmail = regex.hasMatch(userBasicDetailResponseMain?.data?.email ?? '');
      strUserName = userBasicDetailResponseMain?.data?.firtName ?? 'TestUser';
      selectedGender = userBasicDetailResponseMain?.data?.gender ?? 'Male';
      if (userBasicDetailResponseMain?.data?.emailVerified == 1) {
        isEmailVerified = true;
      }
      TGSession.getInstance().set(SESSION_EMAIL, userBasicDetailResponseMain?.data?.email ?? '');
      TGSession.getInstance().set(SESSION_MOBILENUMBER, userBasicDetailResponseMain?.data?.email ?? strMobile);
      TGSession.getInstance().set(SESSION_USERNAME, userBasicDetailResponseMain?.data?.userName ?? 'TestUser');
      setState(() {});
    } else {
      LoaderUtils.handleErrorResponse(
          context, response?.getBankListResObj().status, response?.getBankListResObj().message, null);
    }
    isUserDataLoaded = true;
    setState(() {});
  }

  _onErrorSaveConsent(TGResponse errorResponse) {
    TGLog.d("getUserBasicDetail() : Error");
    isUserDataLoaded = true;
    setState(() {});
    handleServiceFailError(context, errorResponse.error);
  }

  void getEmailOtp() async {
    if (await TGNetUtil.isInternetAvailable()) {
      getOTP();
    } else {
      if (context.mounted) {
        showSnackBarForintenetConnection(context, getOTP);
      }
    }
  }

  Future<void> getOTP() async {
    GetEmailOTPRequest getEmailOTP = GetEmailOTPRequest(customerName: strUserName, emailId: strEmail);
    var jsonReq = jsonEncode(getEmailOTP.toJson());
    TGLog.d("GST OTP Request : $jsonReq");
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_SBI_GET_EMAIL_OTP);
    ServiceManager.getInstance().getEmailOtp(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetOTP(response),
        onError: (errorResponse) => _onErrorGetOTP(errorResponse));
  }

  _onSuccessGetOTP(GetEmailOtpRespose response) {
    TGLog.d("SaveConsent() : Success---$response");
    getOtpResponse = response.getOtpReponseObj();
    if (getOtpResponse?.status == RES_SUCCESS) {
      TGSession.getInstance().set(SESSION_OTPSESSIONKEY, getOtpResponse?.data);
      showSnackBar(context, "OTP send to your register email address");
    } else {
      Navigator.pop(context, false);
      showSnackBar(context, getOtpResponse?.message ?? 'Error in get otp');
    }
  }

  _onErrorGetOTP(TGResponse errorResponse) {
    TGLog.d("SaveConsent() : Error");
    handleServiceFailError(context, errorResponse.error);
  }
}

class EmailIdWidget extends StatefulWidget {
  String label;

  EmailIdWidget({Key? key, required this.label}) : super(key: key);

  @override
  EmailIdWidgetState createState() => EmailIdWidgetState();
}

class EmailIdWidgetState extends State<EmailIdWidget> {
  bool hidePassword = true;

  bool validEmail(String email) {
    return RegExp(Email_Pattern).hasMatch(email);
  }

  get label => widget.label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        onChanged: (content) {
          setState(
            () {
              validEmail(content);
            },
          );
        },
        obscureText: hidePassword,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: ThemeHelper.getInstance()
              ?.textTheme
              .headline3
              ?.copyWith(fontSize: 12.sp, color: MyColors.lightGraySmallText),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: MyColors.lightGreyDividerColor)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: MyColors.lightGreyDividerColor)),
          suffixIcon: IconButton(
            icon: hidePassword
                ? Icon(
                    Icons.visibility_off_outlined,
                    color: hidePassword ? MyColors.pnbTextcolor : MyColors.black,
                  )
                : Icon(
                    Icons.visibility_outlined,
                    color: hidePassword ? MyColors.pnbTextcolor : MyColors.black,
                  ),
            onPressed: () {
              setState(
                () {
                  hidePassword = !hidePassword;
                },
              );
            },
            focusColor: MyColors.black,
            disabledColor: MyColors.pnbTextcolor,
          ),
          suffixIconColor: MyColors.black,
        ),
        keyboardType: TextInputType.visiblePassword,
        maxLines: 1,
        validator: (value) {
          if (value == null || value.isEmpty || validEmail(value)) {
            return 'Please enter $label';
          }
          return null;
        });
  }
}

class ContactNumberWidget extends StatefulWidget {
  String label;
  String username;
  bool hideMobile;

  ContactNumberWidget({Key? key, required this.label, required this.username, required this.hideMobile})
      : super(key: key);

  @override
  ContactNumberWidgetState createState() => ContactNumberWidgetState();
}

class ContactNumberWidgetState extends State<ContactNumberWidget> {
  get label => widget.label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        onChanged: (content) {
          setState(() {});
        },
        obscureText: widget.hideMobile,
        obscuringCharacter: 'X',
        initialValue: widget.username,
        enabled: false,
        cursorColor: Colors.grey,
        style: ThemeHelper.getInstance()?.textTheme.headline3,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: ThemeHelper.getInstance()
              ?.textTheme
              .headline3
              ?.copyWith(fontSize: 12.sp, color: MyColors.lightGraySmallText),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: MyColors.lightGreyDividerColor)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: MyColors.lightGreyDividerColor)),
          suffixIcon: IconButton(
            icon: widget.hideMobile
                ? Icon(
                    Icons.visibility_off_outlined,
                    color: widget.hideMobile ? MyColors.pnbTextcolor : MyColors.black,
                  )
                : Icon(
                    Icons.visibility_outlined,
                    color: widget.hideMobile ? MyColors.pnbTextcolor : MyColors.black,
                  ),
            onPressed: () {
              setState(
                () {
                  widget.hideMobile = !widget.hideMobile;
                },
              );
            },
            focusColor: MyColors.black,
            disabledColor: MyColors.pnbTextcolor,
          ),
          suffixIconColor: MyColors.black,
        ),
        keyboardType: TextInputType.visiblePassword,
        maxLines: 1,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly]);
  }
}
