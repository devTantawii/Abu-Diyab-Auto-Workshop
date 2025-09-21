// lib/screens/reminds/widgets/note_details_bottom_sheet.dart
import 'package:abu_diyab_workshop/screens/reminds/screen/widget/text_icon.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubit/notes_details_cubit.dart';
import '../../cubit/notes_details_state.dart';
import '../../cubit/user_car_note_cubit.dart';

class NoteDetailsBottomSheet extends StatefulWidget {
  final int noteId;

  const NoteDetailsBottomSheet({Key? key, required this.noteId})
    : super(key: key);

  @override
  State<NoteDetailsBottomSheet> createState() => _NoteDetailsBottomSheetState();
}

class _NoteDetailsBottomSheetState extends State<NoteDetailsBottomSheet> {
  late TextEditingController detailsCtrl;
  late TextEditingController kmCtrl;
  late TextEditingController lastMaintCtrl;
  late TextEditingController remindMeCtrl;

  bool _initialized = false; // لتعيين البيانات مرة واحدة فقط

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
    return BlocBuilder<UserNoteDetailsCubit, UserNoteDetailsState>(
      builder: (context, state) {
        if (state is UserNoteDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserNoteDetailsError) {
          return Center(child: Text("❌ ${state.message}"));
        } else if (state is UserNoteDetailsLoaded) {
          final data = state.note;

          // تعيين القيم مرة واحدة فقط عند التحميل الأول
          if (!_initialized) {
            detailsCtrl.text = data["details"] ?? "";
            kmCtrl.text = data["kilometer"] ?? "";
            lastMaintCtrl.text = data["last_maintenance"] ?? "";
            remindMeCtrl.text = data["remind_me"] ?? "";
            _initialized = true;
          }

          return Container(
            height: MediaQuery.of(context).size.height *.86,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 20,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'تعديل معلومات الصيانة',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextIcon(
                          text: 'ممشي السيارة',
                          imagePath: 'assets/icons/speed.png',
                        ),
                        // تفاصيل الصيانة
                        Container(
                          width: double.infinity,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 1.5,
                              color: const Color(0xFF9B9B9B),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DottedBorder(
                                    color: const Color(0xFFBA1B1B),
                                    strokeWidth: 1,
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(8),
                                    dashPattern: const [6, 3],
                                    child: Container(
                                      height: 36,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      alignment: Alignment.centerRight,
                                      child: TextField(
                                        controller: detailsCtrl,
                                        keyboardType: TextInputType.text,
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          color: Color(0xFF707070),
                                          fontSize: 15,
                                          fontFamily: 'Graphik Arabic',
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                          hintText: 'اكتب تفاصيل الصيانة هنا',
                                          hintStyle: TextStyle(
                                            color: Color(0xFF707070),
                                            fontSize: 15,
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
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'KM',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Graphik Arabic',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        TextIcon(
                          text: 'تاريخ آخر صيانة',
                          imagePath: 'assets/icons/ui_calender.png',
                        ),
                        TextField(
                          controller: lastMaintCtrl,
                          decoration: InputDecoration(
                            labelText: "تاريخ آخر صيانة",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
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
                              lastMaintCtrl.text =
                                  "${date.year}-${date.month}-${date.day}";
                            }
                          },
                        ),

                        TextIcon(
                          text: 'صيانة كل ****** كم',
                          imagePath: 'assets/icons/maintance.png',
                        ),
                        Container(
                          width: double.infinity,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 1.5,
                              color: const Color(0xFF9B9B9B),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DottedBorder(
                                    color: const Color(0xFFBA1B1B),
                                    strokeWidth: 1,
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(8),
                                    dashPattern: const [6, 3],
                                    child: Container(
                                      height: 36,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      alignment: Alignment.centerRight,
                                      child: TextField(
                                        controller: kmCtrl,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          color: Color(0xFF707070),
                                          fontSize: 15,
                                          fontFamily: 'Graphik Arabic',
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                          hintText: '0000000',
                                          hintStyle: TextStyle(
                                            color: Color(0xFF707070),
                                            fontSize: 15,
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
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'KM',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Graphik Arabic',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        TextIcon(
                          text: 'ذكرني',
                          imagePath: 'assets/icons/notific.png',
                        ),
                        TextField(
                          controller: remindMeCtrl,
                          decoration: InputDecoration(
                            labelText: "تاريخ آخر صيانة",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
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
                              remindMeCtrl.text =
                                  "${date.year}-${date.month}-${date.day}";
                            }
                          },
                        ),

                        TextIcon(
                          text: 'المرفقات',
                          imagePath: 'assets/icons/attatch.png',
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => FullScreenImage(imageUrl: data['media']),
                              ),
                            );
                          },
                          child: Container(
                            height: 100.h,
                            width: 100.w,
                            child: Image.network(data['media'], fit: BoxFit.fill),
                          ),
                        ),

                        const SizedBox(height: 20),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  width: double.infinity, // يملأ كل العرض المتاح
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1.5, color: Color(0xFF9B9B9B)),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 12,
                        offset: Offset(0, 0),
                        spreadRadius: 6,
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
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
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
                          child:  Text(
                            'حفظ التعديلات',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontFamily: 'Graphik Arabic',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16), // مسافة بين الزرين

                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(width: 1.5, color: Color(0xFF9B9B9B)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () async {
                            await context.read<UserNoteDetailsCubit>().deleteNote(widget.noteId);
                            context.read<UserNotesCubit>().getUserNotes();
                            Navigator.pop(context, "deleted");
                          },
                          child:  Text(
                            'حذف الصيانة',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.sp,
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
          // زر الإغلاق في أعلى الشاشة
          Positioned(
            top: 40, // المسافة من الأعلى
            right: 20, // المسافة من اليمين
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54, // خلفية شبه شفافة
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(8),
                child: Icon(
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
