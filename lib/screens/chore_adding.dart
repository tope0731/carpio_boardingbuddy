import 'dart:io';

import 'package:carpio_boardingbuddy/screens/home_boarding_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';

class ChoreAdding extends StatefulWidget {
  const ChoreAdding({super.key});

  @override
  State<ChoreAdding> createState() => _ChoreAddingState();
}

class _ChoreAddingState extends State<ChoreAdding> {
  String boardingId = '';
  var choreName = TextEditingController();
  var choreDesc = TextEditingController();
  File? image;
  bool fromImagePicker = false;
  int? selectedIndex;
  String fromChoices = 'walang laman';

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    String _uid = user!.uid;
    var userData =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    boardingId = userData['boarding id'];
    setState(() {});
  }

  Future<void> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
        fromImagePicker = true;
        fromChoices = 'may laman galing gallery';
      });
    } catch (e) {
      print(e);
    }
  }

  void addChore(String chore, String choreDesc, var imagePath) async {
    if (imagePath == null) {
      return;
    }

    QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        title: 'Registering chore...');
    try {
      if (fromImagePicker == true) {
        String choreImage = chore;
        final beforeImg = FirebaseStorage.instance
            .ref()
            .child('ChoreImages')
            .child('$choreImage.jpg');
        await beforeImg.putFile(imagePath);

        String choreImgURL = await beforeImg.getDownloadURL();
        var choreCollection = FirebaseFirestore.instance
            .collection('boardings')
            .doc(boardingId)
            .collection('chores');

        var newDocRef = await choreCollection.add({
          'boarding id': boardingId,
          'chore name': chore,
          'chore description': choreDesc,
          'chore image': choreImgURL,
        });
        String autoGeneratedId = newDocRef.id;
        Navigator.of(context).pop();

        await newDocRef.update({'chore id': autoGeneratedId}).then((value) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const BoardingHouse(),
            ),
          );
        });
      } else {
        var choreCollection = FirebaseFirestore.instance
            .collection('boardings')
            .doc(boardingId)
            .collection('chores');

        var newDocRef = await choreCollection.add({
          'boarding id': boardingId,
          'chore name': chore,
          'chore description': choreDesc,
          'chore image': imagePath,
        });
        String autoGeneratedId = newDocRef.id;
        Navigator.of(context).pop();

        await newDocRef.update({'chore id': autoGeneratedId}).then((value) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const BoardingHouse(),
            ),
          );
        });
      }
    } catch (e) {
      Navigator.of(context).pop();
      QuickAlert.show(
          context: context, type: QuickAlertType.error, title: '$e');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    File? imagePath = image;

    List<String> choreChoices = [
      'https://firebasestorage.googleapis.com/v0/b/boardingbuddy-db2d7.appspot.com/o/ChoreImages%2F4.png?alt=media&token=04235822-9fc0-4b19-a36a-f839ad0e6110',
      'https://firebasestorage.googleapis.com/v0/b/boardingbuddy-db2d7.appspot.com/o/ChoreImages%2F5.png?alt=media&token=a28c5a64-10b8-4cac-90ed-b6184c61dc56',
      'https://firebasestorage.googleapis.com/v0/b/boardingbuddy-db2d7.appspot.com/o/ChoreImages%2F6.png?alt=media&token=892d50db-f740-4789-97f3-9c1a1df43410',
      'https://firebasestorage.googleapis.com/v0/b/boardingbuddy-db2d7.appspot.com/o/ChoreImages%2F7.png?alt=media&token=3f8b95db-ba6d-474e-b44d-79f6c5085ebb',
      'https://firebasestorage.googleapis.com/v0/b/boardingbuddy-db2d7.appspot.com/o/ChoreImages%2F3.png?alt=media&token=629cc8b1-19ed-404b-80d6-fd25dd71c37c',
      'https://firebasestorage.googleapis.com/v0/b/boardingbuddy-db2d7.appspot.com/o/ChoreImages%2F2.png?alt=media&token=aabda3c4-e436-4338-906d-138f3761a3dc',
    ];

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
        title: const Text('Chore Adding'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: choreName,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(13),
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
                    label: Text('Chore name'),
                    hintText: 'eg. hugas pinggan, walis sala, tapon basura'),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: choreDesc,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(13),
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
                  label: Text('Chore Description'),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Text(
                'Pick chore image:',
                style: TextStyle(
                  color: Colors.green.shade900,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: double.infinity,
                height: 250,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                          fromChoices = choreChoices[index];
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selectedIndex == index
                                  ? Colors
                                      .blue 
                                  : Colors
                                      .transparent, 
                              width: 2.0,
                            ),
                          ),
                          child: GridTile(
                            child: Image.network(
                              choreChoices[index],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: choreChoices.length,
                ),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.image,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      pickImage();
                    },
                    label: const Text(
                      'Pick chore image in gallery',
                      style: TextStyle(
                        color: Colors.white, 
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .green.shade300, 
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  image != null
                      ? Center(
                          child: Container(
                            child: Image.file(
                              imagePath!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    if (choreName.text == '' ||
                        choreDesc.text == '' ||
                        fromChoices == 'walang laman') {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: 'INPUT DATA',
                          text: 'Please input the required data');
                    } else {
                      addChore(choreName.text, choreDesc.text,
                          fromImagePicker ? imagePath : fromChoices);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue,
                    ),
                  ),
                  child: const Text(
                    'ADD CHORE',
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
