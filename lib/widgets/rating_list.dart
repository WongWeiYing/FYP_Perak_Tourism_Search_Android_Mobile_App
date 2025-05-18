import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/data/rating_data.dart';
import 'package:go_perak/repositories/chat_repo.dart';
import 'package:go_perak/screens/chat_room_page.dart';
import 'package:go_perak/screens/user/full_screen_page.dart';
import 'package:go_perak/utils/state_provider.dart/user_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class RatingList extends HookConsumerWidget {
  final List<RatingData> ratings;
  final int? noDisplay;

  const RatingList({super.key, this.noDisplay, required this.ratings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ChatService chatService = ChatService();
    final currentUser = ref.watch(currentUserProvider);

    return ListView.separated(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: noDisplay ?? ratings.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final rating = ratings[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                PopupMenuButton<String>(
                  color: Colors.white,
                  onSelected: (value) async {
                    if (value == 'chat') {
                      String chatRoomId = await chatService.getOrCreateChatRoom(
                          currentUser.userID!, rating.userID);

                      Navigator.pushNamed(
                        context,
                        CustomRouter.chatRoom,
                        arguments: ChatRoomPage(
                          chatRoomId: chatRoomId,
                          otherUserId: rating.userID,
                          otherUserName: rating.username,
                          otherUserPhotoUrl: rating.profilePic,
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'chat',
                      child: Text('Message'),
                    ),
                  ],
                  child: GestureDetector(
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.transparent,
                      foregroundImage: NetworkImage(rating.profilePic),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rating.username,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                buildRatingStars(rating.rating),
              ],
            ),
            const SizedBox(height: 4),
            Text(
                DateFormat('yyyy-MM-dd  HH:mm ')
                    .format((rating.createdAt as Timestamp).toDate()),
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Text(rating.comment, maxLines: 3, overflow: TextOverflow.ellipsis),
            if (rating.photoUrls.isNotEmpty) ...[
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: rating.photoUrls.map((img) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FullScreenImagePage(
                                imageUrls: rating.photoUrls,
                                initialIndex: rating.photoUrls.indexOf(img),
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(img,
                              width: 150, height: 180, fit: BoxFit.cover),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget buildRatingStars(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < fullStars; i++)
          const Icon(Icons.star, color: Colors.amber, size: 20),
        if (hasHalfStar)
          const Icon(Icons.star_half, color: Colors.amber, size: 20),
        for (int i = 0; i < emptyStars; i++)
          const Icon(Icons.star_border, color: Colors.amber, size: 20),
      ],
    );
  }
}
