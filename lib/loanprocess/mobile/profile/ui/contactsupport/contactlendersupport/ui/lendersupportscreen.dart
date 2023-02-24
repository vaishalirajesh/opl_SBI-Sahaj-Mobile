import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../../utils/Utils.dart';
import '../../../../../../../utils/colorutils/mycolors.dart';
import '../../../../../../../utils/constants/imageconstant.dart';
import '../../../../../../../utils/helpers/themhelper.dart';
import '../../../../../../../utils/strings/strings.dart';
import '../../../../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';




class LenderSupportMain extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      return  SafeArea(child:  WillPopScope(
          onWillPop: () async {
        return true;
      },
      child: LenderSupportMains()));
    });
  }

}

class LenderSupportMains extends StatefulWidget {


  @override
  LenderSupportMainBody createState() => new LenderSupportMainBody();
}

class LenderSupportMainBody extends State<LenderSupportMains> {


  @override
  Widget build(BuildContext context) {
    return LenderSupportScreen(context);;
  }


  Widget LenderSupportScreen(BuildContext context) {
    return Scaffold(
      appBar: getAppBarWithTitle(str_contact_support,onClickAction: ()=>{
        Navigator.pop(context)
      }),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SidbiSupportUI(context),
            SizedBox(height: 20.h,),
            AxisSupportUI(context),
            SizedBox(height: 20.h,),
            IciciSupport(context),

          ],
        ),
      ),
    );
  }

  Widget SidbiSupportUI(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(str_sidbi_support, style: ThemeHelper
                .getInstance()
                ?.textTheme
                .bodyText1,),
            SvgPicture.asset(Utils.path(LOANCARDRIGHTARROW))
          ],
        ),
        SizedBox(height: 20.h,),
        GestureDetector(
          onTap: () {

          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.email_sharp, color: MyColors.pnbTextcolor, size: 20.h,),
              SizedBox(width: 10.w,),
              Text('newdelhi@sidbi.in', style: ThemeHelper
                  .getInstance()
                  ?.textTheme
                  .headline5
                  ?.copyWith(color: MyColors.pnbTextcolor),),
            ],
          ),
        ),
        SizedBox(height: 20.h,),
        GestureDetector(
          onTap: () {

          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.phone_in_talk_sharp, color: MyColors.pnbTextcolor,
                size: 20.h,),
              SizedBox(width: 10.w,),
              Text('079-41055000', style: ThemeHelper
                  .getInstance()
                  ?.textTheme
                  .headline5
                  ?.copyWith(color: MyColors.pnbTextcolor),),
            ],
          ),
        ),
        SizedBox(height: 20.h,),
        Divider(thickness: 1, color: ThemeHelper
            .getInstance()
            ?.disabledColor),

      ],
    );
  }

  Widget AxisSupportUI(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(str_axis_support, style: ThemeHelper
                .getInstance()
                ?.textTheme
                .bodyText1,),
            SvgPicture.asset(Utils.path(LOANCARDRIGHTARROW))
          ],
        ),
        SizedBox(height: 20.h,),
        GestureDetector(
          onTap: () {

          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.email_sharp, color: MyColors.pnbTextcolor, size: 20.h,),
              SizedBox(width: 10.w,),
              Text('mumbai@axis.in', style: ThemeHelper
                  .getInstance()
                  ?.textTheme
                  .headline5
                  ?.copyWith(color: MyColors.pnbTextcolor),),
            ],
          ),
        ),
        SizedBox(height: 20.h,),
        GestureDetector(
          onTap: () {

          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.phone_in_talk_sharp, color: MyColors.pnbTextcolor,
                size: 20.h,),
              SizedBox(width: 10.w,),
              Text('079-40155010', style: ThemeHelper
                  .getInstance()
                  ?.textTheme
                  .headline5
                  ?.copyWith(color: MyColors.pnbTextcolor),),
            ],
          ),
        ),
        SizedBox(height: 20.h,),
        Divider(thickness: 1, color: ThemeHelper
            .getInstance()
            ?.disabledColor),

      ],
    );
  }

  Widget IciciSupport(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(str_icici_support, style: ThemeHelper
                .getInstance()
                ?.textTheme
                .bodyText1,),
            SvgPicture.asset(Utils.path(LOANCARDRIGHTARROW))
          ],
        ),
        SizedBox(height: 20.h,),
        GestureDetector(
          onTap: () {

          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.email_sharp, color: MyColors.pnbTextcolor, size: 20.h,),
              SizedBox(width: 10.w,),
              Text('newdelhi@icici.in', style: ThemeHelper
                  .getInstance()
                  ?.textTheme
                  .headline5
                  ?.copyWith(color: MyColors.pnbTextcolor),),
            ],
          ),
        ),
        SizedBox(height: 20.h,),
        GestureDetector(
          onTap: () {

          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.phone_in_talk_sharp, color: MyColors.pnbTextcolor,
                size: 20.h,),
              SizedBox(width: 10.w,),
              Text('079-502019902', style: ThemeHelper
                  .getInstance()
                  ?.textTheme
                  .headline5
                  ?.copyWith(color: MyColors.pnbTextcolor),),
            ],
          ),
        ),
      ],
    );
  }

}
