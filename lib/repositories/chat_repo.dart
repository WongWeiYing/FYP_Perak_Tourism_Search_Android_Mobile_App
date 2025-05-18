import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_perak/utils/state_provider.dart/user_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final chatListProvider = StreamProvider<List<ChatRoomDisplayData>>((ref) {
  return ChatListNotifier().streamChatList(ref);
});

class ChatListNotifier {
  Stream<List<ChatRoomDisplayData>> streamChatList(Ref ref) {
    final currentUser = ref.watch(currentUserProvider);
    final firestore = FirebaseFirestore.instance;

    return firestore
        .collection('Chat_rooms')
        .where('participants', arrayContains: currentUser.userID)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      Map<String, Map<String, dynamic>> userCache = {};
      List<ChatRoomDisplayData> result = [];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        if (data['lastMessage'] == null ||
            data['lastMessage'].toString().trim().isEmpty) {
          continue;
        }
        final otherUserId = (data['participants'] as List)
            .firstWhere((id) => id != currentUser.userID);

        if (!userCache.containsKey(otherUserId)) {
          final userDoc = await _getUserOrMerchantData(otherUserId);
          userCache[otherUserId] = userDoc.data() as Map<String, dynamic>;
        }

        result.add(ChatRoomDisplayData(
          chatRoomId: doc.id,
          lastMessage: data['lastMessage'],
          lastMessageTime: data['lastMessageTime'],
          unreadCount: (data['unreadCount'] ?? {})[currentUser.userID] ?? 0,
          otherUserId: otherUserId,
          otherUserData: userCache[otherUserId]!,
        ));
      }
      return result;
    });
  }

  Future<DocumentSnapshot> _getUserOrMerchantData(String userId) async {
    final firestore = FirebaseFirestore.instance;
    DocumentSnapshot userDoc =
        await firestore.collection('Users').doc(userId).get();

    if (!userDoc.exists) {
      final merchantDoc =
          await firestore.collection('Merchants').doc(userId).get();
      final categoryType = merchantDoc['categoryType'];
      final businessId = merchantDoc['business'];
      userDoc = await firestore.collection(categoryType).doc(businessId).get();
    }

    return userDoc;
  }
}

class ChatRoomDisplayData {
  final String chatRoomId;
  final String lastMessage;
  final Timestamp lastMessageTime;
  final int unreadCount;
  final String otherUserId;
  final Map<String, dynamic> otherUserData;

  ChatRoomDisplayData({
    required this.chatRoomId,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.otherUserId,
    required this.otherUserData,
  });
}
