import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/helpers/themhelper.dart';
import '../../../../utils/strings/strings.dart';

class BankListLoader extends StatelessWidget
{
  const BankListLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return BankListLoaderScreen();
  }

}

class BankListLoaderScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => BankListLoaderScreenState();

}

class BankListLoaderScreenState extends State<BankListLoaderScreen>
{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(height: 80.h,width: 80.w,Utils.path(FINDING_AA_LINKBANK),fit: BoxFit.fill,),
            SizedBox(height: 10.h),
            Padding(
              padding: const EdgeInsets.all(20).w,
              child: Text(
                strDescFindingAccountAggregator,
                style: ThemeHelper
                    .getInstance()
                    ?.textTheme
                    .headline1!
                    .copyWith(fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

}