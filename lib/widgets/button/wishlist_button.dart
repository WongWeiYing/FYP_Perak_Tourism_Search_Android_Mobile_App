import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_perak/utils/state_provider.dart/user_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SavelistButton extends HookConsumerWidget {
  final String itemID;
  final String type;
  const SavelistButton({super.key, required this.itemID, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final savedItemsAsync = ref.watch(savedItemsStreamProvider);

    return savedItemsAsync.when(
      data: (savedItems) {
        final isSaved = savedItems.contains(itemID);

        return Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              isSaved ? Icons.favorite : Icons.favorite_border,
              color: isSaved ? Colors.red : Colors.grey,
            ),
            onPressed: () async {
              final saveRef = FirebaseFirestore.instance
                  .collection('Users')
                  .doc(currentUser.userID)
                  .collection('Savelist')
                  .doc(itemID);

              if (isSaved) {
                await saveRef.delete();
              } else {
                await saveRef.set({
                  'itemID': itemID,
                  'type': type,
                  'savedAt': FieldValue.serverTimestamp(),
                });
              }
            },
          ),
        );
      },
      loading: () => const SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(strokeWidth: 2)),
      error: (_, __) => const Icon(Icons.error),
    );
  }
}

final savedItemsStreamProvider = StreamProvider<Set<String>>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  return FirebaseFirestore.instance
      .collection('Users')
      .doc(currentUser.userID)
      .collection('Savelist')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.id).toSet());
});
