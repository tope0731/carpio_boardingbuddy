import 'package:carpio_boardingbuddy/screens/home_boarding_screen.dart';
import 'package:carpio_boardingbuddy/screens/home_screen.dart';
import 'package:carpio_boardingbuddy/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authentication extends StatelessWidget {
  const Authentication({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasData) {
            String userId = snapshot.data!.uid;
            // print(userId);
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .get(),
              builder: (context, userDocSnapshot) {
                if (userDocSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (userDocSnapshot.hasData) {
                  String status = userDocSnapshot.data!.get('boarding id');
                  print("This is the user type: $status");
                  if (status == '') {
                    return HomeScreen();
                  } else {
                    return const BoardingHouse();
                  }
                } else {
                  return const LoginScreen();
                }
              },
            );
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
