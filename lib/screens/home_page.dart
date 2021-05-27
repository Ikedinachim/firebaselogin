import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const pageName = '/homePage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${FirebaseAuth.instance.currentUser.displayName}'),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => FirebaseAuth.instance.signOut())
        ],
      ),
      body: Center(
        child: Text('this is the homePage'),
      ),
    );
  }
}
