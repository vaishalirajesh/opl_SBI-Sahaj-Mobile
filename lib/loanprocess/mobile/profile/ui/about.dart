import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sbi_sahay_1_0/utils/helpers/myfonts.dart';

import '../../../../utils/helpers/themhelper.dart';
import '../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.h),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: ThemeHelper.getInstance()!.dividerColor,
                    offset: const Offset(0, 2.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: getAppBarWithTitle(
                "About GST Sahay",
                onClickAction: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          body: Container(padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h), child: _aboutContent()),
          /*bottomNavigationBar: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 30.h),
            child: AppButton(
              title: str_ok,
              onPress: () {
                Navigator.pop(context);
              },
            ),
          ),*/
        ),
      ),
    );
  }
}

Widget _aboutContent() {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: 'The MSME Sahaj is in line with the Open Credit Enablement Network (OCEN) specifications.\n',
          style: ThemeHelper.getInstance()!.textTheme.bodyMedium,
        ),
        // TextSpan(
        //   text:
        //       'GST Sahay is a revolutionary product that has been designed keeping in mind the needs of small and medium-sized businesses. This solution will made the process of applying for a loan simpler, as we understand that getting a loan can be a cumbersome and time-consuming process.\n\n',
        //   style: ThemeHelper.getInstance()!.textTheme.bodyMedium,
        // ),
        TextSpan(
          text: '\nFeatures\n',
          style: ThemeHelper.getInstance()!.textTheme.bodyMedium?.copyWith(fontFamily: MyFont.Nunito_Sans_Bold),
        ),
        TextSpan(
          text: 'Based on standard OCEN protocols.\n',
          style: ThemeHelper.getInstance()!.textTheme.bodyMedium,
        ),
        TextSpan(
          text:
              'Can leverage AAs to digitally get bank account details and can access GST data, both directly from source.\n',
          style: ThemeHelper.getInstance()!.textTheme.bodyMedium,
        ),
        TextSpan(
          text: 'Offer instant small ticket, collateral-free, cash flow-based loans to MSMEs against its invoices.\n',
          style: ThemeHelper.getInstance()!.textTheme.bodyMedium,
        ),
        TextSpan(
          text:
              'Entire loan process is digital from lead generation to disbursement and is expected to be completed within minutes.\n',
          style: ThemeHelper.getInstance()!.textTheme.bodyMedium,
        ),
        TextSpan(
          text: 'Real time digital application & offers.\n',
          style: ThemeHelper.getInstance()!.textTheme.bodyMedium,
        ),
        TextSpan(
          text: 'Immediate disbursement & digital collection through Standing instructions.',
          style: ThemeHelper.getInstance()!.textTheme.bodyMedium,
        ),
      ],
    ),
  );
}
