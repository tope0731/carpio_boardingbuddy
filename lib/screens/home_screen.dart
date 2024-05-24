import 'package:carpio_boardingbuddy/screens/create_room_screen.dart';
import 'package:carpio_boardingbuddy/screens/home_boarding_screen.dart';
import 'package:carpio_boardingbuddy/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:quickalert/quickalert.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = '';
  String boarding = '';
  bool hasBoarding = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    String _uid = user!.uid;
    var userData =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    boarding = userData['boarding id'];

    userName = userData['first name'];
    print(hasBoarding);
    setState(() {});
  }

  void scanQr() async {
    try {
      const lineColor = '#ffffff';
      const cancelButtonText = 'CANCEL';
      const isShowFlashIcon = true;
      const scanMode = ScanMode.DEFAULT;

      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        lineColor,
        cancelButtonText,
        isShowFlashIcon,
        scanMode,
      );

      if (barcodeScanRes != '-1') {
        final User? user = FirebaseAuth.instance.currentUser;
        String _uid = user!.uid;
        var userQuerySnapshot = await FirebaseFirestore.instance
            .collection('boardings')
            .where('id', isEqualTo: barcodeScanRes)
            .get();

        if (userQuerySnapshot.docs.isNotEmpty) {
          // get client name
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_uid)
              .update({
            'boarding id': barcodeScanRes,
          });
          QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  title: 'You joined the room')
              .then((value) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const BoardingHouse(),
              ),
            );
          });
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Invalid User',
            text: 'User does not exist',
          );
          print('User does not exist');
        }
      } else {
        print('User cancelled the scan');
      }
    } catch (e) {
      print('Error scanning QR code: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BoardingBuddy',
          style: TextStyle(color: Colors.orange),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.person,
              color: Colors.blue.shade300,
              size: 35,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                children: [],
              ),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const CreateRoom(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue,
                    ),
                  ),
                  child: const Text(
                    'CREATE ROOM',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    scanQr();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.green,
                    ),
                  ),
                  child: const Text(
                    'JOIN ROOM',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
