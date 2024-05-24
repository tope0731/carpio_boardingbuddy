import 'package:carpio_boardingbuddy/screens/before_chore.dart';
import 'package:carpio_boardingbuddy/screens/home_boarding_screen.dart';
import 'package:carpio_boardingbuddy/screens/view_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChoreHistory extends StatefulWidget {
  ChoreHistory(this.choreId, {super.key});

  String choreId;

  @override
  State<ChoreHistory> createState() => _ChoreHistoryState();
}

class _ChoreHistoryState extends State<ChoreHistory> {
  List<Map<String, dynamic>> userDisplayList = [];
  List<String> users = [];
  String boardingId = '', userId = '';
  bool hasData = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    List<Map<String, dynamic>> tempList = [];
    final User? user = FirebaseAuth.instance.currentUser;
    String _uid = user!.uid;

    print(_uid);

    var userData =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    boardingId = userData['boarding id'];

    print(boardingId);

    var historyDocs = await FirebaseFirestore.instance
        .collection('boardings')
        .doc(boardingId)
        .collection('chores')
        .doc(widget.choreId)
        .collection('chore history')
        .get();
    var choreDocData = historyDocs.docs;

    if (choreDocData.isNotEmpty) {
      choreDocData.forEach((element) {
        tempList.add(element.data());
        hasData = true;
        tempList
            .sort((a, b) => b['date and time'].compareTo(a['date and time']));
        userDisplayList = tempList;
        setState(() {});
      });
      
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
                builder: (_) => const BoardingHouse(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            const Text(
              '--------------- CHORE HISTORY ---------------',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            if (hasData)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final Timestamp orderedDate =
                          userDisplayList[index]['date and time'];
                      String scannedDate = DateFormat('MMM dd yyyy,  h:mm a')
                          .format(orderedDate.toDate());
                      String fullName = userDisplayList[index]['first name'] +
                          ' ' +
                          userDisplayList[index]['last name'];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => ViewDetails(
                                  userDisplayList[index]['chore history id'],
                                  widget.choreId, false),
                            ),
                          );
                        },
                        child: Card(
                          elevation:
                              3, 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), 
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: ListTile(
                              title: Text(fullName),
                              subtitle: Text(scannedDate),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: userDisplayList.length,
                  ),
                ),
              )
            else
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ListView(
                    children: [
                      Card(
                        elevation:
                            3, 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), 
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          child: const ListTile(
                            title: Text('No data found'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => BeforeChore(widget.choreId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'DO THE CHORE',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
