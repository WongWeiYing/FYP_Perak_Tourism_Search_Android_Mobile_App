import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_perak/data/food_data.dart';
import 'package:go_perak/data/rating_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final foodListProvider = FutureProvider<List<FoodData>>((ref) async {
  final snapshot = await FirebaseFirestore.instance.collection('Food').get();
  return snapshot.docs.map((doc) {
    final data = doc.data();
    data['foodID'] = doc.id;
    return FoodData.fromJson(data, null);
  }).toList();
});

final foodReviewProvider = FutureProvider.autoDispose
    .family<List<RatingData>, String>((ref, foodID) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('Food')
      .doc(foodID)
      .collection('Ratings')
      .orderBy('createdAt', descending: true)
      .get();

  return snapshot.docs.map((doc) => RatingData.fromJson(doc.data())).toList();
});

final foodProvider =
    FutureProvider.autoDispose.family<FoodData, String>((ref, foodID) async {
  final snapshot =
      await FirebaseFirestore.instance.collection('Food').doc(foodID).get();

  print('Business ID $foodID');

  if (snapshot.exists && snapshot.data() != null) {
    return FoodData.fromJson(snapshot.data()!, foodID);
  } else {
    throw Exception('Place not found');
  }
});
