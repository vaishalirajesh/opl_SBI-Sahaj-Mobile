import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gstmobileservices/common/app_functions.dart';
import 'package:gstmobileservices/common/tg_log.dart';
import 'package:gstmobileservices/singleton/tg_session.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:gstmobileservices/util/tg_flavor.dart';
import 'package:gstmobileservices/util/tg_util.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/constants/session_keys.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/welcome/ntbwelcome/mobileui/getstarted.dart';

class AutoLogin extends StatefulWidget {
  const AutoLogin({required this.str, Key? key}) : super(key: key);
  final Map<dynamic, dynamic> str;

  @override
  State<AutoLogin> createState() => AutoLoginState();
}

class AutoLoginState extends State<AutoLogin> {
  @override
  Widget build(BuildContext context) {
    return Container(color: ThemeHelper.getInstance()?.colorScheme.background);
  }

  @override
  void initState() {
    TGLog.d(widget.str);
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   LoaderUtils.showLoaderwithmsg(context, LOADERSAMPLE, "Wait a Moment...", msg: "Getting Details...");
    // });
    String encryptedText = widget.str['encData'];
    TGLog.d("sso encrypted String : $encryptedText");
    decryptParameter(encryptedText);
  }

  _showErrorDialog(String msg) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'Error',
            style: ThemeHelper.getInstance()?.textTheme.bodySmall,
          ),
          content: Text(
            msg,
            style: ThemeHelper.getInstance()?.textTheme.headlineSmall,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                SystemNavigator.pop(animated: true);
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> decryptParameter(String encryptedText) async {
    await Future.delayed(const Duration(seconds: 5));
    String _key;
    if (TGFlavor.baseUrl() == "https://sbiuat-gstsahay.instantmseloans.in") {
      _key = "GS+5@hayM0bi#PRO";
    } else {
      _key = "GS+5@hayM0bi#UAT";
    }

    if (encryptedText != null) {
      try {
        final key = enc.Key.fromUtf8(_key);
        final keyBytes = base64Encode(Uint8List.fromList(_key.codeUnits).sublist(0, 16));
        final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.ecb));
        final decrypted = encrypter.decrypt64(base64Encode(hex.decode(encryptedText)), iv: enc.IV.fromBase64(keyBytes));
        TGLog.d("sso decrypted String : $decrypted");
        var parsedQueryParameters = Uri.splitQueryString(decrypted);
        if (parsedQueryParameters["mobileNo"]?.isEmpty == true) {
          if (context.mounted) {
            Navigator.pop(context);
          }
          _showErrorDialog("Mobile number is getting empty");
        } else if (parsedQueryParameters["emailId"]?.isEmpty == true) {
          if (context.mounted) {
            Navigator.pop(context);
          }
          _showErrorDialog("EmailID is getting empty");
        } else if (parsedQueryParameters["address"]?.isEmpty == true) {
          if (context.mounted) {
            Navigator.pop(context);
          }
          _showErrorDialog("Address is getting empty");
        } else if (parsedQueryParameters["cifNo"]?.isEmpty == true) {
          if (context.mounted) {
            Navigator.pop(context);
          }
          _showErrorDialog("CifNo is getting empty");
        } else if (parsedQueryParameters["panNo"]?.isEmpty == true) {
          if (context.mounted) {
            Navigator.pop(context);
          }
          _showErrorDialog("Pan Number is getting empty");
        } else {
          String? gstin = await TGSharedPreferences.getInstance().get(PREF_GSTIN);
          if (gstin != null) {
            if (parsedQueryParameters["panNo"] != gstin.substring(2, 12)) {
              TGSharedPreferences.getInstance().remove(PREF_ISTC_DONE);
              TGSharedPreferences.getInstance().remove(PREF_ISGST_CONSENT);
              TGSharedPreferences.getInstance().remove(PREF_ISGSTDETAILDONE);
              TGSharedPreferences.getInstance().remove(PREF_GSTIN);
            }
          }

          await Utils.removeToken(TGFlavor.param("bankName"));
          String? token = await Utils.getAccessToken(TGFlavor.param("bankName"));
          TGLog.d("After Removed Token :${token ?? ""}");
          setAccessTokenInRequestHeader();

          TGSession.getInstance().set(SESSION_SSOMOBILE, parsedQueryParameters["mobileNo"]);
          TGSession.getInstance().set(SESSION_SSOEMAIL, parsedQueryParameters["emailId"]);
          TGSession.getInstance()
              .set(SESSION_SSOADDRESS, parsedQueryParameters["address"]?.toLowerCase().replaceAll("+", " "));
          TGSession.getInstance().set(SESSION_SSOCIFNO, parsedQueryParameters["cifNo"]);
          TGSession.getInstance().set(SESSION_SSOPANNO, parsedQueryParameters["panNo"]);

          TGSession.getInstance().set(SESSION_ISSSOAPPLY, true);
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const GetStartedScreen(),
              ),
              (route) => false, //if you want to disable back feature set to false
            );
          }
        }
      } catch (error) {
        if (context.mounted) {
          Navigator.pop(context);
        }
        TGLog.e(error);
        _showErrorDialog("Some Error While Decryption");
      }
    }
  }
}
