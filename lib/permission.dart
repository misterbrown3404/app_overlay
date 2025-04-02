// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:usage_stats/usage_stats.dart';

// Future<void> requestPermissions(BuildContext context) async{
//   if(!await Permission.systemAlertWindow.isGranted){
//     await Permission.systemAlertWindow.request();

//   }
//   if(!await hasUsageAccess()){
//     showUsageAccessDialog(context);
//   }
// }

// Future <bool> hasUsageAccess() async{
//   try{
//     List <EventUsageInfo> events = await UsageStats.queryEvents(DateTime.now().subtract(Duration(minutes: 1)), DateTime.now());

//     return events.isNotEmpty;
//   } catch(e){
//     return false;
//   }
  
// }
// void showUsageAccessDialog(BuildContext context){

//    showDialog(context: context, 
//    builder: (context) => AlertDialog(
//     title: Text("Enable usagr"),
//     content: Text("To Track app"),
//     actions: [
//       TextButton(onPressed: ()async{
//         await openAppSettings();
//         Navigator.pop(context);
//       }, child: Text("open Setting"))
//     ],
//    )) ;
//   }