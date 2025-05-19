import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/screens/login/sign_up_page.dart';
import 'package:go_perak/widgets/button/primary_button.dart';
import 'package:go_perak/widgets/message/toast_message.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class FaceCapturePage extends StatefulWidget {
  final String icImagePath;
  final String icNo;
  final String name;
  const FaceCapturePage(
      {super.key,
      required this.icImagePath,
      required this.icNo,
      required this.name});

  @override
  State<FaceCapturePage> createState() => _FaceCapturePageState();
}

class _FaceCapturePageState extends State<FaceCapturePage> {
  CameraController? controller;
  bool isProcessing = false;
  int selectedCameraIndex = 0; // Track which camera is active

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    // Prefer front-facing camera if available
    final frontCameraIndex = cameras.indexWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    selectedCameraIndex = frontCameraIndex != -1 ? frontCameraIndex : 0;

    controller = CameraController(
      cameras[selectedCameraIndex],
      ResolutionPreset.medium,
    );
    await controller!.initialize();
    if (controller!.value.isInitialized) {
      await controller!.lockCaptureOrientation();
    }
    if (mounted) {
      setState(() {});
    }
  }

  void switchCamera() async {
    final cameras = await availableCameras();
    if (cameras.length > 1) {
      selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;
      await controller?.dispose();
      initializeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> captureAndCompare() async {
    if (controller == null || !controller!.value.isInitialized) return;

    setState(() => isProcessing = true);

    final liveImage = await controller!.takePicture();
    final isMatched = await compareFaces(widget.icImagePath, liveImage.path);

    setState(() => isProcessing = false);

    if (isMatched) {
      // Navigate to next screen
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Face matched successfully!')),

      // );
      showCustomSnackBar(context, 'Face matched successfully!');

      Navigator.pushNamed(context, CustomRouter.signUp,
          arguments: SignUpPage(
            name: widget.name,
            icNo: widget.icNo,
          ));
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Verification Failed'),
          content: const Text('Face mismatch. Please try again.'),
          actions: [
            PrimaryButton(
              onTap: () => Navigator.pop(context),
              title: 'Retry',
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Step 2: Face Capture')),
      body: Column(
        children: [
          Expanded(
            child: controller != null && controller!.value.isInitialized
                ? CameraPreview(controller!)
                : const Center(child: CircularProgressIndicator()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: isProcessing ? null : captureAndCompare,
                child: isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Capture & Verify'),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.flip_camera_ios),
                onPressed: switchCamera,
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

Future<bool> compareFaces(String icFacePath, String liveFacePath) async {
  final icFaceCompressed = await compressImage(File(icFacePath));
  final liveFaceCompressed = await compressImage(File(liveFacePath));

  final url = Uri.parse('https://api-us.faceplusplus.com/facepp/v3/compare');
  final request = http.MultipartRequest('POST', url)
    ..fields['api_key'] = ''
    ..fields['api_secret'] = 'YN5Ka-3-G1MT7put0LAHhEglWSKOcnpr'
    ..files.add(
        await http.MultipartFile.fromPath('image_file1', icFaceCompressed.path))
    ..files.add(await http.MultipartFile.fromPath(
        'image_file2', liveFaceCompressed.path));

  final response = await request.send();
  final responseBody = await response.stream.bytesToString();

  print('Face++ API Response: $responseBody');

  if (response.statusCode == 200) {
    final data = jsonDecode(responseBody);
    final confidence = data['confidence'] ?? 0.0;
    return confidence >= 80;
  }
  return false;
}

Future<File> compressImage(File file) async {
  final tempDir = await getTemporaryDirectory();
  final targetPath = '${tempDir.path}/compressed_${file.path.split('/').last}';

  XFile? compressedXFile = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 70,
    minWidth: 800,
    minHeight: 800,
  );

  return compressedXFile != null ? File(compressedXFile.path) : file;
}
