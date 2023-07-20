import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/comman/getrequestmodel/get_gst_ref_id_model.dart';
import 'package:gstmobileservices/model/models/get_loan_app_status_main.dart';
import 'package:gstmobileservices/model/models/gst_invoicelist_response_main.dart';
import 'package:gstmobileservices/model/models/share_gst_invoice_res_main.dart';
import 'package:gstmobileservices/model/requestmodel/get_gst_basic_data_request.dart';
import 'package:gstmobileservices/model/requestmodel/get_loan_app_status_request.dart';
import 'package:gstmobileservices/model/requestmodel/share_gst_invoice_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_app_referenceid_response.dart';
import 'package:gstmobileservices/model/responsemodel/get_loan_app_status_response.dart';
import 'package:gstmobileservices/model/responsemodel/gst_invoicelist_response.dart';
import 'package:gstmobileservices/model/responsemodel/share_gst_invoice_response.dart';
import 'package:gstmobileservices/service/request/tg_get_request.dart';
import 'package:gstmobileservices/service/request/tg_post_request.dart';
import 'package:gstmobileservices/service/requtilization.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/service/uris.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/gstinvoiceslist/ui/gstinvoicelistrefresh.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/gstinvoiceslist/ui/searchinvoicelist.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusconstants.dart';
import 'package:sbi_sahay_1_0/utils/helpers/myfonts.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';
import 'package:sbi_sahay_1_0/widgets/app_drawer.dart';
import 'package:sbi_sahay_1_0/widgets/info_loader.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/erros_handle.dart';
import '../../../../utils/internetcheckdialog.dart';
import '../../../../utils/movestageutils.dart';
import '../../../../utils/progressloader.dart';
import '../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';

class GSTInvoicesList extends StatelessWidget {
  const GSTInvoicesList({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return const SafeArea(child: GstInvoiceScreen());
      },
    );
  }
}

class GstInvoiceScreen extends StatefulWidget {
  const GstInvoiceScreen({super.key});

  @override
  GstInvoceListState createState() => GstInvoceListState();
}

class GstInvoceListState extends State<GstInvoiceScreen> {
  bool isFetchInvoiceClick = false;
  bool isShareInvoiceClick = false;
  List<bool> isSortByChecked = [false, false, false, false, false, false];
  int selectedSortOption = 0;
  GstInvoceListResMain? _gstInvoceListResMain = GstInvoceListResMain();
  List<GstInvoiceDataObj> arrInvoiceList = [];

  ShareGstInvoiceResMain? _shareGstInvoiceResMain;
  GetLoanStatusResMain? _getLoanStatusResMain;
  String? loanApplicationReferenceID;

  String? loanApplicationID;
  List<GstInvoiceDataObj> foundUser = [];
  var sortList = [
    "Invoice Date: Latest - Oldest",
    "Invoice Date: Oldest - Latest",
    "Buyer's Name: A - Z",
    "Buyer's Name: Z - A",
    "Amount: Low to High",
    "Amount: High to Low"
  ];
  bool isLoadData = false;
  bool isShowTransparentBg = false;

  void setShareInvoices() {
    isShareInvoiceClick = true;
  }

  void sortListById() {
    switch (selectedSortOption) {
      case 0:
        setState(() {
          arrInvoiceList.sort((a, b) {
            return AppUtils.convertDateFormat(a.invoiceData?.invDate, "dd-mm-yyyy", "yyyy-mm-dd")
                .compareTo(AppUtils.convertDateFormat(b.invoiceData?.invDate, "dd-mm-yyyy", "yyyy-mm-dd"));
          });
        });
        break;

      case 1:
        setState(() {
          arrInvoiceList.sort((a, b) {
            return AppUtils.convertDateFormat(b.invoiceData?.invDate, "dd-mm-yyyy", "yyyy-mm-dd")
                .compareTo(AppUtils.convertDateFormat(a.invoiceData?.invDate, "dd-mm-yyyy", "yyyy-mm-dd"));
          });
        });
        break;

      case 2:
        setState(() {
          arrInvoiceList.sort((a, b) {
            return a.buyerName.toString().toLowerCase().compareTo(b.buyerName.toString().toLowerCase());
          });
        });
        break;

      case 3:
        setState(() {
          arrInvoiceList.sort((a, b) {
            return b.buyerName.toString().toLowerCase().compareTo(a.buyerName.toString().toLowerCase());
          });
        });
        break;

      case 4:
        setState(() {
          arrInvoiceList.sort((a, b) {
            return a.invoiceData?.invValue.compareTo(b.invoiceData?.invValue);
          });
        });
        break;

      case 5:
        setState(() {
          arrInvoiceList.sort((a, b) {
            return b.invoiceData?.invValue.compareTo(a.invoiceData?.invValue);
          });
          arrInvoiceList.reversed;
        });
        break;
    }
  }

  @override
  void initState() {
    getLoanAppRefIdAPI();
    super.initState();
  }

  Future<void> getLoanAppRefIdAPI() async {
    if (await TGNetUtil.isInternetAvailable()) {
      getLoanApplicationRefrenceIDAPI();
    } else {
      if (context.mounted) {
        showSnackBarForintenetConnection(context, getLoanApplicationRefrenceIDAPI);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!isLoadData) {
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
      child: bodyScaffold(),
    );
  }

  Widget bodyScaffold() {
    return !isLoadData
        ? ShowInfoLoader(
            msg: str_wait_for_gst_invoice,
            isTransparentColor: isShowTransparentBg,
          )
        : Stack(
            children: [
              Scaffold(
                drawer: const AppDrawer(),
                appBar: getAppBarWithStepDone("2", str_loan_approve_process, 0.50,
                    onClickAction: () => {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => const DashboardWithGST(),
                            ),
                            (route) => false, //if you want to disable back feature set to false
                          )
                        }),
                body: Stack(
                  children: [
                    Container(color: ThemeHelper.getInstance()!.backgroundColor, child: gstInvoiceContent()),
                    Align(alignment: Alignment.bottomCenter, child: shareInvoiceButton()),
                  ],
                ),
              ),
              if (isShowTransparentBg)
                ShowInfoLoader(
                  msg: str_sharing_invoice,
                  isTransparentColor: isShowTransparentBg,
                )
            ],
          );
  }

  Widget gstInvoiceContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Text(str_GST_Invoices_for_loan_offers, style: ThemeHelper.getInstance()!.textTheme.headline2),
          ),
          SizedBox(
            height: 10.h,
          ),
          // Padding(
          //   padding: EdgeInsets.only(left: 20.w, right: 20.w),
          //   child: invoiceSearchBarTextField(),
          // ),
          buildSearchWidget(),
          SizedBox(
            height: 10.h,
          ),
          eligibleInvoiceUi(),
          // SizedBox(height: 10.h)
        ],
      ),
    );
  }

  Widget eligibleInvoiceUi() {
    return Container(
      decoration: const BoxDecoration(),
      child: Padding(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    "$str_select_any_inovice (${arrInvoiceList.length})",
                    style: ThemeHelper.getInstance()!.textTheme.headline2,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: refreshInvoiceButton(),
                  ),
                ),
                SizedBox(width: 20.h),
                filterInvoiceButton()
              ],
            ),
            // SizedBox(height: 20.h),
            // Text(str_All_the_invoicesgenerated,
            //     style: ThemeHelper.getInstance()!
            //         .textTheme
            //         .headline3!
            //         .copyWith(color: MyColors.darkblack, fontSize: 14.sp)),
            // Text(str_invoice_disc,
            //     style: ThemeHelper.getInstance()!
            //         .textTheme
            //         .headline3!
            //         .copyWith(color: MyColors.darkblack, fontSize: 14.sp)),
            SizedBox(height: 10.h),
            const Divider(),
            SizedBox(
              height: 10.h,
            ),
            invoiceListContainer(),
            SizedBox(
              height: 70.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget invoiceListContainer() {
    return _gstInvoceListResMain?.data == null || (_gstInvoceListResMain?.data?.length == 0)
        ? SizedBox(
            height: 0.5.sh,
            child: Center(
              child: Text(
                str_invoice_data_found,
                style: ThemeHelper.getInstance()!.textTheme.headline3!,
              ),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: _gstInvoceListResMain?.data?.length ?? 0,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    key: ValueKey("${_gstInvoceListResMain?.data?[index].buyerName.toString()}"),
                    child: invoiceDataUI(index),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Divider(
                    thickness: 1.h,
                  )
                ],
              );
            },
          );
  }

  Widget invoiceDataUI(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(
              _gstInvoceListResMain?.data?[index].buyerName.toString() ?? '',
              style: ThemeHelper.getInstance()!.textTheme.headline3!,
              maxLines: 2,
            )),
            Text(
              AppUtils.convertIndianCurrency(
                  '${_gstInvoceListResMain?.data?[index].invoiceData?.invValue.toString() ?? ''} '),
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .bodySmall!
                  .copyWith(fontSize: 16, color: MyColors.pnbcolorPrimary),
            )
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
        Row(
          children: [
            Text(
                AppUtils.convertDateFormat(
                    _gstInvoceListResMain?.data?[index].invoiceData?.invDate.toString() ?? "24-03-2023",
                    "dd-MM-yyyy",
                    'd MMM'),
                style: ThemeHelper.getInstance()!.textTheme.subtitle1?.copyWith(color: MyColors.lightGraySmallText)),
            Text(" | ${_gstInvoceListResMain?.data?[index].ctin}" ?? "",
                style: ThemeHelper.getInstance()!.textTheme.subtitle1?.copyWith(color: MyColors.lightGraySmallText)),
          ],
        ),
      ]),
    );
  }

  Widget buildSearchWidget() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => SearchInvoiceList(
              arrInvoiceList: arrInvoiceList,
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.search,
                  color: ThemeHelper.getInstance()!.colorScheme.onSurface,
                ),
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                  child: Text(
                    "Search",
                    style: ThemeHelper.getInstance()!.textTheme.headline3?.copyWith(
                          color: ThemeHelper.getInstance()!.colorScheme.onSurface,
                        ),
                  ),
                )
              ],
            ),
            Divider(
              thickness: 1,
              color: ThemeHelper.getInstance()!.colorScheme.onSurface,
            )
          ],
        ),
      ),
    );
  }

  Widget invoiceSearchBarTextField() {
    return Container(
      decoration: const BoxDecoration(
          // borderRadius: BorderRadius.all(Radius.circular(8.r)),
          // border: Border.all(
          //   color: ThemeHelper.getInstance()!.colorScheme.shadow,
          //   style: BorderStyle.solid,
          //   width: 0.5,
          // ),
          ),
      height: 35.h,
      child: TextField(
        style: ThemeHelper.getInstance()!.textTheme.button,
        cursorColor: ThemeHelper.getInstance()!.backgroundColor,
        decoration: InputDecoration(
          fillColor: ThemeHelper.getInstance()!.backgroundColor,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ThemeHelper.getInstance()!.colorScheme.onSurface, width: 1.0),
            // borderRadius: BorderRadius.all(Radius.circular(7.r))
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ThemeHelper.getInstance()!.colorScheme.onSurface, width: 1.0),
            // borderRadius: BorderRadius.all(Radius.circular(7.r))
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
          prefixIcon: Icon(Icons.search, color: MyColors.lightGraySmallText.withOpacity(0.3)),
          // hintText: "Search...",
          labelText: str_Search,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintStyle: ThemeHelper.getInstance()!.textTheme.button,
          filled: true,
          labelStyle: ThemeHelper.getInstance()!
              .textTheme
              .headline3!
              .copyWith(color: MyColors.lightGraySmallText.withOpacity(0.3)),
          //    fillColor: searchbarBGColor.withOpacity(0.37),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: ThemeHelper.getInstance()!.colorScheme.onSurface, width: 1.0),
            // borderRadius: BorderRadius.all(
            //   Radius.circular(7.r),
            // ),
          ),
        ),
      ),
    );
    // return GestureDetector(
    //   onTap: () {
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => SearchInvoiceList(arrInvoiceList),
    //         ));
    //   },
    //   child: SizedBox(
    //       height: 45.h,
    //       child: TextFormField(
    //         onChanged: (value) => {},
    //         style: ThemeHelper.getInstance()!
    //             .textTheme
    //             .bodyText1!
    //             .copyWith(fontSize: 14.sp),
    //         cursorColor: ThemeHelper.getInstance()!.primaryColor,
    //         decoration: InputDecoration(
    //             fillColor: ThemeHelper.getInstance()!.backgroundColor,
    //             focusedBorder: UnderlineInputBorder(
    //                 borderSide: BorderSide(
    //                     color: ThemeHelper.getInstance()!.colorScheme.primary,
    //                     width: 1.0),
    //                 borderRadius: BorderRadius.all(Radius.circular(6.r))),
    //             enabledBorder: UnderlineInputBorder(
    //                 borderSide: BorderSide(
    //                     color: ThemeHelper.getInstance()!.colorScheme.primary,
    //                     width: 1.0),
    //                 borderRadius: BorderRadius.all(Radius.circular(6.r))),
    //             contentPadding: EdgeInsets.symmetric(vertical: 10.h),
    //             prefixIcon: new Icon(Icons.search_rounded,
    //                 color: ThemeHelper.getInstance()!
    //                     .primaryColor
    //                     .withOpacity(0.3)),
    //             // hintText: "Search...",
    //             labelText: str_Search,
    //             floatingLabelBehavior: FloatingLabelBehavior.never,
    //             hintStyle: ThemeHelper.getInstance()!
    //                 .textTheme
    //                 .bodyText1!
    //                 .copyWith(fontSize: 14.sp),
    //             filled: true,
    //             enabled: false,
    //             labelStyle: ThemeHelper.getInstance()!
    //                 .textTheme
    //                 .headline3!
    //                 .copyWith(color: MyColors.pnbcolorPrimary.withOpacity(0.3)),
    //             //    fillColor: searchbarBGColor.withOpacity(0.37),
    //             border: UnderlineInputBorder(
    //                 borderSide: BorderSide(
    //                     color: ThemeHelper.getInstance()!.colorScheme.onSurface,
    //                     width: 1.0),
    //                 borderRadius: BorderRadius.all(Radius.circular(6.r)))
    // ),
    //       )),
    // );
  }

  Widget shareInvoiceButton() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 25.h, top: 25.h),
      child: AppButton(
        onPress: onPressShareInvoiceButton,
        title: str_proceed,
      ),
    );
  }

//popup
  Widget refreshGstBottomSheetDialog() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 30.h),
        Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Container(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            decoration: BoxDecoration(
              color: ThemeHelper.getInstance()!.cardColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 40.h),
                SvgPicture.asset(AppUtils.path(REFRESHGST), height: 200.h, width: 154.w),
                SizedBox(height: 27.h),
                Text(
                  str_refresh_gst,
                  style: ThemeHelper.getInstance()!
                      .textTheme
                      .headline2!
                      ?.copyWith(fontSize: 18.sp, fontFamily: MyFont.Roboto_Regular),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40.h),
                Padding(
                  padding: EdgeInsets.only(bottom: 30.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: refreshLaterButton()),
                      SizedBox(width: 10.w),
                      Expanded(child: refreshNowButton()),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget sortByBottomSheetDialog() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 25.h),
          Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            // const Spacer(),
            Text(
              str_SortBy,
              style: ThemeHelper.getInstance()?.textTheme.headline2!.copyWith(color: MyColors.pnbcolorPrimary),
            ),
            const Spacer(),
            GestureDetector(
              child: Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: SvgPicture.asset(AppUtils.path(IMG_CLOSE_X), height: 10.h, width: 10.w)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ]),
          SizedBox(height: 10.h),
          const Divider(),
          sortByDialogContent(),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 30.h),
            child: applySortButton(),
          )
        ],
      ),
    );
  }

  Widget refreshNowButton() {
    return SizedBox(
      // width: 140.w,
      height: 50.h, //38,
      child: ElevatedButton(
        onPressed: () async {
          Navigator.pop(context);
          getLoanAppRefIdAPI();
          setState(() {
            isShowTransparentBg = true;
          });
        },
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          foregroundColor: ThemeHelper.getInstance()!.primaryColor,
          backgroundColor: ThemeHelper.getInstance()!.primaryColor,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
        ),
        child: Text(
          str_refresh_now,
          style: ThemeHelper.getInstance()!.textTheme.button,
        ),
      ),
    );
  }

  Widget refreshLaterButton() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ThemeHelper.getInstance()!.primaryColor),
        borderRadius: const BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      // width: 140.w,
      height: 50.h, //38,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          foregroundColor: ThemeHelper.getInstance()!.backgroundColor,
          backgroundColor: ThemeHelper.getInstance()!.backgroundColor,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
        ),
        child: Text(
          str_refresh_later,
          style: ThemeHelper.getInstance()!.textTheme.bodyText1,
        ),
      ),
    );
  }

  Widget refreshInvoiceButton() {
    return InkWell(
      onTap: () {
        setState(() {
          // isValidOTP = false;
          // isGstOtpLoader = false;
          // isRefreshGstLoader = false;
        });
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (BuildContext context, StateSetter setModelState) {
              return Center(
                child: refreshGstBottomSheetDialog(),
              );
            });
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SvgPicture.asset(AppUtils.path(REFRESHIMG), height: 15.h, width: 15.w),
            SizedBox(
              width: 8.w,
            ),
            Text(
              'Refresh',
              style: ThemeHelper.getInstance()?.textTheme.headline6?.copyWith(fontSize: 16.sp),
            )
          ],
        ),
      ),
    );
  }

  Widget filterInvoiceButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SvgPicture.asset(AppUtils.path(IMG_FILTER_INVOICE), height: 15.h, width: 15.w),
          SizedBox(
            width: 4.w,
          ),
          Text(
            'Sort',
            style: ThemeHelper.getInstance()?.textTheme.headline6?.copyWith(fontSize: 16.sp),
            textAlign: TextAlign.right,
          )
        ],
      ),
    );
  }

  Widget sortByDialogContent() {
    return Container(
      height: 230.h,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: sortList.length,
        itemBuilder: (context, index) {
          return SoryByListCardUI(index);
        },
      ),
    );
  }

  Widget SoryByListCardUI(
    int index,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h, left: 20.w, right: 20.w),
      child: GestureDetector(
        onTap: () {
          setState(() {
            for (int i = 0; i < isSortByChecked.length; i++) {
              isSortByChecked[i] = false;
            }
            isSortByChecked[index] = true;
          });
          setState(() {
            selectedSortOption = index;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              sortList[index],
              style: ThemeHelper.getInstance()?.textTheme.headline5,
            ),
            Radio(
              value: true,
              onChanged: (value) {
                setState(() {
                  for (int i = 0; i < isSortByChecked.length; i++) {
                    isSortByChecked[i] = false;
                  }
                  isSortByChecked[index] = value!;
                });
                setState(() {
                  selectedSortOption = index;
                });
              },
              activeColor: ThemeHelper.getInstance()?.primaryColor,
              groupValue: isSortByChecked[index],
              toggleable: true,
            )
          ],
        ),
      ),
    );
  }

  Widget applySortButton() {
    return SizedBox(
      height: 55.h,
      child: ElevatedButton(
        onPressed: () {
          sortListById();
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
        ),
        child: Center(
          child: Text(
            str_Apply,
            style: ThemeHelper.getInstance()?.textTheme.button,
          ),
        ),
      ),
    );
  }

  Widget fetchInvoicesAnimation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [MyColors.pnbPinkColor, ThemeHelper.getInstance()!.backgroundColor],
              begin: Alignment.bottomCenter,
              end: Alignment.centerLeft)),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            height: 159.h,
            width: 250.w,
            AppUtils.path(FETCHGSTLOADER),
            fit: BoxFit.fill,
          ),
          // Lottie.asset(Utils.path(FETCHGSTLOADER),
          //     height: 159.h,
          //     //80.w,
          //     width: 250.w,
          //     //80.w,
          //     repeat: true,
          //     reverse: false,
          //     animate: true,
          //     frameRate: FrameRate.max,
          //     fit: BoxFit.fill),
          Text(
            str_Fetching_Eligible_Invoices,
            style: ThemeHelper.getInstance()?.textTheme.headline1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  //API

  Future<void> getLoanApplicationRefrenceIDAPI() async {
    String? loanapplicationRefID = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    TGLog.d("GetAppRefId : request --loanapplicationRefID---$loanapplicationRefID");

    if (loanapplicationRefID == null) {
      String gstin = await TGSharedPreferences.getInstance().get(PREF_GSTIN);
      TGGetRequest tgGetRequest = GSTRefid(gstin: gstin, invoiceType: '');
      TGLog.d("GetAppRefId : request -- $tgGetRequest");

      ServiceManager.getInstance().getAppReferenceId(
          request: tgGetRequest,
          onSuccess: (response) => _onSuccessGetAppRefId(response),
          onError: (error) => _onErrorGetAppRefId(error));
    } else {
      if (await TGNetUtil.isInternetAvailable()) {
        getGSTInvoicesListAPI();
      } else {
        showSnackBarForintenetConnection(context, getGSTInvoicesListAPI);
      }
    }
  }

  _onSuccessGetAppRefId(GetAppRefIdResponse? response) async {
    TGLog.d("GetAppRefId : onSuccess()");
    if (response?.getAppRefId()?.status == RES_SUCCESS) {
      TGSharedPreferences.getInstance().set(PREF_LOANAPPREFID, response?.getAppRefId().data?.loanApplicationRefId);
      if (await TGNetUtil.isInternetAvailable()) {
        getGSTInvoicesListAPI();
      } else {
        showSnackBarForintenetConnection(context, getGSTInvoicesListAPI);
      }
    } else {
      // Navigator.pop(context);
      LoaderUtils.handleErrorResponse(context, response?.getAppRefId().status, response?.getAppRefId().message, null);
    }
  }

  _onErrorGetAppRefId(TGResponse errorResponse) {
    TGLog.d("GetAppRefId : onError()");
    // Navigator.pop(context);
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> getGSTInvoicesListAPI() async {
    String gstin = await TGSharedPreferences.getInstance().get(PREF_GSTIN);
    GstBasicDataRequest gstInvoiceListRequest = GstBasicDataRequest(id: gstin);

    var jsonReq = jsonEncode(gstInvoiceListRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_GST_INVOICE_LIST);

    TGLog.d("Invoice List Request : $jsonReq");
    ServiceManager.getInstance().getGstInvoiceList(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGstInvoiceList(response),
        onError: (error) => _onErrorGstInvoiceList(error));
  }

  _onSuccessGstInvoiceList(GstInvoiceListResponse? response) {
    TGLog.d("Invoice List Request : onSuccess()");
    TGLog.d(response?.getAppRefIdObj().status ?? "");

    if (response?.getAppRefIdObj().status == RES_DETAILS_FOUND) {
      setState(() {
        _gstInvoceListResMain = response?.getAppRefIdObj();
        arrInvoiceList = _gstInvoceListResMain!.data!;
      });
      TGLog.d("Invoice List Request : onSuccess()---2");
    } else if (_gstInvoceListResMain?.status == REFRESH_GST_INVOICES) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GSTInvoiceListRefresh(),
          ));
    } else {
      LoaderUtils.handleErrorResponse(
          context, response?.getAppRefIdObj().status, response?.getAppRefIdObj().message, null);
    }
    isLoadData = true;
    isShowTransparentBg = false;
    setState(() {});
  }

  _onErrorGstInvoiceList(TGResponse errorResponse) {
    TGLog.d("GstInvoiceListResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
    setState(() {
      isLoadData = true;
      isShowTransparentBg = false;
    });
  }

  void onPressShareInvoiceButton() async {
    setState(() {
      isShowTransparentBg = true;
    });
    if (arrInvoiceList.isNotEmpty) {
      if (await TGNetUtil.isInternetAvailable()) {
        shareInvoicesListAPI();
      } else {
        if (context.mounted) {
          showSnackBarForintenetConnection(context, shareInvoicesListAPI);
        }
      }
    }
  }

  Future<void> shareInvoicesListAPI() async {
    loanApplicationReferenceID = await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);
    loanApplicationID = await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);

    ShareGstInvoiceRequest shareGstInvoiceRequest =
        ShareGstInvoiceRequest(loanApplicationRefId: loanApplicationReferenceID);
    var jsonReq = jsonEncode(shareGstInvoiceRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, URI_SHARE_GST_INVOICE);
    ServiceManager.getInstance().shareGstInvoiceList(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessShareGstInvoice(response),
        onError: (error) => _onErrorShareGstInvoice(error));
  }

  _onSuccessShareGstInvoice(ShareGstInvoiceResponse? response) {
    TGLog.d("ShareGstInvoiceResponse : onSuccess()");
    _shareGstInvoiceResMain = response?.getShareGstInvoiceObj();

    if (_shareGstInvoiceResMain?.status == RES_SUCCESS) {
      if (loanApplicationID != null && loanApplicationReferenceID != null) {
        getLoanAppStatusAfterShareGstInvoiceAPI();
      } else {
        getLoanAppStatusAfterShareGstInvoiceAPI();
      }
    } else {
      // Navigator.pop(context);
      LoaderUtils.handleErrorResponse(
          context, response?.getShareGstInvoiceObj().status, response?.getShareGstInvoiceObj().message, null);
    }
  }

  _onErrorShareGstInvoice(TGResponse errorResponse) {
    TGLog.d("ShareGstInvoiceResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
    // Navigator.pop(context);
  }

  Future<void> getLoanApplicaionStatusAPI() async {
    GetLoanStatusRequest getLoanStatusRequest = GetLoanStatusRequest(loanApplicationRefId: loanApplicationReferenceID);
    var jsonReq = jsonEncode(getLoanStatusRequest.toJson());
    TGPostRequest tgPostRequest = await getPayLoad(jsonReq, AppUtils.getManageLoanAppStatusParam('1'));
    ServiceManager.getInstance().getLoanAppStatus(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGetLoanAppStatus(response),
        onError: (error) => _onErrorGetLoanAppStatus(error));
  }

  _onSuccessGetLoanAppStatus(GetLoanStatusResponse? response) {
    TGLog.d("GetLoanAppStatusResponse : onSuccess()");

    _getLoanStatusResMain = response?.getLoanStatusResObj();
    if (_getLoanStatusResMain?.status == RES_SUCCESS) {
      if (_getLoanStatusResMain?.data?.stageStatus == "PROCEED") {
        TGLog.d("GetLoanAppStatusResponse : in proceed");
        setState(() {
          isLoadData = true;
          isShowTransparentBg = false;
        });
        MoveStage.navigateNextStage(context, _getLoanStatusResMain?.data?.currentStage);
        // Navigator.pop(context);
        //Navigator.pushReplacementNamed(context, MyRoutes.AccountAggregatorDetailsRoutes);
      } else if (_getLoanStatusResMain?.data?.stageStatus == "HOLD") {
        Future.delayed(const Duration(seconds: 10), () {
          getLoanAppStatusAfterShareGstInvoiceAPI();
        });
      } else {
        getLoanAppStatusAfterShareGstInvoiceAPI();
      }
    } else {
      // Navigator.pop(context);
      setState(() {
        isLoadData = true;
        isShowTransparentBg = false;
      });
      LoaderUtils.handleErrorResponse(context, response?.getLoanStatusResObj().status,
          response?.getLoanStatusResObj().message, response?.getLoanStatusResObj().data?.stageStatus);
    }
    // setState(() {
    //   isShowTransparentBg = false;
    // });
  }

  _onErrorGetLoanAppStatus(TGResponse errorResponse) {
    TGLog.d("GetLoanAppStatusResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
    setState(() {
      isShowTransparentBg = false;
      isLoadData = true;
    });
    // Navigator.pop(context);
  }

  Future<void> getLoanAppStatusAfterShareGstInvoiceAPI() async {
    if (await TGNetUtil.isInternetAvailable()) {
      getLoanApplicaionStatusAPI();
    } else {
      showSnackBarForintenetConnection(context, getLoanApplicaionStatusAPI);
    }
  }
}
