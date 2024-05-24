import 'package:carpio_boardingbuddy/screens/home_boarding_screen.dart';
import 'package:carpio_boardingbuddy/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:quickalert/quickalert.dart';

class JoinRoom extends StatefulWidget {
  const JoinRoom({super.key});

  @override
  State<JoinRoom> createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  var roomController = TextEditingController();

  void insertBoarding(String boarding) async {
    print('insertBoarding');
    List<Map<String, dynamic>> filterList = [];
    try {
      print('insertBoarding1');
      final filterDoc =
          await FirebaseFirestore.instance.collection('boardings').get();

      var filterDocData = filterDoc.docs;

      if (filterDocData.isNotEmpty) {
        print('insertBoarding2');
        filterDocData.forEach((element) {
          filterList.add(element.data());
        });

        for (int i = 0; i < filterList.length; i++) {
          if (boarding == filterList[i]['id']) {
            addBoarder(filterList[i]['id']);
            return;
          }
        }
        QuickAlert.show(
            context: context, type: QuickAlertType.error, text: 'Invalid Code');
      }
    } catch (e) {
      QuickAlert.show(
          context: context, type: QuickAlertType.error, text: 'Invalid Code');
      print(e);
    }
  }

  void addBoarder(String boardingId) async { 
    User user = FirebaseAuth.instance.currentUser!;
    String _uid = user.uid;

    await FirebaseFirestore.instance.collection('users').doc(_uid).update({
      'boarding id': boardingId,
    });

    QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'Joined a room')
        .then((value) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const BoardingHouse(),
        ),
      );
    });
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
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_uid)
              .update({
                'boarding id' : barcodeScanRes,
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
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => HomeScreen(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Join Room'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: ElevatedButton(
          onPressed: scanQr,
          child: const Text('Scan'),
        ),
      ),
    );
  }
}
