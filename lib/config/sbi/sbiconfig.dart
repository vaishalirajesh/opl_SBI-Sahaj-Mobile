import '../../myappmobile.dart';
import '../webappconfigWidgets.dart';

class SBIConfig {
  static var configuredAppForWeb = WebAppConfig(
    version: "1.0",
    bankName: "SBI",
    bankId: 1,
    asstesPath: 'assets/sbi/',
    baseURl: "",
    environment: "UAT",
    child: const MyAppForMobileApp(),
  );
}
