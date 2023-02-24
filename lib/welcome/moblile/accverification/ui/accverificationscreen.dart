import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';

import '../../../../routes.dart';
import '../../../../utils/strings/strings.dart';
import '../../../../widgets/animation_routes/page_animation.dart';
import '../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';
import '../../../termscondition/mobile/termscondition.dart';

class AccVerification extends StatelessWidget {
  const AccVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SafeArea(child: AcVerificationScreen());
    });
  }
}

class AcVerificationScreen extends StatefulWidget {
  const AcVerificationScreen({super.key});

  @override
  AcVerificationState createState() => AcVerificationState();
}

class AcVerificationState extends State<AcVerificationScreen> {
  final accList = ['XXXXXXXXXXXX8574', 'XXXXXXXXXXXX7926'];
  var selectedAcc = '';
  var isAccSelected = false;

  var isValidOtp = false;
  String firstOtpTxt = '';
  String secondOtpTxt = '';
  String thirdOtpTxt = '';
  String fourthOtpTxt = '';
  String fifthOtpTxt = '';
  String sixthOtpTxt = '';

  @override
  Widget build(BuildContext context) {
    return   WillPopScope(
        onWillPop: () async {
      return true;
    },
    child:Scaffold(
      appBar: getAppBarWithTitle(str_acc_verification,onClickAction: () =>{
        Navigator.pop(context)
      }),
      body: accVerificationScreenContent(),
    ));
  }

  void checkIsValidOtp() {
    isValidOtp = firstOtpTxt.isNotEmpty &&
        secondOtpTxt.isNotEmpty &&
        thirdOtpTxt.isNotEmpty &&
        fourthOtpTxt.isNotEmpty &&
        fifthOtpTxt.isNotEmpty &&
        sixthOtpTxt.isNotEmpty;
  }

  Widget accVerificationScreenContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            str_select_current_acc,
            style: ThemeHelper.getInstance()?.textTheme.headline1,
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            str_kindly_select_curr_acc,
            style: ThemeHelper.getInstance()?.textTheme.headline3,
          ),
          SizedBox(
            height: 10.h,
          ),
          accountListDropdown(),
          SizedBox(
            height: 30.h,
          ),
          verifyAccountButton(),
        ],
      ),
    );
  }

  Widget accountListDropdown() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButtonFormField(
          decoration: InputDecoration(
              hintText: str_select_current_acc,
              hintStyle: ThemeHelper.getInstance()?.textTheme.headline4,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: ThemeHelper.getInstance()!.unselectedWidgetColor)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          ThemeHelper.getInstance()!.unselectedWidgetColor))),
          items: accList
              .map((label) => DropdownMenuItem(
                    value: label,
                    child: Text(
                      label,
                      style: ThemeHelper.getInstance()?.textTheme.bodyText1,
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              isAccSelected = true;
              selectedAcc = value!;
            });
          }),
    );
  }

  Widget verifyAccountButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55.h,
      child: ElevatedButton(

          style: isAccSelected
              ? ThemeHelper.getInstance()!.elevatedButtonTheme.style
              : ThemeHelper.setPinkDisableButtonBig(),

          onPressed: () {
            if (isAccSelected) {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Wrap(children: [otpTextFields()]);
                  },
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25))),
                  clipBehavior: Clip.antiAlias,
                  isScrollControlled: true);
            }
          },
          child: Center(
            child: Text(
              str_verify
               /*viewModel.isAccSelected
                ? ThemeHelper.getInstance()?.textTheme.button
                : ThemeHelper.getInstance()?.textTheme.headline3*/
              ,
            ),
          )),
    );
  }

  Widget otpTextFields() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            str_verify_current_acc,
            style: ThemeHelper.getInstance()?.textTheme.headline1,
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            str_current_acc_otp_txt + selectedAcc,
            style: ThemeHelper.getInstance()?.textTheme.headline3,
          ),
          SizedBox(
            height: 20.h,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              str_enter_6_digit_otp,
              style: ThemeHelper.getInstance()?.textTheme.headline4,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          otpFieldUI(),
          SizedBox(
            height: 20.h,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              str_did_not_receive_otp,
              style: ThemeHelper.getInstance()?.textTheme.headline4,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          resendOTPContainer(),
          SizedBox(
            height: 30.h,
          ),
          verifyOTPButton()
        ],
      ),
    );
  }

  Widget resendOTPContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.replay,
              color: ThemeHelper.getInstance()?.primaryColor,
            ),
            SizedBox(
              width: 5.w,
            ),
            Text(
              str_resend_otp,
              style: ThemeHelper.getInstance()?.textTheme.headline6,
            )
          ],
        ),
      ),
    );
  }

  Widget otpFieldUI() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  firstOtpTxt = value;
                  checkIsValidOtp();
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                });
              },
              maxLength: 1,
              keyboardType: TextInputType.number,
              style: ThemeHelper.getInstance()?.textTheme.bodyText1,
              textAlign: TextAlign.center,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            ThemeHelper.getInstance()!.unselectedWidgetColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            ThemeHelper.getInstance()!.unselectedWidgetColor),
                  ),
                  counterText: ''),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  secondOtpTxt = value;
                  checkIsValidOtp();
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                  if (value.length == 0) {
                    FocusScope.of(context).previousFocus();
                  }
                });
              },
              maxLength: 1,
              keyboardType: TextInputType.number,
              style: ThemeHelper.getInstance()?.textTheme.bodyText1,
              textAlign: TextAlign.center,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            ThemeHelper.getInstance()!.unselectedWidgetColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            ThemeHelper.getInstance()!.unselectedWidgetColor),
                  ),
                  counterText: ''),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  thirdOtpTxt = value;
                  checkIsValidOtp();
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                  if (value.length == 0) {
                    FocusScope.of(context).previousFocus();
                  }
                });
              },
              maxLength: 1,
              keyboardType: TextInputType.number,
              style: ThemeHelper.getInstance()?.textTheme.bodyText1,
              textAlign: TextAlign.center,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            ThemeHelper.getInstance()!.unselectedWidgetColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            ThemeHelper.getInstance()!.unselectedWidgetColor),
                  ),
                  counterText: ''),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  fourthOtpTxt = value;
                  checkIsValidOtp();
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                  if (value.length == 0) {
                    FocusScope.of(context).previousFocus();
                  }
                });
              },
              maxLength: 1,
              keyboardType: TextInputType.number,
              style: ThemeHelper.getInstance()?.textTheme.bodyText1,
              textAlign: TextAlign.center,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            ThemeHelper.getInstance()!.unselectedWidgetColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            ThemeHelper.getInstance()!.unselectedWidgetColor),
                  ),
                  counterText: ''),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  fifthOtpTxt = value;
                  checkIsValidOtp();
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                  if (value.length == 0) {
                    FocusScope.of(context).previousFocus();
                  }
                });
              },
              maxLength: 1,
              keyboardType: TextInputType.number,
              style: ThemeHelper.getInstance()?.textTheme.bodyText1,
              textAlign: TextAlign.center,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            ThemeHelper.getInstance()!.unselectedWidgetColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            ThemeHelper.getInstance()!.unselectedWidgetColor),
                  ),
                  counterText: ''),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  sixthOtpTxt = value;
                  checkIsValidOtp();
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                  if (value.length == 0) {
                    FocusScope.of(context).previousFocus();
                  }
                });
              },
              maxLength: 1,
              keyboardType: TextInputType.number,
              style: ThemeHelper.getInstance()?.textTheme.bodyText1,
              textAlign: TextAlign.center,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            ThemeHelper.getInstance()!.unselectedWidgetColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            ThemeHelper.getInstance()!.unselectedWidgetColor),
                  ),
                  counterText: ''),
            ),
          ),
        ),
      ],
    );
  }

  Widget verifyOTPButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55.h,
      child: ElevatedButton(

          style: isValidOtp
              ? ThemeHelper.getInstance()!.elevatedButtonTheme.style
              : ThemeHelper.setPinkDisableButtonBig(),

          onPressed: () {
            if(isValidOtp){
             // Navigator.pushNamed(context, MyRoutes.tcRouted);
            //  Navigator.of(context).push(CustomRightToLeftPageRoute(child: TCview(), ));
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TCview(),)
              );
            }


            /*if (viewModel.isValidOtp) {
            viewModel.afterAccVerifyRedirect();
          }*/
          },
          child: Center(
            child: Text(
              str_verify /*viewModel.isValidOtp
                ? ThemeHelper.getInstance()?.textTheme.button
                : ThemeHelper.getInstance()?.textTheme.headline3*/
              ,
            ),
          )),
    );
  }
}
