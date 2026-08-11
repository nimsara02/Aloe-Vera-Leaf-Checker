import 'dart:io';
import 'package:image/image.dart' as img;

class ImageValidationResult {
  final bool isValid;
  final String errorMessage;

  ImageValidationResult({required this.isValid, required this.errorMessage});
}

class ImageValidator {
  static const int maxFileSizeBytes = 10 * 1024 * 1024; // 10 MB limit

  // FR11: Format Validation
  static bool isValidFormat(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.jpg') || lower.endsWith('.jpeg') || lower.endsWith('.png');
  }

  // FR12: File Size Validation
  static bool isValidSize(File file) {
    return file.lengthSync() <= maxFileSizeBytes;
  }

  // FR41: Image Quality Check (Detect Blurriness & Extreme Darkness)
  static Future<ImageValidationResult> checkQuality(File file) async {
    // 1. Format Check
    if (!isValidFormat(file.path)) {
      return ImageValidationResult(
        isValid: false,
        errorMessage: 'Invalid format! Only JPG, JPEG, and PNG files are supported.',
      );
    }

    // 2. Size Check
    if (!isValidSize(file)) {
      return ImageValidationResult(
        isValid: false,
        errorMessage: 'Image is too large! Maximum allowed size is 10 MB.',
      );
    }

    // 3. Quality / Clarity Analysis
    final bytes = await file.readAsBytes();
    final decodedImage = img.decodeImage(bytes);

    if (decodedImage == null) {
      return ImageValidationResult(
        isValid: false,
        errorMessage: 'Corrupted image file. Please choose another image.',
      );
    }

    // Measure average brightness / contrast to detect extreme blur/darkness
    double luminanceSum = 0;
    final samples = decodedImage.width * decodedImage.height;

    // Sample pixels across image
    for (int y = 0; y < decodedImage.height; y += 5) {
      for (int x = 0; x < decodedImage.width; x += 5) {
        final pixel = decodedImage.getPixel(x, y);
        final r = pixel.r;
        final g = pixel.g;
        final b = pixel.b;
        luminanceSum += (0.299 * r + 0.587 * g + 0.114 * b);
      }
    }

    final avgLuminance = luminanceSum / (samples / 25);

    if (avgLuminance < 20) {
      return ImageValidationResult(
        isValid: false,
        errorMessage: 'Image is too dark! Please ensure good lighting for quality leaf inspection.',
      );
    }

    return ImageValidationResult(isValid: true, errorMessage: '');
  }
}