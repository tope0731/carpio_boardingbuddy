import 'package:carpio_boardingbuddy/screens/before_doing_camera.dart';
import 'package:carpio_boardingbuddy/screens/chore_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BeforeChore extends StatelessWidget {
  BeforeChore(this.choreId, {super.key});

  String choreId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => ChoreHistory(choreId),
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
              '--------------- BEFORE DOING THE CHORE ---------------',
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
                    builder: (_) => CameraBeforeChore(choreId),
                  ),
                );
              },
              child: Container(
                height: 400,
                width: 300,
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.black,
                )),
                child: const Icon(
                  Icons.add_a_photo_outlined,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            
          ],
        ),
      ),
    );
  }
}
