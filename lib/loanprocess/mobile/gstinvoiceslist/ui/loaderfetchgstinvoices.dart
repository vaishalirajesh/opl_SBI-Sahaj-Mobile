


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/fetch_gst_data_res_main.dart';
import 'package:gstmobileservices/model/models/get_loan_app_status_main.dart';
import 'package:gstmobileservices/model/models/share_gst_invoice_res_main.dart';
import 'package:gstmobileservices/model/requestmodel/fetch_gst_data_status_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_loan_app_status_request.dart';
import 'package:gstmobileservices/model/requestmodel/share_gst_invoice_request.dart';
import 'package:gstmobileservices/model/responsemodel/fetch_gst_data_status_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_loan_app_status_response.dart';
import 'package:gstmobileservices/model/responsemodel/share_gst_invoice_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:lottie/lottie.dart';

import '../../../../routes.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/colorutils/mycolors.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/dimenutils/dimensutils.dart';
import '../../../../utils/helpers/themhelper.dart';
import '../../../../utils/strings/strings.dart';



class LoaderFetchGstInvoices extends StatelessWidget
{
  const LoaderFetchGstInvoices({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      return  SafeArea(child: LoaderFetchGstInvoicesBody());
    });
  }

}

class LoaderFetchGstInvoicesBody extends StatefulWidget {

  @override
  LoaderFetchGstInvoiceState createState() => LoaderFetchGstInvoiceState();
}

class LoaderFetchGstInvoiceState extends State<LoaderFetchGstInvoicesBody> {

  ShareGstInvoiceResMain? _shareGstInvoiceResMain;
  GetLoanStatusResMain? _getLoanStatusResMain;

  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return MobileLoaderWithoutProgess(context);
  }


  Widget MobileLoaderWithoutProgess(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [MyColors.pnbPinkColor,
            ThemeHelper.getInstance()!.backgroundColor
          ], begin: Alignment.bottomCenter, end: Alignment.centerLeft)),
      height: MyDimension.getFullScreenHeight(),
      width: MyDimension.getFullScreenWidth(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Image.asset(height: 250.h,width: 250.w,Utils.path(FETCHGSTLOADER),fit: BoxFit.fill,),
                // Lottie.asset(Utils.path(FETCHGSTLOADER),
                //     height: 250.h,
                //     //80.w,
                //     width: 250.w,
                //     //80.w,
                //     repeat: true,
                //     reverse: false,
                //     animate: true,
                //     frameRate: FrameRate.max,
                //     fit: BoxFit.fill
                // ),
                Text(str_Fetching_Eligible_Invoices, style: ThemeHelper
                    .getInstance()
                    ?.textTheme
                    .headline1, textAlign: TextAlign.center, maxLines: 3,),
                SizedBox(height: 10.h),
                Text("", style: ThemeHelper
                    .getInstance()
                    ?.textTheme
                    .headline3, textAlign: TextAlign.center, maxLines: 10,),
              ],
            ),
          ],
        ),
      ),
    );
  }




}