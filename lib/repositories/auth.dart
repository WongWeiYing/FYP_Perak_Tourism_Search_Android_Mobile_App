import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/utils/state_provider.dart/sign_up_state.dart';
import 'package:go_perak/utils/state_provider.dart/user_state.dart';
import 'package:go_perak/widgets/message/toast_message.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<String> createUserWithEmailAndPassword(
    WidgetRef ref, BuildContext context) async {
  try {
    print(ref.read(signUpProvider).email ?? '');
    print(ref.read(signUpProvider).password ?? '');

    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: ref.read(signUpProvider).email ?? '',
            password: ref.read(signUpProvider).password ?? '');

    final uid = credential.user?.uid;
    if (uid != null) {
      //String? token = await FirebaseMessaging.instance.getToken();

      if (ref.read(signUpProvider).roles == 'Users') {
        await FirebaseFirestore.instance.collection('Users').doc(uid).set({
          //'email': ref.read(signUpProvider).email ?? '',
          'fullname': ref.read(signUpProvider).fullname ?? '',
          'profilePic':
              'https://mgjdhfjzxxmcwhsxjjln.supabase.co/storage/v1/object/public/profile-pictures/profile-pictures/user-default.jpg',
          'username': ref.read(signUpProvider).username ?? '',
          'icNo': ref.read(signUpProvider).icNo ?? '',
          //'token': token,
        });
      } else {
        String logoUrl = '';
        //Add business logo into supabase storage
        final supabase = Supabase.instance.client;
        final logo = (ref.read(signUpProvider).logoUrl);
        final logoExt = logo?.path.split('.').last;
        final logoImagePath =
            'business-logo/$uid/${DateTime.now().millisecondsSinceEpoch}.$logoExt';
        final res = await supabase.storage
            .from('business-logo-photos')
            .upload(logoImagePath, logo!);
        if (res.isNotEmpty) {
          logoUrl = supabase.storage
              .from("business-logo-photos")
              .getPublicUrl(logoImagePath);
        }

        //Add business photos into supabase storage
        List<String> photoUrls = [];
        for (var image in ref.read(signUpProvider).photoUrls!) {
          final ext = image.path.split('.').last;
          final filePath =
              'business-photos/$uid/${DateTime.now().millisecondsSinceEpoch}.$ext';
          final res = await supabase.storage
              .from('business-photos')
              .upload(filePath, image);
          if (res.isNotEmpty) {
            final url =
                supabase.storage.from('business-photos').getPublicUrl(filePath);
            photoUrls.add(url);
          }
        }

        final categoryID = await FirebaseFirestore.instance
            .collection(ref.read(signUpProvider).categoryType ?? 'All')
            .add({
          'businessName': ref.read(signUpProvider).businessName ?? '',
          'businessLogo': logoUrl,
          'businessEmail': ref.read(signUpProvider).email ?? '',
          'description': ref.read(signUpProvider).description ?? '',
          'contactNumber': ref.read(signUpProvider).contactNumber ?? '',
          'operatingHours': ref.read(signUpProvider).operatingHours ?? '',
          'address': ref.read(signUpProvider).address ?? '',
          'photoUrls': photoUrls,
          'isApproved': false,
          'createdAt': FieldValue.serverTimestamp(),
          'averageRating': 0.0,
          'ratingCount': 0,
          'tags': ref.read(signUpProvider).labels ?? []
        });

        await FirebaseFirestore.instance.collection('Merchants').doc(uid).set({
          'fullname': ref.read(signUpProvider).fullname ?? '',
          'icNo': ref.read(signUpProvider).icNo ?? '',
          'business': categoryID.id,
          'categoryType': ref.read(signUpProvider).categoryType ?? 'All',
          //'token': token,
        });
      }

      await FirebaseFirestore.instance
          .collection('UsersRole')
          .doc(uid)
          .set({'role': ref.read(signUpProvider).roles});
    }

    return '';
  } on FirebaseAuthException catch (e) {
    return e.message ?? 'An unknown error occured. Please try again later.';
  }
}

Future<String> signInWithEmailAndPassword(
    String email, String password, BuildContext context, WidgetRef ref) async {
  try {
    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    print(userCredential.user?.uid);

    final snapshot = await FirebaseFirestore.instance
        .collection('UsersRole')
        .doc(userCredential.user?.uid)
        .get();

    if (snapshot.exists && snapshot.data() != null) {
      final data = snapshot.data();

      ref.read(currentUserProvider.notifier).setRole(data!['role'] as String);
      ref
          .read(currentUserProvider.notifier)
          .setUserID(userCredential.user!.uid);

      print(data['role'] as String);

      // String? token = await FirebaseMessaging.instance.getToken();
      // await FirebaseFirestore.instance
      //     .collection('Users')
      //     .doc(userCredential.user!.uid)
      //     .update({
      //   'token': token,
      // });

      //ref.read(currentUserProvider.notifier).setFcmToken(token);

      await saveUserIdLocally(userCredential.user!.uid, data['role'] as String);
      // return '';
    }
    return '';
  } on FirebaseAuthException catch (e) {
    // showCustomSnackBar(
    //     context, e.message ?? 'Unknown error occur. Please try again later');
    return 'Wrong Password.';
  }
}

Future<void> saveUserIdLocally(String uid, String role) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userID', uid);
  await prefs.setString('userRole', role);
  // await prefs.setString('fcmToken', token);
}

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('userID');
  await prefs.remove('userRole');
  // await prefs.remove('fcmToken');

  Navigator.pushNamedAndRemoveUntil(
      context, CustomRouter.login, (route) => false);
}

Future<void> sendPasswordResetEmail(String email, BuildContext context) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    showCustomSnackBar(context, 'Password reset email sent.');
  } on FirebaseAuthException catch (e) {
    String message;
    if (e.code == 'user-not-found') {
      message = 'No user found for that email.';
    } else {
      message = 'Something went wrong. Try again later.';
    }
    showCustomSnackBar(context, message);
  }
}
