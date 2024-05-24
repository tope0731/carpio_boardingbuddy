import 'package:carpio_boardingbuddy/screens/home_boarding_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class ViewMembers extends StatefulWidget {
  const ViewMembers({Key? key}) : super(key: key);

  @override
  State<ViewMembers> createState() => _ViewMembersState();
}

class _ViewMembersState extends State<ViewMembers> {
  List<Map<String, dynamic>> memberList = [];
  String boarding = '';

  @override
  void initState() {
    super.initState();
    getBoardingMembers();
  }

  void getBoardingMembers() async {
    List<Map<String, dynamic>> filterList = [];
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      String _uid = user!.uid;
      var userData =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      boarding = userData['boarding id'];

      final memberDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('boarding id', isEqualTo: boarding)
          .get();

      var memberDocData = memberDoc.docs;

      if (memberDocData.isNotEmpty) {
        memberDocData.forEach((element) {
          filterList.add(element.data());
        });
        setState(() {
          memberList = filterList;
        });
      }
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
                builder: (_) => const BoardingHouse(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Boarding Members'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          // You can customize the avatar with member images
                          child: Text('${index + 1}'),
                        ),
                        title: Text(
                          memberList[index]['first name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          memberList[index]['email'],
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: memberList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
