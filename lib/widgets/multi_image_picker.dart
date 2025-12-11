import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class MultiImagePickerWidget extends StatefulWidget {
  final void Function(List<File>) onImagesSelected;
  final List<String>? existingImageUrls;

  const MultiImagePickerWidget({
    Key? key,
    required this.onImagesSelected,
    this.existingImageUrls,
  }) : super(key: key);

  @override
  _MultiImagePickerWidgetState createState() => _MultiImagePickerWidgetState();
}

class _MultiImagePickerWidgetState extends State<MultiImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];

  Future<void> _pickImages() async {
    final ImageSource? source = await _showSourceDialog();
    if (source == null) return;

    List<XFile>? pickedFiles = [];

    if (source == ImageSource.gallery) {
      pickedFiles = await _picker.pickMultiImage(imageQuality: 80);
    } else if (source == ImageSource.camera) {
      final XFile? cameraFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (cameraFile != null) pickedFiles = [cameraFile];
    }

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages =
            pickedFiles!.map((xfile) => File(xfile.path)).toList();
      });
      widget.onImagesSelected(_selectedImages);
    }
  }

  Future<ImageSource?> _showSourceDialog() async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return await showDialog<ImageSource>(
      context: context,
      builder:
          (context) => Dialog(
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
                        onTap: () => Navigator.pop(context, ImageSource.camera),
                      ),
                      _buildOptionButton(
                        icon: Icons.photo_library_rounded,
                        label: isArabic ? 'المعرض' : 'Gallery',
                        color: Colors.green,
                        onTap:
                            () => Navigator.pop(context, ImageSource.gallery),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
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
              color:
                  Theme.of(context).brightness == Brightness.light
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
              color:
                  Theme.of(context).brightness == Brightness.light
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
      height: 150.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: ShapeDecoration(
        color:
            Theme.of(context).brightness == Brightness.light
                ? const Color(0xFFFFFFFF)
                : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: GestureDetector(
        onTap: _pickImages,
        child: DottedBorder(
          color: Colors.grey,
          strokeWidth: 3,
          dashPattern: [16.h, 8.w],
          borderType: BorderType.RRect,
          radius: Radius.circular(8.r),
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child:
              _selectedImages.isNotEmpty
                  ? ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length,
                    separatorBuilder: (_, __) => SizedBox(width: 8.w),
                    itemBuilder:
                        (context, index) => ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.file(
                            _selectedImages[index],
                            fit: BoxFit.cover,
                            width: 100.w,
                            height: 100.h,
                          ),
                        ),
                  )
                  : (widget.existingImageUrls != null &&
                      widget.existingImageUrls!.isNotEmpty)
                  ? ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.existingImageUrls!.length,
                    separatorBuilder: (_, __) => SizedBox(width: 8.w),
                    itemBuilder:
                        (context, index) => ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            widget.existingImageUrls![index],
                            fit: BoxFit.cover,
                            width: 100.w,
                            height: 100.h,
                            errorBuilder:
                                (_, __, ___) =>
                                    const Icon(Icons.error, size: 40),
                          ),
                        ),
                  )
                  : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/ep_upload.png',
                          height: 46.32.h,
                          width: 62.04.w,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          isArabic
                              ? 'يرجي إضافة المرفقات (صور السيارة,صورة نجم,تقدير..)'
                              : 'Please add attachments (car photos, star photo, rating, etc.)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black.withOpacity(0.7)
                                    : Colors.white,
                            fontSize: 11.sp,
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
