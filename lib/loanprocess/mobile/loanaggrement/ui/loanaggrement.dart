import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';
import 'package:webviewx/webviewx.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/helpers/themhelper.dart';
import '../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';
import '../../loanaggrementcompleted/model/loanaggcompeletedvm.dart';

Widget LoanAgreementScreen(LoanAggVM viewModel) {
  return ChangeNotifierProvider<LoanAggVM>(
    create: (BuildContext context) => viewModel,
    child: Consumer<LoanAggVM>(builder: (context, viewModel, _) {
      return LoanAgreementView(viewModel);
    }),
  );
}

Widget LoanAgreementView(LoanAggVM viewModel) {
  return ChangeNotifierProvider(
      create: (BuildContext context) => viewModel,
      child: Consumer<LoanAggVM>(builder: (context, viewModel, _) {
        return Scaffold(
            appBar: getAppBarWithStepDone("3", "Documentation", 2.0, onClickAction: () => {Navigator.pop(context)}),
            body: Container(child: setUpViewData(viewModel)),
            bottomNavigationBar: BottomAppBar(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                child: SizedBox(height: 55.h, child: ShareInvoiceButtonUI(viewModel)),
              ),
              elevation: 0,
            ));
      }));
}

Widget setUpViewData(LoanAggVM viewModel) {
  return Padding(
    padding: EdgeInsets.only(left: 20.w, right: 20.w),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 35.h),
          SvgPicture.asset(
            AppUtils.path(IMG_PNB_BANK_NAME),
            height: 35.h,
            width: 180.w,
          ),
          SizedBox(height: 51.h),
          Text(
            str_Loan_Agreement,
            style: ThemeHelper.getInstance()!.textTheme.headline1,
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Text(
                str_Deposit_ac,
                style: ThemeHelper.getInstance()!.textTheme.headline3,
              ),
              SizedBox(width: 15.w),
              smallPnbImg(viewModel),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Punjab National Bank",
                    style:
                        ThemeHelper.getInstance()!.textTheme.headline6!.copyWith(color: MyColors.black, fontSize: 14),
                  ),
                  Text(
                    str_ac_no + ":9521521425328574",
                    style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(fontSize: 14),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 20.h),
          Padding(padding: EdgeInsets.only(left: 160.w), child: BtnDownload(viewModel)),
          setAggMentData(viewModel)
        ],
      ),
    ),
  );
}

Widget smallPnbImg(LoanAggVM viewModel) {
  return Container(
      decoration: BoxDecoration(
        color: ThemeHelper.getInstance()!.colorScheme.onPrimary,
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        AppUtils.path(SMALLBANKLOGO),
        height: 15.h,
        width: 15.w,
      ));
}

Widget setAggMentData(LoanAggVM viewModel) {
  return Container(
      decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: WebViewX(
        key: const ValueKey('webviewx'),
        initialContent:
            "<p>Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante. Donec eu libero sit amet quam egestas semper. Aenean ultricies mi vitae est. Mauris placerat eleifend leo.</p>",
        initialSourceType: SourceType.html,
        height: 403.h,
        width: MediaQuery.of(viewModel.context).size.width,
      ));
}

Widget BtnDownload(LoanAggVM viewModel) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: MyColors.pnbCheckboxTextColor,
          style: BorderStyle.solid,
          width: 1.0,
        )),
    width: 150.w,
    height: 30.h,
    child: Center(
        child: TextButton(
      onPressed: () {},
      child: Align(
          alignment: Alignment.center,
          child: Text(
            str_download,
            style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(color: MyColors.ligtBlue),
            textAlign: TextAlign.center,
          )),
    )),
  );
}

Widget ShareInvoiceButtonUI(LoanAggVM viewModel) {
  return Container(
    color: ThemeHelper.getInstance()!.backgroundColor,
    height: 55.h,
    child: ElevatedButton(
      onPressed: () {},
      child: Center(
        child: Text(
          str_i_agree,
          style: ThemeHelper.getInstance()?.textTheme.button,
        ),
      ),
    ),
  );
}
