// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/widgets/q_r_scanner.dart';

//
Future qrScannerSheet(
  BuildContext context,
  bool autoZoom,
  bool showCameraSwitchBtn,
  bool showGalleryBtn,
  bool showTorchBtn,
  Future Function(String? outputString)? getOutput,
) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    builder: (context) {
      return QRScanner(
        getOutput: (output) async => getOutput?.call(output),
        autoZoom: autoZoom,
        showCameraSwitchButton: showCameraSwitchBtn,
        showGalleryButton: showGalleryBtn,
        showTorchButton: showTorchBtn,
      );
    },
  );
}
