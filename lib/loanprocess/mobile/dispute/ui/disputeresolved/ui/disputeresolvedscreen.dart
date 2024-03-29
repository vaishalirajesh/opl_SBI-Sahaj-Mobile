import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../utils/Utils.dart';
import '../../../../../../utils/colorutils/mycolors.dart';
import '../../../../../../utils/constants/imageconstant.dart';
import '../../../../../../utils/helpers/myfonts.dart';
import '../../../../../../utils/helpers/themhelper.dart';
import '../../../../../../utils/strings/strings.dart';
import '../../../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';

class DisputeResolvedMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SafeArea(
          child: WillPopScope(
              onWillPop: () async {
                return true;
              },
              child: DisputeResolvedScreen()));
    });
  }
}

class DisputeResolvedScreen extends StatefulWidget {
  const DisputeResolvedScreen({Key? key}) : super(key: key);

  @override
  State<DisputeResolvedScreen> createState() => _DisputeResolvedScreenState();
}

class _DisputeResolvedScreenState extends State<DisputeResolvedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBarWithTitle(str_dispute_tracker, onClickAction: () => {Navigator.pop(context)}),
      body: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppUtils.path(MOBILESTEPDONE),
              height: 75.h,
              width: 75.w,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15.h, top: 25.h),
              child: Text(
                str_dispute_resolved,
                style: ThemeHelper.getInstance()?.textTheme.headline1,
              ),
            ),
            Text(
              str_dispute_resolved_txt,
              style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(
                  fontFamily: MyFont.Nunito_Sans_Semi_bold, color: ThemeHelper.getInstance()?.indicatorColor),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.h),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  border: Border.all(
                    width: 2,
                    color: ThemeHelper.getInstance()!.colorScheme.onSurface,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            str_loan_app_id,
                            style: ThemeHelper.getInstance()?.textTheme.headline5,
                          ),
                          Row(
                            children: [
                              Text(
                                'PL32005034179004',
                                style: ThemeHelper.getInstance()
                                    ?.textTheme
                                    .headline5
                                    ?.copyWith(color: ThemeHelper.getInstance()?.primaryColor),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Icon(
                                Icons.copy,
                                color: ThemeHelper.getInstance()?.primaryColor,
                                size: 12.h,
                              )
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              str_dispute_date,
                              style: ThemeHelper.getInstance()?.textTheme.headline5,
                            ),
                            Text(
                              'November 7, 2022',
                              style: ThemeHelper.getInstance()
                                  ?.textTheme
                                  .headline5
                                  ?.copyWith(color: ThemeHelper.getInstance()?.primaryColor),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            str_Stage,
                            style: ThemeHelper.getInstance()?.textTheme.headline5,
                          ),
                          Text(
                            'Documentation & KYC',
                            style: ThemeHelper.getInstance()
                                ?.textTheme
                                .headline5
                                ?.copyWith(color: ThemeHelper.getInstance()?.primaryColor),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 50.w, right: 50.w, top: 25.h, bottom: 20.h),
              child: Text(
                str_further_equiry_contact,
                style: ThemeHelper.getInstance()?.textTheme.headline3?.copyWith(
                    fontFamily: MyFont.Nunito_Sans_Semi_bold, color: ThemeHelper.getInstance()?.indicatorColor),
                maxLines: 5,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.email_sharp,
                        color: MyColors.pnbTextcolor,
                        size: 12.h,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        'newdelhi@sidbi.in',
                        style: ThemeHelper.getInstance()?.textTheme.headline5?.copyWith(color: MyColors.pnbTextcolor),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_in_talk_sharp,
                        color: MyColors.pnbTextcolor,
                        size: 12.h,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        '079-41055000',
                        style: ThemeHelper.getInstance()?.textTheme.headline5?.copyWith(color: MyColors.pnbTextcolor),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomSheet: OkButtonUI(context),
    );
  }
}

Widget OkButtonUI(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(bottom: 20.h, left: 20.h, right: 20.h),
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: 50.h,
      child: ElevatedButton(
          onPressed: () {},
          child: Center(
            child: Text(
              str_ok,
              style: ThemeHelper.getInstance()?.textTheme.button,
            ),
          )),
    ),
  );
}
