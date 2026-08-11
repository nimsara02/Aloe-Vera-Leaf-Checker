import 'dart:io';
import 'dart:math';

class DetailedGradingMetrics {
  final double greenPercentage; // FR24
  final double yellowBrowningPercentage; // FR24
  final double physicalDamagePercentage; // FR25
  final String damageType; // FR25: e.g., Tip Burn, Scratches, Cut/Tear, None
  final String finalGrade; // FR27: Grade A, Grade B, Rejected
  final String reason;

  DetailedGradingMetrics({
    required this.greenPercentage,
    required this.yellowBrowningPercentage,
    required this.physicalDamagePercentage,
    required this.damageType,
    required this.finalGrade,
    required this.reason,
  });
}

class GradingEngine {
  // FR24, FR25, FR27: Process leaf features and derive multi-parameter grade
  static Future<DetailedGradingMetrics> evaluateLeaf({
    required File imageFile,
    required String diseaseDetected,
    required double diseaseConfidence,
  }) async {
    final random = Random();

    // FR24: Color Analysis Engine (Simulating Hue/Saturation Masking)
    double greenPct;
    double yellowPct;

    if (diseaseDetected == 'Healthy') {
      greenPct = 88.0 + random.nextDouble() * 10.0; // 88% - 98%
      yellowPct = 100.0 - greenPct;
    } else if (diseaseDetected == 'Sunburn') {
      greenPct = 60.0 + random.nextDouble() * 15.0;
      yellowPct = 100.0 - greenPct;
    } else {
      greenPct = 50.0 + random.nextDouble() * 20.0;
      yellowPct = 100.0 - greenPct;
    }

    // FR25: Physical Damage Detection Engine
    final damageTypes = ['None', 'Surface Scratches', 'Tip Burn', 'Edge Cut/Tear'];
    String damageType;
    double damagePct;

    if (diseaseDetected == 'Healthy' && greenPct > 90.0) {
      damageType = 'None';
      damagePct = random.nextDouble() * 3.0; // <3% minor blemishes
    } else {
      damageType = damageTypes[1 + random.nextInt(damageTypes.length - 1)];
      damagePct = 5.0 + random.nextDouble() * 20.0; // 5% - 25%
    }

    // FR27: Final Grade Generation Algorithm
    // Weighted Criteria:
    // - Rejected if Disease = Rot/Fungus OR Physical Damage > 20% OR Green < 55%
    // - Grade A if Green >= 85%, Damage < 5%, and Healthy
    // - Grade B otherwise
    String finalGrade;
    String reason;

    if (diseaseDetected == 'Rot / Fungus') {
      finalGrade = 'Rejected';
      reason = 'Rejected due to severe fungal/rot disease.';
    } else if (damagePct > 20.0) {
      finalGrade = 'Rejected';
      reason = 'Rejected due to severe physical damage (${damagePct.toStringAsFixed(1)}% $damageType).';
    } else if (greenPct < 55.0) {
      finalGrade = 'Rejected';
      reason = 'Rejected due to severe color degradation (${yellowPct.toStringAsFixed(1)}% yellowing/browning).';
    } else if (diseaseDetected == 'Healthy' && greenPct >= 85.0 && damagePct < 5.0) {
      finalGrade = 'Grade A';
      reason = 'Premium Quality: >85% green hue, minimal physical damage, and disease-free.';
    } else {
      finalGrade = 'Grade B';
      reason = 'Standard Quality: Minor surface defects ($damageType) or moderate color variation detected.';
    }

    return DetailedGradingMetrics(
      greenPercentage: double.parse(greenPct.toStringAsFixed(1)),
      yellowBrowningPercentage: double.parse(yellowPct.toStringAsFixed(1)),
      physicalDamagePercentage: double.parse(damagePct.toStringAsFixed(1)),
      damageType: damageType,
      finalGrade: finalGrade,
      reason: reason,
    );
  }
}