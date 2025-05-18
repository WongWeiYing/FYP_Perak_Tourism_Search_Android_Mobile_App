import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_perak/data/place_data.dart';
import 'package:go_perak/data/rating_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final placesProvider = FutureProvider<List<PlaceData>>((ref) async {
  final snapshot = await FirebaseFirestore.instance.collection('Places').get();
  return snapshot.docs.map((doc) {
    final data = doc.data();
    data['placeID'] = doc.id;
    return PlaceData.fromJson(data);
  }).toList();
});

final placeReviewProvider = FutureProvider.autoDispose
    .family<List<RatingData>, String>((ref, placeID) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('Places')
      .doc(placeID)
      .collection('Ratings')
      .orderBy('createdAt', descending: true)
      .get();

  return snapshot.docs.map((doc) => RatingData.fromJson(doc.data())).toList();
});

final placeProvider =
    FutureProvider.autoDispose.family<PlaceData, String>((ref, placeID) async {
  final snapshot =
      await FirebaseFirestore.instance.collection('Places').doc(placeID).get();

  if (snapshot.exists && snapshot.data() != null) {
    return PlaceData.fromJsonWithID(snapshot.data()!, placeID);
  } else {
    throw Exception('Place not found');
  }
});
