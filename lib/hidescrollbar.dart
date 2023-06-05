import 'dart:ui';

import 'package:flutter/material.dart';

class NoThumbScrollBehavior extends MaterialScrollBehavior  {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
  };
}
