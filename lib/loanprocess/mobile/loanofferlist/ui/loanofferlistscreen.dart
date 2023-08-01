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
import 'package:sbi_sahay_1_0/loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusconstants.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/widgets/app_drawer.dart';
import 'package:sbi_sahay_1_0/widgets/info_loader.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';

import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/constants/prefrenceconstants.dart';
import '../../../../utils/erros_handle.dart';
import '../../../../utils/internetcheckdialog.dart';
import '../../../../utils/progressLoader.dart';
import '../../../../utils/strings/strings.dart';
import '../../../../widgets/animation_routes/shimmer_widget.dart';
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
  LoanOfferListBody createState() => LoanOfferListBody();
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

  Future<void> getLoanOfferListAPI() async {
    if (await TGNetUtil.isInternetAvailable()) {
      getLoanOfferList();
    } else {
      if (context.mounted) {
        showSnackBarForintenetConnection(context, getLoanOfferList);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!isListLoaded) {
          return false;
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const DashboardWithGST(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
          return true;
        }
      },
      child: LoanOfferListScreenContent(context),
    );
  }

  Widget OfferContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   children: [
            //     Text(
            //       "Valid for: ",
            //       style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(fontSize: 12.sp),
            //     ),
            //     Text(
            //       "",
            //       style: ThemeHelper.getInstance()
            //           ?.textTheme
            //           .headline2
            //           ?.copyWith(fontSize: 14.sp, color: MyColors.pnbcolorPrimary),
            //     ),
            //   ],
            // ),
            // SizedBox(
            //   height: 10.h,
            // ),
            // const Divider(),
            // SizedBox(
            //   height: 10.h,
            // ),
            Text(
              str_loan_offers,
              style: ThemeHelper.getInstance()?.textTheme.headline2,
            ),
            SizedBox(
              height: 10.h,
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
    return !isListLoaded
        ? ShowInfoLoader(
            msg: str_laon_offer_from_lender,
            isTransparentColor: isListLoaded,
          )
        : Scaffold(
            backgroundColor: ThemeHelper.getInstance()?.backgroundColor,
            drawer: const AppDrawer(),
            appBar: getAppBarWithStepDone('2', str_loan_approve_process, 0.50,
                onClickAction: () => {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const DashboardWithGST(),
                        ),
                        (route) => false, //if you want to disable back feature set to false
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
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: _getLoanOfferRes?.data?.offers?.length ?? 0,
        itemBuilder: (context, index) {
          return Padding(
            key: ValueKey("${_getLoanOfferRes?.data?.offers?[index]}"),
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
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), //color of shadow
              spreadRadius: 1, //spread radius
              blurRadius: 3, // blur radius
              offset: const Offset(0, 1), // changes position of shadow
            )
          ],
          borderRadius: BorderRadius.circular(12.r),
          color: ThemeHelper.getInstance()?.backgroundColor,
        ),
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
                      _getLoanOfferRes?.data?.offers?[index].buyerName ?? '',
                      style: ThemeHelper.getInstance()
                          ?.textTheme
                          .headline2
                          ?.copyWith(fontSize: 16.sp, color: ThemeHelper.getInstance()?.primaryColor),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  SvgPicture.asset(
                    AppUtils.path(MOBILETDASHBOARDARROWFORWARD),
                    height: 12.h,
                    width: 6.w,
                  ),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                '$str_invoice${_getLoanOfferRes?.data?.offers?[index].invoiceNumber}',
                style: ThemeHelper.getInstance()
                    ?.textTheme
                    .headline3
                    ?.copyWith(color: ThemeHelper.getInstance()?.colorScheme.tertiary, fontSize: 12.sp),
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        str_loan_offer,
                        style: ThemeHelper.getInstance()
                            ?.textTheme
                            .headline3
                            ?.copyWith(fontSize: 12.sp, color: MyColors.pnbcolorPrimary),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      FittedBox(
                        fit: BoxFit.fill,
                        child: Text(
                          AppUtils.convertIndianCurrency(
                              _getLoanOfferRes?.data?.offers?[index].offerDetails?[0].termsSanctionedAmount),
                          style: ThemeHelper.getInstance()?.textTheme.headline6?.copyWith(fontSize: 14.sp),
                        ),
                      )
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
                            .headline3
                            ?.copyWith(fontSize: 12.sp, color: MyColors.lightGraySmallText),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      FittedBox(
                        fit: BoxFit.fill,
                        child: Text(
                          AppUtils.convertIndianCurrency(
                              _getLoanOfferRes?.data?.offers?[index].offerDetails?[0].termsRequestedAmount),
                          style: ThemeHelper.getInstance()?.textTheme.headline2?.copyWith(fontSize: 14.sp),
                        ),
                      )
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
                            .headline3
                            ?.copyWith(fontSize: 12.sp, color: MyColors.lightGraySmallText),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        AppUtils.convertDateFormat(
                          _getLoanOfferRes?.data?.offers?.elementAt(index).offerDetails?.elementAt(0).repayDate ?? "",
                          'dd MMM yyyy',
                          'dd MMM, yyyy',
                        ),
                        style: ThemeHelper.getInstance()?.textTheme.headline2?.copyWith(fontSize: 14.sp),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        TGSession.getInstance().set(PREF_LOANOFFER, _getLoanOfferRes?.data?.offers?[index]);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KfsScreen(),
          ),
        );
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

  Future<void> getLoanOfferList() async {
    String loanAppRefId = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID) ?? '';
    GetLoanOfferRequest getLoanOfferRequest = GetLoanOfferRequest(loanApplicationRefId: loanAppRefId);
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
          context, response?.getLoanOfferResObj().status, response?.getLoanOfferResObj().message, null);
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
