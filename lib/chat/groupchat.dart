import 'package:chatappwithfirebase/chat/chatscreen.dart';
import 'package:chatappwithfirebase/chat/sininscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class ChatRoomListScreen extends StatelessWidget {
  final _database = FirebaseDatabase.instance.reference();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Rooms'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _auth.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            },
          ),
        ],
      ),
      body: FirebaseAnimatedList(
        query: _database.child('rooms'),
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map<String, dynamic>? room = snapshot.value as Map<String, dynamic>?;
          if (room != null) {
            return ListTile(
              title: Text(room['name'] ?? 'Unnamed Room'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChatScreen(roomId: snapshot.key!)));
              },
            );
          }
          return SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _createChatRoom(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _createChatRoom(BuildContext context) async {
    String? roomName = await _showChatRoomInputDialog(context);
    if (roomName != null && roomName.trim().isNotEmpty) {
      final newRoomRef = _database.child('rooms').push();
      await newRoomRef.set({'name': roomName.trim()});
    }
  }

  Future<String?> _showChatRoomInputDialog(BuildContext context) {
    TextEditingController roomNameController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create Chat Room'),
          content: TextField(
            controller: roomNameController,
            decoration: InputDecoration(
              hintText: 'Enter room name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(roomNameController.text),
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
