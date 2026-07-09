// Automatic FlutterFlow imports
import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({
    super.key,
    this.width,
    this.height,
    required this.showTorchButton,
    required this.showCameraSwitchButton,
    required this.autoZoom,
    this.getOutput,
    required this.showGalleryButton,
  });

  final double? width;
  final double? height;
  final bool showTorchButton;
  final bool showCameraSwitchButton;
  final bool autoZoom;
  final Future Function(String? output)? getOutput;
  final bool showGalleryButton;

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  late final MobileScannerController _controller;
  late final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      autoZoom: widget.autoZoom,
      formats: [BarcodeFormat.all],
      returnImage: true,
      // initialZoom: 100
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildOverlay() {
    return IgnorePointer(
      child: Center(
        child: Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Future<void> _scanFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (image == null) return;

      final BarcodeCapture? capture =
          await _controller.analyzeImage(image.path);

      if (capture == null || capture.barcodes.isEmpty) {
        if (mounted) {
          //if QR not found first exit from screen then show msg
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No QR code found'),
            ),
          );
        }

        return;
      }

      final Barcode barcode = capture.barcodes.first;

      final value = barcode.rawValue;

      if (value == null || value.isEmpty) return;

      await HapticFeedback.mediumImpact();
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
          content: Column(
            mainAxisSize: MainAxisSize.min, // This keeps the height compact
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.lightGreen.shade200,
                    borderRadius: BorderRadius.circular(6)),
                padding: const EdgeInsets.all(8),
                child: Text(
                  value,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 16), // Adds spacing between elements
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centers the button horizontally
                children: [
                  OutlinedButton.icon(
                    onPressed: () async {
                    Uri url=  Uri.parse(value);
                  await launchUrl(url);
                    },
                    label: const Text("Open URL",style: TextStyle(color: Colors.lightGreen),overflow: TextOverflow.ellipsis,),
                    icon: const Icon(Icons.save,color: Colors.green,),

                  )
                ],
              )
            ],
          ),
        ),
      );

      widget.getOutput?.call(value);

      Navigator.pop(context);
    } catch (e) {
      debugPrint('Gallery scan error: $e');
    }
  }

  Widget _buildControls() {
    return Positioned(
      bottom: 30,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.showGalleryButton)
            IconButton(
              iconSize: 32,
              color: Colors.white,
              onPressed: _scanFromGallery,
              icon: const Icon(Icons.image),
            ),
          if (widget.showTorchButton)
            ValueListenableBuilder<MobileScannerState>(
              valueListenable: _controller,
              builder: (context, state, child) {
                return IconButton(
                  iconSize: 32,
                  color: Colors.white,
                  onPressed: _controller.toggleTorch,
                  icon: Icon(
                    state.torchState == TorchState.on
                        ? Icons.flash_on
                        : Icons.flash_off,
                  ),
                );
              },
            ),
          if (widget.showCameraSwitchButton)
            IconButton(
              iconSize: 32,
              color: Colors.white,
              onPressed: _controller.switchCamera,
              icon: const Icon(Icons.cameraswitch),
            ),
        ],
      ),
    );
  }

  Future<void> _handleDetection(BarcodeCapture capture) async {
    if (_isProcessing) return;
    final barcode = capture.barcodes.firstOrNull;

    if (barcode == null) return;

    final value = barcode.rawValue;

    if (value == null || value.isEmpty) return;

    await widget.getOutput?.call(value);

    Navigator.pop(context);
    _isProcessing = true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(children: [
      MobileScanner(
        controller: _controller,
        onDetect: _handleDetection,
      ),
      _buildOverlay(),
      _buildControls()
    ]));
  }
}
