import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/profile/ui/privacypolicy.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';

import '../../../../personalinfo/ui/personalinfo.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/constants/prefrenceconstants.dart';
import '../../../../utils/strings/strings.dart';
import 'contactsupport/ui/contactsupportscreen.dart';
import 'faq/ui/faq.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ProfileViewScreen();
    });
  }
}

class ProfileViewScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfileViewScreenState();
}

class ProfileViewScreenState extends State<ProfileViewScreen> {
  String? businessName;
  String? gstinNumber;
  String? panNumber;

  void setPersonalDetails() async {
    String? name = await TGSharedPreferences.getInstance().get(PREF_USERNAME);
    String? gstin = await TGSharedPreferences.getInstance().get(PREF_GSTIN);
    String? pan = await TGSharedPreferences.getInstance().get(PREF_PANNO);

    setState(() {
      businessName = name;
      gstinNumber = gstin;
      panNumber = pan;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPersonalDetails();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ProfileScreen(context);
    });
  }

  Widget ProfileScreen(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: ThemeHelper.getInstance()?.colorScheme.primary,
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.0.w, right: 20.w, top: 30.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      str_Profile,
                      style: ThemeHelper.getInstance()!
                          .textTheme
                          .headline1!
                          .copyWith(fontSize: 25.sp, color: MyColors.white),
                    ),

                    //Remove notification Icon suggested by QA Team
                    /*SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: SvgPicture.asset(
                            Utils.path(MOBILEDASHWIHTOUTNOTIBELL),
                            //
                          ),
                        )*/
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 130.0.h),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: 375.w,
                  decoration: BoxDecoration(
                      color: MyColors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(26.r),
                          topRight: Radius.circular(26.r))),
                  child: _buildProfileList(context),
                ),
              ),
              Positioned(
                  top: 80.h,
                  left: 20.w,
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.white),
                      width: 101.w,
                      height: 101.w,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CircleAvatar(
                          backgroundColor: MyColors.white,
                          backgroundImage: AssetImage(Utils.path(PROFILE_IMG)),
                        ),
                      )))
            ],
          )),
    );
  }

  _buildProfileList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 45.h,
        ),
        _buildProfileHeaderValue(),
        SizedBox(
          width: 400.w,
          child: Column(
            children: [
              SizedBox(
                height: 25.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                child: Divider(
                  height: 2.h,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              GestureDetector(
                child: _buildProfileListRow(PROFILE, str_personal_inform, true),
                onTap: () {
                  //   Navigator.of(context).push(CustomRightToLeftPageRoute(child: PersonalInfoDetails(), ));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonalInfoDetails(),
                      ));

                  // Navigator.pushNamed(
                  //     context, MyRoutes.PersonalInfoDetailsRoutes);
                },
              ),

              //Remove Notification. 10/2/23 Aarti
              /*SizedBox(
                height: 15.h,
              ),
              GestureDetector(
                child: _buildProfileListRow(
                    NOTIFICATION, str_Notification_preferences, true),
                onTap: () {
                  //    Navigator.pushNamed(context, MyRoutes.NotiPrefrencesRoutes);
                  //   Navigator.of(context).push(CustomRightToLeftPageRoute(child: NotiPrefrences(), ));
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NotiPrefrences(),)
                  );
                },
              ),*/
              SizedBox(
                height: 15.h,
              ),
              GestureDetector(
                child:
                    _buildProfileListRow(PRIVACY, str_Privacy_security, true),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrivacyPolicy(),
                      ));
                },
              ),
              SizedBox(
                height: 15.h,
              ),
              GestureDetector(
                child: _buildProfileListRow(ABOUT, str_About, true),
                onTap: (){
                  TGView.showSnackBar(context: context, message: "Coming Soon...");
                },
              ),
              SizedBox(
                height: 15.h,
              ),
              GestureDetector(
                child: _buildProfileListRow(FAQ, str_FAQs, true),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FAQMain(),
                      ));

                },
              ),
              SizedBox(
                height: 15.h,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactSupportMain(),
                      ));
                },
                child: _buildProfileListRow(CONTACT, str_Contact_Support, true),
              ),
              SizedBox(
                height: 15.h,
              ),
              /*_buildProfileListRow(MOBILELOGOUT, str_Log_out, false),
              SizedBox(
                height: 100.h,
              )*/
            ],
          ),
        ),
      ],
    );
  }

  _buildProfileHeaderValue() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0.w, right: 20.w, top: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            businessName ?? "",
            style: ThemeHelper.getInstance()!
                .textTheme
                .headline1!
                .copyWith(fontSize: 18.sp),
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            panNumber ?? "",
            style: ThemeHelper.getInstance()!
                .textTheme
                .headline2!
                .copyWith(fontSize: 12.sp, color: MyColors.pnbLogoColor),
          )
        ],
      ),
    );
  }

  _buildProfileListRow(String leadingImg, String title, bool flag) {
    return SizedBox(
      height: 39.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 15.h,
                  width: 20.w,
                  child: SvgPicture.asset(
                    Utils.path(leadingImg),
                    //
                  ),
                ),
                SizedBox(
                  width: 19.w,
                ),
                Text(
                  title,
                  style: ThemeHelper.getInstance()!
                      .textTheme
                      .headline2!
                      .copyWith(
                          fontSize: 16.sp,
                          color: flag
                              ? MyColors.pnbGreyColor
                              : MyColors.pnbOrganColor),
                )
              ],
            ),
            SizedBox(
                height: 15.h,
                width: 20.w,
                child: SvgPicture.asset(
                  Utils.path(RIGHTARROWIC),
                  //
                ))
          ],
        ),
      ),
    );
  }
}
