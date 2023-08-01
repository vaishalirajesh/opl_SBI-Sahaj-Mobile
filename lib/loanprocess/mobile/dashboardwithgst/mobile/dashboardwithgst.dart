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
import 'package:gstmobileservices/util/data_format_utils.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:intl/intl.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/gstinvoiceslist/ui/gstinvoicelist.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/helpers/myfonts.dart';
import 'package:sbi_sahay_1_0/utils/progressLoader.dart';
import 'package:sbi_sahay_1_0/widgets/back_to_home_widget.dart';
import 'package:sbi_sahay_1_0/widgets/info_loader.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';

import '../../../../registration/mobile/dashboardwithoutgst/mobile/dashboardwithoutgst.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/constants/prefrenceconstants.dart';
import '../../../../utils/constants/stageconstants.dart';
import '../../../../utils/constants/statusConstants.dart';
import '../../../../utils/helpers/themhelper.dart';
import '../../../../utils/internetcheckdialog.dart';
import '../../../../utils/movestageutils.dart';
import '../../../../utils/singlebuttondialog.dart';
import '../../../../utils/strings/strings.dart';
import '../../profile/ui/newprofile.dart';
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

class _DashboardWithGstState extends State<DashboardWithGst> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  void setUserData() async {
    String? text = await TGSharedPreferences.getInstance().get(PREF_BUSINESSNAME);
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

  bool isLoadData = false;

  @override
  void initState() {
    //tabController = TabController(vsync: this, length: 3);
    //tabController.index = 0;
    getBasicDetailApiCall();
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
    return !isLoadData
        ? const ShowInfoLoader(
            msg: str_getting_user_detail,
            subMsg: str_wait_a_moment,
          )
        : WillPopScope(
            onWillPop: () async {
              if (_scaffoldKey.currentState!.isDrawerOpen) {
                _scaffoldKey.currentState!.closeDrawer();
                return false;
              } else {
                final shouldPop = await _showFirstWaring(context);
                return shouldPop ?? false;
              }
            },
            child: Scaffold(
              key: _scaffoldKey,
              drawer: MyDrawer(userName: name, screenName: "Dashbaord"),
              appBar: getAppBarMainDashboard("2", str_loan_approve_process, 0.50,
                  onClickAction: () => {_scaffoldKey.currentState?.openDrawer()}),
              body: MainContainerView(),
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

  bool activeChecker(int currentIndex) => tabIndex == currentIndex ? true : false;

  _buildTab(String title, String activePath, String inActivePath, int currentIndex) {
    return SizedBox(
      width: 100.w,
      height: 60.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 5.h),
            child: SvgPicture.asset(
              AppUtils.path(activeChecker(currentIndex) ? activePath : inActivePath),
            ),
          ),
          Text(title,
              style: ThemeHelper.getInstance()!.textTheme.headline1!.copyWith(
                  fontSize: 12.sp,
                  color: activeChecker(currentIndex) ? MyColors.pnbcolorPrimary : MyColors.pnbGreyColor)),
        ],
      ),
    );
  }

  Widget MainContainerView() {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [MyColors.lightRedGradient, MyColors.lightBlueGradient],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              _buildTopContent(),
              _buildMiddleContent(),
              GestureDetector(
                onTap: () {
                  setExpanded1();
                },
                child: _buildOnPendingCard(str_Pending_Disbursement, str_p1, MyColors.white),
              ),
              GestureDetector(
                onTap: () {
                  setExpanded2();
                },
                child: buildOngingCard(strOngoingapplication, str_o1, MyColors.white),
              ),
              buildCardImg(),
              SizedBox(
                height: 12.h,
              ),
              if (!isRecentTransactionEmpty) recentTransactionList()
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
            left: 10.0.w,
            right: 10.w,
            top: 15.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  str_Recent_Transactions,
                  style: ThemeHelper.getInstance()!.textTheme.button!.copyWith(color: MyColors.black),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // setState(() {
                  //   TGSession.getInstance().set("TabIndex", 0);
                  //   tabController.index = 1;
                  //   setState(() {
                  //     tabIndex = 1;
                  //   });
                  // });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TransactionsMain(),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(5.r),
                  child: Text(
                    str_seeAll,
                    style: ThemeHelper.getInstance()!
                        .textTheme
                        .subtitle1!
                        .copyWith(color: MyColors.hyperlinkcolornew, fontFamily: MyFont.Roboto_Medium),
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.w, right: 10.w),
          child: const Divider(),
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      // height: 127.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8.r),
        ),
        // border: Border.all(
        //     width: 1, color: ThemeHelper.getInstance()!.primaryColor),
        color: ThemeHelper.getInstance()!.backgroundColor,
      ),
      child: Column(
        children: [
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                AppUtils.path(DASHBOARDGSTPROFILEWOHOUTGST),
                height: 35.h,
                width: 35.w,
                color: MyColors.lightRedGradient,
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //SizedBox(height: 20.h),
                    Text(name, style: ThemeHelper.getInstance()?.textTheme.headline2?.copyWith(fontSize: 16.sp)),
                    SizedBox(height: 5.h),
                    Text('PAN: $pan',
                        style: ThemeHelper.getInstance()!.textTheme.headline5!.copyWith(
                            fontSize: 12.sp, color: MyColors.lightGraySmallText, fontFamily: MyFont.Roboto_Regular)),
                  ],
                ),
              ),
              SizedBox(width: 20.w),
              Align(
                alignment: Alignment.centerRight,
                child: SvgPicture.asset(
                  AppUtils.path(MOBILETDASHBOARDARROWFORWARD),
                  height: 15.h,
                  width: 10.w,
                ),
              )
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          const Divider(),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: "GSTIN : ",
                    style: ThemeHelper.getInstance()?.textTheme.bodyText2?.copyWith(color: MyColors.pnbTextcolor),
                  ),
                  TextSpan(
                    text: gstin,
                    style: ThemeHelper.getInstance()?.textTheme.bodyText2,
                  )
                ]),
              ),
              // Text("GSTIN: $gstin", style: ThemeHelper.getInstance()?.textTheme.bodyText2),
              const Spacer(),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: "State : ",
                    style: ThemeHelper.getInstance()?.textTheme.bodyText2?.copyWith(color: MyColors.pnbTextcolor),
                  ),
                  TextSpan(
                    text: state,
                    style: ThemeHelper.getInstance()?.textTheme.bodyText2,
                  )
                ]),
              ),
            ],
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  _buildMiddleContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.h),
        Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildCard(
              0,
              str_Outstanding,
              MOBILETDASHBOARDWITHGSTOUTSTANDING,
              _basicdetailsResponse?.data?[0].loanDetails?.outstanding?.count ?? "0",
              AppUtils.convertIndianCurrency(_basicdetailsResponse?.data?[0].loanDetails?.outstanding?.amount)),
          const Spacer(),
          _buildCard(
              1,
              strOverdue,
              MOBILETDASHBOARDWITHGSTOVERDUE,
              _basicdetailsResponse?.data?[0].loanDetails?.overdue?.count ?? "0",
              AppUtils.convertIndianCurrency(_basicdetailsResponse?.data?[0].loanDetails?.overdue?.amount)),
        ]),
        Padding(
          padding: EdgeInsets.only(top: 10.h, bottom: 12.h),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
            _buildCard(
                2,
                strRepaid,
                IMG_kfs_coin_stack,
                _basicdetailsResponse?.data?[0].loanDetails?.repaid?.count ?? "0",
                AppUtils.convertIndianCurrency(_basicdetailsResponse?.data?[0].loanDetails?.repaid?.amount)),
            const Spacer(),
            _buildCard(
                3,
                strDisbursed,
                MOBILEHANDWITHMONEY,
                _basicdetailsResponse?.data?[0].loanDetails?.disbursed?.count ?? "0",
                AppUtils.convertIndianCurrency(_basicdetailsResponse?.data?[0].loanDetails?.disbursed?.amount))
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
                color: ThemeHelper.getInstance()!.indicatorColor, fontSize: 13.sp, fontFamily: MyFont.Nunito_Sans_Bold))
      ],
    );
  }

  _buildCard(int index, String title, String imgString, String count, String price) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TransactionsMain(),
          ),
        );
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
        // height: 110.h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.0.w, right: 10.w, top: 15.h, bottom: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    AppUtils.path(imgString),
                    height: 24.h,
                    width: 24.w,
                  ),
                  const Spacer(),
                  Text(
                    count,
                    style: ThemeHelper.getInstance()?.textTheme.headline5?.copyWith(color: MyColors.pnbTextcolor),
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
                        style: ThemeHelper.getInstance()?.textTheme.headline4?.copyWith(fontSize: 12.sp),
                      ),
                      Text(
                        price,
                        style: ThemeHelper.getInstance()!.textTheme.headline1!.copyWith(fontSize: 14.sp),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    AppUtils.path(MOBILETDASHBOARDARROWFORWARD),
                    height: 12.h,
                    width: 6.w,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15.h,
            )
          ],
        ),
      ),
    );
  }

  _buildOnPendingCard(String title, String subTitle, Color backgroundColor) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(8.r),
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
          padding: EdgeInsets.only(left: 10.0.w, right: 10.w, top: 15.h, bottom: 15.h),
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
                          style: ThemeHelper.getInstance()!.textTheme.headline1!.copyWith(fontSize: 13.sp)),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        subTitle,
                        style: ThemeHelper.getInstance()!.textTheme.bodyText2!,
                      )
                    ],
                  ),
                  SvgPicture.asset(
                    isExpanded1 ? AppUtils.path(IMG_UP_ARROW) : AppUtils.path(IMG_DOWN_ARROW),
                    height: 20.h,
                    width: 20.w,
                  ),
                ],
              ),
              isExpanded1 //&& pendingLoan?.isNotEmpty == true)
                  ? Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: pendingDisbursementList(),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget onGoingDisbursementList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: ongoingLoan?.length ?? 0,
      itemBuilder: (context, index) {
        return Padding(
          key: const ValueKey(''),
          padding: EdgeInsets.only(left: 5.w, right: 5.w),
          child: loanDetailCardUI(context, ongoingLoan?[index]),
        );
      },
    );
  }

  Widget pendingDisbursementList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: pendingLoan?.length ?? 0,
      itemBuilder: (context, index) {
        return Padding(
          key: const ValueKey(''),
          padding: EdgeInsets.only(left: 5.w, right: 5.w),
          child: loanDetailCardUI(context, pendingLoan?[index]),
        );
      },
    );
  }

  Widget loanDetailCardUI(BuildContext context, LoanDetailData? data) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: () {
          TGLog.d("ON press account");
          MoveStage.movetoStage(context, data);
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(
          //     builder: (BuildContext context) => const CongratulationsScreen(),
          //   ),
          //   (route) => false, //if you want to disable back feature set to false
          // );
        },
        child: Container(
          decoration: BoxDecoration(
            color: MyColors.pnbPinkColor,
            borderRadius: BorderRadius.all(
              Radius.circular(12.r),
            ),
          ),
          padding: EdgeInsets.only(left: 15.r, right: 15.r, bottom: 15.r, top: 15.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildInvoiceText(data?.buyerName ?? '-'),
                        SizedBox(
                          height: 5.h,
                        ),
                        buildCompanyText("Invoice: ${data?.totalInvoice ?? 0}")
                      ],
                    ),
                  ),
                  //..Check Status Button ..I am here
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              const MySeparator(
                color: Colors.grey,
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildCompanyText(str_Stage),
                        SizedBox(height: 5.h),
                        buildInvoiceText(data?.currentApplicationStage ?? ''),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildCompanyText(str_loan_amt),
                      SizedBox(height: 5.h),
                      buildInvoiceText(DataFormatUtils.convertIndianCurrency(data?.disbursementAmt) ?? '0'),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20.h,
              ),

              //_buildBottomPartInsideCard(data),
              _buildCheckStatusButton(data)
            ],
          ),
        ),
      ),
    );
  }

  buildCompanyText(String text) => Text(
        text,
        style: ThemeHelper.getInstance()!
            .textTheme
            .headline3!
            .copyWith(fontSize: 12.sp, color: MyColors.lightGraySmallText),
      );

  buildInvoiceText(String text) => Text(
        text,
        style:
            ThemeHelper.getInstance()!.textTheme.headline2!.copyWith(fontSize: 14.sp, color: MyColors.pnbcolorPrimary),
      );

  _buildCheckStatusButton(LoanDetailData? data) {
    return Container(
      width: 109.w,
      height: 30.h,
      decoration: BoxDecoration(
        border: Border.all(color: ThemeHelper.getInstance()!.primaryColor, width: 1),
        //color: ThemeHelper.getInstance()?.backgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(4.r),
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          MoveStage.movetoStage(context, data);
        },
        style: ThemeHelper.getInstance()!.elevatedButtonTheme.style!.copyWith(
              foregroundColor: MaterialStateProperty.all(MyColors.pnbcolorPrimary),
              backgroundColor: MaterialStateProperty.all(MyColors.pnbPinkColor),
              textStyle: MaterialStateProperty.all(
                TextStyle(fontSize: 12.sp, fontFamily: MyFont.Nunito_Sans_Bold),
              ),
            ),
        child: const Text(str_checkstatus),
      ),
    );
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
          _buildContainer(currentStage == str_doc_kyc || currentStage == str_disbursement),
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
        _buildBottomCardPartWidget(str_Lender, strSBI, true),
        _buildBottomCardPartWidget(str_Loan_amount, AppUtils.convertIndianCurrency(data?.invoiceAmount), false)
      ],
    );
  }

  _buildBottomCardPartWidget(String title, String subTitle, bool flag) {
    return Column(
      crossAxisAlignment: flag ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(title,
            style: ThemeHelper.getInstance()!
                .textTheme
                .headline3!
                .copyWith(fontSize: 10.sp, color: MyColors.pnbGreyColor)),
        Text(
          subTitle,
          style: ThemeHelper.getInstance()!.textTheme.headline1!.copyWith(
                fontSize: 10.sp,
              ),
        )
      ],
    );
  }

  buildOngingCard(String title, String subTitle, Color backgroundColor) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(8.r),
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
          padding: EdgeInsets.only(left: 10.0.w, right: 10.w, top: 15.h, bottom: 15.h),
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
                          style: ThemeHelper.getInstance()!.textTheme.headline1!.copyWith(fontSize: 13.sp)),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        subTitle,
                        style: ThemeHelper.getInstance()!.textTheme.bodyText2!,
                      )
                    ],
                  ),
                  SvgPicture.asset(
                    isExpanded2 ? AppUtils.path(IMG_UP_ARROW) : AppUtils.path(IMG_DOWN_ARROW),
                    height: 20.h,
                    width: 20.w,
                  ),
                ],
              ),
              (isExpanded2) //&& ongoingLoan?.isNotEmpty == true)
                  ? Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: onGoingDisbursementList(),
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
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8.r),
          ),
          color: ThemeHelper.getInstance()!.backgroundColor,
        ),
        padding: EdgeInsets.only(
          top: 20.h,
          bottom: 20.h,
        ),
        // height: 140.h,
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
                    style: ThemeHelper.getInstance()!.textTheme.headline2!.copyWith(fontSize: 14.sp),
                    maxLines: 3,
                    softWrap: true,
                  ),
                  Text(
                    str_Shareothereligibleinvoicesandgetloanoffers,
                    style: ThemeHelper.getInstance()!.textTheme.bodyText2!,
                    maxLines: 3,
                    softWrap: true,
                  ),
                  SizedBox(height: 18.h),
                  GestureDetector(
                    onTap: () {
                      if (isOngoingJounery == true) {
                        DialogUtils.showCustomDialog(context,
                            title:
                                "Other eligible invoices cannot be financed due to an ongoing application is already there.",
                            okBtnText: "OK");
                      } else {
                        TGSharedPreferences.getInstance().remove(PREF_AAID);
                        TGSharedPreferences.getInstance().remove(PREF_AACODE);
                        TGSharedPreferences.getInstance().remove(PREF_LOANAPPREFID);
                        TGSharedPreferences.getInstance().remove(PREF_LOANOFFER);
                        TGSharedPreferences.getInstance().remove(GET_ALLLIST);
                        TGSharedPreferences.getInstance().remove(PREF_AAURL);
                        TGSharedPreferences.getInstance().remove(PREF_AACALLBACKURL);
                        TGSharedPreferences.getInstance().remove(PREF_CONSENTTYPE);
                        TGSharedPreferences.getInstance().remove(PREF_CONSENT_AAID);
                        TGSharedPreferences.getInstance().remove(PREF_OFFERID);
                        TGSharedPreferences.getInstance().remove(PREF_LOANAPPID);
                        TGSharedPreferences.getInstance().remove(PREF_REPAYMENTPLANID);
                        TGSharedPreferences.getInstance().remove(PREF_CURRENT_STAGE);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => const GSTInvoicesList(),
                          ),
                          (route) => false, //if you want to disable back feature set to false
                        );
                      }
                    },
                    child: Container(
                      width: 165.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.r),
                        ),
                        color: ThemeHelper.getInstance()!.primaryColor,
                      ),
                      child: Center(
                        child: Text("Finance Another Invoice",
                            style: ThemeHelper.getInstance()!
                                .textTheme
                                .headline2!
                                .copyWith(fontSize: 14.sp, color: Colors.white)),
                      ),
                    ),
                  )
                ],
              ),
            ),
            //Spacer(),
            Flexible(
              flex: 4,
              child: SvgPicture.asset(
                AppUtils.path(MOBILETDASHBOARDWITHGSTINVOICE_OTHER_SERVICES),
                height: 88.h,
                width: 88.w,
              ),
            )
          ],
        ));
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
          itemCount: translist?.length ?? 0,
          itemBuilder: (context, index) {
            String tradename = translist?[index]?.tradename ?? 'Flipcart Pvt. Ltd.';
            String status = translist?[index]?.status ?? 'Repaid';
            String createdDate = translist?[index]?.createdDate ?? '09 Aug, 2022';
            String invoiceAmount = translist?[index]?.disbursement_amt ?? '44000';
            return Column(children: [
              _buildListCard(
                  day: AppUtils.convertDateFormat(createdDate, "dd-MM-yyyy", 'dd MMM, yyyy'),
                  month: "Aug",
                  background: setBackgroundColor(index),
                  companyName: tradename,
                  subtext: AppUtils.getCamelCase(status),
                  price: invoiceAmount,
                  top: 5.h),
              Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: const Divider(),
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
      type == strDisbursed ? MyColors.pnbGreenColor : MyColors.pnbGreenColor; //MyColors.pnbRedColor;

  _buildListCard(
      {required String day,
      required String month,
      required Color background,
      required String companyName,
      required String subtext,
      required String price,
      double top: 0,
      double bottom: 5}) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0.w, right: 10.w, bottom: bottom, top: top),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(companyName,
                    style: ThemeHelper.getInstance()!
                        .textTheme
                        .headline1!
                        .copyWith(color: MyColors.black, fontSize: 14.sp, fontFamily: MyFont.Roboto_Regular)),
                SizedBox(
                  height: 2.h,
                ),
                Text(day, style: ThemeHelper.getInstance()!.textTheme.bodyText2!),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppUtils.convertIndianCurrency(price),
                // NumberFormat.simpleCurrency(locale: 'hi-In').format(int.parse(price.toString())).toString(),
                style: ThemeHelper.getInstance()!.textTheme.headline1!.copyWith(fontSize: 13.sp),
              ),
              Text(
                subtext,
                style:
                    ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(color: setColor(subtext), fontSize: 11.sp),
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
    TGLog.d("GST basic deatil request-------${tgGetRequest.toString()}");
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
      TGSharedPreferences.getInstance()
          .set(PREF_BUSINESSNAME, _basicdetailsResponse?.data?[0].gstBasicDetails?.tradeNam);
      TGSharedPreferences.getInstance().set(PREF_GSTIN, _basicdetailsResponse?.data?[0].gstin);
      TGSession.getInstance().set(PREF_GSTIN, _basicdetailsResponse?.data?[0].gstin);
      TGSharedPreferences.getInstance()
          .set(PREF_USERNAME, _basicdetailsResponse?.data?[0].gstBasicDetails?.lgnm.toString());
      TGSharedPreferences.getInstance().set(PREF_PANNO, _basicdetailsResponse?.data?[0].gstin?.substring(2, 12));
      TGSharedPreferences.getInstance()
          .set(PREF_USERSTATE, _basicdetailsResponse?.data?[0].gstBasicDetails?.stcd.toString());
      setUserData();
      if (await TGNetUtil.isInternetAvailable()) {
        getUserLoanDetails();
      } else {
        showSnackBarForintenetConnection(context, getUserLoanDetails);
      }
    } else {
      setState(() {
        isLoadData = true;
      });
      LoaderUtils.handleErrorResponse(
          context, response?.getGstBasicDetailsRes().status, response?.getGstBasicDetailsRes().message, null);
    }
  }

  _onErrorGetGstBasicDetails(TGResponse errorResponse) {
    setState(() {
      isLoadData = true;
    });
    TGLog.d("GetGstBasicDetailsResponse : onError()");
  }

  Future<void> getUserLoanDetails() async {
    TGGetRequest tgGetRequest = GetLoanDetailByRefIdReq();
    ServiceManager.getInstance().getAllLoanDetailByRefId(
        request: tgGetRequest,
        onSuccess: (response) => _onSuccessGetAllLoanDetailByRefId(response),
        onError: (error) => _onErrorGetAllLoanDetailByRefId(error));
  }

  _onSuccessGetAllLoanDetailByRefId(GetAllLoanDetailByRefIdResponse? response) async {
    TGLog.d("RegisterResponse : onSuccess()--${response?.getAllLoanDetailObj()}");

    if (response?.getAllLoanDetailObj().status == RES_DETAILS_FOUND) {
      _getAllLoanDetailRes = response?.getAllLoanDetailObj();
      if (_getAllLoanDetailRes?.data?.isNotEmpty == true) {
        if (_getAllLoanDetailRes?.data?[0].currentApplicationStage != STAGE_DISBURSEMENT_STATUS) {
          isOngoingJounery = true;
        }
        pendingLoan =
            _getAllLoanDetailRes?.data?.where((i) => i.currentApplicationStage == STAGE_DISBURSEMENT_STATUS).toList();

        ongoingLoan =
            _getAllLoanDetailRes?.data?.where((i) => i.currentApplicationStage != STAGE_DISBURSEMENT_STATUS).toList();
      } else {
        isOngoingJounery = false;
      }
      setState(() {});
      if (await TGNetUtil.isInternetAvailable()) {
        getRecentTransactionDetail();
      } else {
        showSnackBarForintenetConnection(context, getRecentTransactionDetail);
      }
    } else {
      setState(() {
        isLoadData = true;
      });
      LoaderUtils.handleErrorResponse(
          context, response?.getAllLoanDetailObj().status, response?.getAllLoanDetailObj().message, null);
    }
  }

  _onErrorGetAllLoanDetailByRefId(TGResponse errorResponse) {
    TGLog.d("RegisterResponse : onError()");
    setState(() {
      isLoadData = true;
    });
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
    if (response?.getRecentTransactionResObj().status == RES_DETAILS_FOUND) {
      setState(() {
        if (getrecenttransactionobj?.data?.transactionList?.isNotEmpty == true) {
          translist = getrecenttransactionobj?.data?.transactionList;
          isRecentTransactionEmpty = false;
        } else {
          isRecentTransactionEmpty = true;
        }
        isLoadData = true;
      });
    } else {
      setState(() {
        isLoadData = true;
      });
      LoaderUtils.handleErrorResponse(
          context, response?.getRecentTransactionResObj().status, response?.getRecentTransactionResObj().message, null);
    }
  }

  _onErrorGetRecentTransaction(TGResponse errorResponse) {
    TGLog.d("GetRecentTransactiResponse : onError()");
    setState(() {
      isLoadData = true;
    });
  }

  static Future<bool?> showFirstWaring(BuildContext context) async => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: const Text('Do you want to Exit?'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      SystemNavigator.pop(animated: true);
                    },
                    child: const Text('Exit'),
                  )
                ],
              ),
            ],
            title: Text(
              'Exit',
              style: ThemeHelper.getInstance()!.textTheme.headline1,
            ),
          ));

  static Future<bool?> _showFirstWaring(BuildContext context) async => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text('Do You Want to Exit?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).popUntil((route) => false);
                    SystemNavigator.pop(animated: true);
                  },
                  child: const Text('Exit'),
                )
              ],
            ),
          ],
          title: Text(
            'Exit',
            style: ThemeHelper.getInstance()!.textTheme.displayLarge,
          ),
        ),
      );
}

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key, required this.userName, required this.screenName});

  String userName = '';
  String screenName = '';

  @override
  Widget build(BuildContext context) {
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
                  gradient: LinearGradient(
                      colors: [MyColors.lightRedGradient, MyColors.lightBlueGradient],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppUtils.path(DASHBOARDGSTPROFILEWOHOUTGST),
                    height: 35.h,
                    width: 35.w,
                  ),
                  SizedBox(width: 15.w),
                  Text(userName,
                      style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(color: MyColors.white)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.w, top: 5.h, bottom: 5.h),
                      child: Icon(
                        Icons.close,
                        color: MyColors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            leading: SvgPicture.asset(
              AppUtils.path(IMG_HOME_MENU),
              height: 21.h,
              width: 24.w,
            ),
            title: Text(
              'Home',
              style: ThemeHelper.getInstance()?.textTheme.headline3,
            ),
            onTap: () {
              if (screenName == "Dashbaord") {
                Scaffold.of(context).closeDrawer();
              } else {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) => const DashboardWithGST()));
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: SvgPicture.asset(
              AppUtils.path(IMG_LINE_MENU),
              height: 21.h,
              width: 24.w,
            ),
            title: Text('Transactions', style: ThemeHelper.getInstance()?.textTheme.headline3),
            onTap: () {
              if (screenName == "Transactions") {
                Scaffold.of(context).closeDrawer();
              } else {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) => const TransactionsView()));
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: SvgPicture.asset(
              AppUtils.path(IMG_USER_MENU),
              height: 21.h,
              width: 24.w,
            ),
            title: Text('Profile', style: ThemeHelper.getInstance()?.textTheme.headline3),
            onTap: () {
              if (screenName == "Profile") {
                Scaffold.of(context).closeDrawer();
              } else {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) => const NewProfileView()));
              }
            },
          ),
          const Divider(),
          const BackToHome(),
          const Divider(),
          // ListTile(
          //   leading: SvgPicture.asset(
          //     AppUtils.path(IMG_RAISE_DISPITE_MENU),
          //     height: 21.h,
          //     width: 24.w,
          //   ),
          //   title: Text('Raise Dispute', style: ThemeHelper.getInstance()?.textTheme.headline3),
          //   onTap: () {
          //     // Update the state of the app.
          //     // ...
          //   },
          // ),
          // const Divider(),
        ],
      ),
    );
  }
}
