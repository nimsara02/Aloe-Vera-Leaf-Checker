import 'dart:io';
import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'detailed_result_screen.dart';

class AnalysisScreen extends StatefulWidget {
  final File? imageFile;

  const AnalysisScreen({Key? key, this.imageFile}) : super(key: key);

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  bool _isAnalyzing = true;
  bool _hasError = false;
  String _statusMessage = 'Initializing analysis pipeline...';
  ResultRecord? _currentResult;

  @override
  void initState() {
    super.initState();
    _startAnalysisProcess();
  }

  // Simulated AI analysis pipeline & SQLite database insert
  Future<void> _startAnalysisProcess() async {
    setState(() {
      _isAnalyzing = true;
      _hasError = false;
      _statusMessage = 'Detecting leaf structure & anomalies...';
    });

    try {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;

      setState(() {
        _statusMessage = 'Measuring color distribution & defects...';
      });

      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;

      setState(() {
        _statusMessage = 'Evaluating quality grade & saving result...';
      });

      // Construct complete ResultRecord with all required fields
      final newResult = ResultRecord(
        leafId: "LEAF-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}",
        imagePath: widget.imageFile?.path ?? '',
        finalGrade: "Grade A",
        diseaseDetected: "Healthy / None",
        confidenceScore: 0.96,
        greenColorPct: 88.5,
        yellowBrowningPct: 5.2,
        physicalDamagePct: 2.1,
        damageType: "None",
        gradingReason: "High chlorophyll density and optimal surface integrity.",
        timestamp: DateTime.now().toString().split('.')[0],
      );

      // Persist to SQLite
      final savedId = await DatabaseHelper.instance.insertResult(newResult);

      // Re-create record instance with assigned SQLite ID
      _currentResult = ResultRecord(
        id: savedId,
        leafId: newResult.leafId,
        imagePath: newResult.imagePath,
        finalGrade: newResult.finalGrade,
        diseaseDetected: newResult.diseaseDetected,
        confidenceScore: newResult.confidenceScore,
        greenColorPct: newResult.greenColorPct,
        yellowBrowningPct: newResult.yellowBrowningPct,
        physicalDamagePct: newResult.physicalDamagePct,
        damageType: newResult.damageType,
        gradingReason: newResult.gradingReason,
        timestamp: newResult.timestamp,
      );

      setState(() {
        _isAnalyzing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isAnalyzing = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        title: const Text('Leaf Analysis'),
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _isAnalyzing
              ? _buildLoadingState()
              : _hasError
              ? _buildErrorState()
              : _buildSuccessState(),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: CircularProgressIndicator(
              color: Colors.green[700],
              strokeWidth: 4,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Analyzing Aloe Vera Leaf',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _statusMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(
            'Analysis Failed',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'An issue occurred while processing the image or saving to the database.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _startAnalysisProcess,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry Analysis'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    if (_currentResult == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.check_circle_outline, size: 70, color: Colors.green),
        const SizedBox(height: 16),
        Text(
          'Inspection Completed!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your leaf scan was analyzed and saved to history.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),

        // Result Summary Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _currentResult!.leafId,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _currentResult!.finalGrade,
                        style: TextStyle(
                          color: Colors.green[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Text(
                  'Disease Detection: ${_currentResult!.diseaseDetected}',
                  style: TextStyle(color: Colors.grey[800], fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  'Confidence Score: ${(_currentResult!.confidenceScore * 100).toStringAsFixed(1)}%',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
        ),

        const Spacer(),

        // Navigation Button to Detailed Results
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DetailedResultScreen(record: _currentResult!),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'View Detailed Metrics',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}