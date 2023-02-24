import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/constants/imageconstant.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';

import '../../../../../../utils/colorutils/mycolors.dart';
import '../../../../../../utils/strings/strings.dart';
import '../../../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';

class ContactSupportMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SafeArea(
          child: WillPopScope(
              onWillPop: () async {
                Navigator.pop(context);
                return true;
              },
              child: ContactSupportMains()));
    });
  }
}

class ContactSupportMains extends StatefulWidget {
  @override
  ContactSupportMainBody createState() => new ContactSupportMainBody();
}

class ContactSupportMainBody extends State<ContactSupportMains> {
  @override
  Widget build(BuildContext context) {
    return ContactSupportScreen(context);
    ;
  }

  Widget ContactSupportScreen(BuildContext context) {
    return Scaffold(
      appBar: getAppBarWithTitle(str_contact_support,
          onClickAction: () => {Navigator.pop(context)}),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              str_contact_sahay_support,
              style: ThemeHelper.getInstance()?.textTheme.bodyText1,
            ),
            SizedBox(
              height: 20.h,
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.email_sharp,
                    color: MyColors.pnbTextcolor,
                    size: 20.h,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    'care@pnb.co.in',
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline5
                        ?.copyWith(color: MyColors.pnbTextcolor),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.phone_in_talk_sharp,
                    color: MyColors.pnbTextcolor,
                    size: 20.h,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    '0120-2490000',
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline5
                        ?.copyWith(color: MyColors.pnbTextcolor),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Divider(
                thickness: 1, color: ThemeHelper.getInstance()?.disabledColor),
            SizedBox(
              height: 10.h,
            ),
            /* GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context, MyRoutes.LenderContactSupportRoutes);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(str_contact_lender_support, style: ThemeHelper
                      .getInstance()
                      ?.textTheme
                      .bodyText1,),
                  SvgPicture.asset(Utils.path(LOANCARDRIGHTARROW))
                ],
              ),
            ),
            SizedBox(height: 10.h,),
            Divider(thickness: 1, color: ThemeHelper
                .getInstance()
                ?.disabledColor),
            SizedBox(height: 20.h,),*/
            Text(
              str_raise_grievance,
              style: ThemeHelper.getInstance()?.textTheme.bodyText1,
            ),
            SizedBox(
              height: 20.h,
            ),
            GestureDetector(
              onTap: () {
                TGView.showSnackBar(
                    context: context, message: "Coming Soon...");
                /*Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RaiseDisputeMain(),)
                );*/
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(Utils.path(MOBILERAISEDISPUTE)),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    str_raise_dispute,
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline5
                        ?.copyWith(color: MyColors.pnbTextcolor),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            GestureDetector(
              onTap: () {
                TGView.showSnackBar(
                    context: context, message: "Coming Soon...");
                /* Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TrackDisputeMain(),)
                );*/
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(Utils.path(MOBILETRACKDISPUTE)),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    str_dispute_tracker,
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline5
                        ?.copyWith(color: MyColors.pnbTextcolor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
