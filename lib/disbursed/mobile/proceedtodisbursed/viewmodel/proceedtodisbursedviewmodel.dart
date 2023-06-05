import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../loanprocess/mobile/important_sms/important_sms.dart';
import '../../../../routes.dart';
import '../../../../widgets/animation_routes/page_animation.dart';

class ProceedToDisbursedVM extends ChangeNotifier
{
  late BuildContext context;
  var isChecked = false;
  var isLoader = false;

  void setContext(BuildContext context)
  {
    this.context = context;
  }

  void setIsChecked(bool bool)
  {
    isChecked = bool;
    notifyListeners();
  }

  void setIsLoader()
  {
    isLoader = true;
    notifyListeners();
  }

  void navigateToDisbursedScreen()
  {
    Future.delayed(const Duration(seconds: 5), () {
     // Navigator.pushNamed(context, MyRoutes.DisbursementSuccessMessage);
  //    Navigator.of(context).push(CustomRightToLeftPageRoute(child: ImportantSMSMain(), ));
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ImportantSMSMain(),)
      );

      notifyListeners();
    });
  }
}