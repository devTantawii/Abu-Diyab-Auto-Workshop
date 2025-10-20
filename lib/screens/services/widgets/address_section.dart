import 'package:abu_diyab_workshop/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../widgets/map_select_location.dart';
import '../../../core/language/locale.dart';

class AddressSection extends StatefulWidget {
  final Function(String, double, double) onAddressSelected;
  const AddressSection({super.key, required this.onAddressSelected});

  @override
  State<AddressSection> createState() => _AddressSectionState();
}

class _AddressSectionState extends State<AddressSection> {
  String? _address;
  bool _loading = false;
  late final locale = AppLocalizations.of(context);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              locale!.isDirectionRTL(context) ? " العنوان " : "Address ",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: textColor(context),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _selectNewAddress,
              child: Text(
                locale!.isDirectionRTL(context)
                    ? " + إضافة عنوان جديد "
                    : "+ Add new address  ",
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
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: borderColor(context), width: 1.5.w),
        color: boxcolor(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              _address ?? "",
              style: TextStyle(fontSize: 14.sp, color: textColor(context)),
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
                   Icon(Icons.location_on, color: Color(0xFFBA1B1B),size: 16.sp,),
                  SizedBox(width: 6.w),
                  Text(
                    locale!.isDirectionRTL(context)
                        ? "العنوان الحالي  "
                        : "Current address",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: accentColor,
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
      MaterialPageRoute(builder: (_) => LocationPickerFull()),
    );

    if (result != null && result is Map<String, dynamic>) {
      String rawAddress = result['address'] ?? '';
      print('📍 Raw address from map: $rawAddress');


      setState(() => _address = rawAddress);
      widget.onAddressSelected(rawAddress, result['lat'], result['lng']);

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

      Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> places =
      await placemarkFromCoordinates(pos.latitude, pos.longitude);

      final place = places.last;

      // print('==================== 🧭 Placemark Data ====================');
      // print('name: ${place.name}');
      // print('street: ${place.street}');
      // print('subThoroughfare: ${place.subThoroughfare}');
      // print('thoroughfare: ${place.thoroughfare}');
      // print('subLocality: ${place.subLocality}');
      // print('locality: ${place.locality}');
      // print('subAdministrativeArea: ${place.subAdministrativeArea}');
      // print('administrativeArea: ${place.administrativeArea}');
      // print('postalCode: ${place.postalCode}');
      // print('country: ${place.country}');
      // print('isoCountryCode: ${place.isoCountryCode}');
      // print('===========================================================');

      bool isArabic = locale!.isDirectionRTL(context);

      String cleanText(String? text) {
        if (text == null || text.isEmpty) return '';

        text = text.replaceAll(RegExp(r'\d{3,}'), '');
        text = text.replaceAll(RegExp(r'[+]+'), '').trim();
        if (isArabic) {
          text = text.replaceAll(RegExp(r'[A-Za-z]'), '');
        } else {
          text = text.replaceAll(RegExp(r'[\u0600-\u06FF]'), '');
        }
        text = text.replaceAll(RegExp(r'\s{2,}'), ' ').trim();
        return text;
      }

      List<String> parts = [
        cleanText(places.last.name),
        cleanText(place.subLocality),
        cleanText(place.subAdministrativeArea),
        cleanText(place.administrativeArea),
        cleanText(place.country),
      ];

      List<String> uniqueParts = [];
      for (var part in parts) {
        if (part.isNotEmpty && !uniqueParts.contains(part)) {
          uniqueParts.add(part);
        }
      }

      String fullAddress = '${place.name}, ${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      print('📍 Full address: $fullAddress');

      setState(() => _address = fullAddress);
      widget.onAddressSelected(fullAddress, pos.latitude, pos.longitude);

    } finally {
      setState(() => _loading = false);
    }
  }
}
