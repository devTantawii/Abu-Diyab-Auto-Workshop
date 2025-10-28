import 'package:abu_diyab_workshop/screens/reminds/cubit/user_car_note_cubit.dart';
import 'package:abu_diyab_workshop/screens/reminds/cubit/user_car_note_state.dart';
import 'package:abu_diyab_workshop/screens/reminds/model/user_car_note_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/language/locale.dart';
import '../../../../widgets/app_bar_widget.dart';
import '../../../my_car/model/all_cars_model.dart';
import '../../../services/widgets/custom_app_bar.dart';
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
      backgroundColor: scaffoldBackgroundColor(context),
      appBar: CustomGradientAppBar(
        title_ar: widget.service.name,
        onBack: () => Navigator.pop(context),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.sp),
            topRight: Radius.circular(15.sp),
          ),
          color: backgroundColor(context),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: BlocBuilder<UserNotesCubit, UserNotesState>(
            builder: (context, state) {
              if (state is UserNotesLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is UserNotesError) {
                return Center(child: Text("❌ خطأ: ${state.message}"));
              }

              if (state is UserNotesLoaded) {
                final notes =
                    state.notes
                        .where(
                          (note) =>
                              note.service.id == widget.service.id &&
                              note.userCar.id ==
                                  widget.car.id,
                        )
                        .toList();

                return ListView(
                  children: [
                    if (notes.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 50),
                          child: Text(
                            " ",
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
                            decoration: BoxDecoration(
                              color: backgroundColor(context),
                              border: Border.all(
                                width: 1.5.w,
                                color: borderColor(context),
                              ),
                              borderRadius: BorderRadius.circular(15.sp),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
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
                                            widget.service.name,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: textColor(context),
                                              fontSize: 14.sp,
                                              fontFamily: 'Graphik Arabic',
                                              fontWeight: FontWeight.w600,
                                              height: 1.60.h,
                                            ),
                                          ),
                                          SizedBox(width: 5.w),
                                          widget.service.icon != null &&
                                                  widget.service.icon.isNotEmpty
                                              ? Image.network(
                                                widget.service.icon,
                                                width: 22.w,
                                                height: 22.h,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => const SizedBox(),
                                              )
                                              : const SizedBox(),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          final result = await showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                    top: Radius.circular(25.sp),
                                                  ),
                                            ),
                                            builder: (modalContext) {
                                              return BlocProvider(
                                                create:
                                                    (_) =>
                                                        UserNoteDetailsCubit()
                                                          ..fetchNoteDetails(
                                                            note.id,
                                                          ),
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
                                          if (result == "updated" ||
                                              result == "deleted") {
                                            print(
                                              ":recycle: تم تعديل أو حذف النوت – هنعمل ريفرش",
                                            );
                                            context
                                                .read<UserNotesCubit>()
                                                .getUserNotes();
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0x7FBA1B1B),
                                            borderRadius: BorderRadius.circular(
                                              50.sp,
                                            ),
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
                          ),
                        );
                      }),
                    SizedBox(height: 20.h),
                    //  Text("السيارة: ${widget.car.name ?? ''}"),
                    SizedBox(height: 10.h),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          final result = await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.sp),
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
                        child: Column(
                          children: [
                            Text(
                              '+ إضافة صيانه',
                              style: TextStyle(
                                color: Color(0xFFBA1B1B),
                                fontSize: 18.sp,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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
      ),
    );
  }
}
