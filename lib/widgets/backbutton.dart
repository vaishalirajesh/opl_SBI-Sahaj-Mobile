import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../routes.dart';
import '../utils/helpers/themhelper.dart';

class CustBackButton{

 //..Login
  static Future<bool?>  showLogout(BuildContext context)async =>showDialog(context: context, builder: (context)=>AlertDialog(content: Text('Do you want to Logout?'),
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          TextButton(onPressed: ()=> Navigator.pop(context,false)
      , child: Text('Cancel'),),
          TextButton(onPressed: (){

             // Navigator.pushNamedAndRemoveUntil(context,MyRoutes.LogoutScreen,(route)=>false);




          }, child: Text('Logout'),)
        ],
      )
      ,
    ],
    title: Text('Exit',style: ThemeHelper.getInstance()!.textTheme.headline1,),));





  //..GetStarted Exit


















static Future<bool?> onBackButtonDoubleClicked(BuildContext context,DateTime backPressedTime)async{

  final difference=DateTime.now().difference(backPressedTime);
    backPressedTime=DateTime.now();
    if(difference>=const Duration(seconds:2)){
      CustBackButton. toast(context,'Click Again to Close The App');
      return false;

    }
    else{
   //   SystemNavigator.pop(animated: true);
      return true;
    }
}

static void toast(BuildContext context,String text){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text),behavior: SnackBarBehavior.floating,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),));
}

}
