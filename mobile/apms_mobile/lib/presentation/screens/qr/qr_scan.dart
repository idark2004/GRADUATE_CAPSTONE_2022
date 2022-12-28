// ignore_for_file: import_of_legacy_library_into_null_safe
import 'dart:io';

import 'package:apms_mobile/bloc/repositories/qr_repo.dart';
import 'package:apms_mobile/main.dart';
import 'package:apms_mobile/models/qr_model.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../components/alert_dialog.dart';

class QRScan extends StatefulWidget {
  const QRScan({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRScan();
}

class _QRScan extends State<QRScan> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? code;
  Qr? qr;
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = MediaQuery.of(context).size.width;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    var navigate = Navigator.of(context);
    controller.scannedDataStream.listen((scanData) async {
      result = scanData;
      controller.pauseCamera();
      code = result!.code!.replaceAll("True", "true");
      qr = qrModelFromJson(code!.replaceAll("False", "false"));
      final QrRepo repo = QrRepo();
      if (!qr!.checkin!) {
        final action = await AlertDialogs.confirmCancelDiaglog(
            context,
            "Check In",
            "Is this the license plate you want to check-in : ${qr!.plate} ?");
        if (action == DialogsAction.confirm) {
          String res = await repo.checkIn(qr!);
          if (res.contains('successfully')) {
            navigate.pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const MyHome(
                    tabIndex: 1,
                    headerTabIndex: 1,
                  ),
                ),);
          } else {
            alert(controller, "Check-in Failed", res);
          }
        }
        if (action == DialogsAction.cancel) {
          controller.resumeCamera();
        }
      } else {
        final action = await AlertDialogs.confirmCancelDiaglog(
            context,
            "Check Out",
            "Is this the license plate you want to check-out : ${qr!.plate}");
        if (action == DialogsAction.confirm) {
          String res = await repo.checkOut(qr!);
          if (res.contains('successfully')) {
            navigate.pushReplacement(
              MaterialPageRoute(
                builder: (context) => const MyHome(
                  tabIndex: 1,
                  headerTabIndex: 2,
                ),
              ),
            );
          } else {
            alert(controller, "Check-out Failed", res);
          }
        }
        if (action == DialogsAction.cancel) {
          controller.resumeCamera();
        }
      }
    });
  }

// alert dialog
  Future<dynamic> alert(
      QRViewController controller, String title, String body) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(color: Colors.redAccent),
        ),
        content: Text(body),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              controller.resumeCamera();
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              child: const Text("Confirm", style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          ),
        ],
      ),
    );
  }
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    } else {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
