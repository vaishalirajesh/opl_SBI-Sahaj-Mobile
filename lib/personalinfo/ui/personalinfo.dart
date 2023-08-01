import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/widgets/app_drawer.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';
import '../../utils/helpers/myfonts.dart';
import '../../utils/strings/strings.dart';

class PersonalInfoDetails extends StatelessWidget {
  const PersonalInfoDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(
          child: ProfileData(),
        );
      },
    );
  }
}

class ProfileData extends StatefulWidget {
  ProfileData({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProfileDataState();
}

class ProfileDataState extends State<ProfileData> {
  String businessName = '';
  String gstinNumber = '';
  String mobileNumber = '';
  bool hideMobile = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void setPersonalDetails() async {
    String name = await TGSharedPreferences.getInstance().get(PREF_USERNAME) ?? '';
    String gstin = await TGSharedPreferences.getInstance().get(PREF_GSTIN) ?? '';
    String mobile = await TGSharedPreferences.getInstance().get(PREF_MOBILE) ?? '';

    setState(() {
      businessName = name;
      gstinNumber = gstin;
      mobileNumber = mobile;
    });
  }

  @override
  void initState() {
    super.initState();
    setPersonalDetails();
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
        drawer: const AppDrawer(),
        appBar: getAppBarMainDashboardWithBackButton(
          "2",
          str_loan_approve_process,
          0.25,
          onClickAction: () => {
            if (_scaffoldKey.currentState!.isDrawerOpen)
              {_scaffoldKey.currentState!.closeDrawer()}
            else
              {Navigator.pop(context)}
          },
          onMenuClick: () => {_scaffoldKey.currentState?.openDrawer()},
        ),
        body: Container(
          //color: ThemeHelper.getInstance()!.primaryColor,
          child: setUpView(context),
        ),
      ),
    );
  }

  Widget setUpView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 50.h,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(0.r), bottomLeft: Radius.circular(0.r)),
                border: Border.all(width: 1, color: ThemeHelper.getInstance()!.primaryColor),
                gradient: LinearGradient(
                    colors: [MyColors.lightRedGradient, MyColors.lightBlueGradient],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20.w, top: 15.h),
                child: Text(
                  "Personal Information",
                  style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(color: MyColors.white),
                ),
              )),
          buildStackImage(PROFILE_IMG),
          SetBodyContainer(context)
        ],
      ),
    );
  }

  Widget buildStackImage(String path) => Stack(
        children: [
          Container(
              height: 70.h,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(0.r), bottomLeft: Radius.circular(0.r)),
                color: MyColors.pnbPinkColor,
              )),
          Center(
            child: Padding(
              padding: EdgeInsets.all(30.h),
              child: Container(
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SvgPicture.asset(
                      AppUtils.path(PROFILEUSER),
                      height: 78.h,
                      width: 78.w,
                    ),
                  )),
            ),
          ),
          //setEditBtn()
        ],
      );

  Widget setEditBtn() {
    return Positioned(
      bottom: 0,
      right: 10.w,
      child: Container(
        height: 24.h,
        width: 24.w,
        decoration: const BoxDecoration(color: Colors.yellow, shape: BoxShape.circle),
        child: IconButton(
          icon: SvgPicture.asset(AppUtils.path(IMG_PENICL)),
          iconSize: 10,
          onPressed: () {},
        ),
      ),
    );
  }

  Widget SetBodyContainer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: ThemeHelper.getInstance()!.backgroundColor,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildRow("GST Username", businessName),
            buildRow("GSTIN", gstinNumber),
            buildRow("Father’s Name", "-"),
            buildRow("Phone Number", mobileNumber, isShowIcon: true),
            buildRow("Application", "-"),
          ],
        ),
      ),
    );
  }

  buildRow(String title, String value, {bool isShowIcon = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: ThemeHelper.getInstance()?.textTheme.overline?.copyWith(color: MyColors.lightGraySmallText),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              !isShowIcon
                  ? value
                  : hideMobile
                      ? "**********"
                      : value,
              style: ThemeHelper.getInstance()
                  ?.textTheme
                  .button
                  ?.copyWith(color: MyColors.darkblack, fontFamily: MyFont.Roboto_Regular),
            ),
            if (isShowIcon)
              IconButton(
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
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }

  Widget LoanDetailCardUI(String title, String subText, bool isDivider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subText.isNotEmpty
            ? Text(
                subText,
                style: ThemeHelper.getInstance()?.textTheme.headline4?.copyWith(color: MyColors.PnbGrayTextColor),
              )
            : Container(
                height: 0.h,
              ),
        Padding(
          padding: EdgeInsets.only(top: 5.h, bottom: 10.h),
          child: Row(
            children: [
              Text(
                title,
                style: ThemeHelper.getInstance()
                    ?.textTheme
                    .headline5
                    ?.copyWith(color: MyColors.pnbPersonalDataColor, fontFamily: MyFont.Nunito_Sans_Semi_bold),
              ),
              Spacer(),
              SvgPicture.asset(
                AppUtils.path(RIGHTARROWIC), height: 17.h, width: 17.w,
                //
              ),
            ],
          ),
        ),
        isDivider
            ? Divider(
                thickness: 1,
                color: MyColors.PnbGrayTextColor,
              )
            : Container(
                height: 0.h,
              )
      ],
    );
  }
}
