import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_gst_basic_details_res_main.dart';
import 'package:gstmobileservices/model/models/get_loandetail_by_refid_res_main.dart';
import 'package:gstmobileservices/model/models/get_recent_transaction_res_main.dart';
import 'package:gstmobileservices/model/requestmodel/get_all_loan_detail_by_refid_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_gst_basic_details_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_recent_transaction_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_all_loan_detail_by_refid_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_gst_basic_details_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_recent_transaction_response.dart';
import 'package:gstmobileservices/service/request/tg_get_request.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/singleton/tg_session.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:intl/intl.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/helpers/myfonts.dart';
import 'package:sbi_sahay_1_0/utils/movestageutils.dart';

import '../../../../personalinfo/ui/personalinfo.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/constants/prefrenceconstants.dart';
import '../../../../utils/constants/stageconstants.dart';
import '../../../../utils/constants/statusConstants.dart';
import '../../../../utils/helpers/themhelper.dart';
import '../../../../utils/internetcheckdialog.dart';
import '../../../../utils/progressLoader.dart';
import '../../../../utils/singlebuttondialog.dart';
import '../../../../utils/strings/strings.dart';
import '../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';
import '../../dashboardwithgst/mobile/dashboardwithgst.dart';
import '../../gstinvoiceslist/ui/gstinvoicelist.dart';
import '../../profile/ui/profilescreen.dart';
import '../../transactions/ui/transactionscreen.dart';

class NewProfileView extends StatelessWidget {
  const NewProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return const SafeArea(child: NewProfileViewBody());
      },
    );
  }
}

class NewProfileViewBody extends StatefulWidget {
  const NewProfileViewBody({
    Key? key,
  }) : super(key: key);

  @override
  State<NewProfileViewBody> createState() => _NewProfileViewBodyState();
}

class _NewProfileViewBodyState extends State<NewProfileViewBody>



    with SingleTickerProviderStateMixin {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  late TabController tabController;
  GetGstBasicdetailsResMain? _basicdetailsResponse;
  GetAllLoanDetailByRefIdResMain? _getAllLoanDetailRes;
  List<LoanDetailData>? pendingLoan;
  List<LoanDetailData>? ongoingLoan;
  GetRecentTransactionResMain? getrecenttransactionobj;
  List<TransactionData>? translist;
  bool isRecentTransactionEmpty = true;
  var name = '';
  var gstin = '';
  var pan = '';
  var state = '';
  int tabIndex = 0;
  bool isExpanded1 = false;
  bool isExpanded2 = false;

  /*String expanded1 = 'Pending';*/
  int count = 0;
  bool isOngoingJounery = false;
  setExpanded1() {
    setState(() {
      isExpanded1 = !isExpanded1;
      isExpanded2 = isExpanded2;
      count = 0;
    });
  }

  setExpanded2() {
    setState(() {
      isExpanded2 = !isExpanded2;
      isExpanded1 = isExpanded1;
      count = 0;
    });
  }

  //showDialog(context: context, builder: (BuildContext context) => errorDialog);}

  void setUserData() async {
    String? text =
    await TGSharedPreferences.getInstance().get(PREF_BUSINESSNAME);
    String? text1 = await TGSharedPreferences.getInstance().get(PREF_PANNO);
    String? text2 = await TGSharedPreferences.getInstance().get(PREF_GSTIN);
    String? text3 = await TGSharedPreferences.getInstance().get(PREF_USERSTATE);

    setState(() {
      name = text ?? "";
      pan = text1 ?? "";
      gstin = text2 ?? "";
      state = text3 ?? "";
    });
  }

  @override
  void initState() {
    //tabController = TabController(vsync: this, length: 3);
    //tabController.index = 0;

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   LoaderUtils.showLoaderwithmsg(context,
    //       msg: "Getting User Details... \nWait a Moment...");
    // });
    // getBasicDetailApiCall();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // if (tabController.index == 0) {
        //   final shoulpop = await showFirstWaring(context);
        //   return shoulpop ?? false;
        // } else if (tabController.index == 1) {
        //   tabController.index = 0;
        //   setState(() {
        //     tabIndex = 0;
        //   });
        //   return false;
        // } else if (tabController.index == 2) {
        //   tabController.index = 0;
        //   setState(() {
        //     tabIndex = 0;
        //   });
        //   return false;
        // } else {
        return false;
        //}
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MyDrawer(),
        appBar: getAppBarMainDashboard("2", str_loan_approve_process, 0.50,
            onClickAction: () => {
              _scaffoldKey.currentState?.openDrawer()
            }),
        body: MainContainerView(),
        //bottomNavigationBar: buildTabBar()
      ),
    );
  }



  bool activeChecker(int currentIndex) =>
      tabIndex == currentIndex ? true : false;


  Widget MainContainerView() {
    return Container(
      // alignment: Alignment.center,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.only(
          //     bottomRight: Radius.circular(0.r),
          //     bottomLeft: Radius.circular(0.r)),
          // border: Border.all(
          //     width: 1, color: ThemeHelper.getInstance()!.primaryColor),
          // //color: ThemeHelper.getInstance()!.primaryColor,

            gradient: LinearGradient(
                colors: [MyColors.lightRedGradient, MyColors.lightBlueGradient],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Text(
                "Profile",
                style: ThemeHelper.getInstance()?.textTheme.headline2?.copyWith(color: MyColors.white),
              ),
              SizedBox(height: 24.h),
              _buildTopContent(),
              _buildMiddleContent(),
            ],
          ),
        ));
  }


  _buildTopContent() {
    return Container(
      alignment: Alignment.center,
      height: 127.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8.r),
        ),
        // border: Border.all(
        //     width: 1, color: ThemeHelper.getInstance()!.primaryColor),
        color: ThemeHelper.getInstance()!.backgroundColor,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Row(
              children: [
                Image(
                  height: 44.h,
                  width: 44.w,
                  image: AssetImage(Utils.path(DASHBOARDGSTPROFILEWOHOUTGST)),
                ),
                SizedBox(width: 15.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Text("Hello, Indo International!, $name",
                        style: ThemeHelper.getInstance()?.textTheme.headline2),
                    SizedBox(height: 5.h),
                    Text("PAN: ABCDE1234F $pan",
                        style: ThemeHelper.getInstance()!
                            .textTheme
                            .headline5!
                            .copyWith(fontSize: 12.sp, color: MyColors.black)),
                  ],
                ),
                /*const Spacer(),
                SvgPicture.asset(
                  Utils.path(MOBILEDASHWIHTOUTNOTIBELL),
                )*/
              ],
            ),
            SizedBox(height: 10.h,),
            Divider(),
            SizedBox(height: 10.h,),
            Row(children: [
              Text("GSTIN: 29ABCDE1234F3Z6",
                  style: ThemeHelper.getInstance()?.textTheme.bodyText2),
              Spacer(),
              Text("State: Gujarat",
                  style: ThemeHelper.getInstance()?.textTheme.bodyText2),
            ],)
          ],
        ),
      ),
    );
  }

  _buildMiddleContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 12.h),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCard(
                  0,
                  "Personal Information",
                  MOBILETDASHBOARDWITHGSTOUTSTANDING,
                  _basicdetailsResponse
                      ?.data?[0].loanDetails?.outstanding?.count ??
                      "",
                  Utils.convertIndianCurrency(_basicdetailsResponse
                      ?.data?[0].loanDetails?.outstanding?.amount)),
              _buildCard(
                  1,
                  "Notification Preferences",
                  MOBILETDASHBOARDWITHGSTOVERDUE,
                  _basicdetailsResponse
                      ?.data?[0].loanDetails?.overdue?.count ??
                      "",
                  Utils.convertIndianCurrency(_basicdetailsResponse
                      ?.data?[0].loanDetails?.overdue?.amount)),
            ]),
        Padding(
          padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCard(
                    2,
                    "Privacy & Security",
                    IMG_kfs_coin_stack,
                    _basicdetailsResponse
                        ?.data?[0].loanDetails?.repaid?.count ??
                        "",
                    Utils.convertIndianCurrency(_basicdetailsResponse
                        ?.data?[0].loanDetails?.repaid?.amount)),
                _buildCard(
                    3,
                    "About",
                    MOBILEHANDWITHMONEY,
                    _basicdetailsResponse
                        ?.data?[0].loanDetails?.disbursed?.count ??
                        "",
                    Utils.convertIndianCurrency(_basicdetailsResponse
                        ?.data?[0].loanDetails?.disbursed?.amount))
              ]),
        ),
        Padding(
          padding: EdgeInsets.only(top: 0.h, bottom: 0.h),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCard(
                    2,
                    "Contact Support",
                    IMG_kfs_coin_stack,
                    _basicdetailsResponse
                        ?.data?[0].loanDetails?.repaid?.count ??
                        "",
                    Utils.convertIndianCurrency(_basicdetailsResponse
                        ?.data?[0].loanDetails?.repaid?.amount)),
                _buildCard(
                    3,
                    "FAQs",
                    MOBILEHANDWITHMONEY,
                    _basicdetailsResponse
                        ?.data?[0].loanDetails?.disbursed?.count ??
                        "",
                    Utils.convertIndianCurrency(_basicdetailsResponse
                        ?.data?[0].loanDetails?.disbursed?.amount))
              ]),
        ),
      ],
    );
  }

  Widget getRowData(String title, String value) {
    return Row(
      children: [
        Text(
          '$title',
          style: ThemeHelper.getInstance()!.textTheme.bodyText2,
        ),
        Text(value,
            style: TextStyle(
                color: ThemeHelper.getInstance()!.indicatorColor,
                fontSize: 13.sp,
                fontFamily: MyFont.Nunito_Sans_Bold))
      ],
    );
  }

  _buildCard(
      int index, String title, String imgString, String count, String price) {
    return GestureDetector(
      onTap: () {
        // TGSession.getInstance().set("TabIndex", index);
        // tabController.index = 1;
        // setState(() {
        //   tabIndex = 1;
        // });
      },
      child: Container(
        decoration: BoxDecoration(
          color: ThemeHelper.getInstance()!.colorScheme.background,
          borderRadius: BorderRadius.all(
            Radius.circular(8.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        width: 162.w,
        height: 110.h,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 10.0.w, right: 10.w, top: 15.h, bottom: 14.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    Utils.path(imgString),
                    height: 24.h,
                    width: 24.w,
                  ),
                  //Spacer(),
                  // Text(
                  //   count,
                  //   style: ThemeHelper.getInstance()
                  //       ?.textTheme
                  //       .headline5
                  //       ?.copyWith(color: MyColors.pnbTextcolor),
                  // ),

                ],
              ),
            ),
            SizedBox(height: 8.h,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: ThemeHelper.getInstance()?.textTheme.headline4,maxLines: 3,
                    ),
                  ),
                  SvgPicture.asset(
                    Utils.path(MOBILETDASHBOARDARROWFORWARD),height: 12.h,width: 6.w,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  createDay(String date) {
    if (date.isNotEmpty) {
      DateTime dt = DateTime.parse(date);
      String formattedDate = DateFormat('dd').format(dt);
      return formattedDate;
    } else {
      return '';
    }
  }

  createtMonth(String date) {
    if (date.isNotEmpty) {
      DateTime dt = DateTime.parse(date);
      String formattedDate = DateFormat('MMM').format(dt);
      return formattedDate;
    } else {
      return '';
    }
  }

  setBackgroundColor(int index) {
    if (count == 0) {
      count = 1;
      return MyColors.pnbYellowColor;
    } else if (count == 1) {
      count = 2;

      return MyColors.pnbPinkColor;
    } else {
      count = 0;

      return MyColors.pnbPurpleColor;
    }
  }

  Color setColor(String type) =>
      type == strDisbursed ? MyColors.pnbGreenColor : MyColors.pnbGreenColor;//MyColors.pnbRedColor;

  _buildListCard(
      {required String day,
        required String month,
        required Color background,
        required String companyName,
        required String subtext,
        required String price,
        double top: 0,
        double bottom: 0}) {
    return Padding(
      padding:
      EdgeInsets.only(left: 20.0.w, right: 20.w, bottom: bottom, top: top),
      child: Row(
        ///mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Container(
              //   decoration: BoxDecoration(
              //       color: background,
              //       borderRadius: BorderRadius.all(Radius.circular(6.r))),
              //   width: 40.w,
              //   height: 40.h,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text(day,
              //           style: ThemeHelper.getInstance()!
              //               .textTheme
              //               .headline1!
              //               .copyWith(
              //                   color: MyColors.pnbGreyColor, fontSize: 14.sp)),
              //       Text(month,
              //           style: ThemeHelper.getInstance()!
              //               .textTheme
              //               .headline3!
              //               .copyWith(color: MyColors.black, fontSize: 10.sp))
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   width: 12.w,
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(companyName,
                      style: ThemeHelper.getInstance()!
                          .textTheme
                          .headline1!
                          .copyWith(color: MyColors.black, fontSize: 12.sp)),
                  Text("19 Aug, 2022",
                      style: ThemeHelper.getInstance()!
                          .textTheme
                          .bodyText2!
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          Column(
            children: [
              Text(
                Utils.convertIndianCurrency(price),
                // NumberFormat.simpleCurrency(locale: 'hi-In').format(int.parse(price.toString())).toString(),
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .headline1!
                    .copyWith(fontSize: 13.sp),
              ),
              Text(
                subtext,
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .headline3!
                    .copyWith(color: setColor(subtext), fontSize: 11.sp),
              )
            ],
          ),
        ],
      ),
    );
  }


}
