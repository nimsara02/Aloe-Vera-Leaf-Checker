import 'package:flutter/material.dart';

class AnalysisResultScreen extends StatelessWidget {
  const AnalysisResultScreen({super.key});

  // App Theme Colors
  static const Color headerGreen = Color(0xFF2C7A59);
  static const Color brightGreen = Color(0xFF1E9E55);
  static const Color buttonGreen = Color(0xFF236147);
  static const Color confidenceBg = Color(0xFFDCFCE7);
  static const Color cardBorderColor = Color(0xFFE2E8F0);
  static const Color textColor = Color(0xFF1A202C);

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
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Analysis Result',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content Area
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Grade Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24.0),
                      color: brightGreen,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Export Grade',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Grade A',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    'Export Quality Approved',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.95),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Star Badge Icon
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFD54F),
                            size: 68,
                          ),
                        ],
                      ),
                    ),

                    // Quality Metrics Section
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quality Metrics',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Metric 1: Disease Status
                          _buildMetricTile(
                            icon: Icons.bug_report_rounded,
                            iconColor: Colors.teal,
                            label: 'Disease Status',
                            value: 'No Disease Detected',
                          ),
                          const SizedBox(height: 12),

                          // Metric 2: Color Quality
                          _buildMetricTile(
                            icon: Icons.palette_rounded,
                            iconColor: Colors.amber,
                            label: 'Color Quality',
                            value: 'Excellent – Uniform Green',
                          ),
                          const SizedBox(height: 12),

                          // Metric 3: Surface Damage
                          _buildMetricTile(
                            icon: Icons.search_rounded,
                            iconColor: Colors.purple,
                            label: 'Surface Damage',
                            value: 'No Damage Found',
                          ),
                          const SizedBox(height: 12),

                          // Metric 4: Thickness Score
                          _buildMetricTile(
                            icon: Icons.straighten_rounded,
                            iconColor: Colors.indigo,
                            label: 'Thickness Score',
                            value: '8.2 / 10',
                          ),
                          const SizedBox(height: 16),

                          // Model Confidence Progress Card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: confidenceBg,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Model Confidence',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2E7D32),
                                      ),
                                    ),
                                    Text(
                                      '96.4%',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1B5E20),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: 0.964,
                                    minHeight: 8,
                                    backgroundColor: Colors.black.withOpacity(0.08),
                                    valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                      buttonGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Action Buttons
                          Row(
                            children: [
                              // Save Button
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      // TODO: Save Result
                                    },
                                    icon: const Icon(
                                      Icons.save_outlined,
                                      color: buttonGreen,
                                      size: 18,
                                    ),
                                    label: const Text(
                                      'Save',
                                      style: TextStyle(
                                        color: buttonGreen,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: buttonGreen,
                                        width: 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Share Report Button
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // TODO: Share Report
                                    },
                                    icon: const Icon(
                                      Icons.share_outlined,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    label: const Text(
                                      'Share Report',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: buttonGreen,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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

  // Metric Item Helper
  Widget _buildMetricTile({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorderColor),
      ),
      child: Row(
        children: [
          // Metric Icon
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 14),

          // Label and Value Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),

          // Green Checkmark Icon
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }
}