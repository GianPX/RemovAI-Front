import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:removai/video_downloader.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    String? url;
    return Scaffold(
      //appBar: AppBar(title: const Text('Remove Background AI')),
       appBar: AppBar(
        foregroundColor: Color(0xFF6750A4),
        titleTextStyle: TextStyle(color: Color(0xFF6750A4), fontSize: 65, fontWeight: FontWeight.bold, fontFamily:"Super"),
        centerTitle: true,
        title: Text('REMOVE BACKGROUND AI'),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              width: 450,
              child: ElevatedButton(
                  onPressed: () async {
                  final video = File(await pickVideo(context));
                  if (await video.exists()) {
                    url = await uploadVideo(video);
                    if (url != null) {
                      print('Uploaded video URL: $url');
                      // Use the uploadedUrl variable here (e.g., navigate to a new screen)
                    } else {
                      print('Error occurred while uploading or retrieving URL');
                    }
                  } else {
                    print('Video not found');
                  }
                  },
                  child: const Text(
                    'Subir archivo',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  )),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              width: 450,
              child: FilledButton(
                  onPressed: () {
                    url='https://res.cloudinary.com/dddgugfmn/video/upload/v1717472672/bg-removed-video-1717472596409-943119783.webm';
                    print('URL');
                    print(url);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PlayVideoFromVimeo(url: url)));
                  },
                  child: const Text('Enviar',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30))),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String?> uploadVideo(File videoFile) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('http://192.168.1.104:3000/upload'),
  );
  request.files.add(await http.MultipartFile.fromPath('video', videoFile.path));
  var response = await request.send();
  if (response.statusCode == 201) {
    final responseData = await response.stream.transform(utf8.decoder).join();
    final responseMap = jsonDecode(responseData) as Map<String, dynamic>;

    // Check if the response has a URL key
    if (responseMap.containsKey('url')) {
      final url = responseMap['url'];
      print('Uploaded video URL: $url');
      print(url);
      return url;
    } else {
      print('Warning: Response did not contain a "url" key.');
    }
  } else {
    //TODO: manage error. At this point, it would be probably a communication error
    print('Failed to upload video');
  }
  return null;
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
