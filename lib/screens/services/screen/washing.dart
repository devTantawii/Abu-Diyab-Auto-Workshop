import 'dart:io';

import 'package:abu_diyab_workshop/screens/services/cubit/washing_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/language/locale.dart';
import '../../my_car/cubit/CarModelCubit.dart';
import '../../my_car/screen/widget/image_picker.dart';
import '../cubit/car_check_cubit.dart';
import '../widgets/Custom-Button.dart';
import '../widgets/NotesAndCarCounter-Section.dart';
import '../widgets/car_brand_widget.dart';
import '../widgets/car_model_widget.dart';
import '../widgets/custom_app_bar.dart';

class Washing extends StatefulWidget {
  const Washing({super.key});

  @override
  State<Washing> createState() => _WashingState();
}

class _WashingState extends State<Washing> {
  int? _selectedCarBrandId;
  int? _selectedCarModelId;
  File? selectedCarDoc;
  final TextEditingController notesController = TextEditingController();
  final TextEditingController kiloReadController = TextEditingController();

  @override
  void dispose() {
    notesController.dispose();
    kiloReadController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Color(0xFFD27A7A),
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
                      'غسيل',
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
                    Image.asset(
                      'assets/icons/technical-support.png',
                      height: 20.h,
                      width: 20.w,
                    ),
                  ],
                ),
                SizedBox(height: 6.h),

                /// ---------------- ماركة السيارة ----------------
                CarBrandWidget(
                  titleAr: "ماركة السيارة",
                  titleEn: "Car brand",
                  selectedCarBrandId: _selectedCarBrandId,
                  onBrandSelected: (id) {
                    setState(() {
                      _selectedCarBrandId = id;
                      _selectedCarModelId = null;
                    });

                    context.read<CarModelCubit>().fetchCarModels(id);

                    context.read<WashingCubit>().resetCarWashing();
                  },
                ),

                /// ---------------- الموديل ----------------
                CarModelWidget(
                  titleAr: "موديل السيارة",
                  titleEn: "Car model",
                  selectedCarModelId: _selectedCarModelId,
                  onModelSelected: (id) {
                    setState(() {
                      _selectedCarModelId = id;
                    });

                   context.read<WashingCubit>().fetchWashingServicesByModel(id);

                  },
                ),
                SizedBox(height: 15.h),

                Align(
                  alignment:
                      locale.isDirectionRTL(context)
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Text(
                    locale.isDirectionRTL(context)
                        ? "الخدمات المتوفرة"
                        : 'Available Services',
                    style: TextStyle(
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                      fontSize: 14.sp,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),

                BlocBuilder<WashingCubit, WashingState>(
                  builder: (context, state) {
                    if (state is WashingLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is WashingLoaded) {
                      final data = state.services;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];

                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 16.h),
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.light
                                  ? Colors.white
                                  : Colors.black,
                              borderRadius: BorderRadius.circular(15.r),
                              border: Border.all(
                                width: 1.5.w,
                                color: const Color(0xFF9B9B9B),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 12.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Transform.scale(
                                  scale: 1.2.sp,
                                  child: Checkbox(
                                    value: state.selections[index],
                                    onChanged: (v) {
                                      context
                                          .read<WashingCubit>()
                                          .toggleSelection(index, v ?? false);
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    side: const BorderSide(
                                      color: Color(0xFF474747),
                                      width: 1.2,
                                    ),
                                    checkColor: Colors.white,
                                    activeColor: const Color(0xFF1FAF38),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),

                                SizedBox(width: 12.w),


                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // 🏷️ الاسم + السعر
                                      Row(
                                        children: [
                                          Text(
                                            item.subService.name,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Theme.of(context).brightness ==
                                                  Brightness.light
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 14.sp,
                                              fontFamily: 'Graphik Arabic',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              Text(
                                                item.price,
                                                style: TextStyle(
                                                  color: const Color(0xFFBA1B1B),
                                                  fontSize: 16.sp,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(width: 4.w),
                                              Image.asset(
                                                'assets/icons/ryal.png',
                                                width: 20.w,
                                                height: 20.h,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 6.h),

                                      // 📄 الوصف
                                      Text(
                                        item.subService.description,
                                        style: TextStyle(
                                          color: Theme.of(context).brightness ==
                                              Brightness.light
                                              ? const Color(0xFF474747)
                                              : Colors.white,
                                          fontSize: 11.sp,
                                          fontFamily: 'Graphik Arabic',
                                          fontWeight: FontWeight.w500,
                                          height: 1.6,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else if (state is WashingError) {
                      return Center(child: Text("Error: ${state.message}"));
                    }
                    return const SizedBox();
                  },
                ),


        SizedBox(height: 10.h),
                NotesAndCarCounterSection(
                  notesController: notesController,
                  kiloReadController: kiloReadController,
                ),

                Align(
                  alignment:
                      locale.isDirectionRTL(context)
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              locale.isDirectionRTL(context)
                                  ? 'إستمارة السيارة '
                                  : 'Car Registration ',
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
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
                UploadFormWidget(
                  onImageSelected: (file) {
                    selectedCarDoc = file;
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
        textEn: "Add My Car",
        onPressed: () {
          print("Button Pressed");
        },
      ),
    );
  }
}
