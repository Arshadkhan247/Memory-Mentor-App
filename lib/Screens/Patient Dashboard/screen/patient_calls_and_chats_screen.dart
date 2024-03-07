// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';

// class PatientCallsAndChatsScreen extends StatefulWidget {
//   final String otherUserUid; // UID of the other user (patient or caregiver)

//   const PatientCallsAndChatsScreen({Key? key, required this.otherUserUid})
//       : super(key: key);

//   @override
//   _PatientCallsAndChatsScreenState createState() =>
//       _PatientCallsAndChatsScreenState();
// }

// class _PatientCallsAndChatsScreenState
//     extends State<PatientCallsAndChatsScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final TextEditingController _messageController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chat'),
//       ),
//       body: Stack(
//         children: [
//           // Background Image
//           Image.asset(
//             'assets/chatBack.jpg',
//             fit: BoxFit.cover,
//             width: double.infinity,
//             height: double.infinity,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: StreamBuilder<QuerySnapshot>(
//                     stream: _firestore
//                         .collection('messages')
//                         .where('users', arrayContainsAny: [
//                           _auth.currentUser?.uid,
//                           widget.otherUserUid
//                         ])
//                         .orderBy('timestamp', descending: true)
//                         .snapshots(),
//                     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       }

//                       if (snapshot.hasError) {
//                         return Center(
//                           child: Text('Error: ${snapshot.error}'),
//                         );
//                       }

//                       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                         return const Center(
//                           child: Text("No messages"),
//                         );
//                       }

//                       final messageDocs = snapshot.data!.docs;

//                       return ListView.builder(
//                         reverse: true,
//                         itemCount: messageDocs.length,
//                         itemBuilder: (context, index) {
//                           final message =
//                               messageDocs[index].data() as Map<String, dynamic>;
//                           final messageText = message['text'] as String?;
//                           final messageSender = message['sender'] as String?;
//                           final timestamp = message['timestamp'] as Timestamp?;

//                           return MessageWidget(
//                             sender: messageSender ?? '',
//                             text: messageText ?? '',
//                             isMe: _auth.currentUser?.uid == messageSender,
//                             timestamp: timestamp?.toDate() ?? DateTime.now(),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 _buildMessageComposer(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageComposer() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _messageController,
//               decoration: const InputDecoration(
//                 hintText: 'Enter your message...',
//               ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.send),
//             onPressed: () async {
//               final user = _auth.currentUser;
//               if (user != null && _messageController.text.isNotEmpty) {
//                 await _firestore.collection('messages').add({
//                   'text': _messageController.text,
//                   'sender': user.uid,
//                   'receiver': widget.otherUserUid,
//                   'timestamp': FieldValue.serverTimestamp(),
//                   'users': [user.uid, widget.otherUserUid],
//                 });
//                 _messageController.clear();
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MessageWidget extends StatelessWidget {
//   final String sender;
//   final String text;
//   final bool isMe;
//   final DateTime timestamp;

//   const MessageWidget({
//     Key? key,
//     required this.sender,
//     required this.text,
//     required this.isMe,
//     required this.timestamp,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment:
//             isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           IntrinsicWidth(
//             child: Container(
//               constraints: BoxConstraints(
//                   maxWidth: MediaQuery.of(context).size.width * 0.85),
//               decoration: BoxDecoration(
//                 color: isMe ? Colors.green[100] : Colors.grey.shade400,
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//               padding: const EdgeInsets.all(4.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     text,
//                     style: const TextStyle(fontSize: 16.0),
//                   ),
//                   const SizedBox(height: 4.0),
//                   Align(
//                     alignment: Alignment.bottomRight,
//                     child: Text(
//                       _formatTimestamp(timestamp),
//                       style: const TextStyle(
//                         fontSize: 11.0,
//                         color: Colors.black54,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   String _formatTimestamp(DateTime timestamp) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final yesterday = DateTime(now.year, now.month, now.day - 1);

//     if (timestamp.isAfter(today)) {
//       return 'Today ${DateFormat.jm().format(timestamp.toLocal())}';
//     } else if (timestamp.isAfter(yesterday)) {
//       return 'Yesterday ${DateFormat.jm().format(timestamp.toLocal())}';
//     } else {
//       return DateFormat('MMMM d, yyyy ${DateFormat.jm().pattern}')
//           .format(timestamp.toLocal());
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
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

                          return MessageWidget(
                            sender: messageSender ?? '',
                            text: messageText ?? '',
                            isMe: _auth.currentUser?.uid == messageSender,
                            timestamp: timestamp?.toDate() ?? DateTime.now(),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      14,
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
              if (user != null && _messageController.text.isNotEmpty) {
                await _firestore.collection('messages').add({
                  'text': _messageController.text,
                  'sender': user.uid,
                  'receiver': widget.otherUserUid,
                  'timestamp': FieldValue.serverTimestamp(),
                  'users': [user.uid, widget.otherUserUid],
                });
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
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

  const MessageWidget({
    Key? key,
    required this.sender,
    required this.text,
    required this.isMe,
    required this.timestamp,
    required this.onDelete,
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
