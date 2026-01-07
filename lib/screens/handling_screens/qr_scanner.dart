import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  MobileScannerController scanController = MobileScannerController();

  @override
  void dispose() {
    scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: scanController,
      onDetect: (scannedData) {
        if (kDebugMode) {
          print("DATA IS : ${scannedData.barcodes.first.rawValue.toString()}");
        }
        if (scannedData.barcodes.first.rawValue != null) {
          scanController.pause();
          Navigator.pop(context, scannedData.barcodes.first.rawValue);
        }
      },
    );
  }
}