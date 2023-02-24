
import 'dart:html' as html;

import 'package:url_launcher/url_launcher.dart';

Future<void> launchdde(String content) async {


  List<String> file_contents = [content];
  html.Blob blob = html.Blob(file_contents, 'text/html');

  String? makeURL=html.Url.createObjectUrlFromBlob(blob);

  await launchUrl(
  Uri.parse(makeURL),
  mode: LaunchMode.externalApplication,
  webOnlyWindowName: '_self',

  );
}
