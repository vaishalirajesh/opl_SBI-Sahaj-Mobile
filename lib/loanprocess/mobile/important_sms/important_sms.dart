import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';

import '../../../disbursed/mobile/proceedtodisbursed/ui/loaderprepareloandisbursement.dart';
import '../../../utils/Utils.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/helpers/themhelper.dart';

class ImportantSMSMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SafeArea(
          child: WillPopScope(
              onWillPop: () async {
                return true;
              },
              child: ImportantSMSMains()));
    });
  }
}

class ImportantSMSMains extends StatefulWidget {
  @override
  ImportantSMSMainBody createState() => new ImportantSMSMainBody();
}

class ImportantSMSMainBody extends State<ImportantSMSMains> {
  @override
  Widget build(BuildContext context) {
    return ImportantSMSScreen(context);
    ;
  }

  Widget ImportantSMSScreen(BuildContext context) {
    return Scaffold(
      //  appBar: AppBar(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [MyColors.pnbPinkColor, ThemeHelper.getInstance()!.backgroundColor],
                    begin: Alignment.bottomCenter,
                    end: Alignment.centerLeft)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 150.h),
                  _buildMiddler(context),
                  Spacer(),
                  _buildBottomSheet(context)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(top: 40.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 22.w,
            height: 16.h,
            child: SvgPicture.asset(
              AppUtils.path(MOBILEBACKARROWBROWN),
              height: 20.h,
              width: 40.w,
            ),
          )
        ],
      ),
    );
  }

  _buildMiddler(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                height: 127.h,
                AppUtils.path(IMPORTANTMAIL),
                fit: BoxFit.fill,
              ),
              //   Lottie.asset(Utils.path(IMPORTANTMAIL),
              //   height: 127.h,
              //   //80.w,
              //   repeat: true,
              //   reverse: false,
              //   animate: true,
              //   frameRate: FrameRate.max,
              //   fit: BoxFit.fill
              //   ,
              // ),
              _buildMiddlerText()
            ]),
      ),
    );
  }

  _buildMiddlerText() {
    return Column(
      children: [
        Text(
          str_Important_with_excl,
          style: ThemeHelper.getInstance()!.textTheme.headline1,
        ),
        SizedBox(
          height: 19.h,
        ),
        Text(
          str_Important_sentence,
          style: ThemeHelper.getInstance()!.textTheme.headline4,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 55.h,
        )
      ],
    );
  }

  _buildBottomSheet(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // Navigator.pushNamed(context, MyRoutes.LoaderPrepareLoanDisbursmentRoutes);
              //    Navigator.of(context).push(CustomRightToLeftPageRoute(child: LoaderPrepareLoanDisbursment(), ));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoaderPrepareLoanDisbursment(),
                  ));
            },
            child: Text(str_ok),
          ),
          SizedBox(
            height: 20.h,
          )
        ],
      ),
    );
  }
}
