import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sbi_sahay_1_0/utils/helpers/myfonts.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';

import '../../../../../../routes.dart';
import '../../../../../../utils/colorutils/mycolors.dart';
import '../../../../../../utils/strings/strings.dart';
import '../../../../../../widgets/animation_routes/page_animation.dart';
import '../../../viewmodel/disputeviewmodel.dart';
import '../../disputeprogress/ui/disputeprogressscreen.dart';
import '../../disputeresolved/ui/disputeresolvedscreen.dart';
import '../../submitdispute/ui/submitdisputescreen.dart';

class RaiseDisputeMain extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      return  SafeArea(child:  WillPopScope(
          onWillPop: () async {
        return true;
      },
      child: RaiseDisputeMains()));
    });
  }

}

class RaiseDisputeMains extends StatefulWidget {


  @override
  RaiseDisputeMainBody createState() => new RaiseDisputeMainBody();
}

class RaiseDisputeMainBody extends State<RaiseDisputeMains> {

  var applicationNo = '';
  var isOpen = true;
  var isSortByChecked = false;
  TextEditingController appNoController = TextEditingController();
  List<String> appList = ['PL20221034174567','PL20221034179004','PL20220634171005','PL20227134174268','PL20221034187439','PL20227134174268','PL20221034187439',];
  List<String> sortList = [str_date_added,str_oldest,str_latest];



  @override
  Widget build(BuildContext context) {
    return RaiseDisputeScreen(context);;
  }


  Widget RaiseDisputeScreen(BuildContext context) {
      return Scaffold(
        appBar: getAppBarWithTitle(str_dispute_details,onClickAction: () =>{
          Navigator.pop(context)
        }),
        body: RaiseDisputeContent(context),
        bottomSheet: Padding(
          padding: EdgeInsets.only(left: 20.h, right: 20.h, bottom: 30.h),
          child: SubmitDisputeBtn(context),
        ),

      );

  }

  Widget RaiseDisputeContent(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: TabBar(
            indicatorColor: ThemeHelper
                .getInstance()
                ?.primaryColor,
            indicatorSize: TabBarIndicatorSize.label,
            padding: EdgeInsets.zero,
            indicatorPadding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
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
            tabs: const [
              Tab(text: str_ongoing_app,),
              Tab(text: str_disb_app,),
            ],
          ), // TabBar
        ), // AppBar
        body: TabBarView(
          children: [
            OngoingApplication(context),
            DisbursedApplication(context)
          ],
        ),
      ),

    );
  }

  Widget OngoingApplication(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OngoingApplicationInfoCard(context),
            SizedBox(height: 30.h,),
            ProvideDescUI(context),
            SizedBox(height: 30.h,),
            UploadScreenshotUI(context),
            SizedBox(height: 100.h,),
          ],
        ),
      ),
    );
  }

  Widget DisbursedApplication(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DisbursedApplicationCard(context),
            SizedBox(height: 30.h,),
            ProvideDescUI(context),
            SizedBox(height: 30.h,),
            UploadScreenshotUI(context),
            SizedBox(height: 100.h,),
          ],
        ),
      ),
    );
  }

  Widget OngoingApplicationInfoCard(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.all(Radius.circular(12.r))),
        shadowColor: ThemeHelper
            .getInstance()
            ?.shadowColor,
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(str_loan_app_id, style: ThemeHelper
                  .getInstance()
                  ?.textTheme
                  .bodyText1,),
              SizedBox(height: 5.h,),
              Text('PL32005034179004', style: ThemeHelper
                  .getInstance()
                  ?.textTheme
                  .bodyText2
                  ?.copyWith(
                  fontFamily: MyFont.Nunito_Sans_Semi_bold, fontSize: 14.sp),),
              SizedBox(height: 20.h,),
              Text(str_stage, style: ThemeHelper
                  .getInstance()
                  ?.textTheme
                  .bodyText1,),
              SizedBox(height: 5.h,),
              Text('Documentation & KYC', style: ThemeHelper
                  .getInstance()
                  ?.textTheme
                  .bodyText2
                  ?.copyWith(
                  fontFamily: MyFont.Nunito_Sans_Semi_bold, fontSize: 14.sp),),
            ],
          ),
        ),
      ),
    );
  }

  Widget DisbursedApplicationCard(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.all(Radius.circular(12.r))),
        shadowColor: ThemeHelper
            .getInstance()
            ?.shadowColor,
        elevation: 1,
        child: Padding(
          padding: EdgeInsets.all(20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(str_disb_app_id, style: ThemeHelper
                  .getInstance()
                  ?.textTheme
                  .bodyText1,),
              SizedBox(height: 5.h,),
              SizedBox(
                height: 45.h,
                child: TextField(
                  controller: appNoController,
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Wrap(children: [
                            DisbursedApplicationListUI(context)
                          ]);
                        },
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25), topRight: Radius
                                .circular(25))),
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
                    hintText: str_select_app,
                    hintStyle: ThemeHelper
                        .getInstance()
                        ?.textTheme
                        .headline5
                        ?.copyWith(fontSize: 12.sp),
                    counterText: '',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.r),
                        borderSide:
                        BorderSide(color: ThemeHelper
                            .getInstance()!
                            .colorScheme
                            .onSurface, width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.r),
                        borderSide:
                        BorderSide(color: ThemeHelper
                            .getInstance()!
                            .colorScheme
                            .onSurface, width: 2)),
                    suffixIcon: Icon(
                      Icons.arrow_drop_down, color: MyColors.pnbTextcolor,),
                  ),
                ),
              ),
              SizedBox(height: 20.h,),
              Text(str_stage, style: ThemeHelper
                  .getInstance()
                  ?.textTheme
                  .bodyText1,),
              SizedBox(height: 5.h,),
              Text('Disbursed', style: ThemeHelper
                  .getInstance()
                  ?.textTheme
                  .bodyText2
                  ?.copyWith(
                  fontFamily: MyFont.Nunito_Sans_Semi_bold, fontSize: 14.sp),),
            ],
          ),
        ),
      ),
    );
  }

  Widget ProvideDescUI(BuildContext context) {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(str_provide_desc, style: ThemeHelper
              .getInstance()
              ?.textTheme
              .bodyText1),
          SizedBox(height: 10.h,),
          TextField(
            maxLines: 4,
            maxLength: 200,
            onChanged: (value) {

            },
            style: ThemeHelper
                .getInstance()
                ?.textTheme
                .bodyText2,
            decoration: InputDecoration(
              hintText: str_enter_desc,
              hintStyle: ThemeHelper
                  .getInstance()
                  ?.textTheme
                  .bodyText1
                  ?.copyWith(
                  color: ThemeHelper
                      .getInstance()
                      ?.colorScheme
                      .onSurface, fontSize: 12.sp),
              counterStyle: ThemeHelper
                  .getInstance()
                  ?.textTheme
                  .bodyText1
                  ?.copyWith(
                  color: ThemeHelper
                      .getInstance()
                      ?.colorScheme
                      .onSurface, fontSize: 12.sp),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.r),
                  borderSide:
                  BorderSide(color: ThemeHelper
                      .getInstance()!
                      .colorScheme
                      .onSurface, width: 2)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.r),
                  borderSide:
                  BorderSide(color: ThemeHelper
                      .getInstance()!
                      .colorScheme
                      .onSurface, width: 2)),
            ),
          )
        ],
      ),
    );
  }

  Widget UploadScreenshotUI(BuildContext context) {
    return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(str_upload_ss, style: ThemeHelper
                .getInstance()
                ?.textTheme
                .bodyText1),
            SizedBox(height: 10.h,),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: 85.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  border: Border.all(
                    width: 2,
                    color: ThemeHelper
                        .getInstance()!
                        .colorScheme
                        .onSurface,
                    style: BorderStyle.solid,
                  )
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload, color: ThemeHelper
                        .getInstance()!
                        .colorScheme
                        .onSurface, size: 15.h,),
                    SizedBox(width: 5.w,),
                    Text(str_upload, style: ThemeHelper
                        .getInstance()
                        ?.textTheme
                        .bodyText1
                        ?.copyWith(
                        color: ThemeHelper
                            .getInstance()
                            ?.colorScheme
                            .onSurface, fontSize: 12.sp),)
                  ],
                ),
              ),
            )
          ],
        )
    );
  }

  Widget SubmitDisputeBtn(BuildContext context) {
    return Container(
      height: 50.h,
      child: ElevatedButton(
          onPressed: () {
            navigateScreen();
          },
          child: Center(child: Text(str_submit, style: ThemeHelper
              .getInstance()
              ?.textTheme
              .button,),)
      ),
    );
  }


  Widget DisbursedApplicationListUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                Text(str_select_app_id, style: ThemeHelper
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: appList.length,
              itemBuilder: (context, index) {
                return ApplicationWidgetUI(context, index);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget ApplicationWidgetUI(BuildContext context, int index) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h,),
          Text(appList[index], style: ThemeHelper
              .getInstance()
              ?.textTheme
              .headline2
              ?.copyWith(fontSize: 16.sp),),
          SizedBox(height: 10.h,),
          Divider(thickness: 1, color: ThemeHelper
              .getInstance()
              ?.disabledColor)
        ],
      ),
      onTap: () {
        Navigator.pop(context);
        setApplicationNo(appList[index]);
      },
    );
  }



  void setApplicationNo(String appNo)
  {
    applicationNo = appNo;
    appNoController.text = appNo;
   // notifyListeners();
  }

  void setOnTabChange(int tab)
  {
    if(tab == 0)
    {
      isOpen = true;
     // notifyListeners();
    }
    else
    {
      isOpen = false;
     // notifyListeners();
    }
  }

  void sortApplication(bool sort)
  {
    isSortByChecked = sort;
    //notifyListeners();
  }
  void navigateScreen()
  {
 //   Navigator.pushNamed(context, MyRoutes.DisputeSubmitRoutes);
 //   Navigator.of(context).push(CustomRightToLeftPageRoute(child: SubmitDisputeMain(), ));
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SubmitDisputeMain(),)
    );

  }

  void disputeTrackNavigation()
  {
    if(isOpen)
    {
     // Navigator.pushNamed(context, MyRoutes.DisputeInProgressRoutes);
  //    Navigator.of(context).push(CustomRightToLeftPageRoute(child: DisputeProgessMain(), ));
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => DisputeProgessMain(),)
      );

    }
    else
    {
  //    Navigator.pushNamed(context, MyRoutes.DisputeResolvedRoutes);
    //  Navigator.of(context).push(CustomRightToLeftPageRoute(child: DisputeResolvedMain(), ));
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => DisputeResolvedMain(),)
      );
    }
  }

}