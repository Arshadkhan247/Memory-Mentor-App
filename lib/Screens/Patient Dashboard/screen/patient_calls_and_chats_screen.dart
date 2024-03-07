import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PatientCallsAndChatsScreen extends StatefulWidget {
  final String otherUserUid;

  const PatientCallsAndChatsScreen({Key? key, required this.otherUserUid})
      : super(key: key);

  @override
  _PatientCallsAndChatsScreenState createState() =>
      _PatientCallsAndChatsScreenState();
}

class _PatientCallsAndChatsScreenState
    extends State<PatientCallsAndChatsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.green.shade200,
        title: const Text('Chat'),
      ),
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/chatBack.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('messages')
                        .where('users', arrayContainsAny: [
                          _auth.currentUser?.uid,
                          widget.otherUserUid
                        ])
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text("No messages"),
                        );
                      }

                      final messageDocs = snapshot.data!.docs;

                      return ListView.builder(
                        reverse: true,
                        itemCount: messageDocs.length,
                        itemBuilder: (context, index) {
                          final message =
                              messageDocs[index].data() as Map<String, dynamic>;
                          final messageText = message['text'] as String?;
                          final messageSender = message['sender'] as String?;
                          final timestamp = message['timestamp'] as Timestamp?;
                          final imageUrl = message['image_url'] as String?;

                          return MessageWidget(
                            sender: messageSender ?? '',
                            text: messageText ?? '',
                            isMe: _auth.currentUser?.uid == messageSender,
                            timestamp: timestamp?.toDate() ?? DateTime.now(),
                            imageUrl: imageUrl,
                            onDelete: () {
                              // Handle message deletion
                              _deleteMessage(messageDocs[index].id);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                _buildMessageComposer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Row(
      children: [
        IconButton(
          onPressed: _pickImage,
          icon: const Icon(
            Icons.image,
          ),
        ),
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    40,
                  ),
                ),
              ),
              hintText: 'Enter your message...',
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () async {
            final user = _auth.currentUser;
            if (user != null) {
              if (_messageController.text.isNotEmpty) {
                await _sendMessage(_messageController.text, user.uid);
              } else if (_imageFile != null) {
                await _sendImage(_imageFile!, user.uid);
                setState(() {
                  _imageFile = null; // Clear the selected image after sending
                });
              }
              _messageController.clear();
            }
          },
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  File? _imageFile;

  Future<void> _sendImage(File imageFile, String senderUid) async {
    // Upload image to Firebase Storage
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('chat_images/${DateTime.now()}.png');
    final UploadTask uploadTask = storageRef.putFile(imageFile);
    await uploadTask.whenComplete(() => null);
    final imageUrl = await storageRef.getDownloadURL();

    // Send message with image URL
    await _firestore.collection('messages').add({
      'image_url': imageUrl,
      'sender': senderUid,
      'receiver': widget.otherUserUid,
      'timestamp': FieldValue.serverTimestamp(),
      'users': [senderUid, widget.otherUserUid],
    });
  }

  Future<void> _sendMessage(String text, String senderUid) async {
    await _firestore.collection('messages').add({
      'text': text,
      'sender': senderUid,
      'receiver': widget.otherUserUid,
      'timestamp': FieldValue.serverTimestamp(),
      'users': [senderUid, widget.otherUserUid],
    });
  }

  void _deleteMessage(String messageId) async {
    await _firestore.collection('messages').doc(messageId).delete();
  }
}

class MessageWidget extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final VoidCallback onDelete;
  final String? imageUrl;

  const MessageWidget({
    Key? key,
    required this.sender,
    required this.text,
    required this.isMe,
    required this.timestamp,
    required this.onDelete,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        // Show a dialog or confirmation for deleting the message
        _showDeleteConfirmation(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              Image.network(
                imageUrl!,
                width: 200.0, // Adjust the width as needed
                height: 150.0, // Adjust the height as needed
              ),
            IntrinsicWidth(
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.85),
                decoration: BoxDecoration(
                  color: isMe ? Colors.green[100] : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageUrl == null)
                      Text(
                        text,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    const SizedBox(height: 4.0),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        _formatTimestamp(timestamp),
                        style: const TextStyle(
                          fontSize: 11.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () {
              onDelete(); // Trigger the onDelete callback
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (timestamp.isAfter(today)) {
      return 'Today ${DateFormat.jm().format(timestamp.toLocal())}';
    } else if (timestamp.isAfter(yesterday)) {
      return 'Yesterday ${DateFormat.jm().format(timestamp.toLocal())}';
    } else {
      return DateFormat('${DateFormat.jm().pattern}')
          .format(timestamp.toLocal());
    }
  }
}
