import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
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
        return   WillPopScope(
            onWillPop: () async {
          return true;
        },
        child: NotiPrefrencesScreen());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBarWithTitle("",onClickAction: () =>{
        Navigator.pop(context)
      }),
      body: setUpView(),
    );
  }

  Widget setUpView() {
    return Container(
      color: ThemeHelper.getInstance()!.colorScheme.onSecondary,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildPushNotificationText(strPushnotifications),
            buildLongSentencePushNotification(strLongSenterPushNotification),
            buildBodyContainer()
          ],
        ),
      ),
    );
  }

  Widget buildPushNotificationText(String text) => Padding(
        padding:
            EdgeInsets.only(left: 20.w, right: 20.w, top: 43.h, bottom: 8.h),
        child:
            Text(text, style: ThemeHelper.getInstance()?.textTheme.headline1),
      );

  Widget buildLongSentencePushNotification(String text) => Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 30.h),
      child: Text(strLongSenterPushNotification,
          style: ThemeHelper.getInstance()?.textTheme.headline3));

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
            buildLoanDetailCardUI(
                strPushNotification,
                strGSTUserName,
                notifcationBool,
                true,
                (bool value) =>
                    setSwitchNotifcationState(notifcationBool, value)),
            buildLoanDetailCardUI(strPlayasound, strGSTIN, soundBool, true,
                (bool value) => setSwitchSoundState(soundBool, value)),
          ],
        ),
      ),
    );
  }

  Widget buildWellNotifyYoyWhenText(String text) => Padding(
        padding: EdgeInsets.only(top: 30.h, bottom: 20.h),
        child: Text(strWellnotifyyouwhenyou,
            style: ThemeHelper.getInstance()
                ?.textTheme
                .headline6!
                .copyWith(color: MyColors.pnbGreyColor)),
      );

  void setSwitchNotifcationState(bool mainbool, bool switchBool) {
    setState(() {
      notifcationBool = switchBool;
    },);
  }

  void setSwitchSoundState(bool mainbool, bool switchBool) {
    setState(() {
      soundBool = switchBool;
    },);
  }

  Widget buildLoanDetailCardUI(String title, String subText, bool stateBool,
      bool isDivider, void Function(bool value) interstate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.only(bottom: 10.h),
          child: Row(
            children: [
              Text(
                title,
                style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(
                    color: ThemeHelper.getInstance()?.indicatorColor,
                    fontFamily: MyFont.Nunito_Sans_Semi_bold),
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
