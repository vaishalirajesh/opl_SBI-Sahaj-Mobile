import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/utils/strings/strings.dart';
import '../../../loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import '../../../loanprocess/mobile/transactions/common_card/card_2/card_2.dart';
import '../../../routes.dart';
import '../../../utils/constants/constant.dart';
import '../../../utils/dimenutils/dimensutils.dart';
import '../../../utils/helpers/myfonts.dart';
import '../../../widgets/titlebarmobile/titlebarwithoutstep.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return const SafeArea(
          child: SignUpViewBody(),
        );
      },
    );
  }
}

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({Key? key}) : super(key: key);
  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {
  @override
  bool isCheck = false;

  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(
          child: WillPopScope(
              onWillPop: () async {

                return true;
              },
              child: Scaffold(
                appBar: getAppBarWithBackBtn(onClickAction: () => {
                  Navigator.pop(context, false),
                  SystemNavigator.pop(animated: true)

                }),
                body: Stack(children: [
                  SingleChildScrollView(
                    primary: true,
                    child: Container(
                      child: SignUpScreenContent(),
                    ),
                  ),
                  // Align(
                  //     alignment: Alignment.bottomCenter,
                  //     child: SignUpButtonUI())
                ]),
              )),
        );
      },
    );
  }

  Widget SignUpScreenContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.w,
                ),
                Text(
                  "Please provide the basic details",
                  style: ThemeHelper.getInstance()?.textTheme.headline2,
                ),
                SizedBox(
                  height: 20.w,
                ),
                TextFieldUI("First Name"),
                SizedBox(
                  height: 20.w,
                ),
                TextFieldUI("Last Name"),
                SizedBox(
                  height: 20.w,
                ),
                GenderTextField("Gender"),
                SizedBox(
                  height: 20.w,
                ),
                ContactNumberWidget(label: "Contact Number"),
                SizedBox(
                  height: 20.w,
                ),
                EmailIdWidget(label: "Email ID"),
                SizedBox(
                  height: 20.w,
                ),
                TextFieldUI("PIN Code of Current Residential Address"),
                SizedBox(
                  height: 20.w,
                ),
                TextFieldUI("City"),
                SizedBox(
                  height: 20.w,
                ),
                TextFieldUI("Your Preferred Branch"),
                SizedBox(
                  height: 20.w,
                ),
                confirmGstDetailCheck(),
                SizedBox(
                  height: 10.w,
                ),
                SignUpButtonUI()
              ],
            ),
    ));
  }

  Widget TextFieldUI(
    String label,
  ) {
    return TextFormField(
        onChanged: (content) {},
        cursorColor: Colors.grey,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: ThemeHelper.getInstance()?.textTheme.headline6?.copyWith(color: MyColors.pnbTextcolor),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: MyColors.pnbTextcolor)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: MyColors.pnbDarkGreyTextColor))),
        keyboardType: TextInputType.text,
        maxLines: 1,
        style: ThemeHelper.getInstance()?.textTheme.headline3,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        });
  }

  Widget SignUpButtonUI() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Container(

        decoration: BoxDecoration(
            border: Border.all(
                color: ThemeHelper.getInstance()!.cardColor, width: 1),
            color: ThemeHelper.getInstance()?.backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(8.r))),
        height: 48.h,
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          style: isCheck ? ThemeHelper.getInstance()!.elevatedButtonTheme.style : ThemeHelper.setDisableButtonBig(),
          onPressed: () async {
            Navigator.pushNamed(context, MyRoutes.EnableGstApiRoutes);
          },
          child: Text(
            str_next,
          ),
        ),
      ),
    );
  }

  Widget confirmGstDetailCheck() {
    return GestureDetector(
      onTap: () {
        // setState(() {
        //   confirmGstDetail = !confirmGstDetail;
        // });
      },
      child: Padding(
          padding: EdgeInsets.only(top: 21.0.h),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 20.w,
                  height: 20.h,
                  child: Checkbox(
                    checkColor: ThemeHelper.getInstance()!.backgroundColor,
                    activeColor: ThemeHelper.getInstance()!.primaryColor,
                    value: isCheck,
                    onChanged: (bool) {
                      setState(() {
                        isCheck = bool!;
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2.r))),
                    side: BorderSide(
                        width: 1,
                        color: isCheck
                            ? ThemeHelper.getInstance()!.primaryColor
                            : ThemeHelper.getInstance()!.disabledColor),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    "I hereby authorize State Bank of India and/or its representatives to call me, SMS me with reference to my loan application. This consent will supersede any registration for any Do Not Call (DNC) / National Do Not Call (NDNC).",
                    style: ThemeHelper.getInstance()
                        ?.textTheme
                        .headline4
                        ?.copyWith(fontFamily: MyFont.Nunito_Sans_Semi_bold),
                    maxLines: 5,
                  ),
                ),
              ])),
    );
  }



  AppBar buildAppBarWithoutAnything() {
    return AppBar(
      iconTheme: IconThemeData(
          color: ThemeHelper.getInstance()!.colorScheme.primary, size: 28),
      elevation: 0,
      automaticallyImplyLeading: true,
      title: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SvgPicture.asset(Utils.path(MOBILESAHAYLOGO),
                    //     height: 20.h, width: 20.w)
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmailIdWidget extends StatefulWidget {
  String label;

  EmailIdWidget({Key? key, required this.label}) : super(key: key);

  @override
  EmailIdWidgetState createState() => new EmailIdWidgetState();
}

class EmailIdWidgetState extends State<EmailIdWidget> {
  bool hidePassword = true;

  bool validEmail(String email) {
    return RegExp(Email_Pattern).hasMatch(email);
  }

  get label => widget.label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        onChanged: (content) {
          setState(
            () {
              validEmail(content);
            },
          );
        },
        obscureText: hidePassword,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: ThemeHelper.getInstance()?.textTheme.headline6?.copyWith(color: MyColors.pnbTextcolor),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: MyColors.pnbTextcolor)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: MyColors.pnbDarkGreyTextColor)),
          suffixIcon: IconButton(
            icon: hidePassword
                ? Icon(
                    Icons.visibility_off_outlined,
                    color:
                        hidePassword ? MyColors.pnbTextcolor : MyColors.black,
                  )
                : Icon(
                    Icons.visibility_outlined,
                    color:
                        hidePassword ? MyColors.pnbTextcolor : MyColors.black,
                  ),
            onPressed: () {
              setState(
                () {
                  hidePassword = !hidePassword;
                },
              );
            },
            focusColor: MyColors.black,
            disabledColor: MyColors.pnbTextcolor,
          ),
          suffixIconColor: MyColors.black,
        ),
        keyboardType: TextInputType.visiblePassword,
        maxLines: 1,
        validator: (value) {
          if (value == null || value.isEmpty || validEmail(value)) {
            return 'Please enter $label';
          }
          return null;
        });
  }
}

class ContactNumberWidget extends StatefulWidget {
  String label;

  ContactNumberWidget({Key? key, required this.label}) : super(key: key);

  @override
  ContactNumberWidgetState createState() => new ContactNumberWidgetState();
}

class ContactNumberWidgetState extends State<ContactNumberWidget> {
  bool hidePassword = true;

  get label => widget.label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        onChanged: (content) {},
        obscureText: hidePassword,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: ThemeHelper.getInstance()?.textTheme.headline6?.copyWith(color: MyColors.pnbTextcolor),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: MyColors.pnbTextcolor)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: MyColors.pnbDarkGreyTextColor)),
          suffixIcon: IconButton(
            icon: hidePassword
                ? Icon(
                    Icons.visibility_off_outlined,
                    color:
                        hidePassword ? MyColors.pnbTextcolor : MyColors.black,
                  )
                : Icon(
                    Icons.visibility_outlined,
                    color:
                        hidePassword ? MyColors.pnbTextcolor : MyColors.black,
                  ),
            onPressed: () {
              setState(
                () {
                  hidePassword = !hidePassword;
                },
              );
            },
            focusColor: MyColors.black,
            disabledColor: MyColors.pnbTextcolor,
          ),
          suffixIconColor: MyColors.black,
        ),
        keyboardType: TextInputType.visiblePassword,
        maxLines: 1,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(10),
          FilteringTextInputFormatter.digitsOnly
        ]);
  }
}

Widget GenderTextField(String label) {
  return TextFormField(
      onChanged: (content) {},
      cursorColor: Colors.grey,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: ThemeHelper.getInstance()?.textTheme.headline6?.copyWith(color: MyColors.pnbTextcolor),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: MyColors.pnbTextcolor)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: MyColors.pnbDarkGreyTextColor)),
          suffixIcon: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_drop_down,
                color: MyColors.pnbTextcolor,
              ))),
      keyboardType: TextInputType.text,
      maxLines: 1,
      style: ThemeHelper.getInstance()?.textTheme.headline3,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      });
}

