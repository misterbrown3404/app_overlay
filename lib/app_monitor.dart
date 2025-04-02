// import 'dart:async';

// import 'package:flutter_overlay_window/flutter_overlay_window.dart';
// import 'package:usage_stats/usage_stats.dart';

// class AppMonitor {
//   static void startMonitoring(){
//     Timer.periodic(const Duration(seconds: 5),(timer) async{
//       var endTime = DateTime.now();
//       var startTime = endTime.subtract(const Duration(seconds: 5));

//       List<EventUsageInfo> events = 
//       await UsageStats.queryEvents(startTime, endTime);
      
//       if(events.isNotEmpty){
//         String? lastOpenedApp = events.last.packageName;
//         print('App Launched: $lastOpenedApp');

//         if(lastOpenedApp != "com.example.app"){
//           showOverlay();
//         }
//       }

//     });
//   }
// }

// Future <void> showOverlay() async{
//   await FlutterOverlayWindow.showOverlay(
//     height: 150,
//     width: 300,
//     enableDrag: true,
//     overlayTitle: "Screen Time Alert",
//     overlayContent: "Reduce screen time!"
//   );
// }