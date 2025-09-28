import 'package:abu_diyab_workshop/screens/reminds/cubit/user_car_note_cubit.dart';
import 'package:abu_diyab_workshop/screens/reminds/cubit/user_car_note_state.dart';
import 'package:abu_diyab_workshop/screens/reminds/model/user_car_note_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/language/locale.dart';
import '../../../../widgets/app_bar_widget.dart';
import '../../../my_car/model/all_cars_model.dart';
import '../../cubit/maintenance_cubit.dart';
import '../../cubit/notes_details_cubit.dart';
import 'card_note_details.dart';
import 'maintance_bottom_sheet.dart';
import 'notes_details.dart';

class AddRemindToCar extends StatefulWidget {
  const AddRemindToCar({super.key, required this.service, required this.car});

  final dynamic service;
  final Car car;

  @override
  State<AddRemindToCar> createState() => _AddRemindToCarState();
}

class _AddRemindToCarState extends State<AddRemindToCar> {
  @override
  void initState() {
    super.initState();
    context.read<UserNotesCubit>().getUserNotes();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.h,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Directionality(
          textDirection:
              locale!.isDirectionRTL(context)
                  ? TextDirection.rtl
                  : TextDirection.ltr,
          child: Container(
            height: 130.h,
            padding: EdgeInsets.only(top: 20.h, right: 16.w, left: 16.w),
            decoration: buildAppBarDecoration(context),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    widget.service.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 36),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocBuilder<UserNotesCubit, UserNotesState>(
          builder: (context, state) {
            if (state is UserNotesLoading)
              return const Center(child: CircularProgressIndicator());
            if (state is UserNotesError)
              return Center(child: Text("❌ خطأ: ${state.message}"));

            if (state is UserNotesLoaded) {
              final notes =
                  state.notes
                      .where((note) => note.service.id == widget.service.id)
                      .toList();

              return ListView(
                children: [
                  if (notes.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 50),
                        child: Text(
                          "لا يوجد ملاحظات",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...notes.map((note) {
                      return GestureDetector(

                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          width: MediaQuery.of(context).size.width * 0.9,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color:Theme.of(context).brightness == Brightness.light
                                ? Colors.white
                                : Color(0xff1D1D1D),
                            shape: RoundedRectangleBorder(
                              side:  BorderSide(
                                width: 1.5.w,
                                color:Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    :Color(0xFF9B9B9B),
                              ),
                              borderRadius: BorderRadius.circular(15.sp),
                            ),
                          ),
                          child: Padding(
                            padding:  EdgeInsets.symmetric(
                              horizontal: 15.sp,
                              vertical: 12.sp,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          widget.service.title,
                                          textAlign: TextAlign.right,
                                          style:  TextStyle(
                                            color:Theme.of(context).brightness == Brightness.light
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 14.sp,
                                            fontFamily: 'Graphik Arabic',
                                            fontWeight: FontWeight.w600,
                                            height: 1.60.h,
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        Image.network(
                                          widget.service.image,
                                          width: 22.w,
                                          height: 22.h,
                                          fit: BoxFit.cover,
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final result = await showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape:  RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(25.sp),
                                            ),
                                          ),
                                          builder: (modalContext) {
                                            return BlocProvider(
                                              create:
                                                  (_) =>
                                              UserNoteDetailsCubit()
                                                ..fetchNoteDetails(note.id),
                                              child: Builder(
                                                builder: (context) {
                                                  return NoteDetailsBottomSheet(
                                                    noteId: note.id,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        );
                                        if (result == "updated" || result == "deleted") {
                                          print(":recycle: تم تعديل أو حذف النوت – هنعمل ريفرش");
                                          context.read<UserNotesCubit>().getUserNotes();
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0x7FBA1B1B),
                                          borderRadius: BorderRadius.circular(50.sp),
                                        ),
                                        child: Image.asset(
                                          'assets/icons/edit.png',
                                          height: 30.h,
                                          width: 30.w,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                CardNotesDetails(
                                  imagePath: 'assets/icons/attatch.png',
                                  text: 'المرفقات 1',
                                ),
                                SizedBox(height: 8.h),
                                CardNotesDetails(
                                  imagePath: 'assets/icons/ui_calender.png',
                                  text: '${note.lastMaintenance}',
                                ),
                                SizedBox(height: 8.h),
                                CardNotesDetails(
                                  imagePath: 'assets/icons/notific.png',
                                  text: '${note.remindMe}',
                                ),
                              ],
                            ),
                          ),
                        ),                      );
                    }),
                  const SizedBox(height: 20),
                //  Text("السيارة: ${widget.car.name ?? ''}"),
                  const SizedBox(height: 10),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        final result = await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                          ),
                          builder:
                              (context) => MaintenanceBottomSheet(
                                service: widget.service,
                                car: widget.car,
                              ),
                        );

                        if (result == "success") {
                          context.read<UserNotesCubit>().getUserNotes();
                        }
                      },
                      child: const Text(
                        '+ إضافة صيانه',
                        style: TextStyle(
                          color: Color(0xFFBA1B1B),
                          fontSize: 18,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
