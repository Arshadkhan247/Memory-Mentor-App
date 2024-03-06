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
//       body: Padding(
//         padding: const EdgeInsets.all(3.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: _firestore
//                     .collection('messages')
//                     .where('users', arrayContainsAny: [
//                       _auth.currentUser?.uid,
//                       widget.otherUserUid
//                     ])
//                     .orderBy('timestamp', descending: true)
//                     .snapshots(),
//                 builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   if (snapshot.hasError) {
//                     return Center(
//                       child: Text('Error: ${snapshot.error}'),
//                     );
//                   }

//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return const Center(
//                       child: Text("No messages"),
//                     );
//                   }

//                   final messageDocs = snapshot.data!.docs;

//                   return ListView.builder(
//                     reverse: true,
//                     itemCount: messageDocs.length,
//                     itemBuilder: (context, index) {
//                       final message =
//                           messageDocs[index].data() as Map<String, dynamic>;
//                       final messageText = message['text'] as String?;
//                       final messageSender = message['sender'] as String?;
//                       final timestamp = message['timestamp'] as Timestamp?;

//                       return MessageWidget(
//                         sender: messageSender ?? '',
//                         text: messageText ?? '',
//                         isMe: _auth.currentUser?.uid == messageSender,
//                         timestamp: timestamp?.toDate() ?? DateTime.now(),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//             _buildMessageComposer(),
//           ],
//         ),
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class PatientCallsAndChatsScreen extends StatefulWidget {
  final String otherUserUid; // UID of the other user (patient or caregiver)

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
        title: const Text('Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(3.0),
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
                      final messageType = message['type'] as String?;
                      final fileUrl = message['fileUrl'] as String?;
                      final timestamp = message['timestamp'] as Timestamp?;

                      return MessageWidget(
                        sender: messageSender ?? '',
                        text: messageText ?? '',
                        isMe: _auth.currentUser?.uid == messageSender,
                        timestamp: timestamp?.toDate() ?? DateTime.now(),
                        type: messageType ?? 'text',
                        fileUrl: fileUrl,
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
    );
  }

  Widget _buildMessageComposer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: _pickImage,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
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
                  await _sendMessage('text', _messageController.text);
                } else if (_imageFile != null) {
                  await _sendMessage('image', _imageFile!);
                }
                _messageController.clear();
                _resetFileVariables();
              }
            },
          ),
        ],
      ),
    );
  }

  File? _imageFile;

  Future<void> _pickImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _sendMessage(String type, dynamic content) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        String caregiverId =
            'yourCaregiverId'; // Replace with actual caregiverId
        String patientId = 'yourPatientId'; // Replace with actual patientId

        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('files')
            .child(caregiverId)
            .child(patientId)
            .child('$fileName.$type');

        UploadTask uploadTask = storageReference.putFile(content);

        await uploadTask.whenComplete(() async {
          String fileUrl = await storageReference.getDownloadURL();

          await _firestore.collection('messages').add({
            'sender': user.uid,
            'receiver': widget.otherUserUid,
            'timestamp': FieldValue.serverTimestamp(),
            'users': [user.uid, widget.otherUserUid],
            'type': type,
            'fileUrl': fileUrl,
          });
        });
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  void _resetFileVariables() {
    setState(() {
      _imageFile = null;
    });
  }
}

class MessageWidget extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final String type;
  final String? fileUrl;

  const MessageWidget({
    Key? key,
    required this.sender,
    required this.text,
    required this.isMe,
    required this.timestamp,
    required this.type,
    this.fileUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (type == 'image') {
      return Image.network(
        fileUrl!,
        width: 200.0,
        height: 200.0,
        fit: BoxFit.cover,
      );
    }

    return IntrinsicWidth(
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
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
      return DateFormat('MMMM d, yyyy ${DateFormat.jm().pattern}')
          .format(timestamp.toLocal());
    }
  }
}
