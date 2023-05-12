import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_aa_list_response_main.dart';
import 'package:gstmobileservices/model/requestmodel/get_aa_list_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_aa_list_response.dart';
import 'package:gstmobileservices/service/request/tg_get_request.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/loanofferlist/ui/loanofferlistscreen.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/erros_handle.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/jumpingdott.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/constants/statusConstants.dart';
import '../../../../utils/internetcheckdialog.dart';
import '../../../../utils/strings/strings.dart';
import '../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';
import '../../accountaggregatorntb/ui/aadetails.dart';

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
  late List<GetAAListObj> typeListDetails;
  bool isAANextClick = false;
  int listLength = 3;
  String isCheckedGroup = 'BankGroupName';

  //List<int> isCheckedList = [];
  int selectedValue = -1;

  bool isLoaderStart = false;

  @override
  void initState() {
    typeListDetails = [];
    // getAAListApiCall();

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
        return true;
      },
      child: Scaffold(
        appBar: getAppBarWithStepDone("2", str_loan_approve_process, 0.50,
            onClickAction: () => {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const AccountAggregatorDetails(),
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
            height: 50.h,
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
            Text(str_select_aa_txt,
                style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 12.sp),
                textAlign: TextAlign.start),
            SizedBox(height: 20.h),
            buildSearchBar(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return SizedBox(
      height: 35.h,
      child: TextField(
        style: ThemeHelper.getInstance()!.textTheme.button,
        cursorColor: ThemeHelper.getInstance()!.backgroundColor,
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
    return ListView.builder(
      shrinkWrap: true,
      //scrollDirection: Axis.vertical,
      itemCount: 1,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            changeState(index);
            // setState((){
            //   selectedValue = index;
            // });
            //
            // TGSharedPreferences.getInstance().set(PREF_AAID, typeListDetails[index].aaId);
            // TGSharedPreferences.getInstance().set(PREF_AACODE, typeListDetails[index].code);
          },
          child: Column(
            children: [
              ListTile(
                leading: Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: buildCheckboxWidgetCustom1(index),
                ),
                //
                //
                //         Transform.translate(
                //   offset: Offset(30, -5),
                //   child: buildCheckboxWidgetCustom1(index),
                // ),

                // Padding(
                //     padding: EdgeInsets.only(bottom: 10.h,left: 20.w),
                //     child: buildCheckboxWidgetCustom1(index)),
                title: Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(Utils.path(IMG_NADL), height: 21.h, width: 60.w),
                      Text("NESL Asset Data Limited",
                          style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 12.sp)),
                    ],
                  ),
                ),
                // trailing: Padding(
                //     padding: EdgeInsets.only(bottom: 10.h),
                //     child: buildCheckboxWidgetCustom1(index)),
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
      onPress: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoanOfferList(),
            ));
      },
      title: str_proceed,
    );
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
        typeList = response?.getAAListResObj();
        if (typeList?.data?.isNotEmpty == true) {
          typeListDetails = typeList!.data!;
          typeListlen = typeList!.data!.length!;
        }
      });
    } else {
      TGView.showSnackBar(context: context, message: response?.getAAListResObj().message ?? "No Data Found");
      setState(() {
        isLoaderStart = false;
      });
    }
  }

  _onErrorGetAAList(TGResponse errorResponse) {
    TGLog.d("GetAppRefId : onError()");
    setState(() {
      isLoaderStart = false;
      handleServiceFailError(context, errorResponse.error);
    });
  }
}
