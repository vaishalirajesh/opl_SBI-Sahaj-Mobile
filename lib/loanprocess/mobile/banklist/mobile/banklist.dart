import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_bank_list_response_main.dart';
import 'package:gstmobileservices/model/requestmodel/get_bank_detail_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_bank_list_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_bank_detail_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_bank_list_response.dart';
import 'package:gstmobileservices/service/request/tg_get_request.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:lottie/lottie.dart';
import 'package:sbi_sahay_1_0/routes.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusconstants.dart';
import 'package:sbi_sahay_1_0/utils/erros_handle.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';
import 'package:sbi_sahay_1_0/widgets/animation_routes/shimmer_widget.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/internetcheckdialog.dart';
import '../../../../widgets/animation_routes/page_animation.dart';
import '../../aalist/ui/accountaggregatorlist.dart';
import 'banklistloader.dart';



class BankList extends StatelessWidget {
  const BankList({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return const SafeArea(child: BankListScreen());
    });
  }
}

class BankListScreen extends StatefulWidget {
  const BankListScreen({Key? key}) : super(key: key);

  @override
  State<BankListScreen> createState() => _BankListScreenState();
}

class _BankListScreenState extends State<BankListScreen> {

  GetBankListResMain? bankList;
  int? bankListlenght=0;
  bool isLoader=true;
  bool isBankSelected = false;
  String bankCode = '';
 late List<BankListObj> _searchResult ;
  late TextEditingController controller;
  late List<BankListObj> _bankListDetails ;
  @override
   initState()  {

    _searchResult = [];
    _bankListDetails = [];
    controller=TextEditingController();
    getBankListAPI();

    super.initState();
  }

  Future<void> getBankListAPI() async
  {
    if (await TGNetUtil.isInternetAvailable()) {
      getBankListApi();
    } else {
      showSnackBarForintenetConnection(context, getBankListApi);
    }
  }
  @override
  Widget build(BuildContext context) {
    TGLog.d("main-> ");
    return
      WillPopScope(
        onWillPop: () async {

            return true;

    },
    child:
      Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildgetAppBarWithSearchBar(),
      body: Padding(
        padding: const EdgeInsets.all(20).w,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              text(text: str_Select_your_Bank, textStyle: textTextHeader1),
              text(text: strSelectYouDescr,
                  textStyle: textTextHeader3Copywith11),
          buildListOfBanks(context)
            ],
          ),
        ),
      ),));
  }

  void hideLoader()
  {
    setState(() {
      isLoader=false;
      isBankSelected = false;
    });
  }

  //..20) Get Bank List Api call
  Future<void> getBankListApi() async {
    TGLog.d("Enter : getBankListApi()");
    TGGetRequest tgGetRequest = GetBankListRequest();
    ServiceManager.getInstance().getBankList(request: tgGetRequest,
        onSuccess: (response) => _onSuccessGetBanList(response),
        onError: (error) => _onErrorGetBanList(error));
    TGLog.d("Exit : getBankListApi()");
  }

  _onSuccessGetBanList(GetBankListResponse? response) {
    TGLog.d("GetBanList : onSuccess()");
    if(response?.getBankListResObj().status == RES_DETAILS_FOUND){
      setState(() {
        bankList = response?.getBankListResObj();
        _bankListDetails=bankList!.data!;
        bankListlenght=bankList?.data?.length;
        isLoader=false;
      });
    }else{
      hideLoader();
      TGView.showSnackBar(context: context, message: response?.getBankListResObj().message ?? "No Data Found");
    }

  }

  _onErrorGetBanList(TGResponse errorResponse) {
    TGLog.d("GetBanList  : Error()");
    hideLoader();
    handleServiceFailError(context, errorResponse.error);
  }


  //..Get Bank By Code Api
  Future<void> getBankByCodeApi() async {

    TGLog.d("selectedBank : ${bankCode}");

    TGGetRequest tgGetRequest = GetBankDetailRequest(bankCode: bankCode);
    ServiceManager.getInstance().getBankDetailByCode(request: tgGetRequest,
        onSuccess: (response) => _onSuccessGetBankDetailById(response),
        onError: (error) => _onErrorGetBankDetailById(error));
  }

  _onSuccessGetBankDetailById(GetBankDetailResponse? response) {
    TGLog.d("GetBankDetailById : onSuccess()");
    if(response?.getBankdetailResObj().status == RES_DETAILS_FOUND){
     // Navigator.pushNamed(context, MyRoutes.AAListRoutes);
      hideLoader();
      //Navigator.of(context).push(CustomRightToLeftPageRoute(child: AAList(), ));
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => AAList(),)
      );


    }else if (response?.getBankdetailResObj().status == RES_DETAILS_NOT_FOUND){
      TGView.showSnackBar(context: context, message: response?.getBankdetailResObj().message ?? "No Data Found");
      hideLoader();
    }else{
      TGView.showSnackBar(context: context, message: response?.getBankdetailResObj().message ?? "No Data Found");
      hideLoader();
    }

  }

  _onErrorGetBankDetailById(TGResponse errorResponse) {
    TGLog.d("GetBankDetailById: onError()");
    handleServiceFailError(context, errorResponse.error);
    hideLoader();
  }


  Widget buildListOfBanks(BuildContext context) {
    return
    isLoader?shimmerLoader():  _searchResult.length != 0 || controller.text.isNotEmpty?   ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount:isLoader? 7: _searchResult.length,
     // itemCount: 3,
      itemBuilder: (context, index) {
        if(isLoader)
          {
            return shimmerLoader();
          }
        else {
          return buildBankListCardUI(context, index, true);
        }
        },
    ):ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount:isLoader? 7:  this._bankListDetails.length??0,
        // itemCount: 3,
        itemBuilder: (context, index) {
          if(isLoader)
          {
            return shimmerLoader();
          }
          else {
            return buildBankListCardUI(context, index, false);
          }
        },
      )

    ;
  }

  Widget buildBankListCardUI(BuildContext context, int index,bool flag) {

    return InkWell(

      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: ThemeHelper.getInstance()!.cardColor,
                  child: Container(
                    color: ThemeHelper.getInstance()!.cardColor,
                    child: Icon(Icons.account_balance, size: 20.h),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(flag?this._searchResult[index]?.bankName ??'Bank not Available' :this._bankListDetails[index]?.bankName ??'Bank not Available', style: textTextHeader3)
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            const Divider()
          ],
        ),
      ),
      onTap: () async {
        setState(() {
          isBankSelected = true;
        });
        bankCode = bankList!.data![index].bankCode ?? "";
        if (await TGNetUtil.isInternetAvailable()) {
          getBankByCodeApi();
        } else {
        showSnackBarForintenetConnection(context, getBankByCodeApi);
        }

        if(kIsWeb)
        {
         // Navigator.of(context).push(CustomRightToLeftPageRoute(child: const BankListLoader(), ));
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => BankListLoader(),)
          );
        }
        else
        {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Wrap(children: [buildbottomLoderFindingAA()]);
              },
              clipBehavior: Clip.antiAlias,
              isScrollControlled: true);
        }

      },
    );
  }

  Widget buildSearchBarView() {
    return SizedBox(
      height: 35.h,
      width: 225.w,
      child: TextField(
        controller: controller,
        style: textTextHeader3,
        onChanged: (_){
          onSearchTextChanged(_);
        },
        cursorColor: ThemeHelper.getInstance()!.backgroundColor,
        decoration: InputDecoration(
          fillColor: ThemeHelper.getInstance()!.backgroundColor,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(7.r))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: ThemeHelper.getInstance()!.cardColor),
              borderRadius: BorderRadius.all(Radius.circular(7.r))),
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
          prefixIcon:
          Icon(Icons.search, color: ThemeHelper.getInstance()!.primaryColor),
          labelText: str_Search,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintStyle: TextStyle(color: ThemeHelper.getInstance()!.primaryColor),
          filled: true,
          labelStyle: TextStyle(color: ThemeHelper.getInstance()!.primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(7.r),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildbottomLoderFindingAA() {
    return SizedBox(
      height: 170.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /*Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                Utils.path(FINDING_AA_LINKBANK),
                fit: BoxFit.cover,
                height: 30,
                width: 30,
              ),
              // you can replace
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(ThemeHelper.getInstance()!.primaryColor),
                strokeWidth:5.w,
              ),
            ],
          ),*/
          Image.asset(height: 80.h,width: 80.w,Utils.path(FINDING_AA_LINKBANK),fit: BoxFit.fill,),
          // Lottie.asset(Utils.path(FINDING_AA_LINKBANK),
          //     height: 80.h,
          //     //80.w,
          //     width: 80.w,
          //     //80.w,
          //     repeat: true,
          //     reverse: false,
          //     animate: true,
          //     frameRate: FrameRate.max,
          //     fit: BoxFit.fill),
          SizedBox(height: 10.h),
          Padding(
            padding: const EdgeInsets.all(20).w,
            child: Text(
              strDescFindingAccountAggregator,
              style: ThemeHelper
                  .getInstance()
                  ?.textTheme
                  .headline1!
                  .copyWith(fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildgetAppBarWithSearchBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: SvgPicture.asset(
                        Utils.path(MOBILEBACKBTN),
                      ),
                      onTap: () {},
                    ),
                    SizedBox(width: 10.w),
                    buildSearchBarView()
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(Utils.path(SMALLBANKLOGO),
                        height: 20.h, width: 20.w),
                    SizedBox(
                      width: 5.w,
                    ),
                    SvgPicture.asset(Utils.path(MOBILESAHAYLOGO),
                        height: 20.h, width: 20.w)
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _bankListDetails.forEach((userDetail) {
      if (userDetail.bankName!.contains(text) || userDetail.bankCode!.contains(text))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }








  Widget sizebox({required double height}) {
    return SizedBox(
      height: height,
    );
  }


  Widget padding({required Widget child, required double horizontal}) =>
      Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontal), child: child);

  Widget paddingOnly({required Widget child,
    required double bottom,
    required double top,
    required double left,
    required double right}) =>
      Padding(
          padding:
          EdgeInsets.only(left: left, right: right, bottom: bottom, top: top),
          child: child);

  Widget text({required String text,
    TextStyle? textStyle,
    TextAlign? textAlgin = TextAlign.left}) {
    return Text(
      text,
      style: textStyle,
      textAlign: textAlgin,
    );
  }

  TextStyle? textTextHeader1 = ThemeHelper
      .getInstance()!
      .textTheme
      .headline1;

  TextStyle? textTextHeader3 = ThemeHelper
      .getInstance()!
      .textTheme
      .headline3;
  TextStyle? textTextHeader2Copywith16 =
  ThemeHelper
      .getInstance()!
      .textTheme
      .headline2!
      .copyWith(fontSize: 16.sp);
  TextStyle? textTextHeader1Copywith14 =
  ThemeHelper
      .getInstance()!
      .textTheme
      .headline1!
      .copyWith(fontSize: 14.sp);
  TextStyle? textTextHeader3Copywith11 =
  ThemeHelper
      .getInstance()!
      .textTheme
      .headline3!
      .copyWith(fontSize: 11.sp);


}

shimmerLoader()=>Padding(
  padding: EdgeInsets.only(top: 10.h,bottom: 10.h),
  child:   Row(
    mainAxisSize: MainAxisSize.max,
  children:[

    ShimmerWidget.cricular(height: 35.h,widht: 35.w,),

    SizedBox(width: 10.w,),

    ShimmerWidget.rectangle(height: 25.h,widht: 280.w,)]

  ),
);