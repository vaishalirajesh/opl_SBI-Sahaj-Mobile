import 'package:flutter/material.dart';

class CustomRightToLeftPageRoute extends PageRouteBuilder{
   final Widget child; CustomRightToLeftPageRoute({required this.child}): super(
   reverseTransitionDuration: Duration(milliseconds: 100),
   transitionDuration: Duration(milliseconds: 150), pageBuilder: (context,animation,seconAnimation)=>child,);
   @override
   Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
   return SlideTransition(
  position:Tween<Offset>(
   begin: Offset(1,0),
   end: Offset.zero,
   ).animate(animation), child: child);
   }

}