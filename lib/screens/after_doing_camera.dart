import 'dart:io';

import 'package:camera/camera.dart';
import 'package:carpio_boardingbuddy/main.dart';
import 'package:carpio_boardingbuddy/screens/after_chore.dart';
import 'package:carpio_boardingbuddy/screens/summary_chore.dart';
import 'package:flutter/material.dart';

class CameraAfterChore extends StatefulWidget {
  CameraAfterChore(this.beforeChoreImage, this.choreId, {super.key});

  File beforeChoreImage;
  String choreId;

  @override
  State<CameraAfterChore> createState() => _CameraAfterChoreState();
}

class _CameraAfterChoreState extends State<CameraAfterChore> {
  late CameraController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('Access denied');
            break;
          default:
            print(e.description);
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    File beforeChoreImage = File(widget.beforeChoreImage.path);
    String choreId = widget.choreId;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('After Doing the Chore'),
          centerTitle: true,
          backgroundColor: Colors.green,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => AfterChore(beforeChoreImage, choreId),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              child: CameraPreview(_controller),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!_controller.value.isInitialized) {
                          return null;
                        }
                        if (_controller.value.isTakingPicture) {
                          return null;
                        }

                        try {
                          await _controller.setFlashMode(FlashMode.auto);
                          XFile file = await _controller.takePicture();
                          File afterChoreImage = File(file.path);
                          print(afterChoreImage);

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => SummaryChore(
                                  beforeChoreImage, afterChoreImage, choreId),
                            ),
                          );
                        } on CameraException catch (e) {
                          debugPrint("Error occured while taking picture : $e");
                          return null;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        "Take Picture",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
