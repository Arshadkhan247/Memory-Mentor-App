// // import 'dart:io';

// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:intl/intl.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:firebase_storage/firebase_storage.dart';

// // class PatientCallsAndChatsScreen extends StatefulWidget {
// //   final String otherUserUid;

// //   const PatientCallsAndChatsScreen({super.key, required this.otherUserUid});

// //   @override
// //   PatientCallsAndChatsScreenState createState() =>
// //       PatientCallsAndChatsScreenState();
// // }

// // class PatientCallsAndChatsScreenState
// //     extends State<PatientCallsAndChatsScreen> {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   final TextEditingController _messageController = TextEditingController();
// //   final ImagePicker _imagePicker = ImagePicker();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         centerTitle: true,
// //         automaticallyImplyLeading: true,
// //         backgroundColor: Colors.blue,
// //         title: const Text(
// //           'Chatting Screen',
// //           style: TextStyle(color: Colors.white),
// //         ),
// //         iconTheme: const IconThemeData(color: Colors.white),
// //       ),
// //       body: Stack(
// //         children: [
// //           // Background Image
// //           Image.asset(
// //             'assets/chatBack.jpg',
// //             fit: BoxFit.cover,
// //             width: double.infinity,
// //             height: double.infinity,
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Column(
// //               children: [
// //                 Expanded(
// //                   child: StreamBuilder<QuerySnapshot>(
// //                     stream: _firestore
// //                         .collection('messages')
// //                         .where('users', arrayContainsAny: [
// //                           _auth.currentUser?.uid,
// //                           widget.otherUserUid
// //                         ])
// //                         .orderBy('timestamp', descending: true)
// //                         .snapshots(),
// //                     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
// //                       if (snapshot.connectionState == ConnectionState.waiting) {
// //                         return const Center(
// //                             child: CircularProgressIndicator(
// //                           color: Colors.blue,
// //                         ));
// //                       }

// //                       if (snapshot.hasError) {
// //                         return Center(
// //                           child: Text('Error: ${snapshot.error}'),
// //                         );
// //                       }

// //                       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
// //                         return const Center(
// //                           child: Text("No messages"),
// //                         );
// //                       }

// //                       final messageDocs = snapshot.data!.docs;

// //                       return ListView.builder(
// //                         reverse: true,
// //                         itemCount: messageDocs.length,
// //                         itemBuilder: (context, index) {
// //                           final message =
// //                               messageDocs[index].data() as Map<String, dynamic>;
// //                           final messageText = message['text'] as String?;
// //                           final messageSender = message['sender'] as String?;
// //                           final timestamp = message['timestamp'] as Timestamp?;
// //                           final imageUrl = message['image_url'] as String?;

// //                           return MessageWidget(
// //                             sender: messageSender ?? '',
// //                             text: messageText ?? '',
// //                             isMe: _auth.currentUser?.uid == messageSender,
// //                             timestamp: timestamp?.toDate() ?? DateTime.now(),
// //                             imageUrl: imageUrl,
// //                             onDelete: () {
// //                               // Handle message deletion
// //                               _deleteMessage(messageDocs[index].id);
// //                             },
// //                           );
// //                         },
// //                       );
// //                     },
// //                   ),
// //                 ),
// //                 _buildMessageComposer(),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildMessageComposer() {
// //     return Row(
// //       children: [
// //         IconButton(
// //           onPressed: _pickImage,
// //           icon: const Icon(
// //             Icons.image,
// //           ),
// //         ),
// //         Expanded(
// //           child: TextField(
// //             controller: _messageController,
// //             decoration: const InputDecoration(
// //               contentPadding: EdgeInsets.only(left: 10),
// //               border: OutlineInputBorder(
// //                 borderRadius: BorderRadius.all(
// //                   Radius.circular(
// //                     40,
// //                   ),
// //                 ),
// //               ),
// //               hintText: 'Enter your message...',
// //             ),
// //           ),
// //         ),
// //         IconButton(
// //           icon: const Icon(Icons.send),
// //           onPressed: () async {
// //             final user = _auth.currentUser;
// //             if (user != null) {
// //               if (_messageController.text.isNotEmpty) {
// //                 await _sendMessage(_messageController.text, user.uid);
// //               } else if (_imageFile != null) {
// //                 await _sendImage(_imageFile!, user.uid);
// //                 setState(() {
// //                   _imageFile = null; // Clear the selected image after sending
// //                 });
// //               }
// //               _messageController.clear();
// //             }
// //           },
// //         ),
// //       ],
// //     );
// //   }

// //   Future<void> _pickImage() async {
// //     final pickedFile =
// //         await _imagePicker.pickImage(source: ImageSource.gallery);
// //     if (pickedFile != null) {
// //       setState(() {
// //         _imageFile = File(pickedFile.path);
// //       });
// //     }
// //   }

// //   File? _imageFile;

// //   Future<void> _sendImage(File imageFile, String senderUid) async {
// //     // Upload image to Firebase Storage
// //     final storageRef = FirebaseStorage.instance
// //         .ref()
// //         .child('chat_images/${DateTime.now()}.png');
// //     final UploadTask uploadTask = storageRef.putFile(imageFile);
// //     await uploadTask.whenComplete(() => null);
// //     final imageUrl = await storageRef.getDownloadURL();

// //     // Send message with image URL
// //     await _firestore.collection('messages').add({
// //       'image_url': imageUrl,
// //       'sender': senderUid,
// //       'receiver': widget.otherUserUid,
// //       'timestamp': FieldValue.serverTimestamp(),
// //       'users': [senderUid, widget.otherUserUid],
// //     });
// //   }

// //   Future<void> _sendMessage(String text, String senderUid) async {
// //     await _firestore.collection('messages').add({
// //       'text': text,
// //       'sender': senderUid,
// //       'receiver': widget.otherUserUid,
// //       'timestamp': FieldValue.serverTimestamp(),
// //       'users': [senderUid, widget.otherUserUid],
// //     });
// //   }

// //   void _deleteMessage(String messageId) async {
// //     await _firestore.collection('messages').doc(messageId).delete();
// //   }
// // }

// // class MessageWidget extends StatelessWidget {
// //   final String sender;
// //   final String text;
// //   final bool isMe;
// //   final DateTime timestamp;
// //   final VoidCallback onDelete;
// //   final String? imageUrl;

// //   const MessageWidget({
// //     super.key,
// //     required this.sender,
// //     required this.text,
// //     required this.isMe,
// //     required this.timestamp,
// //     required this.onDelete,
// //     this.imageUrl,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onLongPress: () {
// //         // Show a dialog or confirmation for deleting the message
// //         _showDeleteConfirmation(context);
// //       },
// //       child: Padding(
// //         padding: const EdgeInsets.all(8.0),
// //         child: Column(
// //           crossAxisAlignment:
// //               isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
// //           children: [
// //             if (imageUrl != null)
// //               Image.network(
// //                 imageUrl!,
// //                 width: 200.0, // Adjust the width as needed
// //                 height: 150.0, // Adjust the height as needed
// //               ),
// //             IntrinsicWidth(
// //               child: Container(
// //                 constraints: BoxConstraints(
// //                     maxWidth: MediaQuery.of(context).size.width * 0.85),
// //                 decoration: BoxDecoration(
// //                   color: isMe ? Colors.green[100] : Colors.grey.shade400,
// //                   borderRadius: BorderRadius.circular(8.0),
// //                 ),
// //                 padding: const EdgeInsets.all(4.0),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     if (imageUrl == null)
// //                       Text(
// //                         text,
// //                         style: const TextStyle(fontSize: 16.0),
// //                       ),
// //                     const SizedBox(height: 4.0),
// //                     Align(
// //                       alignment: Alignment.bottomRight,
// //                       child: Text(
// //                         _formatTimestamp(timestamp),
// //                         style: const TextStyle(
// //                           fontSize: 11.0,
// //                           color: Colors.black54,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   void _showDeleteConfirmation(BuildContext context) {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text('Delete Message'),
// //         content: const Text('Are you sure you want to delete this message?'),
// //         actions: [
// //           TextButton(
// //             onPressed: () {
// //               onDelete(); // Trigger the onDelete callback
// //               Navigator.of(context).pop();
// //             },
// //             child: const Text('Delete'),
// //           ),
// //           TextButton(
// //             onPressed: () {
// //               Navigator.of(context).pop();
// //             },
// //             child: const Text('Cancel'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   String _formatTimestamp(DateTime timestamp) {
// //     final now = DateTime.now();
// //     final today = DateTime(now.year, now.month, now.day);
// //     final yesterday = DateTime(now.year, now.month, now.day - 1);

// //     if (timestamp.isAfter(today)) {
// //       return 'Today ${DateFormat.jm().format(timestamp.toLocal())}';
// //     } else if (timestamp.isAfter(yesterday)) {
// //       return 'Yesterday ${DateFormat.jm().format(timestamp.toLocal())}';
// //     } else {
// //       return DateFormat('${DateFormat.jm().pattern}')
// //           .format(timestamp.toLocal());
// //     }
// //   }
// // }

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class PatientCallsAndChatsScreen extends StatefulWidget {
//   final String otherUserUid;

//   const PatientCallsAndChatsScreen({super.key, required this.otherUserUid});

//   @override
//   PatientCallsAndChatsScreenState createState() =>
//       PatientCallsAndChatsScreenState();
// }

// class PatientCallsAndChatsScreenState
//     extends State<PatientCallsAndChatsScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final TextEditingController _messageController = TextEditingController();
//   final ImagePicker _imagePicker = ImagePicker();
//   File? _imageFile;

//   String getConversationId(String uid1, String uid2) {
//     List<String> ids = [uid1, uid2];
//     ids.sort(); // Sort the IDs to ensure the same conversation ID is generated regardless of order
//     return ids.join("_");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         automaticallyImplyLeading: true,
//         backgroundColor: Colors.blue,
//         title: const Text(
//           'Chatting Screen',
//           style: TextStyle(color: Colors.white),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
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
//                         .doc(getConversationId(
//                             _auth.currentUser!.uid, widget.otherUserUid))
//                         .collection('messages')
//                         .orderBy('timestamp', descending: true)
//                         .snapshots(),
//                     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(
//                             child:
//                                 CircularProgressIndicator(color: Colors.blue));
//                       }

//                       if (snapshot.hasError) {
//                         return Center(child: Text('Error: ${snapshot.error}'));
//                       }

//                       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                         return const Center(child: Text("No messages"));
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
//                           final imageUrl = message['image_url'] as String?;

//                           return MessageWidget(
//                             sender: messageSender ?? '',
//                             text: messageText ?? '',
//                             isMe: _auth.currentUser?.uid == messageSender,
//                             timestamp: timestamp?.toDate() ?? DateTime.now(),
//                             imageUrl: imageUrl,
//                             onDelete: () {
//                               _deleteMessage(messageDocs[index].id);
//                             },
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
//     return Row(
//       children: [
//         IconButton(
//           onPressed: _pickImage,
//           icon: const Icon(Icons.image),
//         ),
//         Expanded(
//           child: TextField(
//             controller: _messageController,
//             decoration: const InputDecoration(
//               contentPadding: EdgeInsets.only(left: 10),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(40)),
//               ),
//               hintText: 'Enter your message...',
//             ),
//           ),
//         ),
//         IconButton(
//           icon: const Icon(Icons.send),
//           onPressed: () async {
//             final user = _auth.currentUser;
//             if (user != null) {
//               if (_messageController.text.isNotEmpty) {
//                 await _sendMessage(_messageController.text, user.uid);
//               } else if (_imageFile != null) {
//                 await _sendImage(_imageFile!, user.uid);
//                 setState(() {
//                   _imageFile = null; // Clear the selected image after sending
//                 });
//               }
//               _messageController.clear();
//             }
//           },
//         ),
//       ],
//     );
//   }

//   Future<void> _pickImage() async {
//     final pickedFile =
//         await _imagePicker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _sendImage(File imageFile, String senderUid) async {
//     // Upload image to Firebase Storage
//     final storageRef = FirebaseStorage.instance
//         .ref()
//         .child('chat_images/${DateTime.now()}.png');
//     final UploadTask uploadTask = storageRef.putFile(imageFile);
//     await uploadTask.whenComplete(() => null);
//     final imageUrl = await storageRef.getDownloadURL();

//     // Send message with image URL
//     await _firestore
//         .collection('messages')
//         .doc(getConversationId(_auth.currentUser!.uid, widget.otherUserUid))
//         .collection('messages')
//         .add({
//       'image_url': imageUrl,
//       'sender': senderUid,
//       'receiver': widget.otherUserUid,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }

//   Future<void> _sendMessage(String text, String senderUid) async {
//     await _firestore
//         .collection('messages')
//         .doc(getConversationId(_auth.currentUser!.uid, widget.otherUserUid))
//         .collection('messages')
//         .add({
//       'text': text,
//       'sender': senderUid,
//       'receiver': widget.otherUserUid,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }

//   void _deleteMessage(String messageId) async {
//     await _firestore
//         .collection('messages')
//         .doc(getConversationId(_auth.currentUser!.uid, widget.otherUserUid))
//         .collection('messages')
//         .doc(messageId)
//         .delete();
//   }
// }

// class MessageWidget extends StatelessWidget {
//   final String sender;
//   final String text;
//   final bool isMe;
//   final DateTime timestamp;
//   final VoidCallback onDelete;
//   final String? imageUrl;

//   const MessageWidget({
//     super.key,
//     required this.sender,
//     required this.text,
//     required this.isMe,
//     required this.timestamp,
//     required this.onDelete,
//     this.imageUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onLongPress: () {
//         _showDeleteConfirmation(context);
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment:
//               isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             if (imageUrl != null)
//               Image.network(
//                 imageUrl!,
//                 width: 200.0,
//                 height: 150.0,
//               ),
//             IntrinsicWidth(
//               child: Container(
//                 constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width * 0.85),
//                 decoration: BoxDecoration(
//                   color: isMe ? Colors.green[100] : Colors.grey.shade400,
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 padding: const EdgeInsets.all(4.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (imageUrl == null)
//                       Text(
//                         text,
//                         style: const TextStyle(fontSize: 16.0),
//                       ),
//                     const SizedBox(height: 4.0),
//                     Align(
//                       alignment: Alignment.bottomRight,
//                       child: Text(
//                         _formatTimestamp(timestamp),
//                         style: const TextStyle(
//                           fontSize: 11.0,
//                           color: Colors.black54,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   void _showDeleteConfirmation(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Message'),
//         content: const Text('Are you sure you want to delete this message?'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               onDelete(); // Trigger the onDelete callback
//               Navigator.of(context).pop();
//             },
//             child: const Text('Delete'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text('Cancel'),
//           ),
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
//       return DateFormat('${DateFormat.jm().pattern}')
//           .format(timestamp.toLocal());
//     }
//   }
// }

import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:mentor/Call_Screen/audio_call_screen.dart';

import 'package:rxdart_ext/not_replay_value_stream.dart';
import 'package:rxdart/rxdart.dart';

class PatientCallsAndChatsScreen extends StatefulWidget {
  final String otherUserUid;
  final String caregiverName;
  // final dynamic otherUserPersonalDetails;

  const PatientCallsAndChatsScreen({
    super.key, // Add key parameter to the constructor
    required this.otherUserUid,
    required this.caregiverName,
    // required this.otherUserPersonalDetails,
  });

  @override
  _PatientCallsAndChatsScreenState createState() =>
      _PatientCallsAndChatsScreenState();
}

class _PatientCallsAndChatsScreenState
    extends State<PatientCallsAndChatsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();
  final picker = ImagePicker();
  File? _image;
  String? _downloadURL;
  var documentId = '';

  Stream<QuerySnapshot<Map<String, dynamic>>> _messageStream() {
    var currentUserUid = _auth.currentUser!.uid;
    var otherUserUid = widget.otherUserUid;

    // var documentId = '${currentUserUid}_$otherUserUid';

    var currentUserDocId = '${otherUserUid}_$currentUserUid';
    var otherUserDocId = '${currentUserDocId}_$otherUserUid';

    var currentUserStream = FirebaseFirestore.instance
        .collection('message')
        .doc(currentUserDocId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();

    var otherUserStream = FirebaseFirestore.instance
        .collection('message')
        .doc(otherUserDocId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();

    return Rx.concat([currentUserStream, otherUserStream]);
  }

  String documentIdOfBothLawyerAndClient() {
    var currentUserUid = _auth.currentUser!.uid;
    var otherUserUid = widget.otherUserUid;

    documentId = '${otherUserUid}_$currentUserUid';
    return documentId;
  }

  @override
  void initState() {
    super.initState();
    documentIdOfBothLawyerAndClient();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Image(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              image: const AssetImage('assets/chatBack.jpg'),
              fit: BoxFit.fill,
            ),
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.10,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),

                        Text(
                          widget.caregiverName.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),

                        //
                        // CircleAvatar(
                        //   backgroundImage: NetworkImage(
                        //       widget.otherUserPersonalDetails['imageUrl']),
                        // ),
                        // const SizedBox(
                        //   width: 10,
                        // ),
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.of(context).push(MaterialPageRoute(
                        //       builder: (context) =>
                        //           LawyerReviewSubmissionScreen(
                        //         lawyerUid: widget.otherUserUid,
                        //         otherPersonalDetails:
                        //             widget.otherUserPersonalDetails,
                        //       ),
                        //     ));
                        //   },
                        //   child: Text(
                        //     widget.otherUserPersonalDetails['name'],
                        //     style: const TextStyle(
                        //       color: Colors.white,
                        //       fontSize: 18,
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.14,
                        ),
                        // IconButton(
                        //   onPressed: () {
                        //     Navigator.of(context).push(
                        //       MaterialPageRoute(
                        //         builder: (context) => AudioCallScreen(
                        //           userId: widget.otherUserUid,
                        //           userName:
                        //               widget.otherUserPersonalDetails['name'],
                        //           callID: documentId,
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   icon: const Icon(
                        //     Icons.call,
                        //     color: Colors.white,
                        //   ),
                        // ),
                        // IconButton(
                        //   onPressed: () {
                        //     Navigator.of(context).push(
                        //       MaterialPageRoute(
                        //         builder: (context) => VideoCallScreen(
                        //           userId: widget.otherUserUid,
                        //           userName:
                        //               widget.otherUserPersonalDetails['name'],
                        //           callID: documentIdOfBothLawyerAndClient(),
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   icon: const Icon(
                        //     Icons.video_call,
                        //     color: Colors.white,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _messageStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("No messages"));
                      }

                      return ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var message = snapshot.data!.docs[index].data();
                          var timestamp = message['timestamp'] as Timestamp?;
                          var messageText = message['text'] as String?;
                          var senderUid = message['sender'] as String;
                          var image = message['image'] as String?;

                          // Determine if the message is sent by the current user or not
                          bool isCurrentUser =
                              senderUid == _auth.currentUser!.uid;

                          // Add null check for timestamp
                          if (timestamp == null) {
                            return const SizedBox();
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 12.0,
                            ),
                            child: Column(
                              crossAxisAlignment: isCurrentUser
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                if (messageText != null)
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.85,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isCurrentUser
                                          ? Colors.blue
                                          : Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      messageText,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                if (image != null)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => FullScreenImage(
                                            imageUrl: image,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Image.network(
                                      image,
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                const SizedBox(height: 4.0),
                                Text(
                                  DateFormat.yMd()
                                      .add_jm()
                                      .format(timestamp.toDate()),
                                  style: const TextStyle(
                                    fontSize: 11.0,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                _buildMessageComposer(),
              ],
            ),
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
          Column(
            children: [
              GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: const Text('Camera'),
                          onTap: () {
                            _getImage(ImageSource.camera);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.image),
                          title: const Text('Gallery'),
                          onTap: () {
                            _getImage(ImageSource.gallery);
                          },
                        ),
                      ],
                    );
                  },
                ),
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 22,
                  ),
                ),
              ),
              if (_image != null)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _image = null;
                    });
                  },
                  icon: const Icon(Icons.cancel_outlined),
                ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          if (_image != null)
            Image.memory(
              _image!.readAsBytesSync(),
              fit: BoxFit.cover,
              height: 120,
              width: 250,
            )
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 0, right: 5),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(30),
                  shadowColor: Colors.grey,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    controller: _messageController,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: const Color(0xFF6789CA),
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.only(left: 10, right: 10, bottom: 13),
                      border: InputBorder.none,
                      hintText: 'Enter Your Message',
                      hintStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(
            width: 3,
          ),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.blue,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
              onPressed: () {
                _image != null ? _sendImage() : _sendMessage();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    dynamic text = _messageController.text.trim();
    String senderUid = _auth.currentUser!.uid;
    String receiverUid = widget.otherUserUid;
    var otherUserId = receiverUid;
    var currentUserId = senderUid;
    documentId = '${otherUserId}_$currentUserId';

    if (text.isNotEmpty) {
      _messageController.clear();

      try {
        DocumentReference messageRef = FirebaseFirestore.instance
            .collection('message')
            .doc(documentId)
            .collection('messages')
            .doc();

        await messageRef.set({
          'text': text,
          'sender': senderUid,
          'receiver': receiverUid,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        print('Error sending message: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending message: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _sendImage() async {
    String? image = _downloadURL!;
    String senderUid = _auth.currentUser!.uid;
    String receiverUid = widget.otherUserUid;

    var otherUserId = receiverUid;
    var currentUserId = senderUid;
    documentId = '${otherUserId}_$currentUserId';

    if (image.isNotEmpty) {
      try {
        DocumentReference messageRef = FirebaseFirestore.instance
            .collection('message')
            .doc(documentId)
            .collection('messages')
            .doc();

        await messageRef.set({
          'image': _downloadURL!,
          'sender': senderUid,
          'receiver': receiverUid,
          'timestamp': FieldValue.serverTimestamp(),
        });
        setState(() {
          _image = null;
          _downloadURL = null;
        });
      } catch (e) {
        print('Error sending message: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending message: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _uploadImageToStorage();
      }
    });
  }

  Future<String?> _uploadImageToStorage() async {
    try {
      if (_image != null) {
        // Read the file into memory
        List<int> imageBytes = await _image!.readAsBytes();

        // Convert imageBytes to Uint8List
        Uint8List uint8ListImageBytes = Uint8List.fromList(imageBytes);

        // Decode the image
        img.Image image = img.decodeImage(uint8ListImageBytes)!;

        // Resize the image to desired dimensions
        img.Image resizedImage = img.copyResize(image, width: 800);

        // Encode the resized image to bytes
        List<int> resizedImageBytes = img.encodeJpg(resizedImage);

        // Convert resizedImageBytes to Uint8List
        Uint8List uint8ListResizedImageBytes =
            Uint8List.fromList(resizedImageBytes);

        // Upload the resized image to Firebase Storage
        final firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('chatsImages/${DateTime.now()}.jpg');

        final firebase_storage.UploadTask task =
            ref.putData(uint8ListResizedImageBytes);
        final firebase_storage.TaskSnapshot snapshot =
            await task.whenComplete(() {});
        _downloadURL = await snapshot.ref.getDownloadURL();
        return _downloadURL;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
