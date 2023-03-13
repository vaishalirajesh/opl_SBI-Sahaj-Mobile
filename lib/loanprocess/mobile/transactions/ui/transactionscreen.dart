import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/model/models/get_all_invoice_loan_response_main.dart';
import 'package:gstmobileservices/model/requestmodel/get_all_invoice_loan_detail_by_refid_request.dart';
import 'package:gstmobileservices/model/responsemodel/get_all_invoice_loans_by_ref_id_response.dart';
import 'package:gstmobileservices/service/request/tg_get_request.dart';
import 'package:gstmobileservices/service/response/tg_response.dart';
import 'package:gstmobileservices/service/service_managers.dart';
import 'package:gstmobileservices/singleton/tg_session.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';

import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/helpers/myfonts.dart';
import '../../../../utils/strings/strings.dart';
import '../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';
import '../common_card/disbursed/disbursed_transaction.dart';
import '../common_card/outstanding/outstanding_transaction.dart';
import '../common_card/overdue/overdue_transaction.dart';
import '../common_card/repaid/repaid_transaction.dart';
import '../disbursed/view/disbursed_screen.dart';

class TransactionsMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return TranscationTabBar();
    });
  }
}

class TransactionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return TranscationTabBar();
    });
  }
}

class TranscationTabBar extends StatefulWidget {
  TranscationTabBar({Key? key}) : super(key: key);

  @override
  State<TranscationTabBar> createState() => _TranscationTabBarState();
}

class _TranscationTabBarState extends State<TranscationTabBar>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late TabController tabController;
  String dropdownvalue = 'S';
  TextEditingController searchTextController = TextEditingController();
  String? searchText;
  GetAllInvoiceLoansResponseMain? getAllLoanDetailByRefIdResMainobj;
  GetAllInvoiceLoansResObj? obj;
  List<SharedInvoice>? outstanding_invoice;
  List<SharedInvoice>? disbursed_invoice;
  List<SharedInvoice>? repaidInvoice;
  List<SharedInvoice>? overdueInvoice;
  List<SharedInvoice>? filter_outstanding_invoice = [];
  List<SharedInvoice>? filter_disbursed_invoice = [];
  List<SharedInvoice>? filter_repaidInvoice = [];
  List<SharedInvoice>? filter_overdueInvoice = [];
  // List of items in our dropdown menu
  var items = [
    'Invoice Date:Latest-Oldest(Default)',
    'Invoice Date:Oldest-Latest',
    'Buyer\'s Name: A-Z',
    'Buyer\'s Name: Z-A',
    'Amount:Low to High',
    'Amount:High to Low',
  ];

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 4);
    tabController.index = TGSession.getInstance().get("TabIndex") ?? 0;
    getAllLoansByReferenceId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MyDrawer(),
        // backgroundColor: ThemeHelper.getInstance()?.colorScheme.primary,
        appBar: buildAppBar(),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: TabBarView(
            controller: tabController,
            children: [
              buildTabView(FetchTranstaion()),
              buildTabView(OverDueTranstaion()),
              buildTabView(RepaidTranstaion()),
              buildTabView(DisbursedTranstaion()),

              /*buildTabView(CancelMain()),
              buildTabView(AllMain()),*/
            ],
          ),
        ),
      ),
    );
  }

  buildAppBar() => AppBar(
        elevation: 0,
        backgroundColor: MyColors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(180.0.h),
          child: Column(
            children: [getAppBarMainDashboard("2", str_loan_approve_process, 0.25,
                onClickAction: () => {
                  _scaffoldKey.currentState?.openDrawer()
                }), buildAppBarBottomPart()],
          ),
        ),
      );

  buildAppBarUpperPart() => Padding(
        padding: EdgeInsets.only(left: 20.w,right: 20.w, top: 0.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  child: SvgPicture.asset(
                    Utils.path(MOBILEMENUBAR),
                  ),
                  onTap: () {},
                ),
                Padding(
                  padding: EdgeInsets.only(left: 70.w),
                  child: SvgPicture.asset(
                    Utils.path(SAHAJLOGOWITHOUTTEXT),
                    height: 30.h,
                    width: 130.w,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(Utils.path(NOTIFICATIONICON),
                    height: 20.h, width: 20.w),
                SizedBox(
                  width: 8.w,
                ),
                SvgPicture.asset(Utils.path(LOGOUT), height: 20.h, width: 20.w)
              ],
            )
          ],
        ),
      );

  buildAppBarBottomPart() => Container(
      decoration: BoxDecoration(
        color: MyColors.white,
        // borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(26.r), topRight: Radius.circular(26.r))
      ),
      child: buildTabRow());

  buildAppBarTitleText(String title) => Text(
        title,
        style: ThemeHelper.getInstance()!
            .textTheme
            .headline5!
            .copyWith(fontSize: 25.sp, color: MyColors.white),
      );

  buildAppBarIcon(String path) => SizedBox(
        width: 20.w,
        height: 20.h,
        child: SvgPicture.asset(
          Utils.path(path),
          //
        ),
      );

  buildTabRow() => Padding(
        padding: EdgeInsets.only(left: 0.w, right: 0.w),
        child: Column(
          children: [
            Container(height: 50.h,
              width:MediaQuery.of(context).size.width,
              child: Padding(
                padding:  EdgeInsets.only(left: 20.w,top: 10.h),
                child: Text(
                    "Transactions",
                    style: ThemeHelper.getInstance()!
                        .textTheme
                        .headline3!
                        .copyWith(color: MyColors.white)),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(0.r),
                      bottomLeft: Radius.circular(0.r)),
                  border: Border.all(
                      width: 1, color: ThemeHelper.getInstance()!.primaryColor),
                  //color: ThemeHelper.getInstance()!.primaryColor,

                  gradient: LinearGradient(colors: [MyColors.lightRedGradient,MyColors.lightBlueGradient],begin: Alignment.centerLeft,end: Alignment.centerRight )
              )),
            buildFirstPartAppBar(),
            buildBottomPartAppBar()],
        ),
      );

  buildTabWidget(String title, int index) => Tab(
      child: Text(title,
          style: TextStyle(
              fontSize: 15.sp,
              color: setColor(index),
              fontFamily: MyFont.Nunito_Sans_Semi_bold)));

  setColor(int index) {
    (tabController.index == index) ? Colors.grey : MyColors.pnbcolorPrimary;
  }

  Widget buildTabView(Widget child) => Container(
        height: MediaQuery.of(context).size.height,
        color: MyColors.white,
        child: Padding(padding: const EdgeInsets.all(18.0), child: child),
      );

  buildFirstPartAppBar() => SizedBox(
        height: 45.h,
        child: TabBar(
          indicatorColor: ThemeHelper.getInstance()?.primaryColor,
          indicatorSize: TabBarIndicatorSize.tab,
          isScrollable: true,
          indicatorWeight: 4.w,
          labelColor: MyColors.pnbcolorPrimary,
          unselectedLabelColor: MyColors.pnbGreyColor,
          controller: tabController,
          /*indicatorSize: TabBarIndicatorSize.label,*/
          tabs: [
            buildTabWidget(str_outstanding, 0),
            buildTabWidget(strOverdue, 1),
            buildTabWidget(strRepaid, 2),
            buildTabWidget(strDisbursed, 3),
          ],
        ),
      );

  Widget filterInvoiceButton() {

    return Container(
      width: 95.w,
      height: 40.h, //38,
      child: ElevatedButton(
          onPressed: () {

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


  buildBottomPartAppBar() => Padding(
      padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 26.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          searchBar(),
          filterInvoiceButton()
        ],
      ));

  Widget searchBar() {
    return SizedBox(
      width: 250.w,
      height: 45.h,
      child: TextFormField(
          autofocus: true,
          controller: searchTextController,
          style: ThemeHelper.getInstance()
              ?.textTheme
              .headline4
              ?.copyWith(fontFamily: MyFont.Nunito_Sans_Regular),
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            prefixIcon: GestureDetector(
              child: Icon(
                Icons.search_sharp,
                color: Colors.grey,
                size: 15.h,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.all(Radius.circular(7.r))),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.all(Radius.circular(7.r))),
            contentPadding: EdgeInsets.symmetric(vertical: 10.h),
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.all(Radius.circular(7.r))),
            hintText: 'Search',
            hintStyle: ThemeHelper.getInstance()
                ?.textTheme
                .headline4
                ?.copyWith(fontFamily: MyFont.Nunito_Sans_Regular),
          ),
          onChanged: (searchValue) {
            setState(() {
              searchText = searchValue;
              if (tabController.index == 0) {
                outstanding_invoice
                    ?.where((invoiceData) =>
                        invoiceData.buyerName?.toLowerCase().contains(
                                searchText.toString().toLowerCase()) ==
                            true ||
                        invoiceData.loanId?.toString().toLowerCase().contains(
                                searchText.toString().toLowerCase()) ==
                            true ||
                        invoiceData.loanAmount
                                ?.toString()
                                .toLowerCase()
                                .contains(
                                    searchText.toString().toLowerCase()) ==
                            true ||
                        invoiceData.invoiceAmount
                                ?.toString()
                                .toLowerCase()
                                .contains(
                                    searchText.toString().toLowerCase()) ==
                            true)
                    .toList();
              } else if (tabController.index == 1) {
                overdueInvoice
                    ?.where((invoiceData) =>
                        invoiceData.buyerName?.toLowerCase().contains(
                                searchText.toString().toLowerCase()) ==
                            true ||
                        invoiceData.loanId?.toString().toLowerCase().contains(
                                searchText.toString().toLowerCase()) ==
                            true ||
                        invoiceData.loanAmount
                                ?.toString()
                                .toLowerCase()
                                .contains(
                                    searchText.toString().toLowerCase()) ==
                            true ||
                        invoiceData.invoiceAmount
                                ?.toString()
                                .toLowerCase()
                                .contains(
                                    searchText.toString().toLowerCase()) ==
                            true)
                    .toList();
              } else if (tabController.index == 2) {
                repaidInvoice
                    ?.where((invoiceData) =>
                        invoiceData.buyerName?.toLowerCase().contains(
                                searchText.toString().toLowerCase()) ==
                            true ||
                        invoiceData.loanId?.toString().toLowerCase().contains(
                                searchText.toString().toLowerCase()) ==
                            true ||
                        invoiceData.loanAmount
                                ?.toString()
                                .toLowerCase()
                                .contains(
                                    searchText.toString().toLowerCase()) ==
                            true ||
                        invoiceData.invoiceAmount
                                ?.toString()
                                .toLowerCase()
                                .contains(
                                    searchText.toString().toLowerCase()) ==
                            true)
                    .toList();
              } else if (tabController.index == 3) {
                disbursed_invoice
                    ?.where((invoiceData) =>
                        invoiceData.buyerName?.toLowerCase().contains(
                                searchText.toString().toLowerCase()) ==
                            true ||
                        invoiceData.loanId?.toString().toLowerCase().contains(
                                searchText.toString().toLowerCase()) ==
                            true ||
                        invoiceData.loanAmount
                                ?.toString()
                                .toLowerCase()
                                .contains(
                                    searchText.toString().toLowerCase()) ==
                            true ||
                        invoiceData.invoiceAmount
                                ?.toString()
                                .toLowerCase()
                                .contains(
                                    searchText.toString().toLowerCase()) ==
                            true)
                    .toList();
              }
            });
          },
          inputFormatters: [
            FilteringTextInputFormatter.allow(
                RegExp("(?!^ +\$)^[a-zA-Z0-9 _]+\$"),
                replacementString: "")
          ]),
    );
  }

  Widget sortBar(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.all(Radius.circular(5.r))),
        height: 45.h,
        width: 88.w,
        child: TextButton(
          onPressed: () {
            btnFilter(context);
          },
          child: FittedBox(
            child: Row(
              children: [
                Text(
                  'Sort by',
                  style: ThemeHelper.getInstance()!
                      .textTheme
                      .headline1!
                      .copyWith(
                          fontSize: 16.sp, color: Colors.grey.withOpacity(0.3)),
                ),
                Icon(Icons.arrow_drop_down)
              ],
            ),
          ),
        ));
  }

  btnFilter(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: ThemeHelper.getInstance()!.backgroundColor,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200.h,
            child: RadioListBuilder(
              num: 20,
            ),
          );
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        clipBehavior: Clip.antiAlias,
        isScrollControlled: true);
  }

  //Api call
  Future<void> getAllLoansByReferenceId() async {
    TGGetRequest tgGetRequest =
        GetAllInvoiceLoanDetailByRefIdReq(gstin: '24AAGFV5271N1ZP');
    ServiceManager.getInstance().getAllInvoiceLoanDetailByRefId(
        request: tgGetRequest,
        onSuccess: (response) => _onSuccessGet2AllLoanDetailByRefId(response),
        onError: (error) => _onErrorGet2AllLoanDetailByRefId(error));
  }

  _onSuccessGet2AllLoanDetailByRefId(GetAllInvoiceLoansResponse? response) {
    setState(() {
      getAllLoanDetailByRefIdResMainobj = response?.getAllLoanDetailObj();
      obj = getAllLoanDetailByRefIdResMainobj?.data;
      outstanding_invoice = obj?.outstandingInvoice;
      disbursed_invoice = obj?.disbursedInvoice;
      repaidInvoice = obj?.repaidInvoice;
      overdueInvoice = obj?.overdueInvoice;
    });
  }

  _onErrorGet2AllLoanDetailByRefId(TGResponse errorResponse) {
    TGLog.d("GetAllInvoiceLoansResponse : onError()");
  }

  Widget FetchTranstaion() {
    if (outstanding_invoice?.isEmpty == true) {
      return Center(
          child: Text(
        "No Data Found!",
        style: ThemeHelper.getInstance()?.textTheme.headline4?.copyWith(
            fontSize: 16.sp, fontFamily: MyFont.Nunito_Sans_Semi_bold),
        textAlign: TextAlign.center,
      ));
    }
    /*else if(searchTextController.text.isNotEmpty && filter_outstanding_invoice?.isEmpty == true && tabController.index == 0)
    {
      return Center(child: Text("No Data Found!",style: ThemeHelper.getInstance()?.textTheme.headline4?.copyWith(fontSize: 16.sp,fontFamily: MyFont.Nunito_Sans_Semi_bold),textAlign: TextAlign.center,));
    }*/
    else {
      return Align(
        alignment: Alignment.center,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: outstanding_invoice?.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                OutstandingTransactionCard(
                    disbursedInvoice: outstanding_invoice?[index]),
                SizedBox(
                  height: 15.h,
                )
              ],
            );
          },
        ),
      );
    }
  }

  Widget RepaidTranstaion() {
    if (repaidInvoice?.isEmpty == true) {
      return Center(
          child: Text(
        "No Data Found!",
        style: ThemeHelper.getInstance()?.textTheme.headline4?.copyWith(
            fontSize: 16.sp, fontFamily: MyFont.Nunito_Sans_Semi_bold),
        textAlign: TextAlign.center,
      ));
    }
    /*else if(searchTextController.text.isNotEmpty && filter_repaidInvoice?.isEmpty == true && tabController.index == 2)
    {
      return Center(child: Text("No Data Found!",style: ThemeHelper.getInstance()?.textTheme.headline4?.copyWith(fontSize: 16.sp,fontFamily: MyFont.Nunito_Sans_Semi_bold),textAlign: TextAlign.center,));
    }*/
    else {
      return Align(
        alignment: Alignment.center,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: repaidInvoice?.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                RepaidTransactionCard(repaidInvoice: repaidInvoice?[index]),
                SizedBox(
                  height: 15.h,
                )
              ],
            );
          },
        ),
      );
    }
  }

  Widget DisbursedTranstaion() {
    if (disbursed_invoice?.isEmpty == true) {
      return Center(
          child: Text(
        "No Data Found!",
        style: ThemeHelper.getInstance()?.textTheme.headline4?.copyWith(
            fontSize: 16.sp, fontFamily: MyFont.Nunito_Sans_Semi_bold),
        textAlign: TextAlign.center,
      ));
    }
    /*else if(searchTextController.text.isNotEmpty && filter_disbursed_invoice?.isEmpty == true && tabController.index == 3)
    {
      return Center(child: Text("No Data Found!",style: ThemeHelper.getInstance()?.textTheme.headline4?.copyWith(fontSize: 16.sp,fontFamily: MyFont.Nunito_Sans_Semi_bold),textAlign: TextAlign.center,));
    }*/
    else {
      return Align(
        alignment: Alignment.center,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: disbursed_invoice?.length ?? 0,
          itemBuilder: (context, index) {
            return Column(
              children: [
                DisbursedTransactionCard(
                    disbursedInvoice: disbursed_invoice?[index]),
                SizedBox(
                  height: 15.h,
                )
              ],
            );
          },
        ),
      );
    }
  }

  Widget OverDueTranstaion() {
    if (overdueInvoice?.isEmpty == true) {
      return Center(
          child: Text(
        "No Data Found!",
        style: ThemeHelper.getInstance()?.textTheme.headline4?.copyWith(
            fontSize: 16.sp, fontFamily: MyFont.Nunito_Sans_Semi_bold),
        textAlign: TextAlign.center,
      ));
    }
    /* else if(searchTextController.text.isNotEmpty && filter_overdueInvoice?.isEmpty == true && tabController.index == 1)
    {
      return Center(child: Text("No Data Found!",style: ThemeHelper.getInstance()?.textTheme.headline4?.copyWith(fontSize: 16.sp,fontFamily: MyFont.Nunito_Sans_Semi_bold),textAlign: TextAlign.center,));
    }*/
    else {
      return Align(
        alignment: Alignment.center,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: overdueInvoice?.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                OverdueTransactionCard(overdueInvoice: overdueInvoice?[index]),
                SizedBox(
                  height: 15.h,
                )
              ],
            );
          },
        ),
      );
    }
  }
}

Widget transactionCardMainUI(SharedInvoice? invoiceData) {
  return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(12.r),
          )));
}

class RadioListBuilder extends StatefulWidget {
  final int num;

  const RadioListBuilder({super.key, required this.num});

  @override
  RadioListBuilderState createState() {
    return RadioListBuilderState();
  }
}

class RadioListBuilderState extends State<RadioListBuilder> {
  int value = 0;
  var items = [
    'Invoice Date:Latest-Oldest(Default)',
    'Invoice Date:Oldest-Latest',
    'Buyer\'s Name: A-Z',
    'Buyer\'s Name: Z-A',
    'Amount:Low to High',
    'Amount:High to Low',
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return RadioListTile(
          value: index,
          activeColor: MyColors.pnbcolorPrimary,
          groupValue: value,
          onChanged: (ind) => setState(() => value = ind!),
          title: Text(items[index]),
        );
      },
      itemCount: items.length,
    );
  }
}
