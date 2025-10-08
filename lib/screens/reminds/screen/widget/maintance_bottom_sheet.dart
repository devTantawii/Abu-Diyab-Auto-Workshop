import 'dart:io';

import 'package:abu_diyab_workshop/screens/reminds/screen/widget/text_icon.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../my_car/model/all_cars_model.dart';
import '../../../my_car/screen/widget/image_picker.dart';
import '../../cubit/maintenance_cubit.dart';
import '../../cubit/maintenance_state.dart';
import '../../model/maintenance_note_model.dart';

class MaintenanceBottomSheet extends StatefulWidget {
  const MaintenanceBottomSheet({super.key, this.service, required this.car});

  final dynamic service;
  final Car car;

  @override
  State<MaintenanceBottomSheet> createState() => _MaintenanceBottomSheetState();
}

class _MaintenanceBottomSheetState extends State<MaintenanceBottomSheet> {
  final TextEditingController mileageController = TextEditingController();
  final TextEditingController kiloss = TextEditingController();
  final TextEditingController lastMaintenanceController =
  TextEditingController();
  DateTime? reminderDate;
  File? selectedCarDoc;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MaintenanceCubit, MaintenanceState>(
      listener: (context, state) {
        if (state is MaintenanceSuccess) {
          Navigator.pop(context, "success");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تمت الإضافة بنجاح")),
          );
        } else if (state is MaintenanceFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
        child: Container(
          height: 700.h,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: const Color(0xFFEAEAEA),
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Center(
                  child: Text(
                    'إضافة معلومات الصيانة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                TextIcon(
                  text: 'ممشي السيارة',
                  imagePath: 'assets/icons/speed.png',
                ),
                Container(
                  width: 350.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1.5.w, color: const Color(0xFF9B9B9B)),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: DottedBorder(
                            color: const Color(0xFFBA1B1B),
                            strokeWidth: 1,
                            borderType: BorderType.RRect,
                            radius: Radius.circular(8.r),
                            dashPattern: const [6, 3],
                            child: Container(
                              height: 36.h,
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              alignment: Alignment.center,
                              child: TextField(
                                controller: mileageController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: const Color(0xFF707070),
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
                            color: Colors.black,
                            fontSize: 15.sp,
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
                  controller: lastMaintenanceController,
                  decoration: InputDecoration(
                    labelText: "تاريخ آخر صيانة",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
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
                      lastMaintenanceController.text =
                      "${date.year}-${date.month}-${date.day}";
                    }
                  },
                ),
                SizedBox(height: 10.h),
                TextIcon(
                  text: 'صيانة كل ****** كم',
                  imagePath: 'assets/icons/maintance.png',
                ),
                Container(
                  width: 350.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1.5.w, color: const Color(0xFF9B9B9B)),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: DottedBorder(
                            color: const Color(0xFFBA1B1B),
                            strokeWidth: 1,
                            borderType: BorderType.RRect,
                            radius: Radius.circular(8.r),
                            dashPattern: const [6, 3],
                            child: Container(
                              height: 36.h,
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              alignment: Alignment.center,
                              child: TextField(
                                controller: kiloss,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: const Color(0xFF707070),
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
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                TextIcon(text: 'ذكرني', imagePath: 'assets/icons/notific.png'),
                GestureDetector(
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      initialDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => reminderDate = date);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(15.w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.r),
                      color: Colors.white,
                    ),
                    child: Text(
                      reminderDate == null
                          ? "اختر تاريخ التذكير"
                          : "${reminderDate!.year}-${reminderDate!.month}-${reminderDate!.day}",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                TextIcon(text: 'المرفقات', imagePath: 'assets/icons/attatch.png'),
                UploadFormWidget(
                  onImageSelected: (file) {
                    selectedCarDoc = file;
                  },
                ),
                SizedBox(height: 25.h),
                Center(
                  child: BlocBuilder<MaintenanceCubit, MaintenanceState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFBA1B1B),
                          padding:
                          EdgeInsets.symmetric(horizontal: 80.w, vertical: 15.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                        onPressed: state is MaintenanceLoading
                            ? null
                            : () {
                          final note = MaintenanceNote(
                            serviceId: widget.service.id,
                            userCarId: widget.car.id,
                            kilometer: mileageController.text,
                            details: kiloss.text,
                            lastMaintenance:
                            lastMaintenanceController.text.isNotEmpty
                                ? lastMaintenanceController.text
                                : null,
                            remindMe: reminderDate != null
                                ? "${reminderDate!.year.toString().padLeft(4, '0')}-${reminderDate!.month.toString().padLeft(2, '0')}-${reminderDate!.day.toString().padLeft(2, '0')}"
                                : null,
                            mediaPath: selectedCarDoc?.path,

                          );

                          context.read<MaintenanceCubit>().createMaintenance(note);
                        },
                        child: state is MaintenanceLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                          "إضافة",
                          style: TextStyle(fontSize: 18.sp, color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}


