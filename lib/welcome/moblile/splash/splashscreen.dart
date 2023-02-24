import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget SplashScreen() {
  return Scaffold(
    appBar: AppBar(),
    body: Container(
      child: ElevatedButton(onPressed: () {}, child: Text("Test me")),
    ),
    bottomNavigationBar: Container(),
  );
}
