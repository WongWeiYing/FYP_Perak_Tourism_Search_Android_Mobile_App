// Flutter project for IC scanning and face recognition before login
// This code provides a full UI and functionality flow.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/constants/app_text_style.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/screens/login/face_capture_page.dart';
import 'package:go_perak/widgets/button/primary_button.dart';
import 'package:go_perak/widgets/message/toast_message.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class ICScanPage extends StatefulWidget {
  const ICScanPage({super.key});

  @override
  State<ICScanPage> createState() => _ICScanPageState();
}

class _ICScanPageState extends State<ICScanPage> {
  XFile? icImage;
  String icNumber = '';
  String name = '';

  Future<void> pickICImage({bool fromCamera = false}) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (image == null) return;

    final extractedDetails = await extractIcDetails(image.path);

    if (extractedDetails != null) {
      setState(() {
        icImage = image;
        icNumber = extractedDetails['icNumber'] ?? 'Unknown IC Number';
        name = extractedDetails['name'] ?? 'Unknown Name';
      });
      showCustomSnackBar(context, 'IC scanned successfully!');
    } else {
      showCustomSnackBar(context, 'Failed to extract IC details.');
    }
  }

  void showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Image Source'),
        content: const Text(
            'Would you like to take a new photo or select from the gallery?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              pickICImage(fromCamera: true);
            },
            child: Text('Camera', style: AppTextStyle.bodyText),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              pickICImage(fromCamera: false);
            },
            child: Text('Gallery', style: AppTextStyle.bodyText),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasDetails = icNumber.isNotEmpty && name.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Step 1: Scan IC'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icImage != null
                ? Image.file(File(icImage!.path), width: 250, height: 150)
                : const Text('No IC image selected.'),
            const SizedBox(height: 16),
            if (hasDetails) ...[
              Text('Name: $name'),
              gapHeight8,
              Text('IC Number: $icNumber'),
              gapHeight24,
              PrimaryButton(
                width: 300,
                height: 40,
                title: 'Proceed to Face Capture',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    CustomRouter.faceCapture,
                    arguments: FaceCapturePage(
                      icImagePath: icImage!.path,
                      name: name,
                      icNo: icNumber,
                    ),
                  );
                },
              ),
              gapHeight24,
            ],
            PrimaryButton(
              width: 300,
              height: 40,
              title: 'Scan IC',
              onTap: showImageSourceDialog,
            ),
          ],
        ),
      ),
    );
  }
}

// OCR Function to extract IC details
Future<Map<String, String>?> extractIcDetails(String imagePath) async {
  final inputImage = InputImage.fromFilePath(imagePath);
  final textRecognizer = GoogleMlKit.vision.textRecognizer();
  final recognizedText = await textRecognizer.processImage(inputImage);

  final icRegex = RegExp(r'\b\d{6}-\d{2}-\d{4}\b');
  String? icNumber;
  String? name;
  bool captureNextLineAsName = false;

  for (final block in recognizedText.blocks) {
    for (final line in block.lines) {
      print('Line: ${line.text}');

      if (icRegex.hasMatch(line.text)) {
        icNumber = icRegex.firstMatch(line.text)?.group(0);
        captureNextLineAsName = true;
      } else if (captureNextLineAsName) {
        name = line.text;
        captureNextLineAsName = false;
        break;
      }
    }
  }

  await textRecognizer.close();

  if (icNumber != null && name != null) {
    return {'icNumber': icNumber, 'name': name};
  }
  return null;
}
