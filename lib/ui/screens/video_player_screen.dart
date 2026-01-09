import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pod_player/pod_player.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String vimeoId;

  const VideoPlayerScreen({
    super.key,
    required this.vimeoId,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  PodPlayerController? controller;

  @override
  void initState() {
    super.initState();
    // 가로 모드 강제 설정
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    if (!kIsWeb) {
      controller = PodPlayerController(
        playVideoFrom: PlayVideoFrom.vimeo(widget.vimeoId),
        podPlayerConfig: const PodPlayerConfig(
          autoPlay: true,
          isLooping: false,
          videoQualityPriority: [720, 360],
        ),
      )..initialise().then((_) {
          // 모바일: 초기화 후 음소거 해제 보장
          controller?.unMute();
        });
    }
  }

  @override
  void dispose() {
    // 세로 모드(원래 상태)로 복구
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: kIsWeb
                  ? HtmlWidget(
                      '''
                      <iframe 
                        src="https://player.vimeo.com/video/${widget.vimeoId}?autoplay=1&muted=0&badge=0&autopause=0&player_id=0&app_id=58479" 
                        style="width:100%;height:100%;border:none;" 
                        allow="autoplay; fullscreen; picture-in-picture" 
                        allowfullscreen>
                      </iframe>
                      ''',
                      factoryBuilder: () => _VideoWidgetFactory(),
                    )
                  : PodVideoPlayer(controller: controller!),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoWidgetFactory extends WidgetFactory {
  @override
  bool get webView => true; // Enable WebView support
}
