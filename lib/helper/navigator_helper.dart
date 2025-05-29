import 'package:flutter/cupertino.dart';

void pagereplacement(BuildContext context,Widget page)

{
 Navigator.of(context).pushReplacement(
   
   PageRouteBuilder(

     transitionDuration: Duration(milliseconds: 300),
     pageBuilder: (_,_,_) => page,
     transitionsBuilder: (_,animation,_,child){
       return FadeTransition(opacity: animation,child: child,);
     }
   )
 );


}