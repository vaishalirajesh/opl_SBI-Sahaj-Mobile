import 'package:flutter/material.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:sbi_sahay_1_0/utils/constants/appconstant.dart';
import 'package:webviewx/webviewx.dart';

import '../../../../routes.dart';
import '../../../../utils/constants/prefrenceconstants.dart';

class AccountAggregatorWebview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AAWebviewScreen();
  }
}

class AAWebviewScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AAWebviewScreenState();
}

class _AAWebviewScreenState extends State<AAWebviewScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: SafeArea(
          child: Scaffold(
            body: accAggregatorWebview(context),
          ),
        ));
  }

  Widget accAggregatorWebview(BuildContext context) {
    TGLog.d("Call Webview");

    late WebViewXController webviewController;

    return Container(
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: WebViewX(
          key: const ValueKey('webviewx'),
          initialContent: AppConstant.AAWEBREDIRCTIONURL ?? "",
          initialSourceType: SourceType.url,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,

          onWebViewCreated: (controller) => webviewController = controller,
          onPageStarted: (src) => {
            TGLog.d("onPageStarted : $src"),
            if (src.contains("resdate="))
              {
                TGSharedPreferences.getInstance().set(PREF_AACALLBACKURL, src),
                Navigator.pushNamed(context, MyRoutes.AAWebViewCallBack)
              }
          },

// onPageFinished: (src) =>
//
//
// debugPrint('The page has finished loading: $src\n'),
          jsContent: const {
            EmbeddedJsContent(
              js: "function testPlatformIndependentMethod() { console.log('Hi from JS') }",
            ),
            EmbeddedJsContent(
              webJs:
                  "function testPlatformSpecificMethod(msg) { TestDartCallback('Web callback says: ' + msg) }",
              mobileJs:
                  "function testPlatformSpecificMethod(msg) { TestDartCallback.postMessage('Mobile callback says: ' + msg) }",
            ),
          },
          dartCallBacks: {
            DartCallback(
              name: 'TestDartCallback',
              callBack: (msg) => "Error",
            )
          },
          webSpecificParams: const WebSpecificParams(
            printDebugInfo: true,
          ),
          mobileSpecificParams: const MobileSpecificParams(
            androidEnableHybridComposition: true,
          ),
          navigationDelegate: (navigation) {
            debugPrint(navigation.content.sourceType.toString());
            return NavigationDecision.navigate;
          },
        ));
  }

  @override
  void initState() {
    super.initState();
  }
}
