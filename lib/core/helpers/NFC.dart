// import 'package:flutter/material.dart';
// import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
//
// class NFCPage extends StatefulWidget {
//   @override
//   _NFCPageState createState() => _NFCPageState();
// }
//
// class _NFCPageState extends State<NFCPage> {
//   String _nfcData = 'No Data Yet';
//
//   Future<void> _readNFC() async {
//     try {
//       NFCTag tag = await FlutterNfcKit.poll(timeout: Duration(seconds: 10));
//       setState(() {
//         _nfcData = 'NFC Tag UID: ${tag.id}';
//       });
//       await FlutterNfcKit.finish();
//     } catch (e) {
//       setState(() {
//         _nfcData = 'Error: $e';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('NFC Reader')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(_nfcData),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _readNFC,
//               child: Text('Start NFC Scan'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
