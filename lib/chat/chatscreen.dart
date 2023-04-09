import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({required String roomId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _database = FirebaseDatabase.instance.reference();
  final _auth = FirebaseAuth.instance;
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final user = _auth.currentUser;
    if (user == null) return;

    await _database.child('messages').push().set({
      'senderId': user.uid,
      'senderName': user.displayName ?? 'Anonymous',
      'text': text.trim(),
    });

    _textController.clear();
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FirebaseAnimatedList(
                controller: _scrollController,
                query: _database.child('messages'),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Map<String, dynamic>? message =
                      snapshot.value as Map<String, dynamic>?;
                  if (message != null) {
                    return ListTile(
                      title: Text(message['senderName'] ?? 'Unknown'),
                      subtitle: Text(message['text'] ?? '-'),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Type your message',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _sendMessage(_textController.text),
                    icon: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
