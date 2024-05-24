import 'dart:io';
import 'package:carpio_boardingbuddy/screens/after_doing_camera.dart';
import 'package:carpio_boardingbuddy/screens/before_chore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AfterChore extends StatefulWidget {
  AfterChore(this.beforeChoreImage, this.choreId, {super.key});

  File beforeChoreImage;
  String choreId;

  @override
  State<AfterChore> createState() => _AfterChoreState();
}

class _AfterChoreState extends State<AfterChore> {
  @override
  Widget build(BuildContext context) {
    File beforeChoreImage = File(widget.beforeChoreImage.path);
    String choreId = widget.choreId;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => BeforeChore(choreId),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              const Text(
                '---------------BEFORE DOING THE CHORE---------------',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 400,
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: Image.file(
                  beforeChoreImage,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                '---------------AFTER DOING THE CHORE---------------',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) =>
                          CameraAfterChore(beforeChoreImage, choreId),
                    ),
                  );
                },
                child: Container(
                  height: 400,
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: const Icon(
                    Icons.add_a_photo_outlined,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
