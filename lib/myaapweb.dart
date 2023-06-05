import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sbi_sahay_1_0/mainScreen.dart';
import 'package:sbi_sahay_1_0/routes.dart';
import 'package:sbi_sahay_1_0/testui.dart';


import 'hidescrollbar.dart';




class MyAppForWeb extends StatelessWidget {
  const MyAppForWeb({super.key});

  @override
  Widget build(BuildContext context) {


    return  MaterialApp(
            debugShowCheckedModeBanner: false,

         //   home: MainScrren(isTitleBardRequeired: false, isSahajLineRequired: false, isDashboardMenuRequired: false, isStepperMenuRequired: false, isFooterSpaceRequired: false, childWidgets: FinanceOption()),
            scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
            routes: {
             // MyRoutes.loginRoutes :(context) =>LoginView(),



            },




        );

  }
}

class RouteGenerator {
  // static Route<dynamic> generateRoute(RouteSettings settings) {
  //   String? route;
  //   Map? queryParameters;
  //   if (settings.name != null) {
  //     var uriData = Uri.parse(settings.name!);
  //     route = uriData.path;
  //
  //     if (route == MyRoutes.aarepponse || route == MyRoutes.ConsentMonitoring) {
  //       queryParameters = uriData.queryParameters;
  //     }
  //   }
  //
  //   return MaterialPageRoute(
  //     builder: (context) {
  //       if (route == MyRoutes.aarepponse) { /* call after account aggregator */
  //         if(responseQueryParam != null || responseQueryParam?.isEmpty==false){
  //           return AccountAggregatorResponseHome(str: responseQueryParam!);
  //         }else{
  //           return AccountAggregatorResponseHome(str: queryParameters!);
  //         }
  //
  //
  //       } else if (route == MyRoutes.ConsentMonitoring) { /*Call after Setup E-Mandate is done*/
  //
  //         return ConsentMonitoringHome(str: queryParameters!);
  //       } else if (route == MyRoutes.enchResponse) { /*Call after Setup E-Mandate*/
  //         return ENachResponseHome();
  //       } else if (route == MyRoutes.ddeResponse) { /* Call after Loan Agreement Process*/
  //         return DdeResponseHome();
  //       } else {
  //         return Container();
  //       }
  //     },
  //     settings: settings,
  //   );
  // }


}