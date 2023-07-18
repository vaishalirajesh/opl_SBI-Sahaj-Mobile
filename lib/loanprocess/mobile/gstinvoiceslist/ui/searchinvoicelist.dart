import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gstmobileservices/model/models/gst_invoicelist_response_main.dart';
import 'package:sbi_sahay_1_0/utils/helpers/myfonts.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/colorutils/mycolors.dart';

class SearchInvoiceList extends StatelessWidget {
  List<GstInvoiceDataObj>? arrInvoiceList;

  SearchInvoiceList({this.arrInvoiceList, super.key});

  @override
  Widget build(BuildContext context) {
    return SearchInvoiceListScreen(arrInvoiceList);
  }
}

class SearchInvoiceListScreen extends StatefulWidget {
  List<GstInvoiceDataObj>? arrInvoiceList;

  SearchInvoiceListScreen(this.arrInvoiceList, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _SearchInvoiceListScreenState();
  }
}

class _SearchInvoiceListScreenState extends State<SearchInvoiceListScreen> {
  TextEditingController searchTextController = TextEditingController();
  String? searchText;
  List<GstInvoiceDataObj>? filterInvoiceList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Container(
            height: 80.h,
            color: ThemeHelper.getInstance()?.primaryColor,
            child: Center(
              child: TextFormField(
                  autofocus: true,
                  controller: searchTextController,
                  style: ThemeHelper.getInstance()?.textTheme.button?.copyWith(fontFamily: MyFont.Nunito_Sans_Regular),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    prefixIcon: GestureDetector(
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 25.h,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    border: InputBorder.none,
                    hintText: 'Search',
                    hintStyle:
                        ThemeHelper.getInstance()?.textTheme.button?.copyWith(fontFamily: MyFont.Nunito_Sans_Regular),
                  ),
                  onChanged: (searchValue) {
                    setState(() {
                      searchText = searchValue;
                      filterInvoiceList = widget.arrInvoiceList
                          ?.where((invoiceData) =>
                              invoiceData.buyerName?.toLowerCase().contains(searchText.toString().toLowerCase()) ==
                                  true ||
                              invoiceData.invoiceData?.invNum
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchText.toString().toLowerCase()) ==
                                  true ||
                              invoiceData.invoiceData?.invValue
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchText.toString().toLowerCase()) ==
                                  true ||
                              invoiceData.invoiceData?.invDate
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchText.toString().toLowerCase()) ==
                                  true)
                          .toList();
                      ;
                      print(filterInvoiceList);
                    });
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("(?!^ +\$)^[a-zA-Z0-9 _]+\$"), replacementString: "")
                  ]),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 20.w), child: invoiceListContainer())
            ],
          ),
        ),
      ),
    );
  }

  Widget invoiceListContainer() {
    if (widget.arrInvoiceList?.isEmpty == true) {
      return SizedBox(
        height: 0.8.sh,
        width: 1.sw,
        child: Center(
            child: Text(
          "No Data Found!",
          style: ThemeHelper.getInstance()
              ?.textTheme
              .headline4
              ?.copyWith(fontSize: 16.sp, fontFamily: MyFont.Nunito_Sans_Semi_bold),
          textAlign: TextAlign.center,
        )),
      );
    } else if (searchTextController.text.isNotEmpty && filterInvoiceList?.isEmpty == true) {
      return SizedBox(
        height: 0.8.sh,
        width: 1.sw,
        child: Center(
            child: Text(
          "No Data Found!",
          style: ThemeHelper.getInstance()
              ?.textTheme
              .headline4
              ?.copyWith(fontSize: 16.sp, fontFamily: MyFont.Nunito_Sans_Semi_bold),
          textAlign: TextAlign.center,
        )),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: searchTextController.text.isEmpty ? widget.arrInvoiceList?.length : filterInvoiceList?.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                key: searchTextController.text.isEmpty
                    ? ValueKey(widget.arrInvoiceList?[index].buyerName.toString())
                    : ValueKey(filterInvoiceList?[index].buyerName.toString()),
                child: searchTextController.text.isEmpty
                    ? invoiceDataUI(widget.arrInvoiceList?[index])
                    : invoiceDataUI(filterInvoiceList?[index]),
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
  }

  Widget invoiceDataUI(GstInvoiceDataObj? gstInvoiceDataObj) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 200.w,
              child: Text(
                gstInvoiceDataObj?.buyerName.toString() ?? "",
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .headline2!
                    .copyWith(fontSize: 14, fontFamily: MyFont.Nunito_Sans_Bold),
                maxLines: 5,
              ),
            ),
            Text(AppUtils.convertIndianCurrency(gstInvoiceDataObj?.invoiceData?.invValue?.toString()),
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
            Text(AppUtils.convertDateFormat(gstInvoiceDataObj?.invoiceData!.invDate!.toString(), "dd-MM-yyyy", 'd MMM'),
                style: ThemeHelper.getInstance()!.textTheme.bodyText2),
            Text(" \u2022 ${gstInvoiceDataObj?.invoiceData?.invNum}" ?? "",
                style: ThemeHelper.getInstance()!.textTheme.bodyText2),
          ],
        ),
      ]),
    );
  }
}
