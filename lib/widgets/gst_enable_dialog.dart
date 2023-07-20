import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:sbi_sahay_1_0/registration/mobile/gst_api_steps/gst_api_steps.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/constants/imageconstant.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/helpers/myfonts.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:url_launcher/url_launcher.dart';

class GSTEnableDialog extends StatefulWidget {
  const GSTEnableDialog({Key? key}) : super(key: key);

  @override
  State<GSTEnableDialog> createState() => _GSTEnableDialogState();
}

class _GSTEnableDialogState extends State<GSTEnableDialog> {
  @override
  Widget build(BuildContext context) {
    return PopUpViewForEnableApi();
  }

  Widget PopUpViewForEnableApi() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        TGSharedPreferences.getInstance().set(PREF_ENABLE_POPUP, false);
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: ThemeHelper.getInstance()?.backgroundColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 15.r,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 15.r),
                    child: GestureDetector(
                      child: const Icon(Icons.close),
                      onTap: () {
                        Navigator.pop(context);
                        TGSharedPreferences.getInstance().set(PREF_ENABLE_POPUP, true);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 30.h), //40
                Center(
                  child: SvgPicture.asset(
                    AppUtils.path(IMG_GSTENABLE_API),
                    height: 95.h, //,
                    width: 95.w, //134.8,
                    allowDrawingOutsideViewBox: true,
                  ),
                ),
                SizedBox(height: 30.h), //40
                Center(
                  child: Column(
                    children: [
                      Text(
                        "It seems you have not enabled GST API.",
                        style: ThemeHelper.getInstance()?.textTheme.headline2?.copyWith(fontSize: 16.sp),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "To understand the process",
                        style: ThemeHelper.getInstance()?.textTheme.headline2?.copyWith(fontSize: 16.sp),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28.h), //28
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Click for video",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: ThemeHelper.getInstance()?.primaryColor,
                                  decorationThickness: 2,
                                  fontSize: 16.sp,
                                  color: ThemeHelper.getInstance()?.primaryColor,
                                  fontFamily: MyFont.Roboto_Medium),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchUrl(Uri.parse("https://www.youtube.com/watch?v=vcxK5Ppd4R4"));
                                },
                            ),
                            const TextSpan(
                              text: "      ",
                            ),
                            TextSpan(
                              text: "Click for steps",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: ThemeHelper.getInstance()?.primaryColor,
                                  decorationThickness: 2,
                                  fontSize: 16.sp,
                                  color: ThemeHelper.getInstance()?.primaryColor,
                                  fontFamily: MyFont.Roboto_Medium),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => GstApiSteps(),
                                    ),
                                  );
                                },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
