import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../core/theme/app_colors.dart';

class FuseVideoPlayer extends StatefulWidget {
  final String? url;
  final File? file;

  const FuseVideoPlayer({super.key, this.url, this.file})
    : assert(
        url != null || file != null,
        'Must provide either a URL or a File',
      );

  @override
  State<FuseVideoPlayer> createState() => _FuseVideoPlayerState();
}

class _FuseVideoPlayerState extends State<FuseVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.url != null
        ? VideoPlayerController.networkUrl(Uri.parse(widget.url!))
        : VideoPlayerController.file(widget.file!);

    _controller.initialize().then((_) {
      _controller.setLooping(true);
      _controller.play();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _isMuted = !_isMuted;
          _controller.setVolume(_isMuted ? 0.0 : 1.0);
        });
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),
          if (_isMuted)
            const Positioned(
              bottom: 16,
              right: 16,
              child: Icon(Icons.volume_off, color: Colors.white70, size: 24),
            ),
        ],
      ),
    );
  }
}
