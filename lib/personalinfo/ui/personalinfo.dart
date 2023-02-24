import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gstmobileservices/singleton/tg_shared_preferences.dart';
import 'package:sbi_sahay_1_0/utils/colorutils/mycolors.dart';
import 'package:sbi_sahay_1_0/utils/constants/prefrenceconstants.dart';
import 'package:sbi_sahay_1_0/utils/helpers/themhelper.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/constants/imageconstant.dart';
import '../../../../widgets/titlebarmobile/titlebarwithoutstep.dart';
import '../../utils/helpers/myfonts.dart';
import '../../utils/strings/strings.dart';

class PersonalInfoDetails extends StatelessWidget {
  const PersonalInfoDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return   WillPopScope(
            onWillPop: () async {
          return true;
        },
        child: ProfileData());
      },
    );
  }
}

class ProfileData extends StatefulWidget {

  ProfileData({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProfileDataState();
}

class ProfileDataState extends State<ProfileData>
{


  String? businessName;
  String? gstinNumber;
  String? mobileNumber;


  void setPersonalDetails() async
  {
    String? name = await TGSharedPreferences.getInstance().get(PREF_USERNAME);
    String? gstin = await TGSharedPreferences.getInstance().get(PREF_GSTIN);
    String? mobile = await TGSharedPreferences.getInstance().get(PREF_MOBILE);

    setState(() {
      businessName = name;
      gstinNumber = gstin;
      mobileNumber = mobile;
    });
  }

  @override
  void initState() {
    super.initState();
    setPersonalDetails();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBarWithTitle(strPersonalInformation,onClickAction: () =>{
        Navigator.pop(context)
      }),
      body: Container(
          color: ThemeHelper.getInstance()!.primaryColor,
          child: setUpView(context)),
    );
  }
  Widget setUpView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [buildStackImage(PROFILE_IMG), SetBodyContainer(context)],
      ),
    );
  }

  Widget buildStackImage(String path) => Padding(
    padding: EdgeInsets.only(top: 43.h, bottom: 30.h),
    child: Center(
      child: Stack(
        children: [
          Container(
              decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.white),
              width: 101.w,
              height: 101.w,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: CircleAvatar(
                  backgroundColor: MyColors.white,
                  backgroundImage: AssetImage(Utils.path(PROFILE_IMG)),
                ),
              )),
          //setEditBtn()
        ],
      ),
    ),
  );
  Widget setEditBtn() {
    return Positioned(
      bottom: 0,
      right: 10.w,
      child: Container(
        height: 24.h,
        width: 24.w,
        decoration:
        const BoxDecoration(color: Colors.yellow, shape: BoxShape.circle),
        child: IconButton(
          icon: SvgPicture.asset(Utils.path(IMG_PENICL)),
          iconSize: 10,
          onPressed: () {},
        ),
      ),
    );
  }

  Widget SetBodyContainer(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 174.h,
      decoration: BoxDecoration(
        color: ThemeHelper.getInstance()!.backgroundColor,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(40), topLeft: Radius.circular(40)),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            LoanDetailCardUI(businessName ?? "", "GST User Name", true),
            SizedBox(height: 10.h,),
            LoanDetailCardUI(gstinNumber ?? "", "GSTIN", true),
            SizedBox(height: 10.h,),
            //LoanDetailCardUI("", "Father’s Name", true),
            SizedBox(height: 10.h,),
            LoanDetailCardUI(mobileNumber ?? "", "Phone Numbers", true),
            SizedBox(height: 10.h,),
            //LoanDetailCardUI("", "Application", true),
          ],
        ),
      ),
    );
  }

  Widget LoanDetailCardUI(String title, String subText, bool isDivider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subText.isNotEmpty
            ? Text(
          subText,
          style: ThemeHelper.getInstance()
              ?.textTheme
              .headline4
              ?.copyWith(color: MyColors.PnbGrayTextColor),
        )
            : Container(
          height: 0.h,
        ),

        Padding(
          padding:  EdgeInsets.only(top:5.h,bottom:10.h),
          child: Row(
            children: [
              Text(
                title,
                style: ThemeHelper.getInstance()?.textTheme.headline5?.copyWith(
                    color: MyColors.pnbPersonalDataColor,
                    fontFamily: MyFont.Nunito_Sans_Semi_bold),
              ),
              Spacer(),
              SvgPicture.asset(
                Utils.path(RIGHTARROWIC), height: 17.h, width: 17.w,
                //
              ),
            ],
          ),
        ),

        isDivider
            ? Divider(
          thickness: 1,
          color: MyColors.PnbGrayTextColor,
        )
            : Container(
          height: 0.h,
        )
      ],
    );
  }

}
