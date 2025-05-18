import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_perak/data/activity_data.dart';
import 'package:go_perak/data/rating_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final activityListProvider = FutureProvider<List<ActivityData>>((ref) async {
  final snapshot =
      await FirebaseFirestore.instance.collection('Activities').get();
  return snapshot.docs.map((doc) {
    final data = doc.data();
    data['activityID'] = doc.id;
    return ActivityData.fromJson(data, null);
  }).toList();
});

final activityReviewProvider = FutureProvider.autoDispose
    .family<List<RatingData>, String>((ref, activityID) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('Activities')
      .doc(activityID)
      .collection('Ratings')
      .orderBy('createdAt', descending: true)
      .get();

  return snapshot.docs.map((doc) => RatingData.fromJson(doc.data())).toList();
});

final activityProvider = FutureProvider.autoDispose
    .family<ActivityData, String>((ref, activityID) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('Activities')
      .doc(activityID)
      .get();

  if (snapshot.exists && snapshot.data() != null) {
    return ActivityData.fromJson(snapshot.data()!, activityID);
  } else {
    throw Exception('Place not found');
  }
});
