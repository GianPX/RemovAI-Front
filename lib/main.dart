import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FilledButton(
              onPressed: () async {
                final video = File(await pickVideo(context));
                if (await video.exists()) {
                  uploadVideo(video);
                } else {
                  //TODO: manage error, but there shouldn't be any
                  print('Video not found');
                }
              },
              child: const Text('Send!')),
        ),
      ),
    );
  }

  Future<void> uploadVideo(File videoFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.1.105:3000/upload'),
    );
    request.files
        .add(await http.MultipartFile.fromPath('video', videoFile.path));
    var response = await request.send();
    if (response.statusCode == 201) {
      print('Video uploaded successfully');
    } else {
      //TODO: manage error. At this point, it would be probably a communication error
      print('Failed to upload video');
    }
  }

  Future<String> pickVideo(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        String? filePath = file.path;

        if (filePath != null) {
          return filePath;
        } else {
          //TODO: manage error in all these else's
          return '';
        }
      } else {
        return '';
      }
    } catch (e) {
      print('Error picking video: $e');
      return '';
    }
  }
}
