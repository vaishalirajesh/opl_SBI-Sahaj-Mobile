import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbi_sahay_1_0/utils/dimenutils/dimensutils.dart';
import 'package:sbi_sahay_1_0/utils/helpers/myfonts.dart';

import '../../utils/Utils.dart';
import '../../utils/colorutils/mycolors.dart';
import '../../utils/constants/imageconstant.dart';
import '../../utils/helpers/themhelper.dart';

Widget TitleBarView(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(
        vertical: MyDimension.setHeight(
            context: context, largerScreen: 0.022, mediumlargeScreen: 0.022, tabletScreen: 0.022, mobileScreen: 0.022),
        horizontal: MyDimension.setWidthScale(
            context: context, largerScreen: 0.051, mediumlargeScreen: 0.051, tabletScreen: 0.051, mobileScreen: 0.051)),
    child: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: SvgPicture.asset(MOBILEBACKBTN,
                height: MyDimension.setHeight(
                    context: context,
                    largerScreen: 0.016,
                    mediumlargeScreen: 0.016,
                    tabletScreen: 0.016,
                    mobileScreen: 0.016),
                width: MyDimension.setHeight(
                    context: context,
                    largerScreen: 0.036,
                    mediumlargeScreen: 0.036,
                    tabletScreen: 0.036,
                    mobileScreen: 0.036)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: MyDimension.setWidthScale(
                        context: context,
                        largerScreen: 0.010,
                        mediumlargeScreen: 0.010,
                        tabletScreen: 0.010,
                        mobileScreen: 0.010)),
                child: SvgPicture.asset(
                  SMALLBANKLOGO,
                  height: MyDimension.setHeight(
                      context: context,
                      largerScreen: 0.028,
                      mediumlargeScreen: 0.028,
                      tabletScreen: 0.028,
                      mobileScreen: 0.028),
                  width: MyDimension.setHeight(
                      context: context,
                      largerScreen: 0.028,
                      mediumlargeScreen: 0.028,
                      tabletScreen: 0.028,
                      mobileScreen: 0.028),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: MyDimension.setWidthScale(
                        context: context,
                        largerScreen: 0.010,
                        mediumlargeScreen: 0.010,
                        tabletScreen: 0.010,
                        mobileScreen: 0.010)),
                child: SvgPicture.asset(
                  MOBILESAHAYLOGO,
                  height: MyDimension.setHeight(
                      context: context,
                      largerScreen: 0.028,
                      mediumlargeScreen: 0.028,
                      tabletScreen: 0.028,
                      mobileScreen: 0.028),
                  width: MyDimension.setHeight(
                      context: context,
                      largerScreen: 0.028,
                      mediumlargeScreen: 0.028,
                      tabletScreen: 0.028,
                      mobileScreen: 0.028),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

AppBar getAppBarWithTitle(String appbarTitle, {required Function onClickAction}) {
  return AppBar(
    centerTitle: true,
    automaticallyImplyLeading: false,
    title: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            child: SvgPicture.asset(
              Utils.path(MOBILEBACKBTNWHITE),
            ),
            onTap: () {
              onClickAction();
            },
          ),
          Expanded(
            child: Center(
              child: Text(
                appbarTitle,
                style: ThemeHelper.getInstance()?.textTheme.caption?.copyWith(fontFamily: MyFont.Nunito_Sans_Regular),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    ),
    backgroundColor: ThemeHelper.getInstance()?.primaryColor,
  );
}

AppBar getAppBarWithBackBtn({required Function onClickAction}) {
  return AppBar(
    title: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            child: SvgPicture.asset(
              Utils.path(MOBILEBACKBTN),
            ),
            onTap: () {
              onClickAction();
            },
          ),
        ],
      ),
    ),
    automaticallyImplyLeading: false,
    bottom: PreferredSize(
      preferredSize: Size(MyDimension.width, 3.h),
      child: Container(
          height: 2.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(0.r), bottomLeft: Radius.circular(0.r)),
              border: Border.all(width: 1, color: ThemeHelper.getInstance()!.primaryColor),
              //color: ThemeHelper.getInstance()!.primaryColor,
              gradient: LinearGradient(
                  colors: [MyColors.lightRedGradient, MyColors.lightBlueGradient],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight))),

      // LinearProgressIndicator(value: 1,
      //     semanticsLabel: '',
      //     minHeight: 3.h,
      //     color: ThemeHelper.getInstance()
      //         ?.colorScheme
      //         .primary,
      //     backgroundColor: Colors.transparent),
    ),
  );
}

AppBar getAppBarWithStep(String step, String appBarTitle, double progress, {required Function onClickAction}) {
  return AppBar(
    title: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                  Utils.path(MOBILEBACKBTN),
                ),
                onTap: () {
                  onClickAction();
                },
              ),
              SizedBox(
                width: 20.w,
              ),
              // Container(
              //   height: 20.w,
              //   width: 20.w,
              //   decoration: BoxDecoration(
              //     color: ThemeHelper.getInstance()?.colorScheme.secondary,
              //     borderRadius:BorderRadius.circular(30.r),
              //     boxShadow:  [BoxShadow(color: ThemeHelper.getInstance()!.primaryColor,spreadRadius: 1.0)]),
              //   child: Center(
              //     child: Text(step,style: ThemeHelper.getInstance()?.textTheme.headline6,),
              //   ),
              //   ),
              SizedBox(
                width: 8.w,
              ),
              Text(
                appBarTitle,
                style: ThemeHelper.getInstance()?.appBarTheme.titleTextStyle,
              ),
              /* SizedBox(width: 3.w,),*/
              // Icon(Icons.arrow_drop_down_sharp,color: ThemeHelper.getInstance()?.primaryColor)
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     SvgPicture.asset(Utils.path(SMALLBANKLOGO),height: 20.h,width: 20.w),
          //     SizedBox(width: 5.w,),
          //     SvgPicture.asset(Utils.path(MOBILESAHAYLOGO),height: 20.h,width: 20.w)
          //   ],
          // )
        ],
      ),
    ),
    iconTheme: IconThemeData(color: ThemeHelper.getInstance()!.colorScheme.primary, size: 28),
    automaticallyImplyLeading: false,
    bottom: PreferredSize(
      preferredSize: Size(MyDimension.width, 3.h),
      child: LinearProgressIndicator(
          value: progress,
          semanticsLabel: '',
          minHeight: 3.h,
          color: ThemeHelper.getInstance()?.colorScheme.primary,
          backgroundColor: Colors.transparent),
    ),
  );
}

AppBar getAppBarWithStepDone(String step, String appBarTitle, double progress, {required Function onClickAction}) {
  return AppBar(
    title: Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
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
                      Utils.path(MOBILEBACKBTN),
                    ),
                    onTap: () {
                      onClickAction();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 32.w),
                    child: SvgPicture.asset(Utils.path(MOBILEMENUBAR)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 3.w),
                    child: Text(
                      appBarTitle,
                      style: ThemeHelper.getInstance()?.appBarTheme.titleTextStyle,
                    ),
                  ),
                  // Icon(Icons.arrow_drop_down_sharp,color: ThemeHelper.getInstance()?.primaryColor,)
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     SvgPicture.asset(Utils.path(SMALLBANKLOGO),height: 20.h,width: 20.w),
              //     SizedBox(width: 5.w,),
              //     SvgPicture.asset(Utils.path(MOBILESAHAYLOGO),height: 20.h,width: 20.w)
              //   ],
              // )
            ],
          ),
        ),
      ],
    ),
    automaticallyImplyLeading: false,
    bottom: PreferredSize(
      preferredSize: Size(MyDimension.width, 3.h),
      child: LinearProgressIndicator(
          value: progress,
          semanticsLabel: '',
          minHeight: 3.h,
          color: ThemeHelper.getInstance()?.colorScheme.primary,
          backgroundColor: Colors.transparent),
    ),
  );
}

AppBar getAppBarMainDashboard(String step, String appBarTitle, double progress, {required Function onClickAction}) {
  return AppBar(
    title: Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                    onTap: () {
                      onClickAction();
                    },
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
                  SvgPicture.asset(Utils.path(NOTIFICATIONICON), height: 20.h, width: 20.w),
                  SizedBox(
                    width: 8.w,
                  ),
                  SvgPicture.asset(Utils.path(LOGOUT), height: 20.h, width: 20.w)
                ],
              )
            ],
          ),
        ),
      ],
    ),
    automaticallyImplyLeading: false,
    // bottom: PreferredSize(
    //   preferredSize: Size( MyDimension.width,3.h),
    //   child: LinearProgressIndicator(value: progress,
    //       semanticsLabel: '',
    //       minHeight: 3.h,
    //       color: ThemeHelper.getInstance()
    //           ?.colorScheme
    //           .primary,
    //       backgroundColor: Colors.transparent),
    // ),
  );
}

AppBar getAppBarMainDashboardWithBackButton(String step, String appBarTitle, double progress,
    {required Function onClickAction}) {
  return AppBar(
    title: Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                      Utils.path(MOBILEBACKBTN),
                    ),
                    onTap: () {
                      onClickAction();
                    },
                  ),
                  SizedBox(width: 24.w),
                  GestureDetector(
                    child: SvgPicture.asset(
                      Utils.path(MOBILEMENUBAR),
                    ),
                    onTap: () {
                      onClickAction();
                    },
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
                  SvgPicture.asset(Utils.path(NOTIFICATIONICON), height: 20.h, width: 20.w),
                  SizedBox(
                    width: 8.w,
                  ),
                  SvgPicture.asset(Utils.path(LOGOUT), height: 20.h, width: 20.w)
                ],
              )
            ],
          ),
        ),
      ],
    ),
    automaticallyImplyLeading: false,
    // bottom: PreferredSize(
    //   preferredSize: Size( MyDimension.width,3.h),
    //   child: LinearProgressIndicator(value: progress,
    //       semanticsLabel: '',
    //       minHeight: 3.h,
    //       color: ThemeHelper.getInstance()
    //           ?.colorScheme
    //           .primary,
    //       backgroundColor: Colors.transparent),
    // ),
  );
}
