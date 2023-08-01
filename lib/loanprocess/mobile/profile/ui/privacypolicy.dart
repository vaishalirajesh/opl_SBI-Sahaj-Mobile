import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/widgets/titlebarmobile/titlebarwithoutstep.dart';
import 'package:webviewx/webviewx.dart';

import '../../../../utils/helpers/themhelper.dart';
import '../../../../utils/strings/strings.dart';

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PrivacypolicyScreen();
  }
}

class PrivacypolicyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PrivacypolicyScreenState();
}

class _PrivacypolicyScreenState extends State<PrivacypolicyScreen> {
  String policyContent = '';
  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          appBar: getAppBarWithTitle("Privacy Policy", onClickAction: () {
            Navigator.pop(context);
          }),
          body: policyContent.isNotEmpty ? policyContainerUI(context) : Container(),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 30.h),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50.h,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text(
                      str_ok,
                      style: ThemeHelper.getInstance()?.textTheme.button,
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Widget policyContainerUI(BuildContext context) {
    WebViewXController webviewController;

    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          width: MediaQuery.of(context).size.width,
          decoration:
              const BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: WebViewX(
            /* javascriptMode: JavascriptMode.unrestricted,*/
            key: const ValueKey('webviewx'),
            initialContent: policyContent,
            initialSourceType: SourceType.html,
            width: MediaQuery.of(context).size.width,
            onWebViewCreated: (controller) async {
              webviewController = controller;
            },
            height: MediaQuery.of(context).size.height * 0.85,
          )),
    );
  }

  Future<void> setData() async {
    final text = await rootBundle.loadString(AppUtils.path('html/privacy-policy.html'));
    setState(() {
      policyContent = text;
    });
  }
}
