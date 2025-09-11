import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({super.key});

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  String _location = "جارٍ تحديد الموقع...";
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUserLocation();
    });
  }

  Future<void> _getUserLocation() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _location = "جارٍ تحديد الموقع...";
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        bool openSettings = await _showConfirmDialog(
          title: "تشغيل الموقع",
          message: "خدمة الموقع مغلقة. هل تريد فتح الإعدادات لتشغيلها؟",
        );
        if (openSettings && mounted) {
          await Geolocator.openLocationSettings();
          await Future.delayed(const Duration(milliseconds: 600));
          serviceEnabled = await Geolocator.isLocationServiceEnabled();
        } else {
          if (!mounted) return;
          setState(() {
            _location = "خدمة الموقع مغلقة - اضغط لإعادة المحاولة";
            _loading = false;
          });
          return;
        }
        if (!serviceEnabled) {
          if (!mounted) return;
          setState(() {
            _location = "خدمة الموقع مغلقة - اضغط لإعادة المحاولة";
            _loading = false;
          });
          return;
        }
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (!mounted) return;
          setState(() {
            _location = "تم رفض إذن الموقع - اضغط لإعادة المحاولة";
            _loading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        bool openAppSettings = await _showConfirmDialog(
          title: "إذن الموقع مرفوض",
          message: "يجب تفعيل إذن الموقع من إعدادات التطبيق. هل تريد فتح الإعدادات الآن؟",
        );
        if (openAppSettings && mounted) {
          await Geolocator.openAppSettings();
        } else {
          if (!mounted) return;
          setState(() {
            _location = "إذن الموقع مرفوض نهائيًا";
            _loading = false;
          });
        }
        return;
      }

      // الآن نأخذ الإحداثيات
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // تحويل الإحداثيات لعنوان
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final city = placemark.locality ?? placemark.subAdministrativeArea ?? '';
        final country = placemark.country ?? '';
        setState(() {
          _location = (city.isNotEmpty ? city : '') + (country.isNotEmpty ? ' / $country' : '');
          _loading = false;
        });
      } else {
        setState(() {
          _location = "لم يتم العثور على عنوان";
          _loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _location = "خطأ في الحصول على الموقع";
        _loading = false;
      });
    }
  }

  Future<bool> _showConfirmDialog({
    required String title,
    required String message,
  }) async {
    if (!mounted) return false;
    final bool? res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, textAlign: TextAlign.center),
        content: Text(message, textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("إلغاء")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("موافق")),
        ],
      ),
    );
    return res ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // مخرَج محمي بحجم ثابت / محدود ليعمل داخل AppBar بدون مشاكل
    return InkWell(
      onTap: _getUserLocation,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on_outlined, color: Colors.white),
          SizedBox(width: 4.w),
          // نستخدم ConstrainedBox بدل Flexible لو مُضمّن داخل AppBar
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 200.w),
            child: _loading
                ? SizedBox(
              height: 16.h,
              width: 16.h,
              child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
                : Text(
              _location,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontFamily: 'Graphik Arabic',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 6.w),
          const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.white),
        ],
      ),
    );
  }
}
