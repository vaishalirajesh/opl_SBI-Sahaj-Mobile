import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/model/models/get_gst_basic_details_res_main.dart';
import 'package:gstmobileservices/model/models/get_loandetail_by_refid_res_main.dart';
import 'package:gstmobileservices/model/models/get_recent_transaction_res_main.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/profile/ui/about.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/profile/ui/privacypolicy.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/helpers/myfonts.dart';

import '../../../../notificationprefrence/ui/notificationprefrence.dart';
import '../../../../personalinfo/ui/personalinfo.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/constants/prefrenceconstants.dart';
import '../../../../utils/helpers/themhelper.dart';
import '../../../../utils/strings/strings.dart';
import '../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';
import '../../dashboardwithgst/mobile/dashboardwithgst.dart';
import 'contactsupport/ui/contactsupportscreen.dart';
import 'faq/ui/faq.dart';

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

class _NewProfileViewBodyState extends State<NewProfileViewBody> with SingleTickerProviderStateMixin {
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

  @override
  void initState() {
    setUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_scaffoldKey.currentState!.isDrawerOpen) {
          _scaffoldKey.currentState!.closeDrawer();
          return false;
        } else {
          Navigator.pop(context);
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MyDrawer(
          userName: name,
          screenName: "Profile",
        ),
        appBar: getAppBarMainDashboard("2", str_loan_approve_process, 0.50,
            onClickAction: () => {_scaffoldKey.currentState?.openDrawer()}),
        body: MainContainerView(),
        //bottomNavigationBar: buildTabBar()
      ),
    );
  }

  bool activeChecker(int currentIndex) => tabIndex == currentIndex ? true : false;

  Widget MainContainerView() {
    return Container(
      // alignment: Alignment.center,
      decoration: BoxDecoration(
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
      ),
    );
  }

  _buildTopContent() {
    return Container(
      alignment: Alignment.center,
      height: 127.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8.r),
        ),
        color: ThemeHelper.getInstance()!.backgroundColor,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: SvgPicture.asset(
                    AppUtils.path(DASHBOARDGSTPROFILEWOHOUTGST),
                    height: 35.h,
                    width: 35.w,
                    color: MyColors.lightRedGradient,
                  ),
                ),
                SizedBox(width: 15.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Text("Hello, $name!",
                        style: ThemeHelper.getInstance()?.textTheme.button?.copyWith(color: MyColors.lightBlackText)),
                    SizedBox(height: 5.h),
                    Text("PAN: $pan",
                        style: ThemeHelper.getInstance()!
                            .textTheme
                            .subtitle1!
                            .copyWith(color: MyColors.lightGraySmallText)),
                  ],
                ),
                /*const Spacer(),
                SvgPicture.asset(
                  Utils.path(MOBILEDASHWIHTOUTNOTIBELL),
                )*/
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            const Divider(),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Row(
                  children: [
                    Text(
                      "GSTIN: ",
                      style: ThemeHelper.getInstance()!.textTheme.overline,
                    ),
                    Text(
                      gstin,
                      style: ThemeHelper.getInstance()
                          ?.textTheme
                          .overline
                          ?.copyWith(fontFamily: MyFont.Roboto_Regular, color: MyColors.lightBlackText),
                    )
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      "State: ",
                      style: ThemeHelper.getInstance()!.textTheme.overline,
                    ),
                    Text(
                      state,
                      style: ThemeHelper.getInstance()
                          ?.textTheme
                          .overline
                          ?.copyWith(fontFamily: MyFont.Roboto_Regular, color: MyColors.lightBlackText),
                    )
                  ],
                ),
              ],
            )
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
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _buildCard(
              0,
              "Personal Information",
              PROFILEUSER,
              _basicdetailsResponse?.data?[0].loanDetails?.outstanding?.count ?? "",
              AppUtils.convertIndianCurrency(_basicdetailsResponse?.data?[0].loanDetails?.outstanding?.amount)),
          _buildCard(
              1,
              "Notification Preferences",
              PROFILEBELL,
              _basicdetailsResponse?.data?[0].loanDetails?.overdue?.count ?? "",
              AppUtils.convertIndianCurrency(_basicdetailsResponse?.data?[0].loanDetails?.overdue?.amount)),
        ]),
        Padding(
          padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _buildCard(
                2,
                "Privacy & Security",
                PROFILEPRIVACY,
                _basicdetailsResponse?.data?[0].loanDetails?.repaid?.count ?? "",
                AppUtils.convertIndianCurrency(_basicdetailsResponse?.data?[0].loanDetails?.repaid?.amount)),
            _buildCard(3, "About", PROFILEABOUT, _basicdetailsResponse?.data?[0].loanDetails?.disbursed?.count ?? "",
                AppUtils.convertIndianCurrency(_basicdetailsResponse?.data?[0].loanDetails?.disbursed?.amount))
          ]),
        ),
        Padding(
          padding: EdgeInsets.only(top: 0.h, bottom: 0.h),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _buildCard(
                4,
                "Contact Support",
                PROFILECONTACT,
                _basicdetailsResponse?.data?[0].loanDetails?.repaid?.count ?? "",
                AppUtils.convertIndianCurrency(_basicdetailsResponse?.data?[0].loanDetails?.repaid?.amount)),
            _buildCard(5, "FAQs", PROFILEFAQ, _basicdetailsResponse?.data?[0].loanDetails?.disbursed?.count ?? "",
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
        if (index == 0) {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const PersonalInfoDetails()));
        } else if (index == 1) {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => NotiPrefrences()));
        } else if (index == 2) {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PrivacyPolicy()));
        } else if (index == 3) {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const AboutPage()));
        } else if (index == 4) {
          //contact support
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ContactSupportMain()));
        } else if (index == 5) {
          //FAQ
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const FAQMain()));
        }

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
        child: Padding(
          padding: EdgeInsets.all(15.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    AppUtils.path(imgString),
                    height: 24.h,
                    width: 24.w,
                  ),
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: ThemeHelper.getInstance()?.textTheme.subtitle1?.copyWith(color: MyColors.lightBlackText),
                      maxLines: 3,
                    ),
                  ),
                  SvgPicture.asset(
                    AppUtils.path(MOBILETDASHBOARDARROWFORWARD),
                    height: 13.h,
                    width: 8.w,
                  )
                ],
              ),
            ],
          ),
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
      type == strDisbursed ? MyColors.pnbGreenColor : MyColors.pnbGreenColor; //MyColors.pnbRedColor;

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
      padding: EdgeInsets.only(left: 20.0.w, right: 20.w, bottom: bottom, top: top),
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
                  Text("19 Aug, 2022", style: ThemeHelper.getInstance()!.textTheme.bodyText2!),
                ],
              ),
            ],
          ),
          Spacer(),
          Column(
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
}
