import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/common/app_init.dart';
import 'package:gstmobileservices/common/keys.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';

import '../../../utils/Utils.dart';
import '../../../utils/constants/imageconstant.dart';
import '../../../utils/helpers/themhelper.dart';

class SplashMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SplashScreen(context: context);
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  BuildContext context;

  SplashScreen({Key? key, required this.context}) : super(key: key);

  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _asyncInit();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SplashBgImage(),
    );
  }

  Widget SplashBgImage() {
    return SafeArea(
      child: Container(
        color: ThemeHelper.getInstance()?.colorScheme.primary,
        child: Center(
          child: SvgPicture.asset(
            AppUtils.path(SMALLBANKLOGO),
            height: 50.h,
            width: 50.w,
          ),
        ),
      ),
    );
  }

  _asyncInit() async {
    TGLog.d("Splash._ayncInit");
    await Future.delayed(Duration(seconds: 5));
    //String? accetoken= await TGSharedPreferences.getInstance().get(PREF_ACCESS_TOKEN);
    await _init();
    setState(() {
      //  if(accetoken != null && accetoken.isNotEmpty){
      //  //  Navigator.of(context).pushReplacementNamed(MyRoutes.loginRoutes);
      //  //   Navigator.of(context).push(CustomRightToLeftPageRoute(
      //  //     child: WelcomePage(),
      //  //   ));
      //    Navigator.push(context,
      //        MaterialPageRoute(builder: (context) => WelcomePage(),)
      //    );
      //
      //
      //    // Navigator.of(context).push(CustomRightToLeftPageRoute(
      //    //     child: GSTInvoicesList(),
      //    // ));
      //  }else{
      // //  Navigator.of(context).pushReplacementNamed(MyRoutes.tcRouted);
      // //    Navigator.of(context).push(CustomRightToLeftPageRoute(
      // //      child: TCview(),
      // //    ));
      //    Navigator.push(context,
      //        MaterialPageRoute(builder: (context) => TCview(),)
      //    );
      //
      //    // Navigator.of(context).push(CustomRightToLeftPageRoute(
      //    //   child: GSTInvoicesList(),
      //    // ));
      //  }
    });
  }

  Future<void> _init() async {
    TGLog.d("_init: Start");

    await initService();
    await TGSharedPreferences.getInstance().remove(PREF_ACCESS_TOKEN_SBI);
    await Future.delayed(Duration(seconds: 5));
    TGLog.d("_init: End");
  }

// Future<void> initLocale() async {
//   TGLog.d("initLocale()");
//   const KEY_APP_LOCALE_CODE='';
//   String? storedLocaleCode =
//   await TGSharedPreferences.getInstance().get(KEY_APP_LOCALE_CODE);
//   if (storedLocaleCode != null) {
//     Locale? locale = TGLocale.findLocaleByCode(storedLocaleCode);
//     MyAppForMobileApp.setLocale(locale);
//   }
// }
}
