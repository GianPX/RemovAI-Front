import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () async {
                  final video = File(await pickVideo(context));
                    if (await video.exists()) {
                      uploadVideo(video);
                    } else {
                      print('Video not found');
                    }
                }, 
                child: const Text('Subir archivo', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
              ),
              const SizedBox(height: 20),
              FilledButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/video');
                  },
                  child: const Text('Enviar',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18))),
            ],
          ),
        ),
      );
  }
}


 Future<void> uploadVideo(File videoFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.1.104:3000/upload'),
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

