import 'package:flutter/material.dart';
import 'package:sbi_sahay_1_0/utils/dimenUtils/dimension.dart';

class ResponsiveLayout extends StatelessWidget
{
  final Widget mobileBody;
  final Widget tabletBody;
  final Widget desktopBody;

  ResponsiveLayout({required this.mobileBody,required this.tabletBody,required this.desktopBody});


  @override
  Widget build(BuildContext context) {
   return LayoutBuilder(builder: (context,constraints){
      if(constraints.maxWidth >= desktop_width)
      {
        return desktopBody;
      }
      else if(constraints.maxWidth <= desktop_width && constraints.maxWidth >= mobile_width)
      {
        return tabletBody;
      }
      else
      {
        return mobileBody;
      }
   });
  }


}