import 'package:flutter/widgets.dart';
import 'package:sbi_sahay_1_0/welcome/moblile/splash/splashscreen.dart';


class SplashMain extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return  SplashScreen();
    },
  );
  }

}