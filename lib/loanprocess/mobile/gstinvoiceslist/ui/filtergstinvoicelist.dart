import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/colorutils/mycolors.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/helpers/themhelper.dart';
import '../../../../utils/strings/strings.dart';

class GSTInvoiceListFilter extends StatelessWidget {
  const GSTInvoiceListFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: Scaffold(
                //resizeToAvoidBottomInset: false,
                appBar: getAppBarWithStepDone("2", str_loan_approve_process, 0.30,
                    onClickAction: () => {Navigator.pop(context)}),
                body: GSTInvoiceListFilterScreen()));
      },
    );
  }
}

class GSTInvoiceListFilterScreen extends StatefulWidget {
  const GSTInvoiceListFilterScreen({super.key});

  @override
  GSTInvoiceListFilterScreenState createState() => GSTInvoiceListFilterScreenState();
}

class GSTInvoiceListFilterScreenState extends State<GSTInvoiceListFilterScreen> {
  var dict = [
    {"sortby": "Invoice Date: Latest - Oldest (Default)", "isSelected": "0"},
    {"sortby": "Invoice Date: Oldest - Latest", "isSelected": "0"},
    {"sortby": "Buyer's Name: A - Z", "isSelected": "0"},
    {"sortby": "Buyer's Name: Z - A", "isSelected": "0"},
    {"sortby": "Amount: Low to High", "isSelected": "0"},
    {"sortby": "Amount: High to Low", "isSelected": "0"}
  ];

  @override
  Widget build(BuildContext context) {
    return sortByBottomSheetDialog();
  }

  Widget sortByBottomSheetDialog() {
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          SizedBox(height: 25.h),
          Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            Spacer(),
            Text(
              str_SortBy,
              style: ThemeHelper.getInstance()?.textTheme.headline2!.copyWith(color: MyColors.pnbcolorPrimary),
            ),
            Spacer(),
            GestureDetector(
              child: Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: SvgPicture.asset(AppUtils.path(IMG_CLOSE_X), height: 10.h, width: 10.w)),
              onTap: () {},
            ),
          ]),
          SizedBox(height: 10.h),
          Divider(),
          sortByDialogContent(),
          Padding(padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 30.h), child: applySortButton())
        ]));
  }

  Widget sortByDialogContent() {
    return Container(
        height: 230.h,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: dict.length,
          itemBuilder: (context, index) {
            return Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(children: [
                  ListTile(
                      onTap: () {
                        setState(() {
                          // setISSelectedValue(index);
                        });
                      },
                      title: Text(dict[index]["sortby"]!,
                          style: ThemeHelper.getInstance()!.textTheme.headline2!.copyWith(fontSize: 16)),
                      trailing: dict[index]["isSelected"] == "0"
                          ? Icon(
                              Icons.radio_button_off,
                              color: ThemeHelper.getInstance()!.disabledColor,
                              size: 20.0,
                            )
                          : Icon(
                              Icons.radio_button_on,
                              color: ThemeHelper.getInstance()!.disabledColor,
                              size: 20.0,
                            )),
                ]),
              ),
            );
          },
        ));
  }

  Widget applySortButton() {
    return Container(
      height: 55.h,
      child: ElevatedButton(
          onPressed: () {
            // Navigator.pushNamed(viewModel.context, MyRoutes.infoShareRoutes);
          },
          child: Center(
            child: Text(
              str_Apply,
              style: ThemeHelper.getInstance()?.textTheme.button,
            ),
          ),
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
          )),
    );
  }
}
