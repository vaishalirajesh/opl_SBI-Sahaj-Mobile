import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';

import '../../../../../../routes.dart';
import '../../../../../../utils/colorutils/mycolors.dart';
import '../../../../../../utils/helpers/myfonts.dart';
import '../../../../../../utils/helpers/themhelper.dart';
import '../../../../../../utils/strings/strings.dart';
import '../../../../../../widgets/animation_routes/page_animation.dart';
import '../../../viewmodel/disputeviewmodel.dart';
import '../../disputeprogress/ui/disputeprogressscreen.dart';
import '../../disputeresolved/ui/disputeresolvedscreen.dart';

class TrackDisputeMain extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      return  SafeArea(child:   WillPopScope(
          onWillPop: () async {
        return true;
      },
      child:TrackDisputeMains()));
    });
  }

}

class TrackDisputeMains extends StatefulWidget {


  @override
  TrackDisputeMainBody createState() => new TrackDisputeMainBody();
}

class TrackDisputeMainBody extends State<TrackDisputeMains> {
  var isOpen = true;
  TextEditingController appNoController = TextEditingController();
  List<String> appList = ['PL20221034174567','PL20221034179004','PL20220634171005','PL20227134174268','PL20221034187439','PL20227134174268','PL20221034187439',];
  List<String> sortList = [str_date_added,str_oldest,str_latest];
  bool isSortByChecked = false;

  @override
  Widget build(BuildContext context) {
    return TrackDisputeScreen(context);;
  }

  Widget TrackDisputeScreen(BuildContext context) {
      return Scaffold(
        appBar: getAppBarWithTitle(str_dispute_tracker,onClickAction: () =>{
          Navigator.pop(context)
        }),
        body: TrackDisputeScreenContent(context),
      );

  }

  Widget TrackDisputeScreenContent(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: TabBar(
            indicatorColor: ThemeHelper
                .getInstance()
                ?.primaryColor,
            indicatorSize: TabBarIndicatorSize.tab,
            onTap: (tab) {
             setOnTabChange(tab);
            },
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            /*indicatorPadding: EdgeInsets.symmetric(horizontal: 20.w),
          labelPadding: EdgeInsets.symmetric(horizontal: 10.w),*/
            labelStyle: ThemeHelper
                .getInstance()
                ?.textTheme
                .bodyText1
                ?.copyWith(
                fontSize: 14.sp, fontFamily: MyFont.Nunito_Sans_Semi_bold),
            unselectedLabelStyle: ThemeHelper
                .getInstance()
                ?.textTheme
                .bodyText2
                ?.copyWith(
                fontSize: 14.sp, fontFamily: MyFont.Nunito_Sans_Semi_bold),
            labelColor: MyColors.pnbcolorPrimary,
            indicatorWeight: 4,
            unselectedLabelColor: MyColors.pnbTabLableolor,
            isScrollable: true,
            tabs: const [
              Tab(
                text: str_open,
              ),
              Tab(
                text: str_closed,
              ),
            ],
          ), // TabBar
        ), // AppBar
        body: TabBarView(
          children: [
            OpenDisputeWidget(context),
            ClosedDisputeWidget(context),
          ],
        ),
        bottomSheet: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
          child: TrackButtonUI(context),
        ),
      ),
    );
  }

  Widget OpenDisputeWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              str_loan_app_id,
              style: ThemeHelper
                  .getInstance()
                  ?.textTheme
                  .bodyText1,
            ),
            SizedBox(
              height: 10.h,
            ),
            LoanAppIdField(context),
            SizedBox(
              height: 20.h,
            ),
            /*SortByWidgetUI(viewModel),
          SizedBox(
            height: 20.h,
          ),*/
            OpenLoanApplicationList(context)
          ],
        ),
      ),
    );
  }

  Widget ClosedDisputeWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              str_loan_app_id,
              style: ThemeHelper
                  .getInstance()
                  ?.textTheme
                  .bodyText1,
            ),
            SizedBox(
              height: 10.h,
            ),
            LoanAppIdField(context),
            SizedBox(
              height: 20.h,
            ),
            /*SortByWidgetUI(viewModel),
          SizedBox(
            height: 20.h,
          ),*/
            OpenLoanApplicationList(context)
          ],
        ),
      ),
    );
  }

  Widget SortByWidgetUI(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          str_dispute_history,
          style: ThemeHelper
              .getInstance()
              ?.textTheme
              .headline2
              ?.copyWith(color: ThemeHelper
              .getInstance()
              ?.primaryColor),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              border: Border.all(
                width: 2,
                color: ThemeHelper
                    .getInstance()!
                    .colorScheme
                    .onSurface,
                style: BorderStyle.solid,
              )),
          child: Padding(
            padding: EdgeInsets.all(12.h),
            child: Row(
              children: [
                Text(
                  str_SortBy,
                  style: ThemeHelper
                      .getInstance()
                      ?.textTheme
                      .headline4
                      ?.copyWith(color: MyColors.PnbGrayTextColor),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: MyColors.PnbGrayTextColor,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget LoanAppIdField(BuildContext context) {
    return SizedBox(
      height: 45.h,
      child: TextField(
        controller: appNoController,
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Wrap(children: [SortByDialogUI(context)]);
              },
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              clipBehavior: Clip.antiAlias,
              isScrollControlled: true);
        },
        readOnly: true,
        onChanged: (value) {},
        style: ThemeHelper
            .getInstance()
            ?.textTheme
            .bodyText2,
        decoration: InputDecoration(
          hintText: str_SortBy,
          hintStyle: ThemeHelper
              .getInstance()
              ?.textTheme
              .headline5
              ?.copyWith(fontSize: 12.sp),
          counterText: '',
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(
                  color: ThemeHelper
                      .getInstance()!
                      .colorScheme
                      .onSurface,
                  width: 2)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(
                  color: ThemeHelper
                      .getInstance()!
                      .colorScheme
                      .onSurface,
                  width: 2)),
          suffixIcon: Icon(
            Icons.arrow_drop_down,
            color: MyColors.pnbTextcolor,
          ),
        ),
      ),
    );
  }

  Widget OpenLoanApplicationList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: appList.length,
      itemBuilder: (context, index) {
        return LoanApplicationListCard(
            context,appList[index], '24/07/2022');
      },
    );
  }

  Widget LoanApplicationListCard(BuildContext context, String appNo,
      String date) {
    return Column(
      children: [
        SizedBox(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  appNo,
                  style: ThemeHelper
                      .getInstance()
                      ?.textTheme
                      .headline2
                      ?.copyWith(fontSize: 16.sp, color: MyColors.black),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  date,
                  style: ThemeHelper
                      .getInstance()
                      ?.textTheme
                      .headline4
                      ?.copyWith(color: MyColors.PnbGrayTextColor),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: isOpen
                    ? MyColors.pnbPendingBackground
                    : MyColors.pnbDashboardBackground,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 5.h),
                child: Text(
                  isOpen ? str_open : str_closed,
                  style: ThemeHelper
                      .getInstance()
                      ?.textTheme
                      .headline6
                      ?.copyWith(
                      color: isOpen
                          ? MyColors.pnbPendingBackgroundDark
                          : MyColors.pnbcolorPrimary,
                      fontFamily: MyFont.Nunito_Sans_Semi_bold,
                      fontSize: 11.sp),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Divider(thickness: 1, color: ThemeHelper
            .getInstance()
            ?.disabledColor)
      ],
    );
  }

  Widget TrackButtonUI(BuildContext context) {
    return Container(
      height: 50.h,
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: ElevatedButton(
        onPressed: () {
          disputeTrackNavigation();
        },
        child: Center(
          child: Text(
            str_track,
            style: ThemeHelper
                .getInstance()
                ?.textTheme
                .button,
          ),
        ),
      ),
    );
  }

  Widget SortByDialogUI(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 20.h,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(),
              Text(str_SortBy, style: ThemeHelper
                  .getInstance()
                  ?.textTheme
                  .bodyText1,),
              GestureDetector(
                child: Icon(
                  Icons.close,
                  color: MyColors.pnbTextcolor,
                  size: 15.h,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h,),
        Divider(thickness: 1, color: ThemeHelper
            .getInstance()
            ?.disabledColor),
        SizedBox(height: 10.h,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: sortList.length,
            itemBuilder: (context, index) {
              return SoryByListCardUI(context, sortList[index]);
            },
          ),
        ),
        SizedBox(height: 20.h,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ApplySortingButtonUI(context),
        ),
        SizedBox(height: 20.h,)
      ],
    );
  }

  Widget SoryByListCardUI(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: ThemeHelper
                .getInstance()
                ?.textTheme
                .headline5,
          ),
          Radio(
            value: true,
            onChanged: (value) {
              sortApplication(value!);
            },
            activeColor: ThemeHelper
                .getInstance()
                ?.primaryColor,
            groupValue: isSortByChecked,
            toggleable: true,
          )
        ],
      ),
    );
  }

  Widget ApplySortingButtonUI(BuildContext context) {
    return ElevatedButton(
      onPressed: () {

      },
      child: Center(
        child: Text(
          str_apply,
          style: ThemeHelper
              .getInstance()
              ?.textTheme
              .button,
        ),
      ),
    );
  }

  //
  void setOnTabChange(int tab)
  {
    if(tab == 0)
    {
      isOpen = true;
     // notifyListeners();
      setState(() {

      });
    }
    else
    {
      isOpen = false;
      setState(() {

      });
     // notifyListeners();
    }
  }

  void disputeTrackNavigation()
  {
    if(isOpen)
    {
     // Navigator.pushNamed(context, MyRoutes.DisputeInProgressRoutes);
    //  Navigator.of(context).push(CustomRightToLeftPageRoute(child: DisputeProgessMain(), ));
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => DisputeProgessMain(),)
      );


    }
    else
    {
  //    Navigator.pushNamed(context, MyRoutes.DisputeResolvedRoutes);
     // Navigator.of(context).push(CustomRightToLeftPageRoute(child: DisputeResolvedMain(), ));
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => DisputeResolvedMain(),)
      );
    }
  }

  void sortApplication(bool sort)
  {
    isSortByChecked = sort;
    setState(() {

    });
  }

}