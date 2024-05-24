import 'package:carpio_boardingbuddy/screens/chore_history.dart';
import 'package:carpio_boardingbuddy/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewDetails extends StatefulWidget {
  ViewDetails(this.historyId, this.choreId, this.fromProfile, {super.key});

  String historyId;
  String choreId;
  bool fromProfile;

  @override
  State<ViewDetails> createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  List<Map<String, dynamic>> userDisplayList = [];
  List<String> users = [];
  String boardingId = '', userId = '';
  bool hasData = false;
  String firstImg = '',
      secondImg = '',
      name = '',
      choreName = '',
      scannedDate = '',
      scannedTime = '';
  String containerimg =
      'https://cdn.vectorstock.com/i/500p/65/30/default-image-icon-missing-picture-page-vector-40546530.jpg';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    String _uid = user!.uid;
    try {
      var userData =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      boardingId = userData['boarding id'];

      var historyDocs = await FirebaseFirestore.instance
          .collection('boardings')
          .doc(boardingId)
          .collection('chores')
          .doc(widget.choreId)
          .collection('chore history')
          .doc(widget.historyId)
          .get();

      firstImg = historyDocs['before chore'];
      secondImg = historyDocs['after chore'];
      choreName = historyDocs['chore name'];
      name = '${historyDocs['first name']} ${historyDocs['last name']}';
      scannedDate = DateFormat('MMM dd yyyy')
          .format(historyDocs['date and time'].toDate());
      scannedTime =
          DateFormat('h:mm a').format(historyDocs['date and time'].toDate());
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    String choreId = widget.choreId;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => widget.fromProfile
                    ? const ProfileScreen()
                    : ChoreHistory(choreId),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Chore details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: $name',
                style: const TextStyle(
                  fontSize: 23,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Chore name: $choreName',
                style: const TextStyle(
                  fontSize: 23,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Date: $scannedDate',
                style: const TextStyle(
                  fontSize: 23,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Time: $scannedTime',
                style: const TextStyle(
                  fontSize: 23,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '-------- BEFORE DOING THE CHORE --------',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue.shade900,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Image.network(
                  firstImg == '' ? containerimg : firstImg,
                  height: 400,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                '--------- AFTER DOING THE CHORE ---------',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.green.shade900,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Image.network(
                  secondImg == '' ? containerimg : secondImg,
                  height: 400,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
