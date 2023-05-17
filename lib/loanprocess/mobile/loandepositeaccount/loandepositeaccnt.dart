import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/model/models/get_aa_list_response_main.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:sbi_sahay_1_0/loanprocess/mobile/dashboardwithgst/mobile/dashboardwithgst.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import 'package:sbi_sahay_1_0/widgets/app_button.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../utils/constants/prefrenceconstants.dart';
import '../../../../utils/strings/strings.dart';
import '../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';
import '../../../documentation/mobile/loanagreement/ui/loanageementscreen.dart';

class LoanDepositeAcc extends StatelessWidget {
  const LoanDepositeAcc({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return const SafeArea(child: LoanDepositeAccView());
    });
  }
}

class LoanDepositeAccView extends StatefulWidget {
  const LoanDepositeAccView({Key? key}) : super(key: key);

  @override
  State<LoanDepositeAccView> createState() => _LoanDepositeAccViewState();
}

class _LoanDepositeAccViewState extends State<LoanDepositeAccView> {
  TextEditingController accNuumberController = TextEditingController();
  TextEditingController ifscNoController = TextEditingController();
  bool _autoValidate = true;

  int typeListlen = 0;
  late List<GetAAListObj> typeListDetails;
  bool isAANextClick = false;
  int listLength = 3;
  String isCheckedGroup = 'BankGroupName';

  //List<int> isCheckedList = [];
  int selectedValue = -1;

  bool isLoaderStart = false;

  @override
  void initState() {
    typeListDetails = [];
    // getAAListApiCall();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const DashboardWithGST(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );
        return true;
      },
      child: Scaffold(
        appBar: getAppBarWithStepDone("2", str_documentation, 0.50,
            onClickAction: () => {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const DashboardWithGST(),
                    ),
                    (route) => false, //if you want to disable back feature set to false
                  )
                }),
        body: AbsorbPointer(
          absorbing: isLoaderStart,
          child: buildMainScreen(context),
        ),
        bottomNavigationBar: SizedBox(
          height: 0.15.sh,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
              child: buildBtnNextAcc(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMainScreen(BuildContext context) {
    return SingleChildScrollView(
      primary: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          buildBankName(),
          SizedBox(
            height: 24.h,
          ),
          buildMainScreenContent(),
        ],
      ),
    );
  }

  Widget buildBankName() {
    return Container(
      color: ThemeHelper.getInstance()!.colorScheme.secondaryContainer,
      height: 81.h,
      child: Padding(
        padding: EdgeInsets.only(left: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(color: ThemeHelper.getInstance()!.backgroundColor, shape: BoxShape.circle),
              width: 40.w,
              height: 40.h,
              child: Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  Utils.path(SMALLBANKLOGO),
                  height: 15.h,
                  width: 15.h,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              strSBI,
              style: ThemeHelper.getInstance()!.textTheme.headline1!.copyWith(
                    fontSize: 14.sp,
                    color: MyColors.black,
                  ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMainScreenContent() {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(
                "Select Loan Deposit A/c",
                style: ThemeHelper.getInstance()!.textTheme.headline2!.copyWith(color: MyColors.darkblack),
                textAlign: TextAlign.start,
              ),
            ]),
            SizedBox(height: 20.h),
            buildRowWidget(
                "Enter the complete current account number, which was fetched through Account Aggregator. The loan would be disbursed in this account."),
            SizedBox(height: 15.h),
            buildRowWidget("Please note the same account will be used for creating E-Mandate to auto-debit repayment."),
            SizedBox(
              height: 30.h,
            ),
            EnterAcc(),
            SizedBox(
              height: 16.h,
            ),
            iFSCcodeText()
          ],
        ),
      ),
    );
  }

  Widget EnterAcc() {
    return TextFormField(
        style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(color: MyColors.pnbTextcolor),
        onChanged: (content) {},
        controller: accNuumberController,
        cursorColor: Colors.white,
        decoration: InputDecoration(
            labelStyle: TextStyle(color: MyColors.verylightGrayColor),
            labelText: str_enter_acc_no,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            floatingLabelStyle: ThemeHelper.getInstance()?.textTheme.bodyText2,
            enabledBorder: UnderlineInputBorder(
              //borderRadius: BorderRadius.all(Radius.circular(6.r)),
              borderSide: BorderSide(width: 1, color: ThemeHelper.getInstance()!.colorScheme.onSurface),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ThemeHelper.getInstance()!.colorScheme.onSurface, width: 1.0),
              // borderRadius: BorderRadius.circular(6.0.r),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: ThemeHelper.getInstance()!.colorScheme.onSurface),
              //borderRadius: BorderRadius.all(Radius.circular(6.r))
            ),
            counterText: ''),
        keyboardType: TextInputType.text,
        maxLength: 15,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter User name';
          }
          return null;
        });
  }

  Widget iFSCcodeText() {
    return TextFormField(
        style: ThemeHelper.getInstance()!.textTheme.headline3!.copyWith(color: MyColors.pnbTextcolor),
        onChanged: (content) {},
        autofocus: _autoValidate,
        controller: ifscNoController,
        cursorColor: Colors.white,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            floatingLabelStyle: ThemeHelper.getInstance()?.textTheme.bodyText2,
            labelText: str_IFSC_Code,
            // hintText: "SBIN0003471",
            labelStyle: TextStyle(color: MyColors.verylightGrayColor),
            //str_IFSC_Code,
            enabledBorder: UnderlineInputBorder(
              // borderRadius: BorderRadius.all(Radius.circular(6.r)),
              borderSide: BorderSide(width: 1, color: ThemeHelper.getInstance()!.colorScheme.onSurface),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ThemeHelper.getInstance()!.colorScheme.onSurface, width: 1.0),
              // borderRadius: BorderRadius.circular(6.0.r),
            ),
            // focusColor: ThemeHelper.getInstance()!.colorScheme.onSurface,
            // fillColor: ThemeHelper.getInstance()!.colorScheme.onSurface,
            border: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: ThemeHelper.getInstance()!.colorScheme.onSurface),
              //borderRadius: BorderRadius.all(Radius.circular(6.r))
            ),
            counterText: ''),
        keyboardType: TextInputType.text,
        maxLength: 15,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter User name';
          }
          return null;
        });
  }

  Widget buildRowWidget(String text) => Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(Utils.path(IMG_GREENTICK_AA), height: 18.r, width: 18.r),
            SizedBox(width: 8.w),
            Expanded(
                child: Text(
              " $text",
              style: ThemeHelper.getInstance()!
                  .textTheme
                  .headline3!
                  .copyWith(color: MyColors.lightGraySmallText, fontSize: 14.sp),
              maxLines: 4,
            )),
          ],
        ),
      );

  Widget buildBtnNextAcc(BuildContext context) {
    return AppButton(
      onPress: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoanAgreementMain(),
          ),
          (route) => false, //
        );
      },
      title: str_proceed,
      isButtonEnable: selectedValue == -1,
    );
  }

  void changeState(int index) {
    // TGSession.getInstance().set(SESSION_CODE, typeListDetails?[0].code);
    // TGSession.getInstance().set(SESSION_AAID, typeListDetails?[0].aaId);

    setState(() {
      selectedValue = index;
      TGSharedPreferences.getInstance().set(PREF_AAID, typeListDetails[index].aaId);
      TGSharedPreferences.getInstance().set(PREF_AACODE, typeListDetails[index].code);
    });
  }

  void setNextAAClick() {
    isAANextClick = true;
    setState(() {});
  }
}
