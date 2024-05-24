import 'package:carpio_boardingbuddy/screens/home_boarding_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quickalert/quickalert.dart';

class ViewCode extends StatefulWidget {
  const ViewCode({super.key});

  @override
  State<ViewCode> createState() => _ViewCodeState();
}

class _ViewCodeState extends State<ViewCode> {
  String roomCode = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCode();
  }

  void getCode() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      String _uid = user!.uid;

      var userData =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      roomCode = userData['boarding id'];
      setState(() {});
    } catch (e) {
      QuickAlert.show(
          context: context, type: QuickAlertType.error, text: 'Invalid Code');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => BoardingHouse(),
              ),
            );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text('View Code'),
        centerTitle: true,
      ),
      body: Center(
        child: QrImageView(
          data: roomCode,
          version: QrVersions.auto,
          size: 300.0,
        ),
      ),
    );
  }
}
