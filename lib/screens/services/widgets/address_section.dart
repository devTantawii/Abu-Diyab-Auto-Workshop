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
              locale!.isDirectionRTL(context) ? "العنوان" : "Address",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: headingColor(context),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _selectNewAddress,
              child: Text(
                locale!.isDirectionRTL(context)
                    ? "+ إضافة عنوان جديد"
                    : "+ Add new address",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: typographyMainColor(context),
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
        border: Border.all(
          color: buttonSecondaryBorderColor(context),
          width: 1.5.w,
        ),
        color: buttonBgWhiteColor(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              _address ?? "",
              style: TextStyle(fontSize: 14.sp, color: headingColor(context)),
            ),
          ),
          SizedBox(height: 6.h),
          Center(
            child: GestureDetector(
              onTap: _getCurrentLocation,
              child:
                  _loading
                      ? CircularProgressIndicator(
                        color: typographyMainColor(context),
                      )
                      : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: typographyMainColor(context),
                            size: 16.sp,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            locale!.isDirectionRTL(context)
                                ? "العنوان الحالي"
                                : "Current address",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: typographyMainColor(context),
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
      print('Raw address from map: $rawAddress');

      setState(() => _address = rawAddress);
      widget.onAddressSelected(rawAddress, result['lat'], result['lng']);
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _loading = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await _showEnableLocationDialog();
        setState(() => _loading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showError(
            locale!.isDirectionRTL(context)
                ? "يجب منح صلاحية الوصول للموقع."
                : "Location permission is required.",
          );
          setState(() => _loading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showGoToSettingsDialog();
        setState(() => _loading = false);
        return;
      }

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> places = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

      final place = places.first;
      String fullAddress =
          "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

      setState(() => _address = fullAddress);
      widget.onAddressSelected(fullAddress, pos.latitude, pos.longitude);
    } catch (e) {
      _showError(
        locale!.isDirectionRTL(context)
            ? "تعذر الحصول على الموقع. حاول مرة أخرى."
            : "Unable to get your location. Please try again.",
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _showEnableLocationDialog() async {
    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              locale!.isDirectionRTL(context)
                  ? "تشغيل الموقع"
                  : "Location Disabled",
            ),
            content: Text(
              locale!.isDirectionRTL(context)
                  ? "الرجاء تفعيل خدمة تحديد الموقع (GPS) للاستمرار."
                  : "Please enable location services (GPS) to continue.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  locale!.isDirectionRTL(context) ? "إلغاء" : "Cancel",
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await Geolocator.openLocationSettings();
                },
                child: Text(
                  locale!.isDirectionRTL(context)
                      ? "فتح الإعدادات"
                      : "Open Settings",
                ),
              ),
            ],
          ),
    );
  }

  void _showGoToSettingsDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              locale!.isDirectionRTL(context)
                  ? "صلاحية الموقع مطلوبة"
                  : "Location Permission Required",
            ),
            content: Text(
              locale!.isDirectionRTL(context)
                  ? "لقد قمت برفض صلاحية الوصول للموقع بشكل دائم. للمتابعة، يرجى تمكين الصلاحية من إعدادات التطبيق."
                  : "You have permanently denied location permission. Please enable it from app settings to continue.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  locale!.isDirectionRTL(context) ? "إلغاء" : "Cancel",
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Geolocator.openAppSettings();
                },
                child: Text(
                  locale!.isDirectionRTL(context)
                      ? "فتح الإعدادات"
                      : "Open Settings",
                ),
              ),
            ],
          ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
