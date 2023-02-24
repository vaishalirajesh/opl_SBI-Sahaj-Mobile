import 'package:flutter/cupertino.dart';
import 'package:gstmobileservices/model/responsemodel/error/service_error.dart';
import 'package:gstmobileservices/util/tg_view.dart';

void handleServiceFailError(BuildContext context, ServiceError? serviceError) {
  if (serviceError != null ) {

    if(serviceError.status==401){

    }else if(serviceError.status==500){

    }else{
      TGView.showSnackBar(context: context, message: serviceError.message??"");
    }
  }
}