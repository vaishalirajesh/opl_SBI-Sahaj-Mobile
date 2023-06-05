import 'package:flutter/cupertino.dart';

class DashboardViewModel extends ChangeNotifier {
  late BuildContext context;

  void setContext(BuildContext context) {
    this.context = context;
  }

  bool isExpanded1 = false;
  bool isExpanded2 = false;
  String Expanded1 = 'Pending';

  setExpanded1() {
    isExpanded1 = !isExpanded1;
    notifyListeners();
  }

  var dict =  [
    {"sortby": "Invoice Date: Latest - Oldest (Default)", "isSelected": "0"},
    {"sortby": "Invoice Date: Oldest - Latest", "isSelected": "0"},
    {"sortby": "Buyer's Name: A - Z", "isSelected": "0"},
    {"sortby": "Buyer's Name: Z - A", "isSelected": "0"},
    {"sortby": "Amount: Low to High", "isSelected": "0"},
    {"sortby": "Amount: High to Low", "isSelected": "0"}
  ];


}
