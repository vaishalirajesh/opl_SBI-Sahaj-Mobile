
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import 'package:sbi_sahay_1_0/utils/Utils.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';

import '../../../../../utils/constants/imageconstant.dart';
import '../../../../../utils/helpers/myfonts.dart';
import '../../../../../utils/helpers/themhelper.dart';
import '../../../../../utils/strings/strings.dart';
import '../../../../../widgets/ratingwidget.dart';
import '../../common_card/card_2/card_2.dart';

class AllMain extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {


    return LayoutBuilder(builder: (context,constraints){
      return  AllScreen();
    });
  }

}
class AllScreen extends StatefulWidget {
  const AllScreen({Key? key}) : super(key: key);

  @override
  State<AllScreen> createState() => _AllScreenState();
}

class _AllScreenState extends State<AllScreen> {
  int len=15;
  bool flag=false;

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Align(
        alignment: Alignment.center,
        child: ListView.separated(
          // bottomRow(),
          itemBuilder: (BuildContext context, int index) {
            if(index<= len-1)
              return  Card2(flag:false, index: index,);
            else
              return  SizedBox(height: 300.h,);
          },
          separatorBuilder: (BuildContext context, int index) =>  SizedBox(
            height: 20.h,
          ),
          itemCount: len+1,
        ),
      ),
    );
  }
}

