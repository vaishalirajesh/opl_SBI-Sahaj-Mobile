
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';
import 'package:uuid/uuid.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/helpers/themhelper.dart';
import '../../../../utils/strings/strings.dart';
import '../../../../widgets/animation_routes/page_animation.dart';
import '../../refreshgstinvoice/refreshgstusername.dart';
import 'gstinvoicelist.dart';


class GSTInvoiceListRefresh extends StatelessWidget {

  const GSTInvoiceListRefresh({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return  WillPopScope(
            onWillPop: () async {
          return true;
        },
        child: Scaffold(
            //resizeToAvoidBottomInset: false,
            appBar: getAppBarWithStep("2", str_loan_approve_process, 0.50,onClickAction: ()=>{
              Navigator.pop(context)
            })
            ,body: GSTInvoiceListRefreshScreen()));
      },
    );
  }
}

class GSTInvoiceListRefreshScreen extends StatefulWidget {
  const GSTInvoiceListRefreshScreen({super.key});

  @override
  GSTInvoiceListRefreshScreenState createState() => GSTInvoiceListRefreshScreenState();
}

class GSTInvoiceListRefreshScreenState extends State<GSTInvoiceListRefreshScreen> {

  @override
  Widget build(BuildContext context) {
    return refreshGstBottomSheetDialog();
  }
  Widget refreshGstBottomSheetDialog() {
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                child: Container(
                    height: 338.h,
                    width: 335.w,
                    decoration: BoxDecoration(
                      color: ThemeHelper.getInstance()!.cardColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 40.h),
                        SvgPicture.asset(Utils.path(REFRESHGST),
                            height: 160.h, width: 154.w),
                        SizedBox(height: 27.h),
                        Text(
                          str_refresh_gst,
                          style: ThemeHelper.getInstance()!
                              .textTheme
                              .headline1!
                              .copyWith(fontSize: 26),
                          textAlign: TextAlign.center,
                        )
                      ],
                    )),
              ),
              SizedBox(height: 25.h),
              Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
                  child: Row(
                    children: [
                      refreshNowButton(),
                      SizedBox(width: 10.w),
                      refreshLaterButton()
                    ],
                  ))
            ]));
  }

  Widget refreshNowButton() {
    return Container(
      width: 155.w,
      height: 56.h, //38,
      child: ElevatedButton(
          onPressed: () {
         //   Navigator.of(context).push(CustomRightToLeftPageRoute(child: GSTInvoicesList(), ));
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RefreshGstUsername(),)
            );
          },
          child: Text(
            str_refresh_now,
            style: ThemeHelper.getInstance()!.textTheme.button,
          ),
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent,
            foregroundColor: ThemeHelper.getInstance()!.primaryColor,
            backgroundColor: ThemeHelper.getInstance()!.primaryColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6))),
          )),
    );
  }

  Widget refreshLaterButton() {
    return Container(
      width: 155.w,
      height: 56.h, //38,
      child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            str_refresh_later,
            style: ThemeHelper.getInstance()!.textTheme.bodyText1,
          ),
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent,
            foregroundColor: ThemeHelper.getInstance()!.backgroundColor,
            backgroundColor: ThemeHelper.getInstance()!.backgroundColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6))),
          )),
    );
  }


}

