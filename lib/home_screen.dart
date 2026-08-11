import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'system_controller.dart';
import 'session_wrapper.dart';
import 'capture_leaf_screen.dart';
import 'image_preview_screen.dart';
import 'scan_history_screen.dart';
import 'profile_settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String userRole;
  final String userPhone;

  const HomeScreen({
    super.key,
    this.userName = 'Nimsara',
    this.userRole = 'Farmer',
    this.userPhone = '0718787500',
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color primaryGreen = Color(0xFF2C7A59);
  static const Color darkCardGreen = Color(0xFF1F523D);
  static const Color lightCardGreen = Color(0xFF3B8365);
  static const Color oliveCardGreen = Color(0xFF536A48);

  @override
  void initState() {
    super.initState();
    // FR6: Initialize inactivity timer when Home loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemController.instance.resetSessionTimer(context);
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  @override
  Widget build(BuildContext context) {
    return SessionWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFFF7FAFC),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: primaryGreen,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getGreeting(),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    widget.userName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.eco,
                                    color: Color(0xFF81C784),
                                    size: 18,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileSettingsScreen(
                                    userName: widget.userName,
                                    userRole: widget.userRole,
                                    userPhone: widget.userPhone,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Quick Stats Bar
                      Row(
                        children: [
                          _buildStatCard('128', 'Total Scans', Icons.search, Colors.purpleAccent),
                          const SizedBox(width: 10),
                          _buildStatCard('89', 'Grade A', Icons.star, Colors.amber),
                          const SizedBox(width: 10),
                          _buildStatCard('12', 'Rejected', Icons.close, Colors.redAccent),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Quick Actions Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 1.25,
                        children: [
                          // 1. FR13 & FR15: Camera Permission & Capture Screen
                          _buildActionCard(
                            context,
                            title: 'Capture Leaf',
                            icon: Icons.camera_alt,
                            cardColor: darkCardGreen,
                            iconBgColor: Colors.purple.shade200,
                            onTap: () async {
                              bool hasPermission = await SystemController.instance
                                  .requestPermission(Permission.camera, context, 'Camera');

                              if (hasPermission && context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CaptureLeafScreen(),
                                  ),
                                );
                              }
                            },
                          ),

                          // 2. FR14 & FR15: Storage Permission & Upload Screen
                          _buildActionCard(
                            context,
                            title: 'Upload Image',
                            icon: Icons.photo_library,
                            cardColor: lightCardGreen,
                            iconBgColor: Colors.blue.shade200,
                            onTap: () async {
                              bool hasPermission = await SystemController.instance
                                  .requestPermission(Permission.photos, context, 'Storage');

                              if (hasPermission && context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ImagePreviewScreen(capturedImages: []),
                                  ),
                                );
                              }
                            },
                          ),

                          // 3. Scan History Screen
                          _buildActionCard(
                            context,
                            title: 'View History',
                            icon: Icons.bar_chart_rounded,
                            cardColor: oliveCardGreen,
                            iconBgColor: Colors.purpleAccent.shade100,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ScanHistoryScreen(),
                                ),
                              );
                            },
                          ),

                          // 4. FR36 & FR43: Network Check & Trigger Notification
                          _buildActionCard(
                            context,
                            title: 'Export Report',
                            icon: Icons.assignment_outlined,
                            cardColor: darkCardGreen,
                            iconBgColor: Colors.orange.shade200,
                            onTap: () async {
                              // FR36 Check
                              await SystemController.instance.checkNetworkConnectivity(context);

                              // FR43 Trigger Local Notification
                              await SystemController.instance.sendNotification(
                                title: 'Report Exported',
                                body: 'Your leaf inspection summary has been generated.',
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String val, String label, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(height: 6),
            Text(
              val,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color cardColor,
        required Color iconBgColor,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}