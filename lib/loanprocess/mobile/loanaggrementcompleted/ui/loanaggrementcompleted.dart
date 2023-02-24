








import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sbi_sahay_1_0/routes.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/strings/strings.dart';
import '../model/loanaggcompeletedvm.dart';


class LoanAggCompeleted extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      return  SafeArea(child:  WillPopScope(
          onWillPop: () async {
        return true;
      },
      child: LoanAggCompeleteds()));
    });
  }

}


class LoanAggCompeleteds extends StatefulWidget {


  @override
  LoanAggCompeletedBody createState() => new LoanAggCompeletedBody();
}

class LoanAggCompeletedBody extends State<LoanAggCompeleteds> {


  @override
  Widget build(BuildContext context) {
    return setupView(context);;
  }


  Widget setupView(BuildContext context) {
    //appbar_check_icon.svg
    return Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w), child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        SvgPicture.asset(
          Utils.path(MOBILESTEPDONE), height: 78.h, width: 78.w,
          //
        ),
        SizedBox(height: 28.h),
        Text(str_lonaAgg_titel, style: ThemeHelper
            .getInstance()!
            .textTheme
            .headline1, textAlign: TextAlign.center),
        SizedBox(height: 10.h),
        Center(child: Text(str_lonaAgg_disc, style: ThemeHelper
            .getInstance()!
            .textTheme
            .headline3, textAlign: TextAlign.center,)),
        SizedBox(height: 50.h),
        BTNStartStartRegistration(context)

      ],));
  }


  Widget BTNStartStartRegistration(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      shadowColor: Colors.transparent,
      foregroundColor: Color(0xFF280470),
      backgroundColor: ThemeHelper
          .getInstance()
          ?.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6.r)),
      ),
    );

    return ElevatedButton(
      style: raisedButtonStyle,
      onPressed: () {
        Navigator.pushNamed(
            context, MyRoutes.proceedToDisbursedRoutes);
      },
      child: Text(str_Proceed,
          style: ThemeHelper
              .getInstance()!
              .textTheme
              .button),
    );
  }


}