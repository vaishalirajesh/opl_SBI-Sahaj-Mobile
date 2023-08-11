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
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/data_format_utils.dart';
import 'package:gstmobileservices/util/tg_net_util.dart';
import 'package:intl/intl.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/transactions/common_card/disbursed/disbursed_transaction.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/transactions/common_card/overdue/overdue_transaction.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/transactions/common_card/repaid/repaid_transaction.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/constants/statusConstants.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/internetcheckdialog.dart';
import 'package:sbi_sahay_1_0/utils/progressLoader.dart';
import 'package:sbi_sahay_1_0/widgets/animation_routes/shimmer_widget.dart';

import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/helpers/myfonts.dart';
import '../../../../utils/strings/strings.dart';
import '../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';

class TransactionsMain extends StatelessWidget {
  const TransactionsMain({super.key});

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

class _TranscationTabBarState extends State<TranscationTabBar> with SingleTickerProviderStateMixin {
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
  bool isListLoaded = false;
  String userName = '';
  var sortList = [
    "Invoice Date: Latest - Oldest",
    "Invoice Date: Oldest - Latest",
    "Buyer's Name: A - Z",
    "Buyer's Name: Z - A",
    "Amount: Low to High",
    "Amount: High to Low"
  ];
  List<bool> isSortByChecked = [true, false, false, false, false, false];
  int selectedSortOption = 0;
  List<SharedInvoice>? arrInvoiceList = [];
  bool isDataChnaged = false;
  var isOutstandingCardHide = true;
  String createDueDate(String date) {
    if (date.isNotEmpty) {
      DateTime dt = DateTime.parse(date);
      String formattedDate = DateFormat('MM/dd/yyyy').format(dt);
      return formattedDate;
    } else {
      return '-';
    }
  }

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 4);
    tabController.index = TGSession.getInstance().get("TabIndex") ?? 0;
    getUserData();
    getLoansByReferenceId();
    tabController.addListener(() {
      setSelectedList();
      TGLog.d("On tab chnage listner----inde: ${tabController.index}---");
    });
    super.initState();
  }

  void getUserData() async {
    userName = await TGSharedPreferences.getInstance().get(PREF_BUSINESSNAME) ?? '';
  }

  Future<void> getLoansByReferenceId() async {
    if (await TGNetUtil.isInternetAvailable()) {
      getAllLoansByReferenceId();
    } else {
      showSnackBarForintenetConnection(context, getAllLoansByReferenceId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (_scaffoldKey.currentState!.isDrawerOpen) {
            _scaffoldKey.currentState!.closeDrawer();
            return false;
          } else {
            Navigator.pop(context);
            return true;
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          drawer: MyDrawer(
            userName: userName,
            screenName: "Transactions",
          ),
          // backgroundColor: ThemeHelper.getInstance()?.colorScheme.primary,
          appBar: buildAppBar(),
          body: Builder(builder: (context) {
            return TabBarView(
              controller: tabController,
              children: [
                buildTabView(fetchTranstaion()),
                buildTabView(overDueTransaction()),
                buildTabView(repaidTransaction()),
                buildTabView(disbursedTransaction()),
              ],
            );
          }),
        ),
      ),
    );
  }

  buildAppBar() => AppBar(
        elevation: 0,
        backgroundColor: ThemeHelper.getInstance()?.colorScheme.background,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100.0.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              getAppBarMainDashboard("2", str_loan_approve_process, 0.25,
                  onClickAction: () => {_scaffoldKey.currentState?.openDrawer()}),
              buildAppBarBottomPart()
            ],
          ),
        ),
      );

  buildAppBarUpperPart() => Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 0.h),
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
                    AppUtils.path(MOBILEMENUBAR),
                  ),
                  onTap: () {},
                ),
                Padding(
                  padding: EdgeInsets.only(left: 70.w),
                  child: SvgPicture.asset(
                    AppUtils.path(SAHAJLOGOWITHOUTTEXT),
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
                SvgPicture.asset(AppUtils.path(NOTIFICATIONICON), height: 20.h, width: 20.w),
                SizedBox(
                  width: 8.w,
                ),
                SvgPicture.asset(AppUtils.path(LOGOUT), height: 20.h, width: 20.w)
              ],
            )
          ],
        ),
      );

  buildAppBarBottomPart() => Container(
        decoration: BoxDecoration(
          color: MyColors.white,
        ),
        child: buildTabRow(),
      );

  buildAppBarTitleText(String title) => Text(
        title,
        style: ThemeHelper.getInstance()!.textTheme.headline5!.copyWith(fontSize: 25.sp, color: MyColors.white),
      );

  buildAppBarIcon(String path) => SizedBox(
        width: 20.w,
        height: 20.h,
        child: SvgPicture.asset(
          AppUtils.path(path),
          //
        ),
      );

  buildTabRow() => Padding(
        padding: EdgeInsets.only(left: 0.w, right: 0.w),
        child: Column(
          children: [
            Container(
              height: 50.h,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(0.r), bottomLeft: Radius.circular(0.r)),
                border: Border.all(width: 1, color: ThemeHelper.getInstance()!.primaryColor),
                //color: ThemeHelper.getInstance()!.primaryColor,

                gradient: LinearGradient(
                    colors: [MyColors.lightRedGradient, MyColors.lightBlueGradient],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Transactions",
                  style: ThemeHelper.getInstance()!.textTheme.button!.copyWith(color: MyColors.white),
                ),
              ),
            ),
            buildFirstPartAppBar(),
            // buildBottomPartAppBar()
          ],
        ),
      );

  buildTabWidget(String title, int index) => Tab(
      child: Text(title,
          style: TextStyle(fontSize: 15.sp, color: setColor(index), fontFamily: MyFont.Nunito_Sans_Semi_bold)));

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
    return Padding(
      padding: EdgeInsets.all(12.h),
      child: InkWell(
        onTap: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (BuildContext context, StateSetter setModelState) {
                return Center(child: buildSortByWidget(setModelState));
              });
            },
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SvgPicture.asset(AppUtils.path(IMG_FILTER_INVOICE), height: 15.h, width: 15.w),
            SizedBox(
              width: 8.w,
            ),
            Text(
              'Sort',
              style: ThemeHelper.getInstance()?.textTheme.headline6,
            )
          ],
        ),
      ),
    );
  }

  Widget buildSortByWidget(StateSetter setModelState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
            child: Material(
              color: ThemeHelper.getInstance()!.cardColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10.h),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // const Spacer(),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              str_SortBy,
                              style: ThemeHelper.getInstance()
                                  ?.textTheme
                                  .headline2!
                                  .copyWith(color: MyColors.pnbcolorPrimary),
                            ),
                          ),
                        ),
                        InkWell(
                          child: Padding(
                            padding: EdgeInsets.only(right: 15.w, top: 15.h, bottom: 10.h, left: 20.w),
                            child: SvgPicture.asset(
                              AppUtils.path(IMG_CLOSE_X),
                              height: 10.h,
                              width: 10.w,
                              color: MyColors.pnbcolorPrimary,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ]),
                  const Divider(),
                  sortByDialogContent(setModelState),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 30.h),
                    child: applySortButton(setModelState),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget sortByDialogContent(StateSetter setModelState) {
    return SizedBox(
      height: 0.4.sh,
      child: ListView.builder(
        // shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: sortList.length,
        itemBuilder: (context, index) {
          return SoryByListCardUI(index, setModelState);
        },
      ),
    );
  }

  Widget applySortButton(StateSetter setModelState) {
    return SizedBox(
      height: 55.h,
      child: ElevatedButton(
        onPressed: () {
          _sortListById(selectedSortOption, setModelState);
          setOriginalList(setModelState);
          isDataChnaged = !isDataChnaged;
          Navigator.pop(context);
          setState(() {});
          setModelState(() {});
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

  void setSelectedList() {
    switch (tabController.index) {
      case 0:
        arrInvoiceList = outstanding_invoice;
        break;
      case 1:
        arrInvoiceList = overdueInvoice;
        break;
      case 2:
        arrInvoiceList = repaidInvoice;
        break;
      case 3:
        arrInvoiceList = disbursed_invoice;
        break;
    }
    setState(() {});
  }

  void setOriginalList(StateSetter setModelState) {
    switch (tabController.index) {
      case 0:
        outstanding_invoice = arrInvoiceList;
        break;
      case 1:
        overdueInvoice = arrInvoiceList;
        break;
      case 2:
        repaidInvoice = arrInvoiceList;
        break;
      case 3:
        disbursed_invoice = arrInvoiceList;
        break;
    }
    tabController.index = tabController.index;
    setModelState(() {});
    setState(() {});
  }

  void _sortListById(int index, StateSetter setModelState) {
    switch (index) {
      case 0:
        setModelState(() {
          arrInvoiceList?.sort((a, b) {
            return DataFormatUtils.convertDateFormat(a.invoiceDate, "dd-mm-yyyy", "yyyy-mm-dd").compareTo(
              DataFormatUtils.convertDateFormat(b.invoiceDate, "dd-mm-yyyy", "yyyy-mm-dd"),
            );
          });
        });
        break;

      case 1:
        setModelState(() {
          arrInvoiceList?.sort((a, b) {
            return DataFormatUtils.convertDateFormat(b.invoiceDate, "dd-mm-yyyy", "yyyy-mm-dd").compareTo(
              DataFormatUtils.convertDateFormat(a.invoiceDate, "dd-mm-yyyy", "yyyy-mm-dd"),
            );
          });
        });
        break;

      case 2:
        setModelState(() {
          arrInvoiceList?.sort((a, b) {
            return a.buyerName.toString().toLowerCase().compareTo(
                  b.buyerName.toString().toLowerCase(),
                );
          });
        });
        break;

      case 3:
        setModelState(() {
          arrInvoiceList?.sort((a, b) {
            return b.buyerName.toString().toLowerCase().compareTo(a.buyerName.toString().toLowerCase());
          });
        });
        break;

      case 4:
        setModelState(() {
          arrInvoiceList?.sort((a, b) {
            return a.invoiceAmount?.compareTo(b.invoiceAmount ?? 0) ?? 0;
          });
        });
        break;

      case 5:
        setModelState(() {
          arrInvoiceList?.sort((a, b) {
            return b.invoiceAmount?.compareTo(a.invoiceAmount ?? 0) ?? 0;
          });
          arrInvoiceList?.reversed;
        });
        break;
    }
  }

  Widget SoryByListCardUI(int index, StateSetter setModelState) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 5.h,
        left: 10.w,
      ),
      child: GestureDetector(
        onTap: () {
          setModelState(() {
            for (int i = 0; i < isSortByChecked.length; i++) {
              isSortByChecked[i] = false;
            }
            isSortByChecked[index] = true;
          });
          setModelState(() {
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
                setModelState(() {
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

  buildBottomPartAppBar() => Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [Expanded(child: searchBar()), filterInvoiceButton()],
          ),
        ),
      );

  Widget searchBar() {
    return SizedBox(
      height: 45.h,
      child: TextFormField(
          autofocus: false,
          controller: searchTextController,
          style: ThemeHelper.getInstance()?.textTheme.headline4?.copyWith(fontFamily: MyFont.Nunito_Sans_Regular),
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
            hintStyle: ThemeHelper.getInstance()?.textTheme.headline4?.copyWith(fontFamily: MyFont.Nunito_Sans_Regular),
          ),
          onChanged: (searchValue) {
            setState(() {
              searchText = searchValue;
              if (tabController.index == 0) {
                outstanding_invoice
                    ?.where((invoiceData) =>
                        invoiceData.buyerName?.toLowerCase().contains(searchValue.toString().toLowerCase()) == true ||
                        invoiceData.loanId?.toString().toLowerCase().contains(searchValue.toString().toLowerCase()) ==
                            true ||
                        invoiceData.loanAmount
                                ?.toString()
                                .toLowerCase()
                                .contains(searchValue.toString().toLowerCase()) ==
                            true ||
                        invoiceData.invoiceAmount
                                ?.toString()
                                .toLowerCase()
                                .contains(searchValue.toString().toLowerCase()) ==
                            true)
                    .toList();
              } else if (tabController.index == 1) {
                overdueInvoice
                    ?.where((invoiceData) =>
                        invoiceData.buyerName?.toLowerCase().contains(searchText.toString().toLowerCase()) == true ||
                        invoiceData.loanId?.toString().toLowerCase().contains(searchText.toString().toLowerCase()) ==
                            true ||
                        invoiceData.loanAmount
                                ?.toString()
                                .toLowerCase()
                                .contains(searchText.toString().toLowerCase()) ==
                            true ||
                        invoiceData.invoiceAmount
                                ?.toString()
                                .toLowerCase()
                                .contains(searchText.toString().toLowerCase()) ==
                            true)
                    .toList();
              } else if (tabController.index == 2) {
                repaidInvoice
                    ?.where((invoiceData) =>
                        invoiceData.buyerName?.toLowerCase().contains(searchText.toString().toLowerCase()) == true ||
                        invoiceData.loanId?.toString().toLowerCase().contains(searchText.toString().toLowerCase()) ==
                            true ||
                        invoiceData.loanAmount
                                ?.toString()
                                .toLowerCase()
                                .contains(searchText.toString().toLowerCase()) ==
                            true ||
                        invoiceData.invoiceAmount
                                ?.toString()
                                .toLowerCase()
                                .contains(searchText.toString().toLowerCase()) ==
                            true)
                    .toList();
              } else if (tabController.index == 3) {
                disbursed_invoice
                    ?.where((invoiceData) =>
                        invoiceData.buyerName?.toLowerCase().contains(searchText.toString().toLowerCase()) == true ||
                        invoiceData.loanId?.toString().toLowerCase().contains(searchText.toString().toLowerCase()) ==
                            true ||
                        invoiceData.loanAmount
                                ?.toString()
                                .toLowerCase()
                                .contains(searchText.toString().toLowerCase()) ==
                            true ||
                        invoiceData.invoiceAmount
                                ?.toString()
                                .toLowerCase()
                                .contains(searchText.toString().toLowerCase()) ==
                            true)
                    .toList();
              }
            });
            setState(() {});
          },
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("(?!^ +\$)^[a-zA-Z0-9 _]+\$"), replacementString: "")
          ]),
    );
  }

  //Api call
  Future<void> getAllLoansByReferenceId() async {
    String gstin = await TGSharedPreferences.getInstance().get(PREF_GSTIN);
    TGGetRequest tgGetRequest = GetAllInvoiceLoanDetailByRefIdReq(gstin: gstin);
    TGLog.d("getAllLoansByReferenceId request: $tgGetRequest");
    ServiceManager.getInstance().getAllInvoiceLoanDetailByRefId(
        request: tgGetRequest,
        onSuccess: (response) => _onSuccessGet2AllLoanDetailByRefId(response),
        onError: (error) => _onErrorGet2AllLoanDetailByRefId(error));
  }

  _onSuccessGet2AllLoanDetailByRefId(GetAllInvoiceLoansResponse? response) {
    TGLog.d("getAllLoansByReferenceId onSuccess(): $response");
    if (response?.getAllLoanDetailObj().status == RES_DETAILS_FOUND) {
      if (mounted) {
        setState(() {
          getAllLoanDetailByRefIdResMainobj = response?.getAllLoanDetailObj();
          obj = getAllLoanDetailByRefIdResMainobj?.data;
          outstanding_invoice = obj?.outstandingInvoice;
          disbursed_invoice = obj?.disbursedInvoice;
          repaidInvoice = obj?.repaidInvoice;
          overdueInvoice = obj?.overdueInvoice;
          isListLoaded = true;
          setSelectedList();
        });
      }
    } else {
      setState(() {
        isListLoaded = true;
      });
      LoaderUtils.handleErrorResponse(
          context, response?.getAllLoanDetailObj().status, response?.getAllLoanDetailObj().message, null);
    }
  }

  _onErrorGet2AllLoanDetailByRefId(TGResponse errorResponse) {
    setState(() {
      isListLoaded = true;
    });
    TGLog.d("GetAllInvoiceLoansResponse : onError()");
  }

  Widget fetchTranstaion() {
    return Column(
      children: [
        buildBottomPartAppBar(),
        Text(isDataChnaged ? "Hello" : "Data chnaged"),
        Expanded(
          child: outstanding_invoice?.isEmpty == true
              ? Center(
                  child: Text(
                    "No Data Found!",
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline4
                        ?.copyWith(fontSize: 16.sp, fontFamily: MyFont.Nunito_Sans_Semi_bold),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: !isListLoaded ? 3 : outstanding_invoice?.length ?? 0,
                  itemBuilder: (context, index) {
                    return !isListLoaded
                        ? shimmerLoader()
                        : Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: MyColors.pnbPinkColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.r),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    // setOutstandingCardUI(),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isOutstandingCardHide = !isOutstandingCardHide;
                                        });
                                      },
                                      child: setOutstandingCardUI(index: index),
                                    ) //showHideCardViewUI()),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15.h,
                              )
                            ],
                          );
                  },
                ),
        )
      ],
    );
  }

  Widget setOutstandingCardUI({required int index}) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.white,
        border: Border.all(color: MyColors.pnbTextcolor.withOpacity(0.1)),
        borderRadius: BorderRadius.all(
          Radius.circular(12.r),
        ),
      ),
      child: Column(
        children: [
          isOutstandingCardHide
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: setOutStandingCardView(index: index),
                )
              : setOutStandingCardBottomView(index: index),
          //isCardHide ? Container() : setOutStandingCardBottomView()
        ],
      ),
    );
  }

  Widget setOutStandingCardView({required int index}) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      outstanding_invoice?[index].buyerName ?? '',
                      style: ThemeHelper.getInstance()!.textTheme.headline5!.copyWith(
                            fontSize: 14.sp,
                            color: MyColors.pnbcolorPrimary,
                          ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      'Invoice: ${outstanding_invoice?[index]?.invoiceNumber}',
                      style: ThemeHelper.getInstance()!
                          .textTheme
                          .headline4!
                          .copyWith(fontSize: 12.sp, color: MyColors.pnbTextcolor),
                    )
                  ],
                ),
              ),
              SvgPicture.asset(
                !isOutstandingCardHide ? AppUtils.path(IMG_UP_ARROW) : AppUtils.path(IMG_DOWN_ARROW),
                height: 20.h,
                width: 20.w,
              ),
              // setDueDetailUi()
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          dividerUI(0.w),
          SizedBox(
            height: 8.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: setAmountDueUi(index: index),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //..Title Never Change
                    Text(
                      str_Due_date,
                      style: ThemeHelper.getInstance()!.textTheme.overline!,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      createDueDate(outstanding_invoice?[0]?.dueDate ?? ''),
                      style: ThemeHelper.getInstance()!.textTheme.overline!.copyWith(
                            fontSize: 14.sp,
                            color: MyColors.darkblack,
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //..Title Never Change
                      Text(
                        '',
                        style: ThemeHelper.getInstance()!.textTheme.overline!,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "Due in ${outstanding_invoice?[index]?.dueDays ?? '0'} ${int.parse(outstanding_invoice?[index]?.dueDays ?? "0") < 1 ? "Day" : "Days"}",
                        style: ThemeHelper.getInstance()!.textTheme.headline4!.copyWith(
                              fontSize: 12.sp,
                              color: AppUtils.getBgColorByTransactionStatus(str_Outstanding),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15.h,
          )
        ],
      ),
    );
  }

  Widget setOutStandingCardBottomView({required int index}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          setOutStandingCardView(index: index),
          dividerUI(0.w),
          SizedBox(
            height: 10.h,
          ),
          setRowColumValueOpenCard("Disbursed On", createDueDate(outstanding_invoice?[0]?.disbursedDate ?? '') ?? '-',
              "Lender", AppUtils.getBankFullName(bankName: outstanding_invoice?[0]?.bankName ?? '')),
          setRowColumValueOpenCard(
              "Invoice Date",
              AppUtils.createInvoiceDate(outstanding_invoice?[0]?.invoiceDate ?? '') ?? '-',
              "ROI",
              '${outstanding_invoice?[0]?.interestRate.toString() ?? "" + " % p.a"}% p.a.' ?? '-'),
          setRowColumValueOpenCard(
              "Loan Amount",
              AppUtils.convertIndianCurrency(outstanding_invoice?[0]?.loanAmount?.toString()) ?? '0',
              "Invoice Amount",
              AppUtils.convertIndianCurrency(outstanding_invoice?[0]?.invoiceAmount?.toString()) ?? '0'),
          setRowColumValueOpenCard(
              "Tenure",
              '${outstanding_invoice?[0]?.tenure ?? '0'} ${outstanding_invoice?[0]?.tenure == '0' ? 'Day' : 'Days'}',
              "Interest Amount",
              AppUtils.convertIndianCurrency(outstanding_invoice?[0]?.interestAmount?.toString()) ?? '0'),
          buildOutStandingBottomWidget(),
        ],
      ),
    );
  }

  Widget setRowColumValueOpenCard(String title, String value, String title2, String value2) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                // width: 66.w,
                child: Text(
                  title,
                  style: ThemeHelper.getInstance()!.textTheme.overline!,
                ),
              ),
              Text(
                value,
                style: ThemeHelper.getInstance()!.textTheme.overline!.copyWith(
                      fontSize: 14.sp,
                      color: MyColors.darkblack,
                    ),
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
        SizedBox(width: 40.w),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title2, style: ThemeHelper.getInstance()!.textTheme.overline!),
              // SizedBox(
              //   height: 5.h,
              // ),
              Text(
                value2,
                style: ThemeHelper.getInstance()!.textTheme.overline!.copyWith(
                      fontSize: 14.sp,
                      color: MyColors.darkblack,
                    ),
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget dividerUI(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Divider(
        color: MyColors.pnbGreyColor.withOpacity(0.2),
      ),
    );
  }

  Widget setAmountDueUi({required int index}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          str_Amount_due,
          style: ThemeHelper.getInstance()!.textTheme.overline!,
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          AppUtils.convertIndianCurrency(outstanding_invoice?[index]?.amountDue?.toString()),
          style: ThemeHelper.getInstance()!.textTheme.overline!.copyWith(
                fontSize: 14.sp,
                color: MyColors.darkblack,
              ),
        )
      ],
    );
  }

  Widget buildOutStandingBottomWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        setDueDetailUi(title: "Prepay Now"),
        SizedBox(height: 15.h),
        setOpenBottomViewText(status: str_Outstanding),
        SizedBox(height: 15.h),
      ],
    );
  }

  Widget setDueDetailUi({required String title}) {
    return SizedBox(
      width: 100.w,
      height: 30.h,
      child: ElevatedButton(
        onPressed: () {
          // setState(() {
          //   setState(() {
          //     isCardHide = !isCardHide;
          //   });
          //
          //   //    widget.flag = !widget.flag;
          // });
        },
        // style: ThemeHelper.getInstance()?.elevale,
        child: Text(
          title,
          style: TextStyle(fontSize: 12.sp),
        ),
      ),
    );
  }

  Widget buildOverDueBottomWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        setDueDetailUi(title: "Pay Now"),
        SizedBox(height: 15.h),
        setOpenBottomViewText(status: strOverdue),
        SizedBox(height: 15.h),
      ],
    );
  }

  Widget buildRepaidBottomWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        setOpenBottomViewText(status: strRepaid),
        SizedBox(height: 15.h),
      ],
    );
  }

  Widget setOpenBottomViewText({required String status}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (status == strOverdue)
          Text(
            "Raise dispute",
            style: ThemeHelper.getInstance()!.textTheme.headline6!.copyWith(
                  fontSize: 12.sp,
                  color: MyColors.hyperlinkcolornew,
                  decoration: TextDecoration.underline,
                  fontFamily: MyFont.Roboto_Regular,
                ),
          ),
        if (status == strOverdue || status == str_Outstanding)
          Text(
            "Request for deferment",
            style: ThemeHelper.getInstance()!.textTheme.headline6!.copyWith(
                  fontSize: 12.sp,
                  color: MyColors.hyperlinkcolornew,
                  decoration: TextDecoration.underline,
                  fontFamily: MyFont.Roboto_Regular,
                ),
          ),
        Text(
          "Contact support",
          style: ThemeHelper.getInstance()!.textTheme.headline6!.copyWith(
                fontSize: 12.sp,
                color: MyColors.hyperlinkcolornew,
                decoration: TextDecoration.underline,
                fontFamily: MyFont.Roboto_Regular,
              ),
        ),
      ],
    );
  }

  Widget repaidTransaction() {
    return Column(
      children: [
        buildBottomPartAppBar(),
        Expanded(
          child: repaidInvoice?.isEmpty == true
              ? Center(
                  child: Text(
                    "No Data Found!",
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline4
                        ?.copyWith(fontSize: 16.sp, fontFamily: MyFont.Nunito_Sans_Semi_bold),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: !isListLoaded ? 3 : repaidInvoice?.length ?? 0,
                  itemBuilder: (context, index) {
                    return !isListLoaded
                        ? shimmerLoader()
                        : Column(
                            children: [
                              RepaidCard(
                                sharedInvoice: repaidInvoice?[index],
                                bottomWidget: buildRepaidBottomWidget(),
                              ),
                              SizedBox(
                                height: 15.h,
                              )
                            ],
                          );
                  },
                ),
        ),
      ],
    );
  }

  Widget disbursedTransaction() {
    return Column(
      children: [
        buildBottomPartAppBar(),
        Expanded(
          child: disbursed_invoice?.isEmpty == true
              ? Center(
                  child: Text(
                    "No Data Found!",
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline4
                        ?.copyWith(fontSize: 16.sp, fontFamily: MyFont.Nunito_Sans_Semi_bold),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: !isListLoaded ? 3 : disbursed_invoice?.length ?? 0,
                  itemBuilder: (context, index) {
                    return !isListLoaded
                        ? shimmerLoader()
                        : Column(
                            children: [
                              DisbursedCard(
                                sharedInvoice: disbursed_invoice?[index],
                                bottomWidget: Padding(
                                  padding: EdgeInsets.only(bottom: 15.h),
                                  child: Text(
                                    "Contact support",
                                    style: ThemeHelper.getInstance()!.textTheme.headline6!.copyWith(
                                          fontSize: 12.sp,
                                          color: MyColors.hyperlinkcolornew,
                                          decoration: TextDecoration.underline,
                                          fontFamily: MyFont.Roboto_Regular,
                                        ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15.h,
                              )
                            ],
                          );
                  },
                ),
        ),
      ],
    );
  }

  Widget overDueTransaction() {
    return Column(
      children: [
        buildBottomPartAppBar(),
        Expanded(
          child: overdueInvoice?.isEmpty == true
              ? Center(
                  child: Text(
                  "No Data Found!",
                  style: ThemeHelper.getInstance()
                      ?.textTheme
                      .headline4
                      ?.copyWith(fontSize: 16.sp, fontFamily: MyFont.Nunito_Sans_Semi_bold),
                  textAlign: TextAlign.center,
                ))
              : ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: !isListLoaded ? 3 : overdueInvoice?.length ?? 0,
                  itemBuilder: (context, index) {
                    return !isListLoaded
                        ? shimmerLoader()
                        : Column(
                            // buildOverDueBottomWidget(),
                            children: [
                              OverDueCard(
                                sharedInvoice: overdueInvoice?[index],
                                bottomWidget: buildOverDueBottomWidget(),
                              ),
                              SizedBox(
                                height: 15.h,
                              )
                            ],
                          );
                  },
                ),
        ),
      ],
    );
  }

  Widget shimmerLoader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(color: MyColors.pnbCheckBoxcolor, width: 1),
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.white),
        child: Padding(
          padding: EdgeInsets.all(15.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      ShimmerWidget.rectangle(
                        height: 15.h,
                        widht: 100.w,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      ShimmerWidget.rectangle(
                        height: 15.h,
                        widht: 100.w,
                      ),
                    ],
                  ),
                  ShimmerWidget.rectangle(
                    height: 20.h,
                    widht: 100.w,
                  )
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Divider(
                thickness: 1,
                color: MyColors.pnbCheckBoxcolor,
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ShimmerWidget.rectangle(
                    height: 20.h,
                    widht: 100.w,
                  ),
                  ShimmerWidget.rectangle(
                    height: 20.h,
                    widht: 100.w,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
