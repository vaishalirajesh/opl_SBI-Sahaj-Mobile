



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../routes.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/colorutils/mycolors.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/dimenutils/dimensutils.dart';
import '../../../../utils/helpers/themhelper.dart';
import '../../../../utils/strings/strings.dart';
import '../../../../widgets/animation_routes/page_animation.dart';
import '../../loanreview/ui/loanreviewscreen.dart';

class LoaderPrepareLoanDisbursment extends StatelessWidget
{
  const LoaderPrepareLoanDisbursment({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      return  SafeArea(child: LoaderPrepareLoanDisbursments());
    });
  }

}

class LoaderPrepareLoanDisbursments extends StatefulWidget {

  @override
  LoaderPrepareLoanDisbursmentState createState() => LoaderPrepareLoanDisbursmentState();
}

class LoaderPrepareLoanDisbursmentState extends State<LoaderPrepareLoanDisbursments> {

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(seconds: 5), () {
      //Navigator.pushNamed(context, MyRoutes.DisbursementSuccessMessage);
      //Navigator.pushNamed(context, MyRoutes.loanReviewRoutes);
   //   Navigator.of(context).push(CustomRightToLeftPageRoute(child: LoanReviewMain(), ));
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoanReviewMain(),)
      );
      // notifyListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoaderPrepareLoanDisbursments(context);
  }


  Widget LoaderPrepareLoanDisbursments(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [MyColors.pnbPinkColor,
            ThemeHelper.getInstance()!.backgroundColor
          ], begin: Alignment.bottomCenter, end: Alignment.centerLeft)),
      height: MyDimension.getFullScreenHeight(),
      width: MyDimension.getFullScreenWidth(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
          Expanded(
          flex: 6,
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                 Padding(
                    padding:  EdgeInsets.only(bottom:20.0.h),
                    child: Image.asset(height: 100.h,width: 100.w,Utils.path(LOANDISBURSED),fit: BoxFit.fill,),
                  ),

                // Lottie.asset(Utils.path(LOANDISBURSED),
                //     height: 250.h,
                //     //80.w,
                //     width: 250.w,
                //     //80.w,
                //     repeat: true,
                //     reverse: false,
                //     animate: true,
                //     frameRate: FrameRate.max,
                //     fit: BoxFit.fill
                // ),
                Text(str_prepare_for_disb, style: ThemeHelper
                    .getInstance()
                    ?.textTheme
                    .headline1, textAlign: TextAlign.center, maxLines: 3,),
                SizedBox(height: 10.h),
                Text("", style: ThemeHelper
                    .getInstance()
                    ?.textTheme
                    .headline3, textAlign: TextAlign.center, maxLines: 10,),

              ],
            ),
          ),
            Expanded(
              flex: 1,
              child:      Align(
              alignment: Alignment.bottomCenter,
              child:Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Processing...",
                          textAlign: TextAlign.start,
                          style: ThemeHelper.getInstance()?.textTheme.headline6),
                      SizedBox(height: 10.h),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: LinearProgressIndicator(
                          semanticsLabel: 'Processing...',
                          minHeight : 8.h,
                          color: ThemeHelper.getInstance()?.primaryColor,
                          backgroundColor: ThemeHelper.getInstance()?.colorScheme.secondary,

                        ),
                      )
                    ],
                  )
              ),
            ),
            )
          ],
        ),
      ),
    );
  }

}