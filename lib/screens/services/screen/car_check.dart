import 'dart:io';
import 'package:abu_diyab_workshop/screens/services/screen/review-request.dart';
import 'package:abu_diyab_workshop/screens/services/widgets/car_brand_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/language/locale.dart';
import '../../../widgets/multi_image_picker.dart';
import '../../../widgets/progress_bar.dart';
import '../../my_car/cubit/CarModelCubit.dart';

import '../../my_car/screen/widget/image_picker.dart';
import '../cubit/car_check_cubit.dart';
import '../cubit/car_check_state.dart';

import '../widgets/Custom-Button.dart';
import '../widgets/NotesAndCarCounter-Section.dart';
import '../widgets/car_model_widget.dart';
import '../widgets/car_selection_widget.dart';
import '../widgets/custom_app_bar.dart';

/// ---------------- Main UI ----------------
class CarCheck extends StatefulWidget {
  final String title;
  final String description;
  final String icon;
  final String slug;

  const CarCheck({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.slug,
  });

  @override
  State<CarCheck> createState() => _CarCheckState();
}

class _CarCheckState extends State<CarCheck> {
  int? _selectedCarBrandId;
  int? _selectedCarModelId;
  List<File> selectedCarDocs = [];
  final TextEditingController notesController = TextEditingController();
  final TextEditingController kiloReadController = TextEditingController();
  int? _selectedUserCarId;
  bool selected = false;

  @override
  void dispose() {
    notesController.dispose();
    kiloReadController.dispose();

    // نفرغ الزيوت لما نخرج من الشاشة

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor(context),
      appBar: CustomGradientAppBar(
        title_ar: "إنشاء طلب",
        onBack: () {
          context.read<CarCheckCubit>().resetCarChecks();
          Navigator.pop(context);
        },
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color:
              Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.title,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                        fontSize: 18.sp,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 5),
                    Image.network(
                      widget.icon,
                      height: 20.h,
                      width: 20.w,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.image_not_supported, size: 20.h);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 6.h),

                Row(
                  children: [
                    Text(
                      widget.description,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: paragraphColor(context),
                        fontSize: 13.sp,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 5),
                  ],
                ),

                SizedBox(height: 6.h),

                /// -------------------- خطوات التقدم --------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ProgressBar(active: true),
                    ProgressBar(),
                    ProgressBar(),
                  ],
                ),
                SizedBox(height: 6.h),

                /// -------------------- قسم السيارات --------------------
                CarsSection(
                  onCarSelected: (userCarId) {
                    setState(() {
                      _selectedUserCarId = userCarId;
                    });
                  },
                ),

                NotesAndCarCounterSection(
                  notesController: notesController,
                  kiloReadController: kiloReadController,
                ),
                SizedBox(height: 10.h),
                Text(
                  locale.isDirectionRTL(context)
                      ? " هل السيارة تعمل!"
                      : "Does the car work?",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color:
                        Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                    fontSize: 14.sp,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w600,
                    height: 1.57,
                  ),
                ),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    // زر نعم
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selected = true;
                          });
                        },
                        child: Container(
                          height: 55.h,
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.white
                                    : Colors.black,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFF9B9B9B),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 22.w,
                                  height: 22.h,
                                  decoration: BoxDecoration(
                                    color:
                                        selected == true
                                            ? typographyMainColor(context)
                                            : Color(0xFFD9D9D9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    size: 16.sp,
                                    color:
                                        Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              ),
                              Text(
                                locale.isDirectionRTL(context) ? " نعم" : "Yes",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // زر لا
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selected = false;
                          });
                        },
                        child: Container(
                          height: 55.h,
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.white
                                    : Colors.black,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFF9B9B9B),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 22.w,
                                  height: 22.h,
                                  decoration: BoxDecoration(
                                    color:
                                        selected == false
                                            ? typographyMainColor(context)
                                            : Color(0xFFD9D9D9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    size: 16.sp,
                                    color:
                                        Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              ),
                              Text(
                                locale.isDirectionRTL(context) ? " لا" : "No",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Align(
                  alignment:
                      locale.isDirectionRTL(context)
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: locale.isDirectionRTL(context)
                                  ? 'المرفقات '
                                  : 'Attatchment',
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                            fontSize: 14.sp,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text:
                              locale.isDirectionRTL(context)
                                  ? '( أختياري )'
                                  : '( Optional )',
                          style: TextStyle(
                            color: const Color(0xFF4D4D4D),
                            fontSize: 12.sp,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    textAlign:
                        locale.isDirectionRTL(context)
                            ? TextAlign.right
                            : TextAlign.left,
                  ),
                ),
                SizedBox(height: 10.h),
                MultiImagePickerWidget(
                  onImagesSelected: (files) {
                    selectedCarDocs = files;
                    print('عدد الصور المختارة: ${selectedCarDocs.length}');
                  },
                ),
                SizedBox(height: 15.h),
              ],
            ),
          ),
        ),
      ),
      //هنا زرار التالي في اخر الصفحه
      bottomNavigationBar: CustomBottomButton(
        textAr: "التالي",
        textEn: "Next",
        onPressed: () {
          // تحقق من البيانات المطلوبة
          if (_selectedUserCarId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("يرجى اختيار السيارة")),
            );
            return;
          }
          if (kiloReadController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("يرجى إدخال قراءة العداد")),
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (BuildContext context) => ReviewRequestPage(
                    title: widget.title,
                    icon: widget.icon,
                    slug: widget.slug,
                    selectedUserCarId: _selectedUserCarId,
                    selectedProduct: 0,
                    isCarWorking: selected.toString(),

                    notes:
                        notesController.text.isNotEmpty
                            ? notesController.text
                            : null,
                    kiloRead:
                        kiloReadController.text.isNotEmpty
                            ? kiloReadController.text
                            : null,
                    selectedCarDocs: selectedCarDocs,
                  ),
            ),
          );
        },
      ),
    );
  }
}
