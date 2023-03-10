import 'dart:convert';

import 'package:flutter/cupertino.dart';
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
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/gstinvoiceslist/ui/gstinvoicelistrefresh.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/gstinvoiceslist/ui/searchinvoicelist.dart';
import 'package:sbi_sahay_1_0/routes.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusconstants.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/erros_handle.dart';
import '../../../../utils/helpers/myfonts.dart';
import '../../../../utils/internetcheckdialog.dart';
import '../../../../utils/movestageutils.dart';
import '../../../../utils/progressloader.dart';
import '../../../../widgets/animation_routes/page_animation.dart';
import '../../../../widgets/loaderscreen/mobileloader/loaderwithoutprogressbar.dart';
import '../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';

class GSTInvoicesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(child: GstInvoiceScreen());
      },
    );
  }
}

class GstInvoiceScreen extends StatefulWidget {
  @override
  GstInvoceListState createState() => GstInvoceListState();
}

class GstInvoceListState extends State<GstInvoiceScreen> {
  bool isFetchInvoiceClick = false;
  bool isShareInvoiceClick = false;
  List<bool> isSortByChecked = [false, false, false, false, false, false];
  int selectedSortOption = 0;
  GstInvoceListResMain? _gstInvoceListResMain;
  List<GstInvoiceDataObj> arrInvoiceList = [];

  ShareGstInvoiceResMain? _shareGstInvoiceResMain;
  GetLoanStatusResMain? _getLoanStatusResMain;
  String? loanApplicationReferenceID;

  String? loanApplicationID;

  // List<Map<String, dynamic>> allUser = [
  //   {
  //     'id': 1,
  //     'companyname': 'Amazon Pvt.Ltd',
  //     'money': '32,205',
  //     'gstinno': '24 Aug 23001832188'
  //   },
  //   {
  //     'id': 2,
  //     'companyname': 'UrbanClap Pvt.Ltd',
  //     'money': '52,205',
  //     'gstinno': '24 Aug 23001832188'
  //   },
  //   {
  //     'id': 3,
  //     'companyname': 'Swiggy Pvt.Ltd',
  //     'money': '12,000',
  //     'gstinno': '24 Aug 23001832188'
  //   },
  // ];
  List<GstInvoiceDataObj> foundUser = [];
  var sortList = [
    "Invoice Date: Latest - Oldest",
    "Invoice Date: Oldest - Latest",
    "Buyer's Name: A - Z",
    "Buyer's Name: Z - A",
    "Amount: Low to High",
    "Amount: High to Low"
  ];

  void setShareInvoices() {
    isShareInvoiceClick = true;
  }

  void sortListById() {
    switch (selectedSortOption) {
      case 0:
        setState(() {
          arrInvoiceList.sort((a, b) {
            return Utils.convertDateFormat(
                    a.invoiceData?.invDate, "dd-mm-yyyy", "yyyy-mm-dd")
                .compareTo(Utils.convertDateFormat(
                    b.invoiceData?.invDate, "dd-mm-yyyy", "yyyy-mm-dd"));
          });
        });
        break;

      case 1:
        setState(() {
          arrInvoiceList.sort((a, b) {
            return Utils.convertDateFormat(
                    b.invoiceData?.invDate, "dd-mm-yyyy", "yyyy-mm-dd")
                .compareTo(Utils.convertDateFormat(
                    a.invoiceData?.invDate, "dd-mm-yyyy", "yyyy-mm-dd"));
          });
        });
        break;

      case 2:
        setState(() {
          arrInvoiceList.sort((a, b) {
            return a.buyerName
                .toString()
                .toLowerCase()
                .compareTo(b.buyerName.toString().toLowerCase());
          });
        });
        break;

      case 3:
        setState(() {
          arrInvoiceList.sort((a, b) {
            return b.buyerName
                .toString()
                .toLowerCase()
                .compareTo(a.buyerName.toString().toLowerCase());
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
    // foundUser = arrInvoiceList;
    //
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   LoaderUtils.showLoaderwithmsg(context,
    //       msg: str_Fetching_Eligible_Invoices + "\n" + str_Kindly_wait_for_60s);
    // });
    // getLoanAppRefIdAPI();

    super.initState();
  }

  Future<void> getLoanAppRefIdAPI() async {
    if (await TGNetUtil.isInternetAvailable()) {
      getLoanApplicationRefrenceIDAPI();
    } else {
      showSnackBarForintenetConnection(
          context, getLoanApplicationRefrenceIDAPI);
    }
  }

  @override
  Widget build(BuildContext context) {
    isFetchInvoiceClick = true;
    return WillPopScope(
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
        child: bodyScaffold());
  }

  Widget bodyScaffold() {
    return Scaffold(
      appBar: getAppBarWithStepDone("2", str_loan_approve_process, 0.50,
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
      body: Stack(
        children: [
          Container(
              color: ThemeHelper.getInstance()!.backgroundColor,
              child: gstInvoiceContent()),
          Align(alignment: Alignment.bottomCenter, child: shareInvoiceButton())
        ],
      ),
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
            child: Text(str_GST_Invoices_for_loan_offers,
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .headline1!
                    .copyWith(color: MyColors.darkblack))),
        SizedBox(
          height: 20.h,
        ),
        Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: invoiceSearchBarTextField()),
        SizedBox(
          height: 30.h,
        ),
        eligibleInvoiceUi(),
        // SizedBox(height: 10.h)
      ],
    ));
  }

  Widget eligibleInvoiceUi() {
    return Container(
      ///height: 812.h,
      decoration: BoxDecoration(
        // borderRadius: const BorderRadius.only(
        //     topRight: Radius.circular(40), topLeft: Radius.circular(40)),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            Row(
              children: [
                Text("$str_select_any_inovice (3)",
                    style: ThemeHelper.getInstance()!
                        .textTheme
                        .headline1!
                        .copyWith(color: MyColors.darkblack, fontSize: 20)),
                Spacer(),
                Row(
                  children: [
                    refreshInvoiceButton(),
                    filterInvoiceButton()
                  ],
                )
              ],
            ),
            SizedBox(height: 15.h),
            Text(str_All_the_invoicesgenerated,
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .headline3!
                    .copyWith(color: MyColors.darkblack)),
            Text(str_invoice_disc,
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .headline3!
                    .copyWith(color: MyColors.black)),
            SizedBox(height: 10.h),
            const Divider(),
            SizedBox(
              height: 10.h,
            ),
            invoiceListContainer()
          ],
        ),
      ),
    );
  }

  Widget invoiceListContainer() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              key: ValueKey("Amazon Pvt. Ltd"),
              child: invoiceDataUI(),
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

  Widget invoiceDataUI() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(
               "Amazon Pvt. Ltd",
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline2!
                  .copyWith(fontSize: 14, fontFamily: MyFont.Nunito_Sans_Bold),
              maxLines: 2,
            )),
            Text(
                "₹ 32,205",
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 16, color: MyColors.pnbcolorPrimary))
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
        Row(
          children: [
            Text(
                Utils.convertDateFormat(
                    "24-03-2023",
                    "dd-MM-yyyy",
                    'd MMM'),
                style: ThemeHelper.getInstance()!.textTheme.bodyText2),
            Text(" | 23001832188" ?? "",
                style: ThemeHelper.getInstance()!.textTheme.bodyText2),
          ],
        ),
      ]),
    );
  }

  Widget invoiceSearchBarTextField() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchInvoiceList(arrInvoiceList),
            ));
      },
      child: SizedBox(
          height: 45.h,
          child: TextFormField(
            onChanged: (value) => {},
            style: ThemeHelper.getInstance()!
                .textTheme
                .bodyText1!
                .copyWith(fontSize: 14.sp),
            cursorColor: ThemeHelper.getInstance()!.primaryColor,
            decoration: InputDecoration(
                fillColor: ThemeHelper.getInstance()!.cardColor,
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: ThemeHelper.getInstance()!.colorScheme.onSurface,
                        width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(6.r))),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: ThemeHelper.getInstance()!.colorScheme.onSurface,
                        width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(6.r))),
                contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                prefixIcon: new Icon(Icons.search_rounded,
                    color: ThemeHelper.getInstance()!
                        .primaryColor
                        .withOpacity(0.3)),
                // hintText: "Search...",
                labelText: str_Search,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintStyle: ThemeHelper.getInstance()!
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 14.sp),
                filled: true,
                enabled: false,
                labelStyle: ThemeHelper.getInstance()!
                    .textTheme
                    .headline3!
                    .copyWith(color: MyColors.pnbcolorPrimary.withOpacity(0.3)),
                //    fillColor: searchbarBGColor.withOpacity(0.37),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: ThemeHelper.getInstance()!.colorScheme.onSurface,
                        width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(6.r)))
    ),
          )),
    );
  }

  Widget shareInvoiceButton() {
    return Container(
      color: ThemeHelper.getInstance()!.backgroundColor,
      height: 100.h,
      child: Padding(
        padding:
            EdgeInsets.only(left: 20.w, right: 20.w, bottom: 25.h, top: 25.h),
        child: ElevatedButton(
            onPressed: () async {

              Navigator.pushNamed(context, MyRoutes.AccountAggregatorDetailsRoutes);
              // WidgetsBinding.instance.addPostFrameCallback((_) async {
              //   LoaderUtils.showLoaderwithmsg(context,
              //       msg: str_share_invoice + "\n" + str_Kindly_wait_for_60s);
              // });
              // if (await TGNetUtil.isInternetAvailable()) {
              //   shareInvoicesListAPI();
              // } else {
              //   showSnackBarForintenetConnection(context, shareInvoicesListAPI);
              // }
            },
            child: Center(
              child: Text(
                str_share_invoice,
                style: ThemeHelper.getInstance()?.textTheme.button,
              ),
            )),
      ),
    );
  }

//popup
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
                height: 500.h,
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
                    ),
                    SizedBox(height: 40.h),
                    Padding(
                        padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
                        child: Row(
                          children: [
                            refreshLaterButton(),
                            SizedBox(width: 10.w),
                            refreshNowButton(),


                          ],
                        ))
                  ],
                )),
          ),

        ]));
  }

  Widget sortByBottomSheetDialog(StateSetter setModelState) {
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          SizedBox(height: 25.h),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Text(
                  str_SortBy,
                  style: ThemeHelper.getInstance()
                      ?.textTheme
                      .headline2!
                      .copyWith(color: MyColors.pnbcolorPrimary),
                ),
                Spacer(),
                GestureDetector(
                  child: Padding(
                      padding: EdgeInsets.only(right: 20.w),
                      child: SvgPicture.asset(Utils.path(IMG_CLOSE_X),
                          height: 10.h, width: 10.w)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ]),
          SizedBox(height: 10.h),
          Divider(),
          sortByDialogContent(setModelState),
          Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 30.h),
              child: applySortButton(setModelState))
        ]));
  }

  Widget refreshNowButton() {
    return Container(


      width: 140.w,
      height: 56.h, //38,
      child: ElevatedButton(
          onPressed: () {},
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

      decoration: BoxDecoration(
        border: Border.all(color: ThemeHelper.getInstance()!.primaryColor),
        borderRadius: const BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      width: 140.w,
      height: 56.h, //38,
      child: ElevatedButton(
          onPressed: () {},
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

  Widget refreshInvoiceButton() {
    return Container(
      width: 100.w,
      height: 40.h, //38,
      child: ElevatedButton(
          onPressed: () {

            showDialog(
                context: context,
                builder: (_) =>refreshGstBottomSheetDialog()
            );

            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => GSTInvoiceListRefresh(),
            //     ));

            // showModalBottomSheet(
            //     backgroundColor: ThemeHelper.getInstance()!.backgroundColor,
            //     context: context,
            //     builder: (BuildContext context) {
            //       return Wrap(children: [refreshGstBottomSheetDialog()]);
            //     },
            //     shape: const RoundedRectangleBorder(
            //         borderRadius: BorderRadius.only(
            //             topLeft: Radius.circular(25),
            //             topRight: Radius.circular(25))),
            //     clipBehavior: Clip.antiAlias,
            //     isScrollControlled: true);
          },
          child: Row(
            children: [
              SvgPicture.asset(Utils.path(REFRESHIMG),
                  height: 15.h, width: 15.w),
              SizedBox(width: 8.w,),
              Text('Refresh',style: ThemeHelper.getInstance()?.textTheme.headline6,)
            ],
          ),
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent,
            //foregroundColor: ThemeHelper.getInstance()!.colorScheme.onPrimary,
            backgroundColor: ThemeHelper.getInstance()!.backgroundColor,
            shape: CircleBorder(),
          )),
    );
  }

  Widget filterInvoiceButton() {
    // return IconButton(
    //   icon: SvgPicture.asset(Utils.path(IMG_FILTER_INVOICE)),
    //   iconSize: 44,
    //   onPressed: () {
    //     showModalBottomSheet(
    //         backgroundColor: ThemeHelper.getInstance()!.backgroundColor,
    //         context: context,
    //         builder: (BuildContext context) {
    //           return StatefulBuilder(
    //               builder: (BuildContext context, StateSetter setModelState) {
    //             return Wrap(children: [sortByBottomSheetDialog(setModelState)]);
    //           });
    //         },
    //         shape: const RoundedRectangleBorder(
    //             borderRadius: BorderRadius.only(
    //                 topLeft: Radius.circular(25),
    //                 topRight: Radius.circular(25))),
    //         clipBehavior: Clip.antiAlias,
    //         isScrollControlled: true);
    //   },
    // );

    return Container(
      width: 95.w,
      height: 40.h, //38,
      child: ElevatedButton(
          onPressed: () {
                showModalBottomSheet(
                    backgroundColor: ThemeHelper.getInstance()!.backgroundColor,
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                          builder: (BuildContext context, StateSetter setModelState) {
                        return Wrap(children: [sortByBottomSheetDialog(setModelState)]);
                      });
                    },
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    clipBehavior: Clip.antiAlias,
                    isScrollControlled: true);
          },
          child: Row(
            children: [
              SvgPicture.asset(Utils.path(IMG_FILTER_INVOICE),
                  height: 15.h, width: 15.w),
              SizedBox(width: 8.w,),
              Text('Sort',style: ThemeHelper.getInstance()?.textTheme.headline6,)
            ],
          ),
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent,
            //foregroundColor: ThemeHelper.getInstance()!.colorScheme.onPrimary,
            backgroundColor: ThemeHelper.getInstance()!.backgroundColor,
            shape: CircleBorder(),
          )),
    );
  }

  Widget sortByDialogContent(StateSetter setModelState) {
    return Container(
        height: 230.h,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: sortList.length,
          itemBuilder: (context, index) {
            return SoryByListCardUI(index, setModelState);
          },
        ));
  }

  Widget SoryByListCardUI(int index, StateSetter setModelState) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h, left: 20.w, right: 20.w),
      child: GestureDetector(
        onTap: () {
          setModelState(() {
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
                setModelState(() {
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

  Widget applySortButton(StateSetter setModelState) {
    return Container(
      height: 55.h,
      child: ElevatedButton(
          onPressed: () {
            sortListById();
            Navigator.pop(context);
          },
          child: Center(
            child: Text(
              str_Apply,
              style: ThemeHelper.getInstance()?.textTheme.button,
            ),
          ),
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6))),
          )),
    );
  }

  Widget fetchInvoicesAnimation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        MyColors.pnbPinkColor,
        ThemeHelper.getInstance()!.backgroundColor
      ], begin: Alignment.bottomCenter, end: Alignment.centerLeft)),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            height: 159.h,
            width: 250.w,
            Utils.path(FETCHGSTLOADER),
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
    String? loanapplicationRefID =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);

    if (loanapplicationRefID == null) {
      String gstin = await TGSharedPreferences.getInstance().get(PREF_GSTIN);

      TGGetRequest tgGetRequest = GSTRefid(gstin: gstin, invoiceType: '');
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
      TGSharedPreferences.getInstance().set(PREF_LOANAPPREFID,
          response?.getAppRefId().data?.loanApplicationRefId);
      if (await TGNetUtil.isInternetAvailable()) {
        getGSTInvoicesListAPI();
      } else {
        showSnackBarForintenetConnection(context, getGSTInvoicesListAPI);
      }
    } else {
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(context, response?.getAppRefId().status,
          response?.getAppRefId().message, null);
    }
  }

  _onErrorGetAppRefId(TGResponse errorResponse) {
    TGLog.d("GetAppRefId : onError()");
    Navigator.pop(context);
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> getGSTInvoicesListAPI() async {
    String gstin = await TGSharedPreferences.getInstance().get(PREF_GSTIN);
    GstBasicDataRequest gstInvoiceListRequest = GstBasicDataRequest(id: gstin);

    var jsonReq = jsonEncode(gstInvoiceListRequest.toJson());
    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, URI_GST_INVOICE_LIST);

    TGLog.d("Invoice List Request : $jsonReq");
    ServiceManager.getInstance().getGstInvoiceList(
        request: tgPostRequest,
        onSuccess: (response) => _onSuccessGstInvoiceList(response),
        onError: (error) => _onErrorGstInvoiceList(error));
  }

  _onSuccessGstInvoiceList(GstInvoiceListResponse? response) {
    TGLog.d("GstInvoiceListResponse : onSuccess()");
    TGLog.d(response?.getAppRefIdObj().status ?? "");

    if (response?.getAppRefIdObj().status == RES_DETAILS_FOUND) {
      Navigator.pop(context);
      setState(() {
        _gstInvoceListResMain = response?.getAppRefIdObj();
        arrInvoiceList = _gstInvoceListResMain!.data!;
      });
    } else if (_gstInvoceListResMain?.status == REFRESH_GST_INVOICES) {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GSTInvoiceListRefresh(),
          ));
    } else {
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(
          context,
          response?.getAppRefIdObj().status,
          response?.getAppRefIdObj().message,
          null);
    }
  }

  _onErrorGstInvoiceList(TGResponse errorResponse) {
    TGLog.d("GstInvoiceListResponse : onError()");
    Navigator.pop(context);
    handleServiceFailError(context, errorResponse.error);
  }

  Future<void> shareInvoicesListAPI() async {
    loanApplicationReferenceID =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPREFID);

    loanApplicationID =
        await TGSharedPreferences.getInstance().get(PREF_LOANAPPID);

    ShareGstInvoiceRequest shareGstInvoiceRequest = ShareGstInvoiceRequest(
        loanApplicationRefId: loanApplicationReferenceID);
    var jsonReq = jsonEncode(shareGstInvoiceRequest.toJson());
    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, URI_SHARE_GST_INVOICE);
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
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(
          context,
          response?.getShareGstInvoiceObj().status,
          response?.getShareGstInvoiceObj().message,
          null);
    }
  }

  _onErrorShareGstInvoice(TGResponse errorResponse) {
    TGLog.d("ShareGstInvoiceResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
    Navigator.pop(context);
  }

  Future<void> getLoanApplicaionStatusAPI() async {
    GetLoanStatusRequest getLoanStatusRequest =
        GetLoanStatusRequest(loanApplicationRefId: loanApplicationReferenceID);
    var jsonReq = jsonEncode(getLoanStatusRequest.toJson());
    TGPostRequest tgPostRequest =
        await getPayLoad(jsonReq, Utils.getManageLoanAppStatusParam('1'));
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
        Navigator.pop(context);
        MoveStage.navigateNextStage(
            context, _getLoanStatusResMain?.data?.currentStage);
      } else if (_getLoanStatusResMain?.data?.stageStatus == "HOLD") {
        Future.delayed(Duration(seconds: 10), () {
          getLoanAppStatusAfterShareGstInvoiceAPI();
        });
      } else {
        getLoanAppStatusAfterShareGstInvoiceAPI();
      }
    } else {
      Navigator.pop(context);
      LoaderUtils.handleErrorResponse(
          context,
          response?.getLoanStatusResObj().status,
          response?.getLoanStatusResObj().message,
          response?.getLoanStatusResObj().data?.stageStatus);
    }
  }

  _onErrorGetLoanAppStatus(TGResponse errorResponse) {
    TGLog.d("GetLoanAppStatusResponse : onError()");
    handleServiceFailError(context, errorResponse.error);
    Navigator.pop(context);
  }

  Future<void> getLoanAppStatusAfterShareGstInvoiceAPI() async
  {
    if (await TGNetUtil.isInternetAvailable()) {
      getLoanApplicaionStatusAPI();
    } else {
      showSnackBarForintenetConnection(
          context, getLoanApplicaionStatusAPI);
    }
  }
}
