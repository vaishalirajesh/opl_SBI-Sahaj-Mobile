import 'package:flutter/material.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/hexcolor.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:shimmer/shimmer.dart';
class ShimmerWidget extends StatelessWidget {
  final double widht;
  final double height;
  final ShapeBorder shapeBorder;
  ShimmerWidget.rectangle({ this.widht=double.infinity, required this.height,}):this.shapeBorder=const RoundedRectangleBorder();
  ShimmerWidget.cricular({ this.widht=double.infinity, required this.height,this.shapeBorder=const CircleBorder()});
  @override
  Widget build(BuildContext context) {

    return Shimmer.fromColors(
    period: Duration(seconds: 3),

        baseColor:HexColor('#E0E0E0'),

        highlightColor: HexColor('#F5F5F5') ,

        child:
     Container(width: widht,height: height,
            decoration: ShapeDecoration(
                color: Colors.grey[200],
                shape: shapeBorder),
     )

 );
  }
}