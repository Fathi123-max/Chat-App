import 'package:chatappwithfirebase/chat/auth.dart';
import 'package:chatappwithfirebase/chat/groupchat.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign in')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Chat App'),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                final user = await _auth.signInWithGoogle();
                if (user != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => ChatRoomListScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sign in failed.')),
                  );
                }
              },
              icon:
                  Image.asset("assets/google_logo.png", width: 24, height: 24),
              label: Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
