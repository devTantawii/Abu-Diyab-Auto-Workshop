import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class UploadFormWidget extends StatefulWidget {
  final void Function(File?) onImageSelected;
  final String? existingImageUrl; // 👈 رابط من API لو موجود

  const UploadFormWidget({
    Key? key,
    required this.onImageSelected,
    this.existingImageUrl,
  }) : super(key: key);

  @override
  _UploadFormWidgetState createState() => _UploadFormWidgetState();
}

class _UploadFormWidgetState extends State<UploadFormWidget> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: await _showSourceDialog(),
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      widget.onImageSelected(_selectedImage);
    }
  }

  Future<ImageSource> _showSourceDialog() async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return await showDialog<ImageSource>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isArabic ? 'اختر المصدر' : 'Choose Source',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'Graphik Arabic',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOptionButton(
                    icon: Icons.camera_alt_rounded,
                    label: isArabic ? 'الكاميرا' : 'Camera',
                    color: Colors.blue,
                    onTap: () =>
                        Navigator.pop(context, ImageSource.camera),
                  ),
                  _buildOptionButton(
                    icon: Icons.photo_library_rounded,
                    label: isArabic ? 'المعرض' : 'Gallery',
                    color: Colors.green,
                    onTap: () =>
                        Navigator.pop(context, ImageSource.gallery),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ) ??
        ImageSource.gallery;
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 30.w),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              fontSize: 13.sp,
              fontFamily: 'Graphik Arabic',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Container(
      height: 140.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: ShapeDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFEAEAEA)
            : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: GestureDetector(
        onTap: _pickImage,
        child: DottedBorder(
          color: Colors.grey,
          strokeWidth: 3,
          dashPattern: [16.h, 8.w],
          borderType: BorderType.RRect,
          radius: Radius.circular(8.r),
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Center(
            child: _selectedImage != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.file(
                _selectedImage!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            )
                : (widget.existingImageUrl != null &&
                widget.existingImageUrl!.isNotEmpty)
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                widget.existingImageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error, size: 40),
              ),
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color:
                    Theme.of(context).brightness == Brightness.light
                        ? Colors.transparent
                        : Colors.grey,
                  ),
                  child: Image.asset(
                    'assets/icons/ep_upload.png',
                    height: 46.32.h,
                    width: 62.04.w,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  isArabic
                      ? 'يمكنك إضافة استمارة السيارة بالضغط هنا'
                      : 'You can upload car registration here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).brightness ==
                        Brightness.light
                        ? Colors.black.withOpacity(0.7)
                        : Colors.white,
                    fontSize: 13.sp,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
