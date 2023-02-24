

import '../../myaapweb.dart';
import '../../myappmobile.dart';

import '../webappconfigWidgets.dart';


class PNBConfig{

  static var configuredAppForWeb = WebAppConfig(
    version: "1.0",
    bankName: "PNB",
    bankId: 1,
    asstesPath: 'assets/pnb/',
    baseURl: "",
    environment: "UAT",
    child: MyAppForWeb(),
  );





}

