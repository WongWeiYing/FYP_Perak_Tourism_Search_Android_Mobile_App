import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_perak/repositories/update_repo.dart';
import 'package:go_perak/utils/state_provider.dart/user_state.dart';
import 'package:go_perak/widgets/button/primary_button.dart';
import 'package:go_perak/widgets/loading_widget.dart';
import 'package:go_perak/widgets/message/toast_message.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WriteReviewPageBase extends ConsumerStatefulWidget {
  final String title;
  final String bucketName;
  //final String userID;
  final String collectionName;
  final String itemID;
  //final String username;
  final int ratingCount;
  final double averageRating;

  const WriteReviewPageBase(
      {super.key,
      required this.title,
      required this.bucketName,
      required this.collectionName,
      required this.itemID,
      //required this.username,
      //required this.userID,
      required this.ratingCount,
      required this.averageRating});

  // Future<void> onSubmitReview({
  //   required double rating,
  //   required String comment,
  //   required List<String> photoUrls,
  // });

  @override
  WriteReviewPageState createState() => WriteReviewPageState();
}

class WriteReviewPageState extends ConsumerState<WriteReviewPageBase> {
  double _rating = 0;
  List<File> _selectedImages = [];
  final picker = ImagePicker();
  final TextEditingController _feedbackController = TextEditingController();
  UpdateRepo updateRepo = UpdateRepo();
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDetails = ref.watch(userDetailsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Rate Product",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text("Add 1 photo", style: TextStyle(fontSize: 16)),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickImage(ImageSource.gallery),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                          child: Icon(
                        Icons.photo_outlined,
                        size: 40,
                        color: Colors.black,
                      )),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickImage(ImageSource.camera),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                          child: Icon(Icons.camera_alt_outlined, size: 40)),
                    ),
                  ),
                ),
              ],
            ),
            if (_selectedImages.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedImages.map((image) {
                  return Image.file(
                    image,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 20),
            const Text("Write 10 characters"),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                setState(() {}); // Update character count
              },
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text("${_feedbackController.text.length} characters"),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              title: "Submit Review",
              onTap: () async {
                if (_rating == 0) {
                  showCustomSnackBar(context, "Please provide at least 1 star");

                  return;
                }
                if (_feedbackController.text.length < 10) {
                  showCustomSnackBar(context,
                      "Please provide at least 10 charaters of comment");

                  return;
                }
                try {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(child: showLoading()),
                  );

                  List<String> photoUrls = [];

                  if (_selectedImages.isNotEmpty) {
                    final supabase = Supabase.instance.client;

                    for (var image in _selectedImages) {
                      final ext = image.path.split('.').last;
                      final filePath =
                          'ratings/${userDetails.value!.userID}/${DateTime.now().millisecondsSinceEpoch}.$ext';

                      final res = await supabase.storage
                          .from(widget.bucketName)
                          .upload(filePath, image);

                      if (res.isNotEmpty) {
                        final url = supabase.storage
                            .from(widget.bucketName)
                            .getPublicUrl(filePath);
                        photoUrls.add(url);
                      }
                    }
                  }

                  final ratingData = {
                    'userID': userDetails.value?.userID,
                    'username': userDetails.value?.username,
                    'rating': _rating,
                    'comment': _feedbackController.text.trim(),
                    'photoUrls': photoUrls,
                    'createdAt': FieldValue.serverTimestamp(),
                    'profilePic': userDetails.value?.profilePic ?? ''
                  };

                  print(widget.itemID);

                  updateRepo.addNewRecordForSubcollection(widget.collectionName,
                      widget.itemID, 'Ratings', ratingData);

                  final avgRating = double.parse(
                    (((widget.averageRating * widget.ratingCount) + _rating) /
                            (widget.ratingCount + 1))
                        .toStringAsFixed(2),
                  );

                  await updateRepo.updateDoubleInfo(widget.collectionName,
                      widget.itemID, 'averageRating', avgRating);

                  await updateRepo.updateDoubleInfo(widget.collectionName,
                      widget.itemID, 'ratingCount', (widget.ratingCount + 1));

                  _rating = 0;
                  _feedbackController.clear();
                  _selectedImages.clear();

                  Navigator.of(context, rootNavigator: true).pop();

                  showCustomSnackBar(context, "Review submitted successfully");

                  Navigator.pop(context, true);
                } catch (e) {
                  Navigator.pop(context);
                  showCustomSnackBar(context, "Error: ${e.toString()}");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
