import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';

import '../../../../../../utils/Utils.dart';
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
        appBar: getAppBarWithTitle("FAQs",
            onClickAction: () => {Navigator.pop(context)}),
        body: SingleChildScrollView(child: buildListData()),
      ),
    );
  }

  Widget buildListData() {
    return Column(
      children: [
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
        faqUI(str_faq_three, str_faq_ans_three, 2),
        SizedBox(
          height: 15.h,
        ),
        faqUI(str_faq_four, str_faq_ans_four, 3),
        SizedBox(
          height: 15.h,
        ),
        faqUI(str_faq_five, str_faq_ans_five, 4),
        SizedBox(
          height: 15.h,
        ),
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
                    ? Utils.path(UPARROWIC)
                    : Utils.path(DOWNARROWIC),
                height: 15.h,
                width: 15.w,
                color: ThemeHelper.getInstance()?.colorScheme.surface,
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
