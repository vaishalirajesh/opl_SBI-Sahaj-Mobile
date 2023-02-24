import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';

import '../../../../routes.dart';
import '../../../../widgets/animation_routes/page_animation.dart';
import '../ui/disputeprogress/ui/disputeprogressscreen.dart';
import '../ui/disputeresolved/ui/disputeresolvedscreen.dart';

class DisputeVM extends ChangeNotifier
{
  late BuildContext context;
  var applicationNo = '';
  var isOpen = true;
  var isSortByChecked = false;
  TextEditingController appNoController = TextEditingController();
  List<String> appList = ['PL20221034174567','PL20221034179004','PL20220634171005','PL20227134174268','PL20221034187439','PL20227134174268','PL20221034187439',];
  List<String> sortList = [str_date_added,str_oldest,str_latest];
  void setContext(BuildContext context)
  {
    this.context = context;
  }

  void setApplicationNo(String appNo)
  {
    applicationNo = appNo;
    appNoController.text = appNo;
    notifyListeners();
  }

  void setOnTabChange(int tab)
  {
    if(tab == 0)
    {
      isOpen = true;
      notifyListeners();
    }
    else
    {
      isOpen = false;
      notifyListeners();
    }
  }

  void sortApplication(bool sort)
  {
    isSortByChecked = sort;
    notifyListeners();
  }
  void navigateScreen()
  {
    Navigator.pushNamed(context, MyRoutes.DisputeSubmitRoutes);

  }

  void disputeTrackNavigation()
  {
    if(isOpen)
    {
   //   Navigator.pushNamed(context, MyRoutes.DisputeInProgressRoutes);
      Navigator.of(context).push(CustomRightToLeftPageRoute(child: DisputeProgessMain(), ));

    }
    else
    {
    //  Navigator.pushNamed(context, MyRoutes.DisputeResolvedRoutes);
    //  Navigator.of(context).push(CustomRightToLeftPageRoute(child: DisputeResolvedMain(), ));
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => DisputeResolvedMain(),)
      );

    }
  }
}