import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/premium_button.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _cameraIndex = 0;
  bool _permissionDenied = false;
  bool _isRecording = false;
  FlashMode _flashMode = FlashMode.off;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameraStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    if (!cameraStatus.isGranted) {
      if (mounted) setState(() => _permissionDenied = true);
      return;
    }

    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;
      await _setCamera(_cameraIndex, micStatus.isGranted);
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<void> _setCamera(int index, bool enableAudio) async {
    _controller = CameraController(
      _cameras[index],
      ResolutionPreset.high,
      enableAudio: enableAudio,
    );
    await _controller!.initialize();
    await _controller!.setFlashMode(_flashMode);
    if (mounted) setState(() {});
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;
    await _setCamera(_cameraIndex, true); // Assuming mic was granted
  }

  Future<void> _toggleFlash() async {
    final modes = [FlashMode.off, FlashMode.auto, FlashMode.always];
    _flashMode = modes[(modes.indexOf(_flashMode) + 1) % modes.length];
    await _controller?.setFlashMode(_flashMode);
    setState(() {});
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    // Allow users to pick either a video or an image
    final XFile? file = await picker.pickMedia();
    if (file == null || !mounted) return;

    final isVideo = file.path.endsWith('.mp4') || file.path.endsWith('.mov');
    if (isVideo) {
      context.push('/preview', extra: {'path': file.path, 'type': 'video'});
    } else {
      await _processImageAndRoute(file.path);
    }
  }

  Future<void> _processImageAndRoute(String path) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatio: const CropAspectRatio(
        ratioX: 1,
        ratioY: 1,
      ), // Square crop by default
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: AppColors.background,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Crop Image'),
      ],
    );

    if (croppedFile != null && mounted) {
      context.push(
        '/preview',
        extra: {'path': croppedFile.path, 'type': 'image'},
      );
    }
  }

  Future<void> _takePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    final file = await _controller!.takePicture();
    if (!mounted) return;
    await _processImageAndRoute(file.path);
  }

  Future<void> _startRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    await _controller!.startVideoRecording();
    setState(() => _isRecording = true);
  }

  Future<void> _stopRecording() async {
    if (_controller == null || !_controller!.value.isRecordingVideo) return;
    final file = await _controller!.stopVideoRecording();
    setState(() => _isRecording = false);
    if (!mounted) return;
    context.push('/preview', extra: {'path': file.path, 'type': 'video'});
  }

  IconData get _flashIcon {
    if (_flashMode == FlashMode.auto) return Icons.flash_auto;
    if (_flashMode == FlashMode.always) return Icons.flash_on;
    return Icons.flash_off;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionDenied) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.no_photography,
                color: AppColors.danger,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Camera permission required',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 24),
              PremiumButton(
                text: 'Open Settings',
                onPressed: () => openAppSettings(),
              ),
            ],
          ),
        ),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller!),

          // Top Controls (Flash)
          Positioned(
            top: 50,
            right: 20,
            child: IconButton(
              icon: Icon(_flashIcon, color: Colors.white, size: 30),
              onPressed: _toggleFlash,
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Gallery Picker
                IconButton(
                  icon: const Icon(
                    Icons.photo_library,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: _pickFromGallery,
                ),

                // Shutter Button (Hold for Video)
                GestureDetector(
                  onTap: _takePhoto,
                  onLongPressStart: (_) => _startRecording(),
                  onLongPressEnd: (_) => _stopRecording(),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: _isRecording ? 100 : 80,
                    width: _isRecording ? 100 : 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isRecording ? AppColors.danger : Colors.white,
                        width: 4,
                      ),
                      color: _isRecording
                          ? AppColors.danger.withValues(alpha: 0.5)
                          : Colors.white24,
                    ),
                  ),
                ),

                // Flip Camera
                IconButton(
                  icon: const Icon(
                    Icons.flip_camera_ios,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: _switchCamera,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
