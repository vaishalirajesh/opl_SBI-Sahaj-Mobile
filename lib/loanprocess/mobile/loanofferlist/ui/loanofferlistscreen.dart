import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_loan_offer_res_main.dart';
import 'package:gstmobileservices/model/requestmodel/get_loan_offer_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_loan_offer_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_session.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusconstants.dart';
import 'package:sbi_sahay_1_0/utils/helpers/myfonts.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';

import '../../../../routes.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/constants/prefrenceconstants.dart';
import '../../../../utils/erros_handle.dart';
import '../../../../utils/internetcheckdialog.dart';
import '../../../../utils/progressLoader.dart';
import '../../../../utils/strings/strings.dart';
import '../../../../widgets/animation_routes/shimmer_widget.dart';
import '../../dashboardwithgst/mobile/dashboardwithgst.dart';
import '../../kfs/kfs_screen.dart';

class LoanOfferList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SafeArea(child: LoanOfferListSc());
    });
  }
}

class LoanOfferListSc extends StatefulWidget {
  @override
  LoanOfferListBody createState() => new LoanOfferListBody();
}

class LoanOfferListBody extends State<LoanOfferListSc> {
  /*List<LoanOfferData>? offers;*/
  bool isListLoaded = false;
  bool isNoOfferAvailable = false;
  var isOtherUpFrontDetailCard = false;
  var isOtherDisclouserCard = false;

  GetLoanOfferResMain? _getLoanOfferRes;

  @override
  void initState() {
    getLoanOfferListAPI();
    super.initState();

  }

  Future<void> getLoanOfferListAPI() async
  {
    if (await TGNetUtil.isInternetAvailable()) {
      getLoanOfferList();
    } else {
      showSnackBarForintenetConnection(
          context, getLoanOfferList);
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => DashboardWithGST(),
              ),
              (route) =>
                  false, //if you want to disable back feature set to false
            );

            return true;
        },
        child: LoanOfferListScreenContent(context));
  }

  Widget OfferContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Valid for:" +
                      "11h 48m",
                  style: ThemeHelper.getInstance()
                      ?.textTheme
                      .headline4
                      ?.copyWith(
                      color:
                      ThemeHelper.getInstance()?.colorScheme.tertiary,
                      fontSize: 14.sp),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Divider(),
            SizedBox(
              height: 25.h,
            ),
            Text(
              str_loan_offers,
              style: ThemeHelper.getInstance()?.textTheme.headline1,
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              str_select_invoice_below,
              style: ThemeHelper.getInstance()?.textTheme.headline3,
            ),
            SizedBox(
              height: 30.h,
            ),
            loanOfferList(context)
          ],
        ),
      ),
    );
  }

  Widget LoanOfferListScreenContent(BuildContext context) {
    // if(!isListLoaded)
    // {
    //   return ShimmerEffectPage();//MobileLoaderWithProgess(context, Utils.path(LOANOFFERLOADER), str_regain_figure, str_fetch_loan_offer_from_lender);
    // }
    // else
    // {
    return Scaffold(
      backgroundColor: ThemeHelper.getInstance()?.backgroundColor,
      appBar: getAppBarWithStepDone('2', str_loan_approve_process, 0.50,
          onClickAction: () => {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => DashboardWithGST(),
                  ),
                  (route) =>
                      false, //if you want to disable back feature set to false
                )
              }),
      body: OfferContent(context),
    );
    //   }
  }

  Widget loanOfferList(BuildContext context) {
    if (isNoOfferAvailable) {
      return SizedBox(
        height: 200.h,
        child: Center(
            child: Text(
          str_no_available_offer,
          style: ThemeHelper.getInstance()?.textTheme.headline1,
          textAlign: TextAlign.center,
        )),
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: !isListLoaded ? 7 : 10,//_getLoanOfferRes?.data?.offers?.length,
        itemBuilder: (context, index) {
          // if (!isListLoaded) {
          //   return Column(
          //     children: [
          //       ShimmerLoader(),
          //       SizedBox(
          //         height: 10.h,
          //       )
          //     ],
          //   );
          // } else {
            return Padding(
              key: ValueKey(
                  "Amazon Pvt. Ltd"),
              padding: EdgeInsets.only(bottom: 20.h),
              child: loanofferItemContainer(context, index),
            );
         // }
        },
      );
    }
  }

  Widget loanofferItemContainer(BuildContext context, int index) {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: ThemeHelper.getInstance()?.cardColor),
        child: Padding(
          padding: EdgeInsets.all(15.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                        "Amazon Pvt. Ltd",
                        style: ThemeHelper.getInstance()
                            ?.textTheme
                            .headline3
                            ?.copyWith(
                                fontFamily: MyFont.Nunito_Sans_Semi_bold,
                                color:
                                    ThemeHelper.getInstance()?.indicatorColor)),
                  ),
                  SvgPicture.asset(
                    Utils.path(LOANCARDRIGHTARROW),
                    height: 17.h,
                    width: 17.w,
                  )
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    str_invoice +
                        "230",
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline4
                        ?.copyWith(
                        color:
                        ThemeHelper.getInstance()?.colorScheme.tertiary,
                        fontSize: 14.sp),
                  ),
                  // Text(
                  //   str_due_date +
                  //      "22 Aug 2022",
                  //   style: ThemeHelper.getInstance()
                  //       ?.textTheme
                  //       .headline4
                  //       ?.copyWith(
                  //           color:
                  //               ThemeHelper.getInstance()?.colorScheme.tertiary,
                  //           fontSize: 14.sp),
                  // ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        str_loan_offer,
                        style: ThemeHelper.getInstance()
                            ?.textTheme
                            .headline6
                            ?.copyWith(fontSize: 16.sp),
                      ),
                      Text(
                          Utils.convertIndianCurrency("25600"),
                          style: ThemeHelper.getInstance()
                              ?.textTheme
                              .headline6
                              ?.copyWith(fontSize: 16.sp))
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        str_invoice_amt,
                        style: ThemeHelper.getInstance()
                            ?.textTheme
                            .headline4
                            ?.copyWith(
                                color: ThemeHelper.getInstance()
                                    ?.colorScheme
                                    .tertiary,
                                fontSize: 16.sp),
                      ),
                      Text(
                          Utils.convertIndianCurrency("35000"),
                          style: ThemeHelper.getInstance()
                              ?.textTheme
                              .headline6
                              ?.copyWith(fontSize: 16.sp))
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        str_due_date,
                        style: ThemeHelper.getInstance()
                            ?.textTheme
                            .headline4
                            ?.copyWith(
                            color: ThemeHelper.getInstance()
                                ?.colorScheme
                                .tertiary,
                            fontSize: 16.sp),
                      ),
                      Text(
                          "22 Aug 2022",
                          style: ThemeHelper.getInstance()
                              ?.textTheme
                              .headline6
                              ?.copyWith(fontSize: 16.sp))
                    ],
                  ),
                ],
              ),


            ],
          ),
        ),
      ),
      onTap: () {
      //  TGSession.getInstance().set(PREF_LOANOFFER, _getLoanOfferRes?.data?.offers?[index]);

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KfsScreen(),
            ));
      },
    );
  }

  void setIsOtherUpFrontCardShow() {
    setState(() {
      isOtherUpFrontDetailCard = !isOtherUpFrontDetailCard;
      isOtherDisclouserCard = false;
    });
    //notifyListeners();
  }

  void setIsOtherDisclouserCardShow() {
    setState(() {
      isOtherDisclouserCard = !isOtherDisclouserCard;
      isOtherUpFrontDetailCard = false;
    });
    // notifyListeners();
  }


  Widget PopUpViewForLoanOfferReady() {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                //image: DecorationImage(image: AssetImage(Utils.path(KFSCONGRATULATIONBG)),fit: BoxFit.fill),
                color: Colors.white,
              ),
              height: 400.h,
              width: 335.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      height: 90.h), //40
                  Center(
                      child: SvgPicture.asset( Utils.path(GREENCONFORMTICK),
                          height: 52.h, //,
                          width:52.w, //134.8,
                          allowDrawingOutsideViewBox: true)),
                  SizedBox(
                      height: 30.h), //40
                  Center(
                      child: Column(children: [
                        Text(
                          "Loan Offers are ready",style: ThemeHelper.getInstance()?.textTheme.headline1?.copyWith(color: MyColors.darkblack),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                            height: 18.h),
                        Padding(
                          padding: const EdgeInsets.only(left: 30,right: 30),
                          child: Text(
                            "Information sharing to get loan offers from lender is completed. Initiate loan process with lender now.",
                            textAlign: TextAlign.center,
                            style: ThemeHelper.getInstance()?.textTheme.bodyText2,
                          ),
                        ),
                      ])),
                  //38
                  SizedBox(
                      height: 20.h),
                  Padding(
                    padding:  EdgeInsets.only(left: 20.w,right: 20.w),
                    child: BtnCheckOut(),
                  )
                ],
              )),
        ));
  }

  Widget BtnCheckOut() {
    return ElevatedButton(
      style: ThemeHelper.getInstance()!.elevatedButtonTheme.style,
      onPressed: () async {
      },
      child:  Text(
        str_Checkit_out,
      ),
    );
  }

  Future<void> getLoanOfferList() async {
    String loanAppRefId =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    GetLoanOfferRequest getLoanOfferRequest =
        GetLoanOfferRequest(loanApplicationRefId: loanAppRefId);
    var jsonReq = jsonEncode(getLoanOfferRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_GET_LOAN_OFFER);
    ServiceManager.getInstance().getLoanOffer(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessSetLoanOffer(response),
        onError: (error) => _onErrorSetLoanOffer(error));
  }

  _onSuccessSetLoanOffer(GetLoanOfferResponse? response) {
    TGLog.d("LoanOfferResponse : onSuccess()");
    _getLoanOfferRes = response?.getLoanOfferResObj();
    if (_getLoanOfferRes?.status == RES_DETAILS_FOUND) {
      if (response?.getLoanOfferResObj().data?.offers?.isEmpty == true) {
        setState(() {
          isListLoaded = true;
          isNoOfferAvailable = true;
        });
      } else {
        setState(() {
          _getLoanOfferRes = response?.getLoanOfferResObj();
          isListLoaded = true;
          isNoOfferAvailable = false;
        });
      }
    } else if (_getLoanOfferRes?.status == RES_DETAILS_NOT_FOUND) {
      Future.delayed(const Duration(seconds: 10), () {
        getLoanOfferListAPI();
      });
    } else {
      LoaderUtils.handleErrorResponse(
          context,
          response?.getLoanOfferResObj().status,
          response?.getLoanOfferResObj().message,null);
      setState(() {
        isListLoaded = true;
        isNoOfferAvailable = true;
      });
    }
  }

  _onErrorSetLoanOffer(TGResponse errorResponse) {
    TGLog.d("LoanOfferResponse : onError()");
    setState(() {
      isListLoaded = true;
      isNoOfferAvailable = true;
    });
    handleServiceFailError(context, errorResponse.error);
  }
}

//Flutterant Implementation of the Shimmer effect

Widget ShimmerLoader() => Container(
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: MyColors.pnbCheckBoxcolor, width: 1),
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.white),
      child: Padding(
        padding: EdgeInsets.all(15.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ShimmerWidget.rectangle(
                  height: 20.h,
                  widht: 200.w,
                ),
                ShimmerWidget.rectangle(
                  height: 17.h,
                  widht: 17.w,
                )
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget.rectangle(
                      height: 20.h,
                      widht: 100.w,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    ShimmerWidget.rectangle(
                      height: 20.h,
                      widht: 100.w,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ShimmerWidget.rectangle(
                      height: 16.h,
                      widht: 100.w,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    ShimmerWidget.rectangle(
                      height: 16.h,
                      widht: 100.w,
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerWidget.rectangle(
                  height: 20.h,
                  widht: 150.w,
                ),
                ShimmerWidget.rectangle(
                  height: 20.h,
                  widht: 50.w,
                ),
              ],
            )
          ],
        ),
      ),
    );
