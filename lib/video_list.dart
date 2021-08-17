import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_viewer/main.dart';

/// Creates list of video players
class VideoList extends StatefulWidget {
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  List<String> _ids = [];
  List<YoutubePlayerController> _controllers;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      initializeSharedPref();
      _ids = await initializeSharedPref();
      if (_ids.isEmpty) {
        _ids.addAll([
          'bMfVgnjVGz4',
          'B9ddApp4j48',
          'PgbBiQ3ggzM',
          'WbCqGq96Vv8',
          '3YsnvDCj5gE',
          'nAOo6hcxyho',
        ]);
      }
      setState(() {
        _controllers = _ids
            .map<YoutubePlayerController>(
              (videoId) => YoutubePlayerController(
                initialVideoId: videoId,
                flags: const YoutubePlayerFlags(
                  autoPlay: false,
                ),
              ),
            )
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video List'),
      ),
      body: _controllers == null || _controllers.isEmpty
          ? Container(
              color: Colors.white,
              child: Center(
                heightFactor: 2.0,
                child: Text(
                  'Please Wait...',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            )
          : GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return YoutubePlayer(
                  key: ObjectKey(_controllers[index]),
                  controller: _controllers[index],
                  actionsPadding: const EdgeInsets.only(left: 16.0),
                  bottomActions: [
                    CurrentPosition(),
                    const SizedBox(width: 10.0),
                    ProgressBar(isExpanded: true),
                    const SizedBox(width: 10.0),
                    RemainingDuration(),
                    FullScreenButton(),
                  ],
                );
              },
              itemCount: _controllers?.length,
              // separatorBuilder: (context, _) => const SizedBox(height: 10.0),
            ),
    );
  }
}
