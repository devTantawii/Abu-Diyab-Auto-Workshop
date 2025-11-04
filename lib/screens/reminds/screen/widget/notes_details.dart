// lib/screens/reminds/widgets/note_details_bottom_sheet.dart
import 'package:abu_diyab_workshop/screens/reminds/screen/widget/text_icon.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/language/locale.dart';
import '../../cubit/notes_details_cubit.dart';
import '../../cubit/notes_details_state.dart';
import '../../cubit/user_car_note_cubit.dart';

class NoteDetailsBottomSheet extends StatefulWidget {
  final int noteId;

  const NoteDetailsBottomSheet({Key? key, required this.noteId}) : super(key: key);

  @override
  State<NoteDetailsBottomSheet> createState() => _NoteDetailsBottomSheetState();
}

class _NoteDetailsBottomSheetState extends State<NoteDetailsBottomSheet> {
  late TextEditingController detailsCtrl;
  late TextEditingController kmCtrl;
  late TextEditingController lastMaintCtrl;
  late TextEditingController remindMeCtrl;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    detailsCtrl = TextEditingController();
    kmCtrl = TextEditingController();
    lastMaintCtrl = TextEditingController();
    remindMeCtrl = TextEditingController();
  }

  @override
  void dispose() {
    detailsCtrl.dispose();
    kmCtrl.dispose();
    lastMaintCtrl.dispose();
    remindMeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final isArabic = locale!.isDirectionRTL(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<UserNoteDetailsCubit, UserNoteDetailsState>(
      builder: (context, state) {
        if (state is UserNoteDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserNoteDetailsError) {
          return Center(child: Text("❌ ${state.message}"));
        } else if (state is UserNoteDetailsLoaded) {
          final data = state.note;

          if (!_initialized) {
            detailsCtrl.text = data["details"] ?? "";
            kmCtrl.text = data["kilometer"] ?? "";
            lastMaintCtrl.text = data["last_maintenance"] ?? "";
            remindMeCtrl.text = data["remind_me"] ?? "";
            _initialized = true;
          }

          return Container(
            height: MediaQuery.of(context).size.height * 0.92,
         //   width: double.infinity,
            color: isDark ? Colors.black : Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isArabic ? 'تعديل معلومات الصيانة' : 'Edit maintenance information',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 18.sp,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 15.h),

                        TextIcon(
                          text: isArabic ? 'ممشى السيارة' : 'Car mileage',
                          imagePath: 'assets/icons/speed.png',
                        ),

                        // تفاصيل الصيانة
                        Container(
                          width: double.infinity,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[900] : Colors.white,
                            border: Border.all(
                              width: 1.5.w,
                              color: const Color(0xFF9B9B9B),
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(8.w),
                                  child: DottedBorder(
                                    color: const Color(0xFFBA1B1B),
                                    strokeWidth: 1.w,
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(8.r),
                                    dashPattern: const [6, 3],
                                    child: Container(
                                      height: 36.h,
                                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                                      alignment: Alignment.centerRight,
                                      child: TextField(
                                        controller: detailsCtrl,
                                        keyboardType: TextInputType.text,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: isDark ? Colors.white70 : const Color(0xFF707070),
                                          fontSize: 15.sp,
                                          fontFamily: 'Graphik Arabic',
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                          hintText: isArabic
                                              ? 'اكتب تفاصيل الصيانة هنا'
                                              : 'Write maintenance details here',
                                          hintStyle: TextStyle(
                                            color: const Color(0xFF707070),
                                            fontSize: 15.sp,
                                            fontFamily: 'Graphik Arabic',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Text(
                                  'KM',
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Colors.black,
                                    fontSize: 15.sp,
                                    fontFamily: 'Graphik Arabic',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 15.h),

                        TextIcon(
                          text: isArabic ? 'تاريخ آخر صيانة' : 'Last maintenance date',
                          imagePath: 'assets/icons/ui_calender.png',
                        ),
                        TextField(
                          controller: lastMaintCtrl,
                          decoration: InputDecoration(
                            labelText: isArabic ? "تاريخ آخر صيانة" : "Last maintenance date",
                            filled: true,
                            fillColor: isDark ? Colors.grey[900] : Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          textAlign: TextAlign.right,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            DateTime? date = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              initialDate: DateTime.now(),
                            );
                            if (date != null) {
                              lastMaintCtrl.text = "${date.year}-${date.month}-${date.day}";
                            }
                          },
                        ),

                        SizedBox(height: 15.h),

                        TextIcon(
                          text: isArabic ? 'صيانة كل ****** كم' : 'Maintenance every ****** km',
                          imagePath: 'assets/icons/maintance.png',
                        ),

                        Container(
                          width: double.infinity,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[900] : Colors.white,
                            border: Border.all(
                              width: 1.5.w,
                              color: const Color(0xFF9B9B9B),
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(8.w),
                                  child: DottedBorder(
                                    color: const Color(0xFFBA1B1B),
                                    strokeWidth: 1.w,
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(8.r),
                                    dashPattern: const [6, 3],
                                    child: Container(
                                      height: 36.h,
                                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                                      alignment: Alignment.centerRight,
                                      child: TextField(
                                        controller: kmCtrl,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: isDark ? Colors.white70 : const Color(0xFF707070),
                                          fontSize: 15.sp,
                                          fontFamily: 'Graphik Arabic',
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                          hintText: '0000000',
                                          hintStyle: TextStyle(
                                            color: const Color(0xFF707070),
                                            fontSize: 15.sp,
                                            fontFamily: 'Graphik Arabic',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Text(
                                  'KM',
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Colors.black,
                                    fontSize: 15.sp,
                                    fontFamily: 'Graphik Arabic',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 15.h),

                        TextIcon(
                          text: isArabic ? 'ذكرني' : 'Remind me',
                          imagePath: 'assets/icons/notific.png',
                        ),
                        TextField(
                          controller: remindMeCtrl,
                          decoration: InputDecoration(
                            labelText: isArabic ? "تاريخ التذكير" : "Reminder date",
                            filled: true,
                            fillColor: isDark ? Colors.grey[900] : Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          textAlign: TextAlign.right,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            DateTime? date = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              initialDate: DateTime.now(),
                            );
                            if (date != null) {
                              remindMeCtrl.text = "${date.year}-${date.month}-${date.day}";
                            }
                          },
                        ),

                        SizedBox(height: 15.h),

                        TextIcon(
                          text: isArabic ? 'المرفقات' : 'Attachments',
                          imagePath: 'assets/icons/attatch.png',
                        ),

                        if (data['media'] != null && data['media'].toString().isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FullScreenImage(imageUrl: data['media']),
                                ),
                              );
                            },
                            child: Container(
                              height: 100.h,
                              width: 100.w,
                              child: Image.network(
                                data['media'],
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const SizedBox(),
                              ),
                            ),
                          ),

                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // أزرار الحفظ والحذف
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: ShapeDecoration(
                    color: isDark ? Colors.grey[900] : Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.5.w, color: borderColor(context)),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.r),
                        topRight: Radius.circular(15.r),
                      ),
                    ),
                    shadows: [
                      BoxShadow(
                        color: shadowcolor(context),
                        blurRadius: 12.r,
                        offset: Offset(0, 5),
                        spreadRadius: 6.r,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFBA1B1B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                          ),
                          onPressed: () async {
                            context.read<UserNoteDetailsCubit>().updateNote(
                              noteId: widget.noteId,
                              details: detailsCtrl.text,
                              kilometer: kmCtrl.text,
                              lastMaintenance: lastMaintCtrl.text,
                              remindMe: remindMeCtrl.text,
                            );
                            await context.read<UserNotesCubit>().getUserNotes();
                            Navigator.pop(context, "updated");
                          },
                          child: Text(
                            isArabic ? 'حفظ التعديلات' : 'Save changes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontFamily: 'Graphik Arabic',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),

                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(width: 1.5.w, color: const Color(0xFF9B9B9B)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                title: Text(
                                  isArabic ? 'تأكيد الحذف' : 'Delete confirmation',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Graphik Arabic',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17.sp,
                                  ),
                                ),
                                content: Text(
                                  isArabic
                                      ? 'هل أنت متأكد من حذف الصيانة؟'
                                      : 'Are you sure you want to delete this maintenance?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Graphik Arabic',
                                    fontSize: 15.sp,
                                    color: isDark ? Colors.white70 : Colors.black87,
                                  ),
                                ),
                                actionsAlignment: MainAxisAlignment.spaceEvenly,
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: Text(
                                      isArabic ? 'إلغاء' : 'Cancel',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 15.sp,
                                        fontFamily: 'Graphik Arabic',
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFBA1B1B),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                                    ),
                                    onPressed: () => Navigator.pop(context, true),
                                    child: Text(
                                      isArabic ? 'تأكيد' : 'Confirm',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        fontFamily: 'Graphik Arabic',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirmed == true) {
                              try {
                                await context.read<UserNoteDetailsCubit>().deleteNote(widget.noteId);
                                await context.read<UserNotesCubit>().getUserNotes();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(
                                      child: Text(
                                        isArabic
                                            ? 'تم حذف الصيانة بنجاح ✅'
                                            : 'Maintenance deleted successfully ✅',
                                        style: TextStyle(
                                          fontFamily: 'Graphik Arabic',
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.green.shade600,
                                    margin: EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );

                                await Future.delayed(const Duration(seconds: 1));
                                Navigator.pop(context, "deleted");
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(
                                      child: Text(
                                        isArabic
                                            ? 'حدث خطأ أثناء الحذف ❌'
                                            : 'An error occurred while deleting ❌',
                                        style: TextStyle(
                                          fontFamily: 'Graphik Arabic',
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.red.shade600,
                                    margin: EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(
                            isArabic ? 'حذف الصيانة' : 'Delete maintenance',
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black,
                              fontSize: 17.sp,
                              fontFamily: 'Graphik Arabic',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              child: Image.network(imageUrl),
            ),
          ),
          Positioned(
            top: 40.h,
            right: 20.h,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(8),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
