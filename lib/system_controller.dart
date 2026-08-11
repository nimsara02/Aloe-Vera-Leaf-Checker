import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'login_screen.dart';

class SystemController {
  static final SystemController instance = SystemController._init();
  SystemController._init();

  Timer? _sessionTimer;
  static const int _timeoutMinutes = 15; // Auto-logout after 15 mins of inactivity

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize Notifications (FR43)
  Future<void> initNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _notificationsPlugin.initialize(initSettings);
  }

  // FR43: Send Local Notification
  Future<void> sendNotification({required String title, required String body}) async {
    const androidDetails = AndroidNotificationDetails(
      'aloe_check_channel',
      'AloeCheck Notifications',
      channelDescription: 'Quality inspection & session updates',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(0, title, body, details);
  }

  // FR6: Reset Session Timeout Timer
  void resetSessionTimer(BuildContext context) {
    _sessionTimer?.cancel();
    _sessionTimer = Timer(const Duration(minutes: _timeoutMinutes), () {
      _handleSessionTimeout(context);
    });
  }

  void stopSessionTimer() {
    _sessionTimer?.cancel();
  }

  // FR6: Logout on Inactivity
  void _handleSessionTimeout(BuildContext context) {
    sendNotification(
      title: 'Session Expired',
      body: 'You were logged out due to 15 minutes of inactivity.',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Session timed out due to inactivity. Please log in again.'),
        backgroundColor: Colors.orange,
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
    );
  }

  // FR13, FR14, FR15: Request Camera & Storage Permissions with Denial Handling
  Future<bool> requestPermission(Permission permission, BuildContext context, String featureName) async {
    final status = await permission.request();

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$featureName permission is required to use this feature.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return false;
    } else if (status.isPermanentlyDenied) {
      if (context.mounted) {
        _showPermissionSettingsDialog(context, featureName);
      }
      return false;
    }
    return false;
  }

  // FR15: Permanent Denial Dialog
  void _showPermissionSettingsDialog(BuildContext context, String featureName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$featureName Permission Required'),
        content: Text(
          '$featureName access was permanently denied. Please enable it in Device Settings to proceed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  // FR36: Check Network Connectivity
  Future<bool> checkNetworkConnectivity(BuildContext context) async {
    final List<ConnectivityResult> connectivityResult =
    await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.wifi_off, color: Colors.white),
                SizedBox(width: 8),
                Text('No Internet Connection. Offline mode enabled.'),
              ],
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return false;
    }
    return true;
  }
}