import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/profile/ui/contactsupport/contactlendersupport/ui/contact_support_sub.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/constants/imageconstant.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/widgets/app_drawer.dart';

import '../../../../../../utils/colorutils/mycolors.dart';
import '../../../../../../utils/strings/strings.dart';
import '../../../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';

class ContactSupportMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SafeArea(child: ContactSupportMains());
    });
  }
}

class ContactSupportMains extends StatefulWidget {
  @override
  ContactSupportMainBody createState() => new ContactSupportMainBody();
}

class ContactSupportMainBody extends State<ContactSupportMains> {
  bool isOpenDetails = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ContactSupportScreen(context);
  }

  Widget ContactSupportScreen(BuildContext context) {
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
          color: MyColors.pnbPinkColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    "Contact Support",
                    style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(color: MyColors.white),
                  ),
                ),
              ),
              SizedBox(height: 25.h),
              isOpenDetails ? _buildOnlySupportTeamContainer() : _buildBottomViewSupportTeam(),
              // SizedBox(height: 14.h),
              // _buildOnlyContactLenderContainer()
            ],
          ),
        ),
      ),
    );
  }

  _buildOnlySupportTeamContainer() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isOpenDetails = false;
        });
      },
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
          child: Container(
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 3.0,
                  )
                ],
                border: Border.all(color: ThemeHelper.getInstance()!.cardColor, width: 1),
                color: ThemeHelper.getInstance()?.backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(8.r))),
            // width: 335.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  _buildTopDetilss(),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          )),
    );
  }

  _buildTopDetilss() {
    return Padding(
      padding: EdgeInsets.all(5.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              child: Text(
            "Contact Lender Support Team",
            style: ThemeHelper.getInstance()!.textTheme.headline2?.copyWith(fontSize: 14.sp, color: MyColors.black),
          )),
          Spacer(),
          SvgPicture.asset(
            !isOpenDetails ? AppUtils.path(IMG_UP_ARROW) : AppUtils.path(IMG_DOWN_ARROW),
            height: 20.h,
            width: 20.w,
          ),
        ],
      ),
    );
  }

  _buildBottomViewSupportTeam() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isOpenDetails = true;
        });
      },
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
          child: Container(
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 3.0,
                  )
                ],
                border: Border.all(color: ThemeHelper.getInstance()!.cardColor, width: 1),
                color: ThemeHelper.getInstance()?.backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(8.r))),
            // width: 335.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  _buildTopDetilss(),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppUtils.path(PROFILEMAIL),
                        height: 24.h,
                        width: 24.w,
                      ),
                      SizedBox(width: 12.w),
                      SizedBox(
                          child: Text(
                        "customercare@sbi.co.in",
                        style: ThemeHelper.getInstance()!.textTheme.headline3?.copyWith(fontSize: 14.sp),
                      )),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppUtils.path(PROFILEMOBILE),
                        height: 24.h,
                        width: 24.w,
                      ),
                      SizedBox(width: 12.w),
                      SizedBox(
                          child: Text(
                        "1800 1234",
                        style: ThemeHelper.getInstance()!.textTheme.headline3?.copyWith(fontSize: 14.sp),
                      )),
                    ],
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          )),
    );
    ;
  }

  _buildOnlyContactLenderContainer() {
    return GestureDetector(
      onTap: () {},
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
          child: Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 3.0,
                  )
                ],
                border: Border.all(color: ThemeHelper.getInstance()!.cardColor, width: 1),
                color: ThemeHelper.getInstance()?.backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(8.r))),
            // width: 335.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  _buildTopDetilssContactLender(),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          )),
    );
  }

  _buildTopDetilssContactLender() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContactSupportSubScreen(),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(5.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                child: Text(
              "Contact Lender Support Team",
              style: ThemeHelper.getInstance()!.textTheme.headline2?.copyWith(fontSize: 14.sp, color: MyColors.black),
            )),
            Spacer(),
            SvgPicture.asset(
              AppUtils.path(MOBILETDASHBOARDARROWFORWARD),
              height: 12.h,
              width: 6.w,
            )
          ],
        ),
      ),
    );
  }
}
