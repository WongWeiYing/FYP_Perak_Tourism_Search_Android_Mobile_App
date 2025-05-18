import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_perak/data/savelist_data.dart';
import 'package:go_perak/utils/state_provider.dart/user_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final savelistProvider = StreamProvider<List<SavelistData>>((ref) {
  final firestore = FirebaseFirestore.instance;
  final currentUser = ref.watch(currentUserProvider);

  return firestore
      .collection('Users')
      .doc(currentUser.userID!)
      .collection('Savelist')
      .orderBy('savedAt', descending: false)
      .snapshots()
      .asyncMap((snapshot) async {
    final docs = snapshot.docs;

    // Pair each saved doc with its itemID/type
    final itemFutures = docs.where((doc) {
      final type = doc.data()['type'];
      return type == 'Places' || type == 'Food' || type == 'Activities';
    }).map((savedDoc) async {
      final data = savedDoc.data();
      final itemId = data['itemID'];
      final itemType = data['type'];

      final fetchedDoc = await firestore.collection(itemType).doc(itemId).get();

      if (!fetchedDoc.exists) return null;

      return SavelistData.fromDocument(fetchedDoc, itemId, itemType);
    }).toList();

    final items = await Future.wait(itemFutures);

    return items.whereType<SavelistData>().toList().reversed.toList();
  });
});

class WishlistRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> removeItemFromSavelist(String userID, String itemID) async {
    try {
      final savelist = await _firestore
          .collection('Users')
          .doc(userID)
          .collection('Savelist')
          .get();

      for (final savedDoc in savelist.docs) {
        final savedData = savedDoc.data();
        if (savedData['itemID'] == itemID) {
          await _firestore
              .collection('Users')
              .doc(userID)
              .collection('Savelist')
              .doc(savedDoc.id)
              .delete();
          break;
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
