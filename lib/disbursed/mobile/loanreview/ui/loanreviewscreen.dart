import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/save_rating_response_main.dart';
import 'package:gstmobileservices/model/requestmodel/save_rating_request.dart';
import 'package:gstmobileservices/model/responsemodel/save_rating_response.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/imageconstant.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/erros_handle.dart';
import 'package:sbi_sahay_1_0/utils/helpers/myfonts.dart';
import 'package:sbi_sahay_1_0/utils/jumpingdott.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';

import '../../../../loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import '../../../../utils/constants/statusConstants.dart';
import '../../../../utils/helpers/themhelper.dart';
import '../../../../utils/internetcheckdialog.dart';
import '../../../../widgets/ratingwidget.dart';

class LoanReviewMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoanReviewMains();
  }
}

class LoanReviewMains extends StatefulWidget {
  @override
  LoanReviewMainBody createState() => new LoanReviewMainBody();
}

class LoanReviewMainBody extends State<LoanReviewMains> {
  var reviewText = 'Average';
  var ratingText = '';
  var isRatingChange = false;
  var isDialogShowing = false;
  double rating = 3;
  bool isLoaderStart = false;

  SaveRatingResMain? _saveRatingResMain;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(const Duration(milliseconds: 1), () {
        if (!isDialogShowing) {
          ShowRatingDialog(context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SafeArea(
          child: WillPopScope(
              onWillPop: () async {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => DashboardWithGST(),
                  ),
                  (route) => false, //if you want to disable back feature set to false
                );

                return true;
              },
              child: LoanReviewScreenContent(context)));
    });
    return LoanReviewScreenContent(context);
  }

  Widget LoanReviewScreenContent(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoaderStart,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            ThemeHelper.getInstance()!.colorScheme.secondary,
            ThemeHelper.getInstance()!.backgroundColor,
          ], begin: Alignment.bottomCenter, end: Alignment.centerLeft),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              SvgPicture.asset(
                AppUtils.path(MOBILECONGRATULATION),
                width: MediaQuery.of(context).size.width,
                height: 150.h,
              ),
              /* SizedBox(height: 80.h,),*/
              Image.asset(
                height: 180.h,
                width: 180.w,
                AppUtils.path(LOANDISBURSED),
                fit: BoxFit.contain,
              ),
              // Lottie.asset(Utils.path(LOANDISBURSED),
              //     height: 150.h,
              //     //80.w,
              //     width: 180.w,
              //     //80.w,
              //     repeat: true,
              //     reverse: false,
              //     animate: true,
              //     frameRate: FrameRate.max,
              //     fit: BoxFit.contain),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  str_loan_disbursed_txt,
                  style: ThemeHelper.getInstance()?.textTheme.bodyText1,
                  textAlign: TextAlign.center,
                  maxLines: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void ShowRatingDialog(BuildContext context) {
    setIsDialogShowing();

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setModelState) {
            return Wrap(children: [ReviewDialogUI(context, setModelState)]);
          });
        },
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        clipBehavior: Clip.antiAlias,
        isScrollControlled: true);
  }

  Widget ReviewDialogUI(BuildContext context, StateSetter setModelState) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              GestureDetector(
                child: Icon(
                  Icons.close,
                  color: MyColors.pnbTextcolor,
                  size: 10.h,
                ),
                onTap: () {
                  setModelState(() {
                    Navigator.pop(context);
                  });
                },
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
            child: Text(
              str_overall_experiance,
              style: ThemeHelper.getInstance()?.textTheme.bodyText1?.copyWith(fontFamily: MyFont.Nunito_Sans_Semi_bold),
              maxLines: 4,
            ),
          ),
          Text(
            reviewText,
            style: ThemeHelper.getInstance()?.textTheme.headline1?.copyWith(fontSize: 20.sp),
          ),
          SizedBox(
            height: 15.h,
          ),
          RatingBarWidget(
            onRatingChanged: (double value) {
              setReviewRating(setModelState, value);
            },
            size: 35,
          ),
          isRatingChange ? RatingDesc(context) : Container()
        ],
      ),
    );
  }

  Widget SubmitRatingButton(BuildContext context) {
    return isLoaderStart
        ? JumpingDots(
            color: ThemeHelper.getInstance()?.primaryColor ?? MyColors.pnbcolorPrimary,
            radius: 10,
          )
        : ElevatedButton(
            onPressed: () async {
              setState(() {
                isLoaderStart = true;
              });
              if (await TGNetUtil.isInternetAvailable()) {
                saveRatingAPI();
              } else {
                showSnackBarForintenetConnection(context, saveRatingAPI);
              }
            },
            child: Center(
              child: Text(
                str_submit,
                style: ThemeHelper.getInstance()?.textTheme.button,
              ),
            ));
  }

  Widget RatingDesc(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 30.h,
        ),
        TextField(
          textInputAction: TextInputAction.done,
          maxLines: 3,
          maxLength: 500,
          onChanged: (value) {
            setRatingText(value);
          },
          decoration: InputDecoration(
            labelText: 'Public Review',
            hintText: '',
            labelStyle: ThemeHelper.getInstance()
                ?.textTheme
                .bodyText1
                ?.copyWith(color: ThemeHelper.getInstance()?.primaryColor, fontSize: 12.sp),
            floatingLabelStyle: ThemeHelper.getInstance()
                ?.textTheme
                .bodyText1
                ?.copyWith(color: ThemeHelper.getInstance()?.primaryColor, fontSize: 12.sp),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(color: MyColors.pnbCheckBoxcolor, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(color: MyColors.pnbCheckBoxcolor, width: 2)),
          ),
        ),
        SizedBox(
          height: 30.h,
        ),
        SubmitRatingButton(context),
      ],
    );
  }

  //model data

  void setReviewRating(StateSetter setModelState, double rating) {
    setModelState(() {
      this.rating = rating;
      isRatingChange = true;
    });

    // setState(() {
    //   this.rating = rating;
    //   isRatingChange = true;
    // });
    //notifyListeners();
  }

  void setRatingText(String value) {
    setState(() {
      this.ratingText = value;
    });

    //notifyListeners();
  }

  void setIsDialogShowing() {
    setState(() {
      isDialogShowing = true;
    });
    //notifyListeners();
  }

  void navigateToLoanDetailsScreen() {
    // Navigator.of(context).push(CustomRightToLeftPageRoute(child: DashboardWithGST(), ));
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardWithGST(),
        ));
    //   Navigator.of(context).push(CustomRightToLeftPageRoute(child: CongratulationsFinalMain(), ));

    // Navigator.pushNamed(context, MyRoutes.LoanDetailsRoutes);
  }

  //API

  Future<void> saveRatingAPI() async {
    String? loanApplicationRefID = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);

    SaveRatingRequest saveRatingRequest =
        SaveRatingRequest(loanApplicationRefId: loanApplicationRefID, rating: "4", comments: "HIGHLY_SATISFIED");
    var jsonReq = jsonEncode(saveRatingRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_SAVE_RATING_DETAIL);
    ServiceManager.getInstance().saveRatingRequest(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessSaveRating(response),
        onError: (error) => _onErrorSaveRating(error));
  }

  _onSuccessSaveRating(SaveRatingResponse? response) {
    TGLog.d("SaveRatingResponse : onSuccess()");

    if (response?.getSaveRatingResOnj().status == RES_SUCCESS) {
      _saveRatingResMain = response?.getSaveRatingResOnj();
      navigateToLoanDetailsScreen();
    } else if (response?.getSaveRatingResOnj().status == RES_OFFER_EXPIRED) {
      //move to no offerfound
      setState(() {
        isDialogShowing = false;
      });
      TGView.showSnackBar(context: context, message: response?.getSaveRatingResOnj().message ?? "offer expired");
    } else if (response?.getSaveRatingResOnj().status == RES_OFFER_INELIGIBLE) {
      //move to no offerfound
      setState(() {
        isLoaderStart = false;
        isDialogShowing = false;
      });
      TGView.showSnackBar(context: context, message: response?.getSaveRatingResOnj().message ?? "Inaligible");
    } else if (response?.getSaveRatingResOnj().status == RES_TECHNICAL_ERROR) {
      setState(() {
        isLoaderStart = false;
        isDialogShowing = false;
      });
      TGView.showSnackBar(context: context, message: response?.getSaveRatingResOnj().message ?? "");
      //    Navigator.pushNamed(context, MyRoutes.DashboardWithGSTRoutes);
      // Navigator.of(context).push(CustomRightToLeftPageRoute(child: DashboardWithGST(), ));
    } else {
      TGView.showSnackBar(context: context, message: response?.getSaveRatingResOnj().message ?? "");
    }
    setState(() {
      isLoaderStart = false;
    });
  }

  _onErrorSaveRating(TGResponse errorResponse) {
    TGLog.d("SaveRatingResponse : onError()");
    setState(() {
      isLoaderStart = false;
      handleServiceFailError(context, errorResponse.error);
    });
  }
}
