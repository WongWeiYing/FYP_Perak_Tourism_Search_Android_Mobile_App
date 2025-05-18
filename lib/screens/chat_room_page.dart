import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/constants/app_color.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/helper/date_time_helper.dart';
import 'package:go_perak/screens/user/full_screen_page.dart';
import 'package:go_perak/utils/state_provider.dart/chat_state.dart';
import 'package:image_picker/image_picker.dart';

class ChatRoomPage extends StatefulWidget {
  final String chatRoomId;
  final String otherUserId;
  final String otherUserName;
  final String otherUserPhotoUrl;
  final String? currentUser;

  const ChatRoomPage(
      {super.key,
      required this.chatRoomId,
      required this.otherUserId,
      required this.otherUserName,
      required this.otherUserPhotoUrl,
      this.currentUser});

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  late StreamSubscription<QuerySnapshot> _messageSubscription;
  bool _isUploading = false;
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    _listenForMessages();
  }

  void _listenForMessages() {
    _messageSubscription = FirebaseFirestore.instance
        .collection('Messages')
        .doc(widget.chatRoomId)
        .collection('Chats')
        .orderBy('timestamp')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _markMessagesAsRead(snapshot);
      }
    });
  }

  void _markMessagesAsRead(QuerySnapshot snapshot) async {
    if (snapshot.docs.isEmpty) return;

    final lastMessage = snapshot.docs.last;
    final senderId = lastMessage['senderId'];
    if (senderId != currentUserId) {
      await FirebaseFirestore.instance
          .collection('Chat_rooms')
          .doc(widget.chatRoomId)
          .update({
        'unreadCount.$currentUserId': 0,
      });
    }
  }

  @override
  void dispose() {
    _messageSubscription.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.otherUserPhotoUrl),
            ),
            SizedBox(width: 8),
            Text(widget.otherUserName),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Messages')
                    .doc(widget.chatRoomId)
                    .collection('Chats')
                    .orderBy('timestamp')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var messages = snapshot.data!.docs;

                  // Call the smarter mark as read
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _markMessagesAsRead(snapshot.data!);
                    _scrollToBottom(); // Scroll after messages load
                  });

                  return ListView.builder(
                    controller: _scrollController, // Attach controller
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var msg = messages[index];
                      bool isMe = msg['senderId'] == currentUserId;

                      DateTime messageDateTime =
                          (msg['timestamp'] as Timestamp).toDate();
                      String formattedDate = formatDate(messageDateTime);

                      final List<String> imageUrls =
                          List<String>.from(msg['imageUrls'] ?? []);

                      bool showDate = false;
                      if (index == 0) {
                        showDate = true;
                      } else {
                        var previousMessageDateTime =
                            (messages[index - 1]['timestamp'] as Timestamp)
                                .toDate();
                        showDate = !isSameDay(
                            messageDateTime, previousMessageDateTime);
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (showDate)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColor.primaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  formattedDate,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          Container(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                if (msg['imageUrls'] != null &&
                                    (msg['imageUrls'] as List).isNotEmpty)
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: imageUrls
                                        .asMap()
                                        .entries
                                        .map<Widget>((entry) {
                                      final index = entry.key;
                                      final url = entry.value;

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            CustomRouter.fullScreenImage,
                                            arguments: FullScreenImagePage(
                                              imageUrls: imageUrls,
                                              initialIndex: index,
                                            ),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: CachedNetworkImage(
                                            imageUrl: url,
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                if ((msg['text'] as String).isNotEmpty)
                                  Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Text(msg['text']),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            if (_isUploading) // Show loading text if uploading
              const Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text("Uploading images...",
                    style: TextStyle(color: Colors.black)),
              ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_a_photo_outlined),
              color: AppColor.primaryColor,
              onPressed: () async {
                final pickedImages = await ImagePicker().pickMultiImage();
                if (pickedImages.isNotEmpty) {
                  setState(() {
                    _isUploading = true;
                  });

                  List<String> uploadedUrls =
                      await _chatService.uploadChatImages(
                    pickedImages,
                    widget.chatRoomId,
                  );
                  setState(() {
                    _isUploading = false;
                  });

                  if (uploadedUrls.isNotEmpty) {
                    _chatService.sendMessage(
                      chatRoomId: widget.chatRoomId,
                      senderId: currentUserId,
                      receiverId: widget.otherUserId,
                      imageUrls: uploadedUrls,
                    );
                  }
                }
              },
            ),
            gapWidth8,
            Container(
              width: 45.w,
              height: 45.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColor.primaryColor,
              ),
              child: IconButton(
                icon: const Icon(Icons.send_outlined, color: Colors.white),
                onPressed: () {
                  _chatService.sendMessage(
                    chatRoomId: widget.chatRoomId,
                    senderId: currentUserId,
                    receiverId: widget.otherUserId,
                    text: _messageController.text.trim(),
                  ); // Only sends text if present
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void sendMessage({List<String>? imageUrls}) async {
  //   final text = _messageController.text.trim();
  //   if (text.isEmpty && (imageUrls == null || imageUrls.isEmpty)) return;

  //   var messageData = {
  //     'senderId': currentUserId,
  //     'text': text,
  //     'imageUrls': imageUrls ?? [],
  //     'timestamp': Timestamp.now(),
  //     'isRead': false,
  //   };

  //   await FirebaseFirestore.instance
  //       .collection('Messages')
  //       .doc(widget.chatRoomId)
  //       .collection('Chats')
  //       .add(messageData);

  //   await FirebaseFirestore.instance
  //       .collection('Chat_rooms')
  //       .doc(widget.chatRoomId)
  //       .update({
  //     'lastMessage': text.isNotEmpty
  //         ? text
  //         : imageUrls!.length > 1
  //             ? '📷 ${imageUrls.length} photos'
  //             : '📷 Photo',
  //     'lastMessageTime': Timestamp.now(),
  //     'unreadCount.${widget.otherUserId}': FieldValue.increment(1),
  //   });

  //   _messageController.clear();
  // }

  // Future<List<String>> uploadChatImages(List<XFile> images) async {
  //   final supabase = Supabase.instance.client;
  //   List<String> uploadedUrls = [];

  //   for (var imageFile in images) {
  //     final file = File(imageFile.path);
  //     final fileExt = file.path.split('.').last;
  //     final timestamp = DateTime.now().millisecondsSinceEpoch;
  //     final filePath = 'chat-photos/${widget.chatRoomId}/$timestamp.$fileExt';

  //     final res = await supabase.storage.from('chat-photos').upload(
  //           filePath,
  //           file,
  //           fileOptions: const FileOptions(upsert: true),
  //         );

  //     if (res.isNotEmpty) {
  //       final url = supabase.storage.from("chat-photos").getPublicUrl(filePath);
  //       uploadedUrls.add(url);
  //     }
  //   }

  //   return uploadedUrls;
  // }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
