import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/screens/chat_room_page.dart';
import 'package:go_perak/utils/state_provider.dart/chat_state.dart';
import 'package:go_perak/widgets/bar/app_bottom_nav_bar.dart';
import 'package:go_perak/widgets/loading_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatListPage extends HookConsumerWidget {
  final bool showBottom;

  const ChatListPage({super.key, this.showBottom = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatListAsync = ref.watch(chatListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: showBottom ? const ProjectAppBottomNav() : null,
      appBar:
          AppBar(title: const Text('Chat List'), backgroundColor: Colors.white),
      body: chatListAsync.when(
        loading: () => Center(child: showLoading()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (chatList) {
          if (chatList.isEmpty) {
            return const Center(child: Text('No chats yet.'));
          }

          return ListView.builder(
            itemCount: chatList.length,
            itemBuilder: (context, index) {
              final chat = chatList[index];
              final userData = chat.otherUserData;

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    userData['profilePic'] ?? userData['businessLogo'] ?? '',
                  ),
                ),
                title: Text(userData['username'] ??
                    userData['businessName'] ??
                    'Unknown'),
                subtitle: Text(chat.lastMessage),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatTimestamp(chat.lastMessageTime),
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (chat.unreadCount > 0)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          chat.unreadCount.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    CustomRouter.chatRoom,
                    arguments: ChatRoomPage(
                      chatRoomId: chat.chatRoomId,
                      otherUserId: chat.otherUserId,
                      otherUserName:
                          userData['username'] ?? userData['businessName'],
                      otherUserPhotoUrl:
                          userData['profilePic'] ?? userData['businessLogo'],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    int hour = date.hour;
    int minute = date.minute;
    String ampm = hour >= 12 ? 'PM' : 'AM';

    hour = hour % 12;
    if (hour == 0) hour = 12;

    return '$hour:${minute.toString().padLeft(2, '0')} $ampm';
  }
}
