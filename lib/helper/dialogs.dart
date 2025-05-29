import 'package:flutter/material.dart';

class Dialogs
{
  static void showsnackbar(BuildContext context,String msg){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg),backgroundColor: Color(
        0xFF38B677).withOpacity(.8),behavior: SnackBarBehavior.floating,shape:RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10)),));
  }

  static void showprogressbar(BuildContext context, )
  {
    showDialog(context: context, builder: (_)=>Center(child: CircularProgressIndicator()));
  }

}
