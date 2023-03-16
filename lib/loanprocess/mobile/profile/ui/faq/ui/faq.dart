import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';

import '../../../../../../utils/Utils.dart';
import '../../../../../../utils/colorutils/mycolors.dart';
import '../../../../../../utils/constants/imageconstant.dart';
import '../../../../../../utils/strings/strings.dart';
import '../../../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';

class FAQMain extends StatelessWidget {
  const FAQMain({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return FAQScreen();
        },
      ),
    );
  }
}

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  List<bool> isShowing = [false, false, false, false, false, false, false];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: getAppBarMainDashboardWithBackButton("2", str_loan_approve_process, 0.25,
            onClickAction: () => {
              Navigator.pop(context)
            }),
        body: SingleChildScrollView(child: buildListData()),
      ),
    );
  }

  Widget buildListData() {
    return Column(
      children: [
        Container(height: 50.h,
            width:MediaQuery.of(context).size.width,
            child: Padding(
              padding:  EdgeInsets.only(left: 20.w,top: 10.h),
              child: Text(
                  "FAQs",
                  style: ThemeHelper.getInstance()!
                      .textTheme
                      .headline3!
                      .copyWith(color: MyColors.white)),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(0.r),
                    bottomLeft: Radius.circular(0.r)),
                border: Border.all(
                    width: 1, color: ThemeHelper.getInstance()!.primaryColor),
                //color: ThemeHelper.getInstance()!.primaryColor,

                gradient: LinearGradient(colors: [MyColors.lightRedGradient,MyColors.lightBlueGradient],begin: Alignment.centerLeft,end: Alignment.centerRight )
            )),
        SizedBox(
          height: 30.h,
        ),
        faqUI(str_faq_one, str_faq_ans_one, 0),
        SizedBox(
          height: 15.h,
        ),
        faqUI(str_faq_two, str_faq_ans_two, 1),
        SizedBox(
          height: 15.h,
        ),
        // faqUI(str_faq_three, str_faq_ans_three, 2),
        // SizedBox(
        //   height: 15.h,
        // ),
        faqUI(str_faq_four, str_faq_ans_four, 3),
        SizedBox(
          height: 15.h,
        ),
        // faqUI(str_faq_five, str_faq_ans_five, 4),
        // SizedBox(
        //   height: 15.h,
        // ),
        faqUI(str_faq_six, str_faq_ans_six, 5),
        SizedBox(
          height: 15.h,
        ),
        faqUI(str_faq_seven, str_faq_ans_seven, 6),
        SizedBox(
          height: 15.h,
        )
      ],
    );
  }

  Widget faqUI(String question, String answer, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isShowing[index] = !isShowing[index];
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: Text(
                  question,
                  style: ThemeHelper.getInstance()!
                      .textTheme
                      .headline2!
                      .copyWith(fontSize: 16),
                  maxLines: 10,
                ),
              ),
              SvgPicture.asset(
                isShowing[index]
                    ? Utils.path(IMG_UP_ARROW) : Utils.path(IMG_DOWN_ARROW),
                height: 15.h,
                width: 15.w,
                //color: ThemeHelper.getInstance()?.colorScheme.surface,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        isShowing[index]
            ? Text(
                answer,
                style: ThemeHelper.getInstance()!
                    .textTheme
                    .headline2!
                    .copyWith(fontSize: 14),
                maxLines: 15,
              )
            : SizedBox(
                height: 0.h,
              ),
        Divider(
          thickness: 1.w,
        ),
      ]),
    );
  }
}
