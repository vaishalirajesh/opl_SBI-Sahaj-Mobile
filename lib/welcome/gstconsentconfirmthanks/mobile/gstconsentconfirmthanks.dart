import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';
import '../../../registration/mobile/login/login.dart';
import '../../../routes.dart';
import '../../../utils/Utils.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/strings/strings.dart';
import '../../../widgets/animation_routes/page_animation.dart';

class GstConsentConform extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(child: GstConsentConformScreen());
      },
    );
  }
}

class GstConsentConformScreen extends StatefulWidget {
  @override
  GstConsentConformState createState() => GstConsentConformState();
}

class GstConsentConformState extends State<GstConsentConformScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        SystemNavigator.pop(animated: true);
        return true;
      },
      child: Scaffold(
          appBar: getAppBarWithBackBtn(onClickAction: () => {
          Navigator.pop(context, false),
          SystemNavigator.pop(animated: true)

          }),
      body: Stack(
        children: [
          Container(
              // color: ThemeHelper.getInstance()!.backgroundColor,
              child: bodyColumn()),
          Align(alignment: Alignment.bottomCenter, child: startRegButton())
        ],
      ),



    //  Container(child: bodyColumn()),
    ),);
  }

  Widget bodyColumn() {
    //appbar_check_icon.svg
    return Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Utils.path(MOBILESTEPDONE), height: 78.h, width: 78.w,
              //
            ),
            SizedBox(height: 30.h),
            Text(
              str_Thanks_for_confirming,
              style: ThemeHelper
                  .getInstance()!
                  .textTheme
                  .headline2,
            ),
            SizedBox(height: 20.h),
            Center(
                child: Text(
                  str_gst_confirm_disc,
                  style: ThemeHelper
                      .getInstance()!
                      .textTheme
                      .headline3?.copyWith(fontSize: 14.sp),
                  textAlign: TextAlign.center,
                )),
            SizedBox(height: 50.h),
            // startRegButton()
          ],
        ));
  }

  Widget startRegButton() {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      shadowColor: Colors.transparent,
      foregroundColor: Color(0xFF280470),
      backgroundColor: ThemeHelper
          .getInstance()
          ?.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6.r)),),
    );

    return ElevatedButton(
      style: raisedButtonStyle,
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginWithMobileNumber(),),
              (
              route) => false, //if you want to disable back feature set to false
        );

        //   Navigator.pushNamed(context,MyRoutes.loginRoutes);
      },
      child: Text(str_Start_Registration,
          style: ThemeHelper
              .getInstance()!
              .textTheme
              .button),
    );
  }
}
