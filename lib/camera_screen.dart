import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  final bool isScanning; // True for scan mode, false for normal camera capture

  const CameraScreen({Key? key, this.isScanning = true}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late List<CameraDescription> cameras;
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndInitialize();
  }

  Future<void> _checkPermissionsAndInitialize() async {
    if (await Permission.camera.request().isGranted) {
      await _initializeCamera();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission denied')),
      );
    }
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras.first, // Use the first available camera
          ResolutionPreset.medium,
        );

        await _cameraController?.initialize();
        setState(() {}); // Refresh the widget once the camera is initialized
      } else {
        throw Exception('No cameras found');
      }
    } catch (e) {
      print('Camera error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initialize the camera: $e')),
      );
    }
  }

  Widget _buildCameraView() {
    if (cameras.isEmpty) {
      return const Center(child: Text('No cameras available'));
    } else if (_cameraController?.value.isInitialized ?? false) {
      return CameraPreview(_cameraController!);
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isScanning ? 'Scanner' : 'Camera'),
        actions: widget.isScanning
            ? null
            : [
          IconButton(
            icon: const Icon(Icons.switch_camera),
            onPressed: () async {
              // Switch between available cameras if more than one exists
              if (cameras.length > 1) {
                final currentCamera = _cameraController?.description;
                final newCamera = cameras.firstWhere(
                      (camera) => camera != currentCamera,
                );
                await _cameraController?.dispose();
                _cameraController = CameraController(
                  newCamera,
                  ResolutionPreset.medium,
                );
                await _cameraController?.initialize();
                setState(() {});
              }
            },
          ),
        ],
      ),
      body: widget.isScanning
          ? MobileScanner(
        allowDuplicates: false,
        onDetect: (barcode, args) {
          if (barcode.rawValue != null) {
            final String scannedData = barcode.rawValue!;
            Navigator.pop(context, scannedData); // Return scanned data
          }
        },
        fit: BoxFit.contain,
      )
          : _buildCameraView(),
      floatingActionButton: !widget.isScanning
          ? FloatingActionButton(
        onPressed: () async {
          if (_cameraController != null && _cameraController!.value.isInitialized) {
            final XFile? photo = await _cameraController?.takePicture();
            if (photo != null) {
              Navigator.pop(context, photo.path); // Return photo path
            }
          }
        },
        child: const Icon(Icons.camera),
      )
          : null,
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
