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
import '../../gstinvoiceslist/ui/gstinvoicelist.dart';
import '../../profile/ui/profilescreen.dart';
import '../../transactions/ui/transactionscreen.dart';

class DashboardWithGST extends StatelessWidget {
  const DashboardWithGST({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return const SafeArea(child: DashboardWithGst());
      },
    );
  }
}

class DashboardWithGst extends StatefulWidget {
  const DashboardWithGst({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardWithGst> createState() => _DashboardWithGstState();
}

class _DashboardWithGstState extends State<DashboardWithGst>



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

  Future<void> getBasicDetailApiCall() async {
    if (await TGNetUtil.isInternetAvailable()) {
      getGstBasicDetails();
    } else {
      showSnackBarForintenetConnection(context, getGstBasicDetails);
    }
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
        drawer: CustomDrawer(),
        appBar: getAppBarMainDashboard("2", str_loan_approve_process, 0.50,
            onClickAction: () => {
              print("Manish here"),
              _scaffoldKey.currentState?.openDrawer()
            }),
        // body: TabBarView(
        //   controller: tabController,
        //   physics: const NeverScrollableScrollPhysics(),
        //   children: [
        //     MainContainerView(),
        //     TransactionsView(),
        //     ProfileView(),
        //   ],
        // ),
        body: MainContainerView(),
        //bottomNavigationBar: buildTabBar()
      ),
    );
  }



  buildTabBar() => TabBar(
        controller: tabController,
        indicatorColor: Colors.transparent,
        unselectedLabelColor: MyColors.pnbGreyColor,
        labelColor: Colors.black45,
        onTap: (_) {
          setState(() {
            tabIndex = _;
          });
        },
        tabs: [
          _buildTab(str_Home, MOBILEHOMEBROWN, MOBILEHOMEGREY, 0),
          _buildTab(str_Transactions, MOBILEPATHROWN, MOBILEPATHGREY, 1),
          _buildTab(str_Profile, MOBILEPROFFILEBROWN, MOBILEPROFFILEGREY, 2),
        ],
      );


  Drawer CustomDrawer(){
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
           SizedBox(
             height: 100.h,
             child: DrawerHeader(
              decoration: BoxDecoration(
              //  color: Colors.blue,
                gradient: LinearGradient(colors: [MyColors.lightRedGradient,MyColors.lightBlueGradient],begin: Alignment.centerLeft,end: Alignment.centerRight )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    height: 44.h,
                    width: 44.w,
                    image: AssetImage(Utils.path(DASHBOARDGSTPROFILEWOHOUTGST)),
                  ),
                  SizedBox(width: 15.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text("Hello, Indo International!, $name",
                          style: ThemeHelper.getInstance()?.textTheme.headline2?.copyWith(color: MyColors.white)),
                      // SizedBox(height: 5.h),
                      // Text("PAN: ABCDE1234F $pan",
                      //     style: ThemeHelper.getInstance()!
                      //         .textTheme
                      //         .headline5!
                      //         .copyWith(fontSize: 12.sp, color: MyColors.white)),
                    ],
                  ),
                  /*const Spacer(),
                  SvgPicture.asset(
                    Utils.path(MOBILEDASHWIHTOUTNOTIBELL),
                  )*/
                ],
              ),
          ),
           ),
          ListTile(
            title:  Text('Home',style: ThemeHelper.getInstance()?.textTheme.headline3,),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          Divider(),
          ListTile(
            title:  Text('Transactions',style: ThemeHelper.getInstance()?.textTheme.headline3),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          Divider(),
          ListTile(
            title:  Text('Profile',style: ThemeHelper.getInstance()?.textTheme.headline3),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          Divider(),
          ListTile(
            title:  Text('Raise Dispute',style: ThemeHelper.getInstance()?.textTheme.headline3),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          Divider(),
        ],
      ),
    );
  }

  bool activeChecker(int currentIndex) =>
      tabIndex == currentIndex ? true : false;

  _buildTab(
      String title, String activePath, String inActivePath, int currentIndex) {
    return SizedBox(
      width: 100.w,
      height: 60.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 5.h),
            child: SvgPicture.asset(
              Utils.path(
                  activeChecker(currentIndex) ? activePath : inActivePath),
            ),
          ),
          Text(title,
              style: ThemeHelper.getInstance()!.textTheme.headline1!.copyWith(
                  fontSize: 12.sp,
                  color: activeChecker(currentIndex)
                      ? MyColors.pnbcolorPrimary
                      : MyColors.pnbGreyColor)),
        ],
      ),
    );
  }

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
              _buildTopContent(),
              _buildMiddleContent(),
              GestureDetector(
                  onTap: () {
                    if (pendingLoan?.isNotEmpty == true) {
                      setExpanded1();
                    }
                  },
                  child: _buildOnPendingCard(str_Pending_Disbursement, str_p1,
                      MyColors.white)),
              GestureDetector(
                  onTap: () {
                    if (ongoingLoan?.isNotEmpty == true) {
                      setExpanded2();
                    }
                  },
                  child: buildOngingCard(strOngoingapplication, str_o1,
                      MyColors.white)),
              buildCardImg(),
              SizedBox(height: 12.h,),
              recentTransactionList()
              /* _buildTitleRow(),
          _buildList()*/
            ],
          ),
        ));
  }

  Widget recentTransactionList() {
   // if (!isRecentTransactionEmpty) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8.r),
          ),
          color: ThemeHelper.getInstance()!.backgroundColor,
        ),
       // color: ThemeHelper.getInstance()?.backgroundColor,
        child: Column(children: [
          Padding(
            padding: EdgeInsets.only(
              left: 20.0.w,
              right: 20.w,
              top: 19.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(str_Recent_Transactions,
                    style: ThemeHelper.getInstance()!
                        .textTheme
                        .headline6!
                        .copyWith(color: MyColors.black, fontSize: 14.sp)),
                GestureDetector(
                  onTap: () {
                    // setState(() {
                    //   TGSession.getInstance().set("TabIndex", 0);
                    //   tabController.index = 1;
                    //   setState(() {
                    //     tabIndex = 1;
                    //   });
                    // });
                  },
                  child: Text(
                    str_sellAll,
                    style: ThemeHelper.getInstance()!
                        .textTheme
                        .headline6!
                        .copyWith(
                            decoration: TextDecoration.underline,
                            color: MyColors.pnbUnderLineColor),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w,right: 20.w),
            child: Divider(),
          ),
          _buildList()
        ]),
      );
    // } else {
    //   return Container();
    // }
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
                  str_Outstanding,
                  MOBILETDASHBOARDWITHGSTOUTSTANDING,
                  _basicdetailsResponse
                          ?.data?[0].loanDetails?.outstanding?.count ??
                      "01",
                  Utils.convertIndianCurrency(_basicdetailsResponse
                      ?.data?[0].loanDetails?.outstanding?.amount)),
              _buildCard(
                  1,
                  strOverdue,
                  MOBILETDASHBOARDWITHGSTOVERDUE,
                  _basicdetailsResponse
                          ?.data?[0].loanDetails?.overdue?.count ??
                      "03",
                  Utils.convertIndianCurrency(_basicdetailsResponse
                      ?.data?[0].loanDetails?.overdue?.amount)),
            ]),
        Padding(
          padding: EdgeInsets.only(top: 10.h, bottom: 12.h),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCard(
                    2,
                    strRepaid,
                    IMG_kfs_coin_stack,
                    _basicdetailsResponse
                            ?.data?[0].loanDetails?.repaid?.count ??
                        "04",
                    Utils.convertIndianCurrency(_basicdetailsResponse
                        ?.data?[0].loanDetails?.repaid?.amount)),
                _buildCard(
                    3,
                    strDisbursed,
                    MOBILEHANDWITHMONEY,
                    _basicdetailsResponse
                            ?.data?[0].loanDetails?.disbursed?.count ??
                        "06",
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
                  Spacer(),
                  Text(
                    count,
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline5
                        ?.copyWith(color: MyColors.pnbTextcolor),
                  ),
                  // SizedBox(
                  //   width: 25.w,
                  //   height: 25.h,
                  //   child: CircleAvatar(
                  //     backgroundColor:
                  //         ThemeHelper.getInstance()!.colorScheme.onSecondary,
                  //     child: SvgPicture.asset(
                  //       Utils.path(imgString),
                  //       height: 18.h,
                  //       width: 18.w,
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            SizedBox(height: 8.h,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(
                      title,
                      style: ThemeHelper.getInstance()?.textTheme.headline4,
                    ),
                    Text(
                      price,
                      style: ThemeHelper.getInstance()!
                          .textTheme
                          .headline1!
                          .copyWith(fontSize: 14.sp),
                    ),
                  ],),
                  Spacer(),
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

  _buildOnPendingCard(String title, String subTitle, Color backgroundColor) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(4.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        width: 335.w,
        child: Padding(
          padding: EdgeInsets.only(
              left: 10.0.w, right: 10.w, top: 15.h, bottom: 15.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$title(${pendingLoan?.length.toString() ?? "0"})",
                          style: ThemeHelper.getInstance()!
                              .textTheme
                              .headline1!
                              .copyWith(fontSize: 13.sp)),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        subTitle,
                        style: ThemeHelper.getInstance()!
                            .textTheme
                            .bodyText2!
                            ,
                      )
                    ],
                  ),

                  SvgPicture.asset(
                    isExpanded1 ?
                    Utils.path(IMG_UP_ARROW) : Utils.path(IMG_DOWN_ARROW),
                    height: 20.h,
                    width: 20.w,
                  ),


                ],
              ),
              (isExpanded1 && pendingLoan?.isNotEmpty == true)
                  ? Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: PendingDisbursementList(),
                    )
                  : const SizedBox(),
              SizedBox(
                height: 0.h,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget OnGoingDisbursementList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: ongoingLoan?.length,
      itemBuilder: (context, index) {
        return Padding(
          key: ValueKey(''),
          padding: EdgeInsets.only(left: 5.w, right: 5.w),
          child: LoanDetailCardUI(context, ongoingLoan?[index]),
        );
      },
    );
  }

  Widget PendingDisbursementList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: pendingLoan?.length,
      itemBuilder: (context, index) {
        return Padding(
          key: ValueKey(''),
          padding: EdgeInsets.only(left: 5.w, right: 5.w),
          child: LoanDetailCardUI(context, pendingLoan?[index]),
        );
      },
    );
  }

  Widget LoanDetailCardUI(BuildContext context, LoanDetailData? data) {
    return Container(
        /* width: 335.w,*/
        height: 160.h,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Container(
            decoration: BoxDecoration(
                color: MyColors.white,
                borderRadius: BorderRadius.all(Radius.circular(12.r))),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 17.w),
              child: Column(
                children: [
                  SizedBox(
                    height: 14.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildCompanyText(data?.buyerName ?? ""),
                          buildInvoiceText(data?.invoiceNumber ?? ""),
                        ],
                      ),
                      //..Check Status Button ..I am here
                      _buildCheckStatusButton(data)
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        str_Stage,
                        style: ThemeHelper.getInstance()!
                            .textTheme
                            .headline3!
                            .copyWith(
                                fontSize: 10.sp, color: MyColors.pnbGreyColor),
                      ),
                      Row(
                        children: [
                          Text(
                              getCurrentStage(
                                  data?.currentApplicationStage ?? ""),
                              style: ThemeHelper.getInstance()!
                                  .textTheme
                                  .headline1!
                                  .copyWith(
                                      fontSize: 10.sp,
                                      color: ThemeHelper.getInstance()!
                                          .colorScheme
                                          .primary)),
                          SizedBox(
                            width: 2.w,
                          ),
                          Icon(
                            Icons.info,
                            color: ThemeHelper.getInstance()!.primaryColor,
                            size: 12,
                          )
                        ],
                      ),
                    ],
                  ),
                  _buildCustomProgressBar(
                      getCurrentStage(data?.currentApplicationStage ?? "")),
                  _buildBottomPartInsideCard(data)
                ],
              ),
            ),
          ),
        ));
  }

  buildCompanyText(String text) => SizedBox(
        width: 150.w,
        child: Text(
          text,
          style: ThemeHelper.getInstance()!
              .textTheme
              .headline1!
              .copyWith(fontSize: 11.sp),
        ),
      );

  buildInvoiceText(String text) => Text(
        str_invoice_no + text,
        style: ThemeHelper.getInstance()!
            .textTheme
            .headline3!
            .copyWith(fontSize: 8.sp),
      );

  _buildCheckStatusButton(LoanDetailData? data) {
    return SizedBox(
        width: 109.w,
        height: 27.h,
        child: ElevatedButton(
          onPressed: () {
            MoveStage.movetoStage(context, data);
          },
          style: ThemeHelper.getInstance()!.elevatedButtonTheme.style!.copyWith(
                foregroundColor:
                    MaterialStateProperty.all(MyColors.pnbcolorPrimary),
                backgroundColor:
                    MaterialStateProperty.all(MyColors.pnbPinkColor),
                textStyle: MaterialStateProperty.all(
                  TextStyle(
                      fontSize: 12.sp, fontFamily: MyFont.Nunito_Sans_Bold),
                ),
              )
          /* : ThemeHelper.getInstance()!
               .elevatedButtonTheme
               .style*/
          ,
          child: Text(str_checkstatus),
        ));
  }

  _buildCustomProgressBar(String currentStage) {
    return FittedBox(
      child: Padding(
        padding: EdgeInsets.only(top: 13.h, bottom: 10.h),
        child: Row(children: [
          _buildContainer(currentStage == str_loan_approve_process ||
              currentStage == str_doc_kyc ||
              currentStage == str_disbursement),
          _buildContainer(currentStage == str_loan_approve_process ||
              currentStage == str_doc_kyc ||
              currentStage == str_disbursement),
          _buildContainer(
              currentStage == str_doc_kyc || currentStage == str_disbursement),
          _buildContainer(currentStage == str_disbursement),
        ]),
      ),
    );
  }

  _buildContainer(bool flag) {
    return Padding(
      padding: EdgeInsets.only(left: flag ? 3.w : 0.w),
      child: Container(
        decoration: BoxDecoration(
            color: flag ? MyColors.pnbGreenColor : MyColors.pnbPinkColor,
            borderRadius: BorderRadius.all(Radius.circular(6.r))),
        width: 65.w,
        height: 3.h,
      ),
    );
  }

  _buildBottomPartInsideCard(LoanDetailData? data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildBottomCardPartWidget(str_Lender, strPnb, true),
        _buildBottomCardPartWidget(str_Loan_amount,
            Utils.convertIndianCurrency(data?.invoiceAmount), false)
      ],
    );
  }

  _buildBottomCardPartWidget(String title, String subTitle, bool flag) {
    return Column(
      crossAxisAlignment:
          flag ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(title,
            style: ThemeHelper.getInstance()!
                .textTheme
                .headline3!
                .copyWith(fontSize: 10.sp, color: MyColors.pnbGreyColor)),
        Text(subTitle,
            style: ThemeHelper.getInstance()!.textTheme.headline1!.copyWith(
                  fontSize: 10.sp,
                ))
      ],
    );
  }

  buildOngingCard(String title, String subTitle, Color backgroundColor) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(4.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        width: 335.w,
        child: Padding(
          padding: EdgeInsets.only(
              left: 10.0.w, right: 10.w, top: 15.h, bottom: 15.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$title(${ongoingLoan?.length.toString() ?? "0"})",
                          style: ThemeHelper.getInstance()!
                              .textTheme
                              .headline1!
                              .copyWith(fontSize: 13.sp)),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        subTitle,
                        style: ThemeHelper.getInstance()!
                            .textTheme
                            .bodyText2!
                         ,
                      )
                    ],
                  ),
                  SvgPicture.asset(
                    isExpanded2 ?
                    Utils.path(IMG_UP_ARROW) : Utils.path(IMG_DOWN_ARROW),
                    height: 20.h,
                    width: 20.w,
                  ),
                ],
              ),
              (isExpanded2 && ongoingLoan?.isNotEmpty == true)
                  ? Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: OnGoingDisbursementList(),
                    )
                  : const SizedBox(),
              SizedBox(
                height: 0.h,
              )
            ],
          ),
        ),
      ),
    );
  }

  buildCardImg() {
    return GestureDetector(
      onTap: () {
        // if (isOngoingJounery == true) {
        //   DialogUtils.showCustomDialog(context,
        //       title:
        //           "Other eligible invoices cannot be financed due to an ongoing application is already there.",
        //       okBtnText: "OK");
        // } else {
        //   TGSharedPreferences.getInstance().remove(PREF_AAID);
        //   TGSharedPreferences.getInstance().remove(PREF_AACODE);
        //   TGSharedPreferences.getInstance().remove(PREF_LOANAPPREFID);
        //   TGSharedPreferences.getInstance().remove(PREF_LOANOFFER);
        //   TGSharedPreferences.getInstance().remove(GET_ALLLIST);
        //   TGSharedPreferences.getInstance().remove(PREF_AAURL);
        //   TGSharedPreferences.getInstance().remove(PREF_AACALLBACKURL);
        //   TGSharedPreferences.getInstance().remove(PREF_CONSENTTYPE);
        //   TGSharedPreferences.getInstance().remove(PREF_CONSENT_AAID);
        //   TGSharedPreferences.getInstance().remove(PREF_OFFERID);
        //   TGSharedPreferences.getInstance().remove(PREF_LOANAPPID);
        //   TGSharedPreferences.getInstance().remove(PREF_REPAYMENTPLANID);
        //   TGSharedPreferences.getInstance().remove(PREF_CURRENT_STAGE);
        //
        //   Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //       builder: (BuildContext context) => GSTInvoicesList(),
        //     ),
        //     (route) => false, //if you want to disable back feature set to false
        //   );
        //}
      },
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8.r),
            ),
            color: ThemeHelper.getInstance()!.backgroundColor,
          ),
          height: 140.h,
        child: Padding(
          padding: EdgeInsets.only(top: 18.h),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 6,
                child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                          "Finance other eligible invoice",
                          style: ThemeHelper.getInstance()!
                              .textTheme
                              .headline2!.copyWith(fontSize: 14.sp),maxLines: 3,softWrap: true,),
                    Text(
                        str_Shareothereligibleinvoicesandgetloanoffers,
                      style: ThemeHelper.getInstance()!
                          .textTheme
                          .bodyText2!,maxLines: 3,softWrap: true,
                    ),
                    SizedBox(height: 18.h),
                    Container(
                      width: 165.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.r),
                        ),
                        color: ThemeHelper.getInstance()!.primaryColor,
                      ),
                      child:Center(
                        child: Text(
                          "Finance Another Invoice",
                          style: ThemeHelper.getInstance()!
                              .textTheme
                              .headline2!.copyWith(fontSize: 14.sp,color: Colors.white)),
                      ) ,
                    )
                  ],
                ),
              ),
             //Spacer(),
            Flexible(
              flex: 4,
              child: SvgPicture.asset(
                Utils.path(MOBILETDASHBOARDWITHGSTINVOICE_OTHER_SERVICES),height: 88.h,width: 88.w,
              ),
            )
          ],),
        )
      ),
    );
  }

  _buildTitleRow() {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.0.w,
        right: 20.w,
        top: 19.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(str_Recent_Transactions,
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline6!
                  .copyWith(color: MyColors.black, fontSize: 14.sp)),
          Text(
            str_sellAll,
            style: ThemeHelper.getInstance()!.textTheme.headline6!.copyWith(
                decoration: TextDecoration.underline,
                color: MyColors.pnbUnderLineColor),
          )
        ],
      ),
    );
  }

  _buildList() {
    // if (isRecentTransactionEmpty) {
    //   return Text(
    //     "No Data Found",
    //     style: ThemeHelper.getInstance()?.textTheme.headline1,
    //     textAlign: TextAlign.center,
    //   );
    // } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8.r),
          ),
          color: ThemeHelper.getInstance()!.backgroundColor,
        ),
        height: 200.h,
        child: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              String tradename = translist?[index]?.tradename ?? 'Flipcart Pvt. Ltd.';
              String status = translist?[index]?.status ?? 'Repaid';
              String createdDate = translist?[index]?.createdDate ?? '09 Aug, 2022';
              String invoiceAmount =
                  translist?[index]?.disbursement_amt ?? '42640';

              return Column(children: [ _buildListCard(
                  day: "09",//createDay(createdDate),
                  month: "Aug",//createtMonth(createdDate),
                  background: setBackgroundColor(index),
                  companyName: tradename,
                  subtext: status,
                  price: invoiceAmount,
                  top: 21.h),
                Padding(
                  padding: EdgeInsets.only(left: 20.w,right: 20.w),
                  child: Divider(),
                ),
              ]);
            }),
      );
    //}

    return [
      _buildListCard(
          day: str_19,
          month: str_Aug,
          background: MyColors.pnbYellowColor,
          companyName: str_Flipcart_Pvt_Ltd,
          subtext: strRepaid,
          price: str_42640,
          top: 21.h),
      _buildListCard(
          day: str_09,
          month: str_Aug,
          background: MyColors.pnbPinkColor,
          companyName: str_Flipcart_Pvt_Ltd,
          subtext: strDisbursed,
          price: str_42640,
          top: 10.h,
          bottom: 10.h),
      _buildListCard(
        day: str_19,
        month: str_Aug,
        background: MyColors.pnbPurpleColor,
        companyName: str_Flipcart_Pvt_Ltd,
        subtext: strDisbursed,
        price: str_42640,
      )
    ];
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

  String getCurrentStage(String stage) {
    if (stage == STAGE_INITIATED ||
        stage == STAGE_SHARE_INVOICE ||
        stage == STAGE_CONSENT ||
        stage == STAGE_LOAN_OFFER ||
        stage == STAGE_LIST_OFFER) {
      return str_loan_approve_process;
    } else if (stage == STAGE_SET_DISBURSEMENT_ACC ||
        stage == STAGE_SIGN_AGGREEMENT ||
        stage == STAGE_SIGN_AGGREEMENT_STATUS ||
        stage == STAGE_GRANT_LOAN ||
        stage == STAGE_E_MANDATE ||
        stage == STAGE_E_MANDATE_STATUS ||
        stage == STAGE_CONSENT_MONITORING ||
        stage == STAGE_DISBURSEMENT) {
      return str_doc_kyc;
    } else if (stage == STAGE_DISBURSEMENT_STATUS) {
      return str_disbursement;
    }

    return "";
  }

  Future<void> getGstBasicDetails() async {
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
      TGSharedPreferences.getInstance().set(PREF_BUSINESSNAME,
          _basicdetailsResponse?.data?[0].gstBasicDetails?.tradeNam);
      TGSharedPreferences.getInstance()
          .set(PREF_GSTIN, _basicdetailsResponse?.data?[0].gstin);
      TGSession.getInstance()
          .set(PREF_GSTIN, _basicdetailsResponse?.data?[0].gstin);
      TGSharedPreferences.getInstance().set(PREF_USERNAME,
          _basicdetailsResponse?.data?[0].gstBasicDetails?.lgnm.toString());
      TGSharedPreferences.getInstance().set(
          PREF_PANNO, _basicdetailsResponse?.data?[0].gstin?.substring(2, 12));
      TGSharedPreferences.getInstance().set(PREF_USERSTATE,
          _basicdetailsResponse?.data?[0].gstBasicDetails?.stcd.toString());

      setUserData();

      if (await TGNetUtil.isInternetAvailable()) {
        getUserLoanDetails();
      } else {
        showSnackBarForintenetConnection(context, getUserLoanDetails);
      }
    } else {
      // Navigator.pop(context);
      //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardWithoutGST()));
    }
  }

  _onErrorGetGstBasicDetails(TGResponse errorResponse) {
    Navigator.pop(context);
    TGLog.d("GetGstBasicDetailsResponse : onError()");
  }

  Future<void> getUserLoanDetails() async {
    TGGetRequest tgGetRequest = GetLoanDetailByRefIdReq();
    ServiceManager.getInstance().getAllLoanDetailByRefId(
        request: tgGetRequest,
        onSuccess: (response) => _onSuccessGetAllLoanDetailByRefId(response),
        onError: (error) => _onErrorGetAllLoanDetailByRefId(error));
  }

  _onSuccessGetAllLoanDetailByRefId(
      GetAllLoanDetailByRefIdResponse? response) async {
    TGLog.d("RegisterResponse : onSuccess()");
    setState(() {
      _getAllLoanDetailRes = response?.getAllLoanDetailObj();
      if (_getAllLoanDetailRes?.data?.isNotEmpty == true) {
        if (_getAllLoanDetailRes?.data?[0].currentApplicationStage !=
            STAGE_DISBURSEMENT_STATUS) {
          isOngoingJounery = true;
        }

        pendingLoan = _getAllLoanDetailRes?.data
            ?.where(
                (i) => i.currentApplicationStage == STAGE_DISBURSEMENT_STATUS)
            .toList();

        ongoingLoan = _getAllLoanDetailRes?.data
            ?.where(
                (i) => i.currentApplicationStage != STAGE_DISBURSEMENT_STATUS)
            .toList();
      } else {
        //  Navigator.pop(context);
        //   Navigator.of(context).push(CustomRightToLeftPageRoute(child: DashboardWithoutGST(),));

        isOngoingJounery = false;
      }
    });

    if (await TGNetUtil.isInternetAvailable()) {
      getRecentTransactionDetail();
    } else {
      showSnackBarForintenetConnection(context, getRecentTransactionDetail);
    }
  }

  _onErrorGetAllLoanDetailByRefId(TGResponse errorResponse) {
    Navigator.pop(context);
    TGLog.d("RegisterResponse : onError()");
  }

  Future<void> getRecentTransactionDetail() async {
    TGGetRequest tgGetRequest = GetRecentTransactionRequest();
    ServiceManager.getInstance().getRecentTransaction(
        request: tgGetRequest,
        onSuccess: (response) => _onSuccessGetRecentTransaction(response),
        onError: (error) => _onErrorGetRecentTransaction(error));
  }

  _onSuccessGetRecentTransaction(GetRecentTransactiobResponse? response) {
    TGLog.d("GetRecentTransactiResponse : onSuccess()");
    getrecenttransactionobj = response?.getRecentTransactionResObj();

    setState(() {
      if (getrecenttransactionobj?.data?.transactionList?.isNotEmpty == true) {
        translist = getrecenttransactionobj?.data?.transactionList;
        isRecentTransactionEmpty = false;
      } else {
        isRecentTransactionEmpty = true;
      }
    });

    Navigator.pop(context);
  }

  _onErrorGetRecentTransaction(TGResponse errorResponse) {
    Navigator.pop(context);
    TGLog.d("GetRecentTransactiResponse : onError()");
  }

  static Future<bool?> showFirstWaring(BuildContext context) async =>
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text('Do you want to Exit?'),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          SystemNavigator.pop(animated: true);
                        },
                        child: Text('Exit'),
                      )
                    ],
                  ),
                ],
                title: Text(
                  'Exit',
                  style: ThemeHelper.getInstance()!.textTheme.headline1,
                ),
              ));
}
