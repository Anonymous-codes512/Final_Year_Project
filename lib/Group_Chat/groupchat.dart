import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupChat extends StatefulWidget {
  const GroupChat({super.key});

  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final CollectionReference _chatCollection =
      FirebaseFirestore.instance.collection('groupChats');
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  bool _hasJoinedGroup = false;

  @override
  void initState() {
    super.initState();
    _showJoinGroupAlert();
  }

  Future<void> _showJoinGroupAlert() async {
    final DocumentReference groupDoc =
        _chatCollection.doc('29nRlKGzgqEnnpLC8dZ9');
    final DocumentSnapshot groupSnapshot = await groupDoc.get();

    if (_currentUser == null || !groupSnapshot.exists) return;

    final List<dynamic> members = groupSnapshot['members'] ?? [];

    // Check if the current user has already joined the group
    if (members.contains(_currentUser.uid)) {
      setState(() {
        _hasJoinedGroup = true;
      });
      return;
    }

    // Show the alert dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Join Group"),
          content: const Text("Do you want to join this group?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, 'Parent_home_screen');
              },
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Add the user to the group's member list
                await groupDoc.update({
                  'members': FieldValue.arrayUnion([_currentUser.uid]),
                });
                setState(() {
                  _hasJoinedGroup = true;
                });
                Navigator.pop(context);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || !_hasJoinedGroup) return;

    final String userName = _currentUser!.email!.split('@')[0];
    final String messageText = _messageController.text.trim();

    try {
      final DocumentReference chatDocRef =
          _chatCollection.doc('29nRlKGzgqEnnpLC8dZ9');
      final DocumentSnapshot docSnapshot = await chatDocRef.get();

      if (!docSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to send message. Document not found.')),
        );
        return;
      }

      final messageData = {
        'senderName': userName,
        'text': messageText,
      };

      await chatDocRef.update({
        'messages': FieldValue.arrayUnion([messageData]),
      });

      _messageController.clear();
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to send message. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Chat"),
        backgroundColor: const Color(0xFF373e37), // Dark greenish shade
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        color: const Color(0xFFF5F5F5), // Off-white background color
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: _chatCollection.doc('29nRlKGzgqEnnpLC8dZ9').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>?;
                  if (data == null || data['messages'] == null) {
                    return const Center(child: Text('No messages yet'));
                  }

                  final messages =
                      List<Map<String, dynamic>>.from(data['messages']);
                  final userName = _currentUser!.email!.split('@')[0];

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final text = msg['text'] ?? '';
                      final senderName = msg['senderName'] ?? 'Unknown';
                      final isCurrentUser = senderName == userName;

                      return Align(
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isCurrentUser
                                ? const Color(
                                    0xFFFFDE59) // Yellow for sent messages
                                : const Color(
                                    0xFF373E37), // Dark greenish for received messages
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: isCurrentUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                senderName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                text,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: "Type a message...",
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.black),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
