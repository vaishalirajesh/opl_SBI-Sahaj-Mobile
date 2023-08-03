import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/singleton/tg_session.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/profile/ui/newprofile.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/transactions/ui/transactionscreen.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/imageconstant.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';

import 'back_to_home_widget.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String userName = '';

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  void getUserData() async {
    userName = await TGSharedPreferences.getInstance().get(PREF_BUSINESSNAME) ?? '';
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      key: _scaffoldKey,
      child: ListView(
        // Important: Remove any padding from the ListView.
        children: [
          SizedBox(
            height: 100.h,
            child: Align(
              alignment: Alignment.center,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  //  color: Colors.blue,
                  gradient: LinearGradient(
                      colors: [MyColors.lightRedGradient, MyColors.lightBlueGradient],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Image(
                      //   height: 44.h,
                      //   width: 44.w,
                      //   image: AssetImage(AppUtils.path(DASHBOARDGSTPROFILEWOHOUTGST)),
                      // ),
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
              Navigator.of(context).pop();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) => const DashboardWithGST()));
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
              TGSession.getInstance().set("TabIndex", 0);
              Navigator.of(context).pop();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) => const TransactionsMain()));
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
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const NewProfileView()));
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
