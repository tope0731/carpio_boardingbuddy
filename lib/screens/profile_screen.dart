import 'package:carpio_boardingbuddy/screens/home_boarding_screen.dart';
import 'package:carpio_boardingbuddy/screens/home_screen.dart';
import 'package:carpio_boardingbuddy/screens/login_screen.dart';
import 'package:carpio_boardingbuddy/screens/view_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, dynamic>> userDisplayList = [];
  List<String> users = [];
  String boardingId = '', userId = '';
  String boarding = '', name = '';
  bool hasBoarding = false;
  var choreDocData = [];
  var searchChoreDocData = [];
  late DateTime? searchDate;
  late DateTime? endDate;
  String displaySearch = 'Date Search';
  bool filtered = false;
  var searchController = TextEditingController();
  List<Map<String, dynamic>> choreList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserHistory();
    getBoarderData();
  }

  void getUserHistory() async {
    final User? user = FirebaseAuth.instance.currentUser;
    String _uid = user!.uid;

    try {
      var userData =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      boardingId = userData['boarding id'];

      var choresQuerySnapshot = await FirebaseFirestore.instance
          .collection('boardings')
          .doc(boardingId)
          .collection('chores')
          .get();

      List<DocumentSnapshot> allChoreHistoryDocs = [];

      for (var choreDoc in choresQuerySnapshot.docs) {
        var historyDocs = await FirebaseFirestore.instance
            .collection('boardings')
            .doc(boardingId)
            .collection('chores')
            .doc(choreDoc.id)
            .collection('chore history')
            .where('user id', isEqualTo: _uid)
            .get();

        allChoreHistoryDocs.addAll(historyDocs.docs);
      }
      allChoreHistoryDocs
          .sort((a, b) => b['date and time'].compareTo(a['date and time']));

      choreDocData = allChoreHistoryDocs;
      filtered = false;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void getBoarderData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    String _uid = user!.uid;
    var userData =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    boarding = userData['boarding id'];
    name = userData['first name'] + ' ' + userData['last name'];

    var user2Data =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    boarding = user2Data['boarding id'];
    if (boarding == '') {
      hasBoarding = false;
    } else {
      hasBoarding = true;
    }

    setState(() {});
  }

  void filterDate(DateTime? startDate, DateTime? endDate) async {
    final User? user = FirebaseAuth.instance.currentUser;
    String _uid = user!.uid;

    try {
      var userData =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      boardingId = userData['boarding id'];

      var dateSearchDocs = await FirebaseFirestore.instance
          .collection('boardings')
          .doc(boardingId)
          .collection('chores')
          .get();

      List<DocumentSnapshot> dateSearchAllDocs = [];

      for (var choreDoc in dateSearchDocs.docs) {
        var historyDocs = await FirebaseFirestore.instance
            .collection('boardings')
            .doc(boardingId)
            .collection('chores')
            .doc(choreDoc.id)
            .collection('chore history')
            .where('date and time',
                isGreaterThanOrEqualTo: startDate, isLessThanOrEqualTo: endDate)
            .get();

        dateSearchAllDocs.addAll(historyDocs.docs);
      }

      List<Map<String, dynamic>> filterList = [];
      dateSearchAllDocs.forEach((uData) {
        var data = uData.data() as Map<String, dynamic>;
        if (data['user id'] == _uid) {
          filterList.add(data);
        }
      });

      filterList
          .sort((a, b) => b['date and time'].compareTo(a['date and time']));
      searchChoreDocData = filterList;
      filtered = true;

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void searchChore(String choreName) async {
    final User? user = FirebaseAuth.instance.currentUser;
    String _uid = user!.uid;

    try {
      if (choreName == '') {
        getUserHistory();
        return;
      }
      var userData =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      boardingId = userData['boarding id'];

      print('search chore nakakapasok1');

      var dateSearchDocs = await FirebaseFirestore.instance
          .collection('boardings')
          .doc(boardingId)
          .collection('chores')
          .get();
      print('search chore nakakapasok2');
      List<DocumentSnapshot> choreSearchAllDocs = [];

      for (var choreDoc in dateSearchDocs.docs) {
        var historyDocs = await FirebaseFirestore.instance
            .collection('boardings')
            .doc(boardingId)
            .collection('chores')
            .doc(choreDoc.id)
            .collection('chore history')
            .where('chore name', isEqualTo: choreName)
            .get();

        choreSearchAllDocs.addAll(historyDocs.docs);
      }

      print(choreSearchAllDocs);

      List<Map<String, dynamic>> filterList = [];
      choreSearchAllDocs.forEach((uData) {
        var data = uData.data() as Map<String, dynamic>;
        if (data['user id'] == _uid) {
          filterList.add(data);
        }
      });
      filterList
          .sort((a, b) => b['date and time'].compareTo(a['date and time']));
      searchChoreDocData = filterList;
      filtered = true;
      setState(() {});
    } catch (e) {
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
                  builder: (_) =>
                      hasBoarding ? const BoardingHouse() : HomeScreen(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back_ios),),
        actions: [
          IconButton(
            onPressed: () {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.info,
                text: 'Are you sure you want to logout?',
                showCancelBtn: true,
                onCancelBtnTap: () {
                  Navigator.of(context).pop();
                },
                onConfirmBtnTap: () {
                  Navigator.of(context).pop();
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/default.jpg'),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            name,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(13),
                  ),
                ),
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                hintText: 'Search Chore',
              ),
              onChanged: (value) {
                searchChore(value);
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  searchDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (searchDate != null) {
                    displaySearch =
                        DateFormat('MMM-dd-yyyy').format(searchDate!);
                    endDate = searchDate!.add(
                      const Duration(
                        hours: 23,
                        minutes: 59,
                        seconds: 59,
                      ),
                    );
                    filterDate(searchDate, endDate);
                  }
                },
                label: Text(
                  displaySearch,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                icon: const Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade300,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Chore History',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: filtered
                    ? ListView.builder(
                        itemBuilder: (context, index) {
                          print('chore length: ${choreDocData.length}');
                          var data = searchChoreDocData[index];

                          final Timestamp orderedDate = data['date and time'];
                          String scannedDate =
                              DateFormat('MMM dd yyyy,  h:mm a')
                                  .format(orderedDate.toDate());
                          var beforeChore = data['chore name'];

                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => ViewDetails(
                                      data['chore history id'],
                                      data['chore id'],
                                      true),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 5),
                                title: Text(
                                  '$beforeChore',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  scannedDate,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: searchChoreDocData.length,
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          var data = choreDocData[index].data();

                          final Timestamp orderedDate = data['date and time'];
                          String scannedDate =
                              DateFormat('MMM dd yyyy,  h:mm a')
                                  .format(orderedDate.toDate());

                          var beforeChore = data['chore name'];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => ViewDetails(
                                      data['chore history id'],
                                      data['chore id'],
                                      true),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 5),
                                title: Text(
                                  '$beforeChore',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  scannedDate,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: choreDocData.length,
                      )),
          )
        ],
      ),
    );
  }
}
