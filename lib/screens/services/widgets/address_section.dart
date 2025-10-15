import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../widgets/map_select_location.dart';

class AddressSection extends StatefulWidget {
  final Function(String, double, double) onAddressSelected;
  const AddressSection({super.key, required this.onAddressSelected});

  @override
  State<AddressSection> createState() => _AddressSectionState();
}

class _AddressSectionState extends State<AddressSection> {
  String? _address;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "العنوان",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _selectNewAddress,
              child: Text(
                "+ إضافة عنوان جديد",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFBA1B1B),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        _addressCard(context),
      ],
    );
  }

  Widget _addressCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 1.5.w),
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : const Color(0xff1D1D1D),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              _address ?? "",
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Center(
            child: GestureDetector(
              onTap: _getCurrentLocation,
              child: _loading
                  ? const CircularProgressIndicator(color: Color(0xFFBA1B1B))
                  : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, color: Color(0xFFBA1B1B)),
                  SizedBox(width: 6.w),
                  Text(
                    "العنوان الحالي",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFBA1B1B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectNewAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) =>  LocationPickerFull()),
    );
    if (result != null && result is Map<String, dynamic>) {
      setState(() => _address = result['address']);
      widget.onAddressSelected(result['address'], result['lat'], result['lng']);
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _loading = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      Position pos =
      await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> places =
      await placemarkFromCoordinates(pos.latitude, pos.longitude);
      String address =
          "${places.first.street}, ${places.first.locality}, ${places.first.country}";
      setState(() => _address = address);
      widget.onAddressSelected(address, pos.latitude, pos.longitude);
    } finally {
      setState(() => _loading = false);
    }
  }
}
