import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/widgets/app_drawer.dart';

import '../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';
import '../../utils/helpers/myfonts.dart';
import '../../utils/strings/strings.dart';
import '../model/notiprefrencevm.dart';

class NotiPrefrences extends StatelessWidget {
  final NotiPrefrenceVM viewModel = NotiPrefrenceVM();

  NotiPrefrences({super.key});

  @override
  Widget build(BuildContext context) {
    viewModel.setContxt(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return const NotiPrefrencesScreen();
      },
    );
  }
}

class NotiPrefrencesScreen extends StatefulWidget {
  const NotiPrefrencesScreen({Key? key}) : super(key: key);

  @override
  State<NotiPrefrencesScreen> createState() => _NotiPrefrencesScreenState();
}

class _NotiPrefrencesScreenState extends State<NotiPrefrencesScreen> {
  bool notifcationBool = true;
  bool soundBool = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
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
          body: setUpView(),
        ),
      ),
    );
  }

  Widget setUpView() {
    return Container(
      color: ThemeHelper.getInstance()!.colorScheme.background,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 50.h,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(0.r), bottomLeft: Radius.circular(0.r)),
                    border: Border.all(width: 1, color: ThemeHelper.getInstance()!.primaryColor),
                    //color: ThemeHelper.getInstance()!.primaryColor,

                    gradient: LinearGradient(
                        colors: [MyColors.lightRedGradient, MyColors.lightBlueGradient],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight)),
                child: Padding(
                  padding: EdgeInsets.only(left: 20.w, top: 15.h),
                  child: Text("Notification Preferences",
                      style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(color: MyColors.white)),
                )),
            buildPushNotificationText(strPushnotifications),
            buildLongSentencePushNotification(strLongSenterPushNotification),
            Padding(padding: EdgeInsets.only(left: 20.w, right: 20.w), child: Divider()),
            buildBodyContainer()
          ],
        ),
      ),
    );
  }

  Widget buildPushNotificationText(String text) => Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 30.h, bottom: 8.h),
        child: Text(text, style: ThemeHelper.getInstance()?.textTheme.headline1?.copyWith(color: MyColors.darkblack)),
      );

  Widget buildLongSentencePushNotification(String text) => Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 30.h),
      child: Text(strLongSenterPushNotification, style: ThemeHelper.getInstance()?.textTheme.headline3));

  Widget buildBodyContainer() {
    return Container(
      height: 500.h,
      decoration: BoxDecoration(
        color: ThemeHelper.getInstance()!.backgroundColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40.r),
          topLeft: Radius.circular(40.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildWellNotifyYoyWhenText(strWellnotifyyouwhenyou),
            buildLoanDetailCardUI(strPushNotification, strGSTUserName, notifcationBool, true,
                (bool value) => setSwitchNotifcationState(notifcationBool, value)),
            buildLoanDetailCardUI(
                strPlayasound, strGSTIN, soundBool, true, (bool value) => setSwitchSoundState(soundBool, value)),
          ],
        ),
      ),
    );
  }

  Widget buildWellNotifyYoyWhenText(String text) => Padding(
        padding: EdgeInsets.only(top: 30.h, bottom: 20.h),
        child: Text(strWellnotifyyouwhenyou,
            style: ThemeHelper.getInstance()?.textTheme.headline6!.copyWith(color: MyColors.pnbGreyColor)),
      );

  void setSwitchNotifcationState(bool mainbool, bool switchBool) {
    setState(
      () {
        notifcationBool = switchBool;
      },
    );
  }

  void setSwitchSoundState(bool mainbool, bool switchBool) {
    setState(
      () {
        soundBool = switchBool;
      },
    );
  }

  Widget buildLoanDetailCardUI(
      String title, String subText, bool stateBool, bool isDivider, void Function(bool value) interstate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Row(
            children: [
              Text(
                title,
                style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(
                    color: ThemeHelper.getInstance()?.indicatorColor, fontFamily: MyFont.Nunito_Sans_Semi_bold),
              ),
              const Spacer(),
              Switch(
                  activeColor: ThemeHelper.getInstance()!.primaryColor,
                  value: stateBool,
                  onChanged: (bool val) {
                    interstate(val);
                  })
            ],
          ),
        ),
        // isDivider
        //     ? Divider(
        //         thickness: 0,
        //         color: MyColors.PnbGrayTextColor,
        //       )
        //     : Container(
        //         height: 0.h,
        //       )
      ],
    );
  }
}
