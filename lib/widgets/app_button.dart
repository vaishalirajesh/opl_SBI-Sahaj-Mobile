import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';

// Common button widget
class AppButton extends StatelessWidget {
  const AppButton({Key? key, required this.onPress, required this.title, this.isButtonEnable = true}) : super(key: key);
  final VoidCallback onPress;
  final String title;
  final bool isButtonEnable;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52.h,
      width: 1.sw,
      child: ElevatedButton(
        onPressed: onPress,
        style: isButtonEnable
            ? ThemeHelper.getInstance()!.elevatedButtonTheme.style
            : ThemeHelper.setPinkDisableButtonBig(),
        child: Text(title),
      ),
    );
  }
}
