import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerPage extends StatefulWidget {
  @override
  _MapPickerPageState createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  LatLng? selectedLocation;
  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  Future<void> checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Permission denied');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("اختر موقعك")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(30.0444, 31.2357), // default Cairo
              zoom: 14,
            ),
            onTap: (LatLng location) {
              setState(() {
                selectedLocation = location;
              });
            },
            markers: selectedLocation != null
                ? {
              Marker(
                markerId: MarkerId('selected'),
                position: selectedLocation!,
              ),
            }
                : {},
          ),
          if (selectedLocation != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  // ترجع اللات/لونغ للمكان المختار
                  Navigator.pop(context, selectedLocation);
                },
                child: Text("تأكيد الموقع"),
              ),
            )
        ],
      ),
    );
  }
}
