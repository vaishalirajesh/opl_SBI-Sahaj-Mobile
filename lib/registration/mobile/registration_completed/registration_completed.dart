
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:sbi_sahay_1_0/routes.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';

import '../../../loanprocess/viemmodel/ConfirmDetailsVM.dart';
import '../../../utils/Utils.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/dimenutils/dimensutils.dart';
import '../../../utils/helpers/themhelper.dart';
import '../../../utils/imagepathutils/myimagePath.dart';
import '../../../utils/strings/strings.dart';
import '../../../widgets/animation_routes/page_animation.dart';
import '../../../widgets/backbutton.dart';
import '../dashboardwithoutgst/mobile/dashboardwithoutgst.dart';


class RegistrationCompleted extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {
        return  SafeArea(child: RegistrationCompletedScreen());
      },
    );
  }

}
class RegistrationCompletedScreen extends StatefulWidget {
  const RegistrationCompletedScreen({Key? key}) : super(key: key);
  @override
  State<RegistrationCompletedScreen> createState() => _RegistrationCompletedScreenState();
}

class _RegistrationCompletedScreenState extends State<RegistrationCompletedScreen> {
  String name = '';
  @override
  void initState() {
    setname();
    super.initState();
  }
  Future<void> setname() async
  {
    var text = await TGSharedPreferences.getInstance().get(PREF_BUSINESSNAME);
    setState(() {
      name = text;
    });
  }
  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, false);
          SystemNavigator.pop(animated: true);


      return true;
    },
    child:
      Scaffold(
        appBar: getAppBarWithBackBtn(onClickAction: (){
          CustBackButton.showLogout(context);
        }),
      body:
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildMiddler(context),
                _buildMiddlerText(),
                // Spacer(),
                _buildBottomSheet(context)
              ],
            ),
          ),
        ),
      ),

    ));
  }
  _buildHeader(BuildContext context){
    return
      Padding(
        padding:  EdgeInsets.only(top:40.0.h),
        child: Row(mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){ CustBackButton.showLogout(context);},
              child:Container(

                width: 22.w,
                height: 16.h,
                child: SvgPicture.asset(Utils.path(MOBILEBACKARROWBROWN),height: 20.h,width: 40.w,),),
            )
          ],
        ),
      )

    ;
  }
  _buildMiddler(BuildContext context){
    return Padding(
      padding:  EdgeInsets.only(top:100.0.h,),
      child: Container(

          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 197.h,

          child:Image.asset(Utils.path(MOBILERegistrationcompleted))

      ),
    );
  }
  _buildMiddlerText()  {

    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(children: [
        SizedBox(height: 57.h,),
        Text(str_Registration_completed,style: ThemeHelper.getInstance()!.textTheme.headline1,)
        ,SizedBox(height: 19.h,), Text(str_welcome + name + str_start_journey,style: ThemeHelper.getInstance()!.textTheme.headline3,textAlign: TextAlign.center,)
        ,SizedBox(height: 55.h,)

      ],),
    );
  }


  _buildBottomSheet(BuildContext context) {
    return Container(

      child:
      Column(
        children: [
          ElevatedButton(
            onPressed: () {

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => DashboardWithoutGST(),),
                    (
                    route) => false, //if you want to disable back feature set to false
              );
              //    Navigator.pushNamed(context, MyRoutes.DashboardWithoutGSTRoutes);
          //    Navigator.of(context).push(CustomRightToLeftPageRoute(child: DashboardWithoutGST(), ));


            },
            child: Text(str_Proceed  ),
          ),

          SizedBox(height: 49.h,)
        ],
      ),





    );
  }
}




