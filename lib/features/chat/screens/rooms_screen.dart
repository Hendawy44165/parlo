import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VoicesScreen extends StatelessWidget {
  const VoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          child: Text("Sign Out"),
        ),
      ),
    );
  }
}
