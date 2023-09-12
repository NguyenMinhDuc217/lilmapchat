import 'package:flutter/material.dart';
import 'package:mynews/model/video.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({Key? key}) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  int _currentIndex = 0;

  void _playVideo({int index = 0, bool init = false}) {
    if (index < 0 || index >= videos.length) return;

    if (!init) {
      _controller.pause();
    }

    setState(() => _currentIndex = index);

    _controller =
        VideoPlayerController.networkUrl(Uri.parse(videos[_currentIndex].url))
          ..addListener(() => setState(() {}))
          ..setLooping(true)
          ..initialize().then((value) => _controller.play());
  }

  String _videoDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  void initState() {
    super.initState();
    _playVideo(init: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video player'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.deepPurpleAccent,
            height: 300,
            child: _controller.value.isInitialized
                ? Column(
                    children: <Widget>[
                      SizedBox(
                        height: 200,
                        child: VideoPlayer(_controller),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ValueListenableBuilder(
                              valueListenable: _controller,
                              builder:
                                  (context, VideoPlayerValue value, child) {
                                return Text(
                                  _videoDuration(value.position),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                );
                              }),
                          Expanded(
                              child: VideoProgressIndicator(
                            _controller,
                            allowScrubbing: true,
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 12),
                          )),
                          Text(
                            _videoDuration(_controller.value.duration),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                      IconButton(
                        onPressed: () => _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play(),
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                      )
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => _playVideo(index: index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.network(
                            videos[index].thumbnail,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          videos[index].name,
                          style: const TextStyle(fontSize: 25),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
