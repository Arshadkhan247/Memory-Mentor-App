// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:intl/intl.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';

// class CaregiverCallsAndChatsScreen extends StatefulWidget {
//   final String otherUserUid;
//   final String caregiverName;

//   const CaregiverCallsAndChatsScreen({
//     super.key,
//     required this.otherUserUid,
//     required this.caregiverName,
//   });

//   @override
//   _CaregiverCallsAndChatsScreenState createState() =>
//       _CaregiverCallsAndChatsScreenState();
// }

// class _CaregiverCallsAndChatsScreenState
//     extends State<CaregiverCallsAndChatsScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _messageController = TextEditingController();
//   final picker = ImagePicker();
//   File? _image;
//   String? _downloadURL;
//   String? userId;

//   Future<String?> getUserIdFromFirestore() async {
//     try {
//       // Get the current user's UID
//       String currentUserId = FirebaseAuth.instance.currentUser!.uid;

//       // Fetch the document from the 'users' collection
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(currentUserId)
//           .get();

//       // Check if the document exists
//       if (userDoc.exists) {
//         // Retrieve the 'userId' field from the document
//         userId = userDoc.get('userId') as String?;

//         return userId;
//       } else {
//         print('User document does not exist.');
//         return null;
//       }
//     } catch (e) {
//       print('Error getting user ID from Firestore: $e');
//       return null;
//     }
//   }

//   Stream<QuerySnapshot<Map<String, dynamic>>> _messageStream() {
//     var currentUserUid = userId;
//     var otherUserUid = widget.otherUserUid;

//     if (currentUserUid == null) {
//       return const Stream.empty(); // Return an empty stream if userId is null
//     }

//     var documentId = '${currentUserUid}_$otherUserUid';
//     var reverseDocumentId = '${otherUserUid}_$currentUserUid';

//     var currentUserStream = FirebaseFirestore.instance
//         .collection('message')
//         .doc(documentId)
//         .collection('messages')
//         .orderBy('timestamp', descending: true)
//         .snapshots();

//     var otherUserStream = FirebaseFirestore.instance
//         .collection('message')
//         .doc(reverseDocumentId)
//         .collection('messages')
//         .orderBy('timestamp', descending: true)
//         .snapshots();

//     return Rx.merge([currentUserStream, otherUserStream]);
//   }

//   @override
//   void initState() {
//     super.initState();
//     getUserIdFromFirestore();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         body: Stack(
//           children: [
//             Image(
//               height: MediaQuery.of(context).size.height,
//               width: double.infinity,
//               image: const AssetImage('assets/chatBack.jpg'),
//               fit: BoxFit.fill,
//             ),
//             Column(
//               children: [
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.10,
//                   width: MediaQuery.of(context).size.width,
//                   decoration: const BoxDecoration(
//                     color: Colors.blue,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 25),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           icon: const Icon(
//                             Icons.arrow_back,
//                             color: Colors.white,
//                           ),
//                         ),
//                         Text(
//                           widget.caregiverName,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                           ),
//                         ),
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.14,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                     stream: _messageStream(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.blue,
//                           ),
//                         );
//                       }

//                       if (snapshot.hasError) {
//                         return Center(
//                           child: Text('Error: ${snapshot.error}'),
//                         );
//                       }

//                       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                         return const Center(child: Text("No messages"));
//                       }

//                       var messages = snapshot.data!.docs;
//                       messages.sort((a, b) {
//                         var timestampA =
//                             (a.data()['timestamp'] as Timestamp?)?.toDate();
//                         var timestampB =
//                             (b.data()['timestamp'] as Timestamp?)?.toDate();
//                         return timestampB!.compareTo(timestampA!);
//                       });

//                       return ListView.builder(
//                         reverse: true,
//                         itemCount: messages.length,
//                         itemBuilder: (context, index) {
//                           var message = messages[index].data();
//                           var timestamp = message['timestamp'] as Timestamp?;
//                           var messageText = message['text'] as String?;
//                           var senderUid = message['sender'] as String;
//                           var image = message['image'] as String?;

//                           bool isCurrentUser =
//                               senderUid == _auth.currentUser!.uid;

//                           if (timestamp == null) {
//                             return const SizedBox();
//                           }

//                           return Padding(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 8.0,
//                               horizontal: 12.0,
//                             ),
//                             child: Align(
//                               alignment: isCurrentUser
//                                   ? Alignment.centerLeft
//                                   : Alignment.centerRight,
//                               child: Column(
//                                 crossAxisAlignment: isCurrentUser
//                                     ? CrossAxisAlignment.start
//                                     : CrossAxisAlignment.end,
//                                 children: [
//                                   if (messageText != null)
//                                     Container(
//                                       constraints: BoxConstraints(
//                                         maxWidth:
//                                             MediaQuery.of(context).size.width *
//                                                 0.85,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: isCurrentUser
//                                             ? Colors.grey
//                                             : Colors.blue.shade300,
//                                         borderRadius:
//                                             BorderRadius.circular(10.0),
//                                       ),
//                                       padding: const EdgeInsets.all(12.0),
//                                       child: Text(
//                                         messageText,
//                                         style: const TextStyle(
//                                           fontSize: 16.0,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                     ),
//                                   if (image != null)
//                                     GestureDetector(
//                                       onTap: () {
//                                         Navigator.of(context).push(
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 FullScreenImage(
//                                               imageUrl: image,
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                       child: Image.network(
//                                         image,
//                                         height: 200,
//                                         width: 200,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                   const SizedBox(height: 4.0),
//                                   Text(
//                                     DateFormat.yMd()
//                                         .add_jm()
//                                         .format(timestamp.toDate()),
//                                     style: const TextStyle(
//                                       fontSize: 11.0,
//                                       color: Colors.black54,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 _buildMessageComposer(),
//               ],
//             ),
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
//           Column(
//             children: [
//               GestureDetector(
//                 onTap: () => showModalBottomSheet(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         ListTile(
//                           leading: const Icon(Icons.camera_alt),
//                           title: const Text('Camera'),
//                           onTap: () {
//                             _getImage(ImageSource.camera);
//                           },
//                         ),
//                         ListTile(
//                           leading: const Icon(Icons.image),
//                           title: const Text('Gallery'),
//                           onTap: () {
//                             _getImage(ImageSource.gallery);
//                           },
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//                 child: const Padding(
//                   padding: EdgeInsets.all(5.0),
//                   child: Icon(
//                     Icons.camera_alt_outlined,
//                     size: 22,
//                   ),
//                 ),
//               ),
//               if (_image != null)
//                 IconButton(
//                   onPressed: () {
//                     setState(() {
//                       _image = null;
//                     });
//                   },
//                   icon: const Icon(Icons.cancel_outlined),
//                 ),
//             ],
//           ),
//           const SizedBox(
//             width: 10,
//           ),
//           if (_image != null)
//             Image.memory(
//               _image!.readAsBytesSync(),
//               fit: BoxFit.cover,
//               height: 120,
//               width: 250,
//             )
//           else
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 0, right: 5),
//                 child: Material(
//                   elevation: 8,
//                   borderRadius: BorderRadius.circular(15),
//                   child: TextFormField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       contentPadding: const EdgeInsets.all(15),
//                       hintText: 'Type a message...',
//                       hintStyle: TextStyle(color: Colors.grey[600]),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           IconButton(
//             onPressed: () {
//               if (_messageController.text.isNotEmpty) {
//                 _sendMessage();
//               } else if (_image != null) {
//                 _sendImage();
//               }
//             },
//             icon: const Icon(Icons.send),
//             color: Colors.blue,
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _getImage(ImageSource source) async {
//     final pickedFile = await picker.pickImage(source: source);

//     if (pickedFile != null) {
//       File imageFile = File(pickedFile.path);
//       final compressedImage = await _compressImage(imageFile);
//       setState(() {
//         _image = compressedImage as File?;
//       });
//     }
//   }

//   Future<XFile> _compressImage(File file) async {
//     final compressedImage = await FlutterImageCompress.compressAndGetFile(
//       file.path,
//       '${file.path}_compressed',
//       quality: 50,
//     );
//     return compressedImage!;
//   }

//   Future<void> _sendMessage() async {
//     var now = DateTime.now();
//     var timestamp = Timestamp.fromDate(now);

//     await FirebaseFirestore.instance
//         .collection('message')
//         .doc('${userId}_${widget.otherUserUid}')
//         .collection('messages')
//         .add({
//       'text': _messageController.text,
//       'timestamp': timestamp,
//       'sender': _auth.currentUser!.uid,
//     });

//     await FirebaseFirestore.instance
//         .collection('message')
//         .doc('${widget.otherUserUid}_$userId')
//         .collection('messages')
//         .add({
//       'text': _messageController.text,
//       'timestamp': timestamp,
//       'sender': _auth.currentUser!.uid,
//     });

//     _messageController.clear();
//   }

//   Future<void> _sendImage() async {
//     var now = DateTime.now();
//     var timestamp = Timestamp.fromDate(now);

//     // Upload the image to Firebase Storage
//     final storageReference = firebase_storage.FirebaseStorage.instance
//         .ref()
//         .child('chat_images')
//         .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

//     final uploadTask = storageReference.putFile(_image!);
//     final taskSnapshot = await uploadTask.whenComplete(() {});
//     final downloadURL = await storageReference.getDownloadURL();

//     await FirebaseFirestore.instance
//         .collection('message')
//         .doc('${userId}_${widget.otherUserUid}')
//         .collection('messages')
//         .add({
//       'image': downloadURL,
//       'timestamp': timestamp,
//       'sender': _auth.currentUser!.uid,
//     });

//     await FirebaseFirestore.instance
//         .collection('message')
//         .doc('${widget.otherUserUid}_$userId')
//         .collection('messages')
//         .add({
//       'image': downloadURL,
//       'timestamp': timestamp,
//       'sender': _auth.currentUser!.uid,
//     });

//     setState(() {
//       _image = null;
//     });
//   }
// }

// class FullScreenImage extends StatelessWidget {
//   final String imageUrl;

//   const FullScreenImage({super.key, required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text('Image Preview'),
//       ),
//       body: Center(
//         child: Image.network(imageUrl),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:rxdart_ext/not_replay_value_stream.dart';

class CaregiverCallsAndChatsScreen extends StatefulWidget {
  final String otherUserUid;
  final String caregiverName;

  const CaregiverCallsAndChatsScreen({
    super.key,
    required this.otherUserUid,
    required this.caregiverName,
  });

  @override
  _CaregiverCallsAndChatsScreenState createState() =>
      _CaregiverCallsAndChatsScreenState();
}

class _CaregiverCallsAndChatsScreenState
    extends State<CaregiverCallsAndChatsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();

    setState(() {
      _userId = userDoc.get('userId') as String?;
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _messageStream() {
    if (_userId == null) return const Stream.empty();

    final documentId = '${_userId}_${widget.otherUserUid}';
    final reverseDocumentId = '${widget.otherUserUid}_$_userId';

    final currentUserStream = FirebaseFirestore.instance
        .collection('message')
        .doc(documentId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();

    final otherUserStream = FirebaseFirestore.instance
        .collection('message')
        .doc(reverseDocumentId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();

    return Rx.merge([currentUserStream, otherUserStream]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/chatBack.jpg',
              fit: BoxFit.fill,
              height: double.infinity,
              width: double.infinity,
            ),
            Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _messageStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: Color(0xff0F547D),
                        ));
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No messages'));
                      }

                      final messages = snapshot.data!.docs;
                      messages.sort((a, b) {
                        final timestampA =
                            (a.data()['timestamp'] as Timestamp?)?.toDate();
                        final timestampB =
                            (b.data()['timestamp'] as Timestamp?)?.toDate();
                        return timestampB!.compareTo(timestampA!);
                      });

                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index].data();
                          final timestamp = message['timestamp'] as Timestamp?;
                          final messageText = message['text'] as String?;
                          final senderUid = message['sender'] as String;
                          final image = message['image'] as String?;

                          final isCurrentUser =
                              senderUid == _auth.currentUser!.uid;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            child: Align(
                              alignment: isCurrentUser
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Column(
                                crossAxisAlignment: isCurrentUser
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.end,
                                children: [
                                  if (messageText != null)
                                    _buildTextMessage(
                                        messageText, isCurrentUser),
                                  if (image != null) _buildImageMessage(image),
                                  _buildTimestamp(timestamp),
                                ],
                              ),
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

  Widget _buildAppBar() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.10,
      width: MediaQuery.of(context).size.width,
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            Text(widget.caregiverName,
                style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(width: 56), // Placeholder for spacing
          ],
        ),
      ),
    );
  }

  Widget _buildTextMessage(String messageText, bool isCurrentUser) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.grey : Colors.blue.shade300,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Text(
        messageText,
        style: const TextStyle(fontSize: 16.0, color: Colors.black),
      ),
    );
  }

  Widget _buildImageMessage(String image) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => FullScreenImage(imageUrl: image)),
        );
      },
      child: Image.network(image, height: 200, width: 200, fit: BoxFit.cover),
    );
  }

  Widget _buildTimestamp(Timestamp? timestamp) {
    return Text(
      DateFormat.yMd().add_jm().format(timestamp?.toDate() ?? DateTime.now()),
      style: const TextStyle(fontSize: 11.0, color: Colors.black54),
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
                  builder: (context) => _buildImageSourceSheet(),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(Icons.camera_alt_outlined, size: 22),
                ),
              ),
              if (_image != null)
                IconButton(
                  onPressed: () => setState(() => _image = null),
                  icon: const Icon(Icons.cancel_outlined),
                ),
            ],
          ),
          const SizedBox(width: 10),
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
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(15),
                  child: TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(15),
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
              ),
            ),
          IconButton(
            onPressed: () => _sendContent(),
            icon: const Icon(Icons.send),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildImageSourceSheet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text('Camera'),
          onTap: () => _getImage(ImageSource.camera),
        ),
        ListTile(
          leading: const Icon(Icons.image),
          title: const Text('Gallery'),
          onTap: () => _getImage(ImageSource.gallery),
        ),
      ],
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final compressedImage = await _compressImage(File(pickedFile.path));
      setState(() => _image = compressedImage as File?);
    }
  }

  Future<XFile?> _compressImage(File file) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      '${file.path}_compressed',
      quality: 50,
    );
    return result;
  }

  Future<void> _sendContent() async {
    if (_messageController.text.isNotEmpty) {
      await _sendMessage();
    } else if (_image != null) {
      await _sendImage();
    }
  }

  Future<void> _sendMessage() async {
    final now = DateTime.now();
    final timestamp = Timestamp.fromDate(now);
    final messageData = {
      'text': _messageController.text,
      'timestamp': timestamp,
      'sender': _auth.currentUser!.uid,
    };

    final docId1 = '${_userId}_${widget.otherUserUid}';
    final docId2 = '${widget.otherUserUid}_$_userId';

    final batch = FirebaseFirestore.instance.batch();
    batch.set(
      FirebaseFirestore.instance
          .collection('message')
          .doc(docId1)
          .collection('messages')
          .doc(),
      messageData,
    );
    batch.set(
      FirebaseFirestore.instance
          .collection('message')
          .doc(docId2)
          .collection('messages')
          .doc(),
      messageData,
    );

    await batch.commit();
    _messageController.clear();
  }

  Future<void> _sendImage() async {
    final now = DateTime.now();
    final timestamp = Timestamp.fromDate(now);
    final storageRef = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('chat_images')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    final uploadTask = storageRef.putFile(_image!);
    final snapshot = await uploadTask;
    final downloadURL = await snapshot.ref.getDownloadURL();

    final messageData = {
      'image': downloadURL,
      'timestamp': timestamp,
      'sender': _auth.currentUser!.uid,
    };

    final docId1 = '${_userId}_${widget.otherUserUid}';
    final docId2 = '${widget.otherUserUid}_$_userId';

    final batch = FirebaseFirestore.instance.batch();
    batch.set(
      FirebaseFirestore.instance
          .collection('message')
          .doc(docId1)
          .collection('messages')
          .doc(),
      messageData,
    );
    batch.set(
      FirebaseFirestore.instance
          .collection('message')
          .doc(docId2)
          .collection('messages')
          .doc(),
      messageData,
    );

    await batch.commit();
    setState(() => _image = null);
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Image Preview'),
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
