import 'package:carpio_boardingbuddy/screens/chore_adding.dart';
import 'package:carpio_boardingbuddy/screens/chore_history.dart';
import 'package:carpio_boardingbuddy/screens/profile_screen.dart';
import 'package:carpio_boardingbuddy/screens/view_code_screen.dart';
import 'package:carpio_boardingbuddy/screens/view_members_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BoardingHouse extends StatefulWidget {
  const BoardingHouse({super.key});

  @override
  State<BoardingHouse> createState() => _BoardingHouseState();
}

class _BoardingHouseState extends State<BoardingHouse> {
  List<Map<String, dynamic>> choreList = [];
  String boardingName = '', boardingId = '';
  List<Map<String, dynamic>> memberList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChoresData();
  }

  void getChoresData() async {
    List<Map<String, dynamic>> filterList = [];
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      String _uid = user!.uid;

      var userData =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      boardingId = userData['boarding id'];

      var userBoarding = await FirebaseFirestore.instance
          .collection('boardings')
          .doc(boardingId)
          .get();

      boardingName = userBoarding['boarding name'];

      final choreDoc = await FirebaseFirestore.instance
          .collection('boardings')
          .doc(boardingId)
          .collection('chores')
          .get();

      var choreDocData = choreDoc.docs;

      if (choreDocData.isNotEmpty) {
        for (var element in choreDocData) {
          filterList.add(element.data());
        }
        if (filterList.isNotEmpty) {
          choreList = filterList;
          setState(() {});
          return;
        }
      }
      setState(() {});
    } catch (e) {}
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
            children: [
              Text(
                boardingName,
                style: const TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const ViewMembers(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.green.shade300,
                      ),
                    ),
                    icon: const Icon(
                      Icons.people_alt_rounded,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'View members',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const ViewCode(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.qr_code_2_rounded,
                      color: Colors.white,
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.blue.shade400,
                      ),
                    ),
                    label: const Text(
                      'View QR Code',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),
              Text(
                'List of Chores',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    if (index < choreList.length) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 100,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.blue,
                              )),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => ChoreHistory(
                                    choreList[index]['chore id'],
                                  ),
                                ),
                              );
                            },
                            child: GridTile(
                              footer: Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                ),
                                child: Center(
                                  child: Text(
                                    choreList[index]['chore name'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              child: Image.network(
                                choreList[index]['chore image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else if (index == choreList.length) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const ChoreAdding(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 100,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.green.shade300,
                            ),
                            child: GridTile(
                              footer: Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                ),
                                child: const Center(
                                  child: Text(
                                    "Add Chore",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                  itemCount: choreList.length + 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
