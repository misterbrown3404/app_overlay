
// Now, let's create the overlay_service.dart file
// Add this to a file called overlay_service.dart

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:app_usage/app_usage.dart';

// This will be used as the entry point for our overlay
@pragma('vm:entry-point')
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OverlayService());
}

class OverlayService extends StatefulWidget {
  const OverlayService({Key? key}) : super(key: key);

  @override
  OverlayServiceState createState() => OverlayServiceState();
}

class OverlayServiceState extends State<OverlayService> {
  int _screenTimeLimit = 30;
  List<String> _restrictedApps = [];
  Timer? _usageCheckTimer;
  bool _shouldBlockScreen = false;
  String _currentForegroundApp = "";
  int _remainingTimeInSeconds = 0;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
    _startMonitoring();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _screenTimeLimit = prefs.getInt('screenTimeLimit') ?? 30;
      _restrictedApps = prefs.getStringList('restrictedApps') ?? [];
      _remainingTimeInSeconds = _screenTimeLimit * 60;
    });
  }
  
  // void _startMonitoring() {
  //   // Check every second
  //   _usageCheckTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
  //     //await _checkCurrentApp();
      
  //     if (_restrictedApps.contains(_currentForegroundApp) && _currentForegroundApp.isNotEmpty) {
  //       setState(() {
  //         _remainingTimeInSeconds -= 1;
  //       });
        
  //       if (_remainingTimeInSeconds <= 0) {
  //         setState(() {
  //           _shouldBlockScreen = true;
  //         });
  //       }
  //     }
  //   });
  // }
  void _startMonitoring() {
  _usageCheckTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
    await _checkAppUsage();
  });
}

  Future<void> _checkAppUsage() async {
  try {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);

    // Fetch usage stats
    List<AppUsageInfo> usageStats = await AppUsage().getAppUsage(startOfDay, now);

    for (var appUsage in usageStats) {
      String packageName = appUsage.packageName;
      int usageTimeInSeconds = appUsage.usage.inSeconds;

      print("$packageName used for $usageTimeInSeconds seconds");

      // Check if the app is restricted and exceeds the limit
      if (_restrictedApps.contains(packageName) && usageTimeInSeconds >= _screenTimeLimit * 60) {
        setState(() {
          _shouldBlockScreen = true;
        });
        return;
      }
    }
  } catch (e) {
    print("Error fetching app usage: $e");
  }
}


  // Future<void> _checkCurrentApp() async {
  //   try {
  //     // This is a simplified approach. In a real app, you would use
  //     // platform-specific methods to determine the foreground app
  //     // Note: This is a placeholder for the actual implementation
  //     final foregroundApp = await DeviceApps.listenToAppsChanges()
  //     if (foregroundApp != null) {
  //       setState(() {
  //         _currentForegroundApp = foregroundApp;
  //       });
  //     }
  //   } catch (e) {
  //     print("Error checking current app: $e");
  //   }
  // }
  
  void _resetTimer() {
    setState(() {
      _shouldBlockScreen = false;
      _remainingTimeInSeconds = _screenTimeLimit * 60;
    });
  }
  
  @override
  void dispose() {
    _usageCheckTimer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "$minutes:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldBlockScreen) {
      // Show a small floating timer when not blocking
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.transparent,
          body: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 50, right: 20),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Time left: ${_formatTime(_remainingTimeInSeconds)}",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ),
        ),
      );
    }
  
    // Full screen blocking overlay
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.9),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.access_time,
                color: Colors.white,
                size: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                "Screen Time Limit Reached",
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "You've reached your allowed screen time for this app.",
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Allow 5 more minutes
                  setState(() {
                    _remainingTimeInSeconds = 5 * 60;
                    _shouldBlockScreen = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text("Allow 5 More Minutes"),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Close the overlay and go back to home
                  FlutterOverlayWindow.closeOverlay();
                },
                child: const Text(
                  "Exit App",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

