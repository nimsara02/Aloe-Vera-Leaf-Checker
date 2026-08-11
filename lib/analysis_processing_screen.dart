import 'dart:async'; // 1. Added for Timer
import 'package:flutter/material.dart';
import 'analysis_result_screen.dart'; // 2. Added for navigation

class AnalysisProcessingScreen extends StatefulWidget {
  const AnalysisProcessingScreen({super.key});

  @override
  State<AnalysisProcessingScreen> createState() => _AnalysisProcessingScreenState();
}

class _AnalysisProcessingScreenState extends State<AnalysisProcessingScreen> {
  static const Color headerGreen = Color(0xFF2C7A59);
  static const Color primaryGreen = Color(0xFF236147);

  // 3. This initState runs automatically when this screen opens
  @override
  void initState() {
    super.initState();

    // Wait for 3 seconds, then navigate to AnalysisResultScreen
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AnalysisResultScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Bar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              color: headerGreen,
              child: const Row(
                children: [
                  SizedBox(width: 8),
                  Text(
                    'Analyzing Image',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Loading / Processing Content
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Loading Spinner
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        color: primaryGreen,
                        strokeWidth: 5,
                      ),
                    ),
                    SizedBox(height: 28),
                    Text(
                      'Analyzing Aloe Vera Leaf...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Checking for disease, color, and leaf quality',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}