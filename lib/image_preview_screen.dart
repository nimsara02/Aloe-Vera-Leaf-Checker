import 'dart:io';
import 'package:flutter/material.dart';

// Import for destination analysis screen
import 'analysis_screen.dart';

class ImagePreviewScreen extends StatefulWidget {
  final List<File> capturedImages;

  const ImagePreviewScreen({
    Key? key,
    required this.capturedImages,
  }) : super(key: key);

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  late List<File> _selectedImages;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Copy passed list so local deletions don't cause unexpected state bugs
    _selectedImages = List<File>.from(widget.capturedImages);
  }

  // Remove image from review list
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
      if (_currentIndex >= _selectedImages.length && _selectedImages.isNotEmpty) {
        _currentIndex = _selectedImages.length - 1;
      }
    });
  }

  // Navigation action passing imageFile directly to AnalysisScreen
  void _proceedToAnalysis() {
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture or select at least one leaf image.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Step 3 Navigation: Pass selected image file cleanly
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnalysisScreen(
          imageFile: _selectedImages[_currentIndex],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Leaf Captures'),
        backgroundColor: Colors.green[700],
        actions: [
          if (_selectedImages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Remove Current Image',
              onPressed: () => _removeImage(_currentIndex),
            ),
        ],
      ),
      body: _selectedImages.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.no_photography, size: 70, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No images available to preview.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Return to Capture'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      )
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Main Image Display Container
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: Colors.black12,
                    child: Image.file(
                      _selectedImages[_currentIndex],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Thumbnail selector row (if multiple images captured)
              if (_selectedImages.length > 1) ...[
                SizedBox(
                  height: 70,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      final isSelected = index == _currentIndex;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? Colors.green[700]! : Colors.transparent,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.file(
                              _selectedImages[index],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Action Buttons Row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retake'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        foregroundColor: Colors.green[800],
                        side: BorderSide(color: Colors.green[700]!),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _proceedToAnalysis,
                      icon: const Icon(Icons.analytics_outlined),
                      label: const Text('Analyze Leaf'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}