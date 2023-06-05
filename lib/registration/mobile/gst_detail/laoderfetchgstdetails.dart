

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/fetch_gst_data_res_main.dart';
import 'package:gstmobileservices/model/requestmodel/fetch_gst_data_status_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_gst_basic_data_request.dart';
import 'package:gstmobileservices/model/responsemodel/fetch_gst_data_status_response.dart';
import 'package:gstmobileservices/model/responsemodel/gst_basic_data_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:lottie/lottie.dart';

import '../../../routes.dart';
import '../../../utils/Utils.dart';
import '../../../utils/colorutils/mycolors.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/dimenutils/dimensutils.dart';
import '../../../utils/helpers/themhelper.dart';
import '../../../utils/strings/strings.dart';

class LoaderFetchGstDetails extends StatelessWidget
{
  const LoaderFetchGstDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      return  SafeArea(child:  WillPopScope(
          onWillPop: () async {
        return true;
      },
      child: LoaderFetchGstDetailsBody()));
    });
  }

}

class LoaderFetchGstDetailsBody extends StatefulWidget {

  @override
  LoaderFetchGstDetailsState createState() => LoaderFetchGstDetailsState();
}

class LoaderFetchGstDetailsState extends State<LoaderFetchGstDetailsBody> {
  FetchGstDataResMain? _fetchGstDataResMain;


  @override
  void initState() {
    // TODO: implement initState
    gstDetailsStatusAPI();
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
                Image.asset(height: 250.h,width: 250.w,Utils.path(LOANOFFERLOADER),fit: BoxFit.fill,),
                // Lottie.asset(Utils.path(LOANOFFERLOADER),
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
                Text(str_Fetching_your_GST_business_details, style: ThemeHelper
                    .getInstance()
                    ?.textTheme
                    .headline1, textAlign: TextAlign.center, maxLines: 3,),
                SizedBox(height: 10.h),
                Text(str_Kindly_wait_for_60s, style: ThemeHelper
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

  void navigateToGstDetailScreen() {
    Navigator.pushNamed(context, MyRoutes.confirmGSTDetailRoutes);
  }

  Future<void> gstDetailsStatusAPI() async {

    FetGstDataStatusRequest fetGstDataStatusRequest= FetGstDataStatusRequest(id : "30AAACR9303A1Z6",);
    var jsonReq = jsonEncode(fetGstDataStatusRequest.toJson()); TGPostRequest tgPostRequest = await getPayLoad(jsonReq,
        URI_FETCH_GST_DATA_STATUS);
    ServiceManager.getInstance().fetchGstDataStatus( request: tgPostRequest,
        onSuccess: (response) => _onSuccessFetchGstDataStatus(response), onError: (error) => _onErrorFetchGstDataStatus(error));

  }

  _onSuccessFetchGstDataStatus(FetchGstDataStatusResponse? response) { TGLog.d("RegisterResponse : onSuccess()");

  _fetchGstDataResMain = response?.getFetchGstDataObj();

  if (_fetchGstDataResMain?.status == 1000){
    navigateToGstDetailScreen();
  }

  }
  _onErrorFetchGstDataStatus(TGResponse errorResponse) { TGLog.d("RegisterResponse : onError()");
  }


}