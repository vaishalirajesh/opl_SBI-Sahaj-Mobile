import 'dart:html' as html;

import 'package:gstmobileservices/common/tg_log.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchAa(String content) async {
  TGLog.d("Web Launch URL----$content");

  List<String> file_contents = [content];

  html.Blob blob = html.Blob(file_contents, 'text/html');

  String? makeURL = html.Url.createObjectUrlFromBlob(blob);

  TGLog.d("Web Launch $makeURL");

  await launchUrl(
    Uri.parse(content),
    mode: LaunchMode.externalApplication,
    webOnlyWindowName: '_self',
  );
}
