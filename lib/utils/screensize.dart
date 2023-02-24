


import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'constants/constant.dart';

void  setSceenSize( String type,BuildContext context){

  if(type==WEB){

    ScreenUtil.init(
      context,
      designSize: Size(1920, 1080),
      minTextAdapt: true,
    );

  }else if(type==TABLET){
    ScreenUtil.init(
      context,
      designSize:Size(360, 872),
      minTextAdapt: false,
    );

  }else if(type==MOBILE){

    ScreenUtil.init(
      context,
      designSize: Size(360, 872),
      minTextAdapt: true,
    );
  }else{

  }


}