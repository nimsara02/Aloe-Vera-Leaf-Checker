import 'package:flutter/material.dart';

class GradingCriteriaScreen extends StatelessWidget {
  const GradingCriteriaScreen({super.key});

  static const Color primaryGreen = Color(0xFF2C7A59);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grading Criteria & Help'),
        backgroundColor: primaryGreen,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FR39: Grading Rules Criteria
              const Text(
                'Quality Inspection Criteria (FR39)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildGradeRuleTile('Grade A (Premium)', 'Confidence >= 90%, zero visible defects, dark green color, healthy pulp.', Colors.green),
              _buildGradeRuleTile('Grade B (Standard)', 'Minor leaf spot or sunburn defects. Acceptable for processing.', Colors.orange),
              _buildGradeRuleTile('Rejected', 'Root rot, severe fungal disease, or severe physical decomposition.', Colors.red),

              const Divider(height: 36),

              // FR40: Help / Documentation
              const Text(
                'Help & Documentation (FR40)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const ExpansionTile(
                title: Text('How to get accurate AI analysis results?'),
                children: [
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('Place the Aloe Vera leaf on a clean, light surface with good natural lighting. Ensure no shadow obscures defects.'),
                  )
                ],
              ),
              const ExpansionTile(
                title: Text('What happens if analysis fails?'),
                children: [
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('You can tap "Retry Analysis" or retake the image with better lighting and focus.'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradeRuleTile(String title, String desc, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }
}