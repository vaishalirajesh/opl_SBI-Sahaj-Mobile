import 'package:flutter/material.dart';
import 'package:gstmobileservices/model/responsemodel/error/service_error.dart';
import 'package:gstmobileservices/util/tg_view.dart';
import 'package:sbi_sahay_1_0/registration/mobile/login/login.dart';

void handleServiceFailError(BuildContext context, ServiceError? serviceError) {
  if (serviceError != null) {
    if (serviceError.status == 401) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const LoginWithMobileNumber(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
    } else {
      TGView.showSnackBar(context: context, message: serviceError.message ?? "");
    }
  }
}
