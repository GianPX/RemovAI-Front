import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(videoPlayerController: VideoPlayerController.networkUrl(Uri.parse('http://10.12.25.73:3000/download')));
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text('Video Sin fondo.'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                      height: 350,
                      width: 380,
                      child: FlickVideoPlayer(flickManager: flickManager))),
              const SizedBox(height: 30),
              FilledButton(
                  onPressed: () {
                    FileDownloader.downloadFile(
                        url: 'http://10.12.25.73:3000/download',
                        name: 'Prueba1', //(optional)
                        onProgress: (String? fileName, double progress) {
                          print('FILE fileName HAS PROGRESS $progress');
                        },
                        onDownloadCompleted: (String path) {
                          print('FILE DOWNLOADED TO PATH: $path');
                        },
                        onDownloadError: (String error) {
                          print('DOWNLOAD ERROR: $error');
                        });
                  },
                  child: const Text('Descargar'))
            ]),
          ),
        ));
  }
}
