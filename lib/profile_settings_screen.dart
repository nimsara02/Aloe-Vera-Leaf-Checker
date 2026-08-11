import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'login_screen.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final String userName;
  final String userRole;
  final String userPhone;
  final String userEmail;

  const ProfileSettingsScreen({
    super.key,
    this.userName = 'Nimsara',
    this.userRole = 'Farmer',
    this.userPhone = '0718787500',
    this.userEmail = 'nimsara@gmail.com',
  });

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  // State Variables for Preferences
  bool _notificationsEnabled = true;
  bool _offlineModeEnabled = false;
  String _selectedLanguage = 'English';
  String _selectedUnitSystem = 'Metric';

  // Dynamic User Profile State
  late String _currentName;
  late String _currentPhone;
  late String _currentRole;

  static const Color primaryGreen = Color(0xFF2C7A59);
  static const Color buttonGreen = Color(0xFF236147);
  static const Color sectionHeaderColor = Color(0xFF8C9BA5);

  @override
  void initState() {
    super.initState();
    _currentName = widget.userName;
    _currentPhone = widget.userPhone;
    _currentRole = widget.userRole;
  }

  // Edit Profile Dialog
  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _currentName);
    final phoneController = TextEditingController(text: _currentPhone);
    final roleController = TextEditingController(text: _currentRole);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Profile', style: TextStyle(fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_android),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: roleController,
              decoration: const InputDecoration(
                labelText: 'Role / Occupation',
                prefixIcon: Icon(Icons.work_outline),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: buttonGreen),
            onPressed: () {
              setState(() {
                _currentName = nameController.text.trim();
                _currentPhone = phoneController.text.trim();
                _currentRole = roleController.text.trim();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Language Picker Dialog
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select Language'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          children: ['English', 'Sinhala', 'Tamil'].map((lang) {
            return SimpleDialogOption(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              onPressed: () {
                setState(() => _selectedLanguage = lang);
                Navigator.pop(context);
              },
              child: Text(
                lang,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: _selectedLanguage == lang ? FontWeight.bold : FontWeight.normal,
                  color: _selectedLanguage == lang ? primaryGreen : Colors.black87,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // Unit System Picker Dialog
  void _showUnitSystemDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select Unit System'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          children: ['Metric', 'Imperial'].map((unit) {
            return SimpleDialogOption(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              onPressed: () {
                setState(() => _selectedUnitSystem = unit);
                Navigator.pop(context);
              },
              child: Text(
                unit,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: _selectedUnitSystem == unit ? FontWeight.bold : FontWeight.normal,
                  color: _selectedUnitSystem == unit ? primaryGreen : Colors.black87,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // Data Privacy Settings Dialog
  void _showDataPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.privacy_tip_outlined, color: primaryGreen),
            SizedBox(width: 8),
            Text('Data Privacy Settings', style: TextStyle(fontSize: 18)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your privacy is fully protected in AloeCheck:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            SizedBox(height: 10),
            Text('• Credentials & profile details are stored locally via SQLite.'),
            SizedBox(height: 6),
            Text('• Image analysis is performed on-device without cloud uploads.'),
            SizedBox(height: 6),
            Text('• No personally identifiable data is shared with third parties.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: primaryGreen)),
          ),
        ],
      ),
    );
  }

  // Password Change Dialog
  void _showChangePasswordDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Change Password', style: TextStyle(fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password (min 6 chars)',
                prefixIcon: Icon(Icons.lock_reset),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                prefixIcon: Icon(Icons.check_circle_outline),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: buttonGreen),
            onPressed: () async {
              final oldPass = oldPasswordController.text.trim();
              final newPass = newPasswordController.text.trim();
              final confirmPass = confirmPasswordController.text.trim();

              if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in all fields.')),
                );
                return;
              }

              if (newPass.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New password must be at least 6 characters.')),
                );
                return;
              }

              if (newPass != confirmPass) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New passwords do not match.')),
                );
                return;
              }

              bool success = await DatabaseHelper.instance.changePassword(
                widget.userEmail,
                oldPass,
                newPass,
              );

              if (!context.mounted) return;

              if (success) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password changed successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Incorrect current password.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Update', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        backgroundColor: primaryGreen,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Green Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              color: primaryGreen,
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD3EAD8),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 45,
                      color: primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _currentName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_currentRole · Aloe Vera Inspector',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ACCOUNT Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ACCOUNT',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: sectionHeaderColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildOptionCard(
                    icon: Icons.person_outline,
                    iconColor: Colors.purple,
                    title: 'Edit Profile',
                    onTap: _showEditProfileDialog,
                  ),
                  const SizedBox(height: 10),
                  _buildOptionCard(
                    icon: Icons.lock_outline,
                    iconColor: Colors.amber.shade700,
                    title: 'Change Password',
                    onTap: _showChangePasswordDialog,
                  ),
                  const SizedBox(height: 10),
                  _buildOptionCard(
                    icon: Icons.phone_android_outlined,
                    iconColor: Colors.indigo,
                    title: 'Phone: ${_currentPhone.isEmpty ? 'Not Provided' : _currentPhone}',
                    onTap: _showEditProfileDialog,
                  ),
                  const SizedBox(height: 10),
                  _buildOptionCard(
                    icon: Icons.privacy_tip_outlined,
                    iconColor: Colors.teal,
                    title: 'Data Privacy Settings',
                    onTap: _showDataPrivacyDialog,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // PREFERENCES Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PREFERENCES',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: sectionHeaderColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildValueCard(
                    icon: Icons.language,
                    iconColor: Colors.blue,
                    title: 'Language',
                    value: _selectedLanguage,
                    onTap: _showLanguageDialog,
                  ),
                  const SizedBox(height: 10),
                  _buildValueCard(
                    icon: Icons.straighten,
                    iconColor: Colors.purple,
                    title: 'Unit System',
                    value: _selectedUnitSystem,
                    onTap: _showUnitSystemDialog,
                  ),
                  const SizedBox(height: 10),
                  _buildToggleCard(
                    icon: Icons.notifications_none,
                    iconColor: Colors.amber.shade700,
                    title: 'Notifications',
                    value: _notificationsEnabled,
                    onChanged: (val) {
                      setState(() {
                        _notificationsEnabled = val;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildToggleCard(
                    icon: Icons.wifi_off,
                    iconColor: Colors.orange.shade700,
                    title: 'Offline Mode',
                    value: _offlineModeEnabled,
                    onChanged: (val) {
                      setState(() {
                        _offlineModeEnabled = val;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Logout Button
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                            (route) => false,
                      );
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFFFD6D6)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.redAccent, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: iconColor, size: 22),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildValueCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: iconColor, size: 22),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 22),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: primaryGreen,
        ),
      ),
    );
  }
}