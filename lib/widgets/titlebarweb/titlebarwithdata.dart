

// Widget TitleBarWithData(BuildContext context) {
//
//   var appConfig=WebAppConfig.of(context);
//   return Container(
//     color: MyColors.white,
//     width: MyDimension.width,
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           width: MyDimension.width,
//           height: MyDimension.getTitbarHeight(context),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 140.w),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SvgPicture.asset( MyImagePath(imagebaseurl: appConfig!.asstesPath).getImageUrl(SBISAHAJLOGO),
//                     width: 202.w, height: 48.w),
//                 Row(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Image(
//                         image: AssetImage(MyImagePath(imagebaseurl: appConfig!.asstesPath).getImageUrl(SBISAHAJLOGO)),
//                         width: 63.w,
//                         height: 65.w),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 40.w),
//                       child: Container(
//                         color: MyColors.dividerColor,
//                         width: 1.w,
//                         height: MyDimension.getTitbarHeight(context),
//                       ),
//                     ),
//                     UserInformationUI(context, CONST_BUSINESS_NAME, CONST_PAN),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         SahajNameBar(context),
//       ],
//     ),
//   );
// }
//
// Widget DropdownMenuUI(BuildContext context) {
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.start,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Padding(
//         padding: EdgeInsets.only(left: 15.w),
//         child: ClipPath(
//           clipper: CustomTriangleClipper(),
//           child: Container(
//             width: 15.w,
//             height: 15.w,
//             decoration: BoxDecoration(color: MyColors.white,border: Border.all(color: MyColors.dropdownMenuBorderColor, width: 1.w)),
//           ),
//         ),
//       ),
//       Container(
//         width: 200.w,
//         decoration: BoxDecoration(
//             color: MyColors.white,
//             border: Border.all(
//                 color: MyColors.dropdownMenuBorderColor, width: 1.w)),
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 20.w),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(bottom: 15.w),
//                     child: Text(
//                       "Dashboard",
//                       style: MyCustomTextStyle.getRegularText(
//                           MyColors.colorAccent, 14.w),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(bottom: 15.w),
//                     child: Text(
//                       "Transaction",
//                       style: MyCustomTextStyle.getRegularText(
//                           MyColors.colorAccent, 14.w),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(bottom: 15.w),
//                     child: Text(
//                       "Profile",
//                       style: MyCustomTextStyle.getRegularText(
//                           MyColors.colorAccent, 14.w),
//                     ),
//                   ),
//                   Text(
//                     "Raise a Dispute",
//                     style: MyCustomTextStyle.getRegularText(
//                         MyColors.colorAccent, 14.w),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ],
//   );
// }
//
// Widget UserInformationUI(
//     BuildContext context, String businessName, String panNo) {
//
//   var appConfig=WebAppConfig.of(context);
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Row(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//                 color: MyColors.dividerColor,
//                 borderRadius: BorderRadius.circular(30.w)),
//             height: 38.w,
//             width: 38.w,
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 10.w, right: 25.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       businessName,
//                       style: MyCustomTextStyle.getBoldText(
//                           MyColors.darkTextColor, 16.w),
//                     ),
//                     Icon(
//                       Icons.arrow_drop_down,
//                       color: MyColors.arrowDownColor,
//                       size: 20.w,
//                     )
//                   ],
//                 ),
//                 SizedBox(
//                   height: 5.w,
//                 ),
//                 Text(
//                   "PAN" + panNo,
//                   style: MyCustomTextStyle.getRegularText(
//                       MyColors.darkGreyColor, 13.w),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(right: 25.w),
//             child: SvgPicture.asset(
//               MyImagePath(imagebaseurl: appConfig!.asstesPath).getImageUrl(NOTIFICATIONICON),
//               height: 25.w,
//               width: 23.w,
//             ),
//           ),
//           GestureDetector(
//             child: SvgPicture.asset(
//               MyImagePath(imagebaseurl: appConfig!.asstesPath).getImageUrl(LOGOUT),
//               height: 24.w,
//               width: 24.w,
//             ),
//             onTap: () {
//               //showLogoutDialog(context);
//             },
//           ),
//         ],
//       ),
//     ],
//   );
// }

/*void showLogoutDialog(BuildContext context)
{

  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.4),
    pageBuilder: (_, __, ___) {
      return LogoutDialogUI(context);
    },
  );
}*/
