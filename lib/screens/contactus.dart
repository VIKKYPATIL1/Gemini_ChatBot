import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Contact Us',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            const ListTile(
              textColor: Colors.white,
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text('cpk652@gmail.com'),
            ),
            const ListTile(
              textColor: Colors.white,
              leading: Icon(Icons.chat_bubble),
              title: Text('Gemini'),
              subtitle: Text('Gemini-pro and Gemini Vision'),
            ),
            const ListTile(
              textColor: Colors.white,
              leading: Icon(Icons.verified_user_outlined),
              title: Text('Version'),
              subtitle: Text('1.0'),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
                child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pop();
                    },
                    child: const Text("Sign Out",
                        style: TextStyle(color: Colors.black))))
          ],
        ),
      ),
    );
  }
}
