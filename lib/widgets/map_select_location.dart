import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

const String googleApiKey = 'AIzaSyA1rfRh5d0HM8hZ34eL8vjgaT2zC4Vtr7o';

class LocationPickerFull extends StatefulWidget {
  @override
  _LocationPickerFullState createState() => _LocationPickerFullState();
}

class _LocationPickerFullState extends State<LocationPickerFull> {
  LatLng? _selectedLocation;
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  LatLng? _initialPosition;

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _searchLocation() async {
    String query = _searchController.text.trim();
    if (query.isEmpty) return;

    final url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=${Uri.encodeComponent(query)}&key=$googleApiKey&language=ar';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _searchResults = data['results'];
      });
    }
  }

  void _selectSearchResult(dynamic result) {
    final location = result['geometry']['location'];
    LatLng latLng = LatLng(location['lat'], location['lng']);
    setState(() {
      _selectedLocation = latLng;
      _searchResults.clear();
      _searchController.text = result['name'];
    });
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedLocation = position;
      _searchResults.clear();
    });
  }

  void _confirmLocation() async {
    LatLng? locationToUse = _selectedLocation ?? _initialPosition;

    if (locationToUse != null) {
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${locationToUse.latitude},${locationToUse.longitude}&key=$googleApiKey&language=ar';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String address = data['results'][0]['formatted_address'];

        Navigator.pop(context, {
          "address": address,
          "lat": locationToUse.latitude,
          "lng": locationToUse.longitude,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تحديد الموقع',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: Colors.indigo,
          ),
        ),
      ),
      body: _initialPosition == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition:
            CameraPosition(target: _initialPosition!, zoom: 14),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onTap: _onMapTap,
            markers: _selectedLocation != null
                ? {
              Marker(
                markerId: MarkerId('selected'),
                position: _selectedLocation!,
              )
            }
                : {},
          ),
          // Search Bar
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'ابحث عن مكان...',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _searchLocation,
                  child: Text('بحث'),
                )
              ],
            ),
          ),
          // Search Results
          if (_searchResults.isNotEmpty)
            Positioned(
              top: 80,
              left: 16,
              right: 16,
              bottom: 100, // خلي المساحة للأسفل للزر
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final result = _searchResults[index];
                    return ListTile(
                      leading:
                      Icon(Icons.location_on, color: Colors.blue),
                      title: Text(result['name']),
                      subtitle: Text(result['formatted_address'] ?? ''),
                      onTap: () => _selectSearchResult(result),
                    );
                  },
                ),
              ),
            ),
          // Confirm Button
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: _confirmLocation,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.blue.shade700,
              ),
              child: Text(
                'تأكيد الموقع',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
