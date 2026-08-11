import 'dart:io';
import 'dart:math';

// Data Model for Analysis Results
class AnalysisResult {
  final String leafId;
  final String grade; // Grade A, Grade B, Rejected
  final String diseaseDetected; // Healthy, Leaf Spot, Root Rot, Sunburn
  final double confidenceScore; // e.g., 94.5%
  final String gradingReason;
  final DateTime timestamp;

  AnalysisResult({
    required this.leafId,
    required this.grade,
    required this.diseaseDetected,
    required this.confidenceScore,
    required this.gradingReason,
    required this.timestamp,
  });
}

class AnalysisService {
  static final AnalysisService instance = AnalysisService._init();
  AnalysisService._init();

  // FR20, FR22, FR23, FR26: Main Analysis Pipeline
  Future<AnalysisResult> analyzeLeaf(File imageFile) async {
    // Simulate network/inference processing delay
    await Future.delayed(const Duration(seconds: 3));

    // FR30: Random failure simulation (5% chance to test failure handling)
    final random = Random();
    if (random.nextDouble() < 0.05) {
      throw Exception("Analysis failed due to image processing error.");
    }

    // =========================================================================
    // 🛑 MODEL INTEGRATION PLACEHOLDER 🛑
    // Once your TFLite model is ready, run inference here:
    // var output = await tfliteInterpreter.run(imageBytes);
    // =========================================================================

    // FR23: Disease Detection Output Simulation
    final List<String> diseases = ['Healthy', 'Leaf Spot', 'Rot / Fungus', 'Sunburn'];
    final detectedDisease = diseases[random.nextInt(diseases.length)];
    final confidence = 85.0 + random.nextDouble() * 12.0; // 85% to 97%

    // FR26: Grading Priority Rule Logic
    // Rules:
    // 1. Healthy + Confidence >= 90% -> Grade A
    // 2. Minor defects (Spot/Sunburn) OR Confidence < 90% -> Grade B
    // 3. Rot/Fungus -> REJECTED
    String grade;
    String reason;

    if (detectedDisease == 'Rot / Fungus') {
      grade = 'Rejected';
      reason = 'Severe fungal damage detected. Leaf is unsuitable for processing.';
    } else if (detectedDisease == 'Healthy' && confidence >= 90.0) {
      grade = 'Grade A';
      reason = 'Optimal leaf thickness, color uniformity, and zero surface blemishes.';
    } else if (detectedDisease == 'Healthy') {
      grade = 'Grade B';
      reason = 'Slight surface discoloration detected, but overall acceptable.';
    } else {
      grade = 'Grade B';
      reason = 'Minor localized $detectedDisease detected. Suitable for secondary processing.';
    }

    return AnalysisResult(
      leafId: '#ALOE-${random.nextInt(8999) + 1000}',
      grade: grade,
      diseaseDetected: detectedDisease,
      confidenceScore: double.parse(confidence.toStringAsFixed(1)),
      gradingReason: reason,
      timestamp: DateTime.now(),
    );
  }
}