import 'dart:io';

import 'package:abu_diyab_workshop/screens/auth/model/login_model.dart';
import 'package:abu_diyab_workshop/screens/services/widgets/car_brand_widget.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constant/api.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/language/locale.dart';

import '../../../../widgets/app_bar_widget.dart';
import '../../../main/screen/main_screen.dart';
import '../../../services/widgets/car_model_widget.dart';
import '../../../services/widgets/custom_app_bar.dart';
import '../../cubit/CarModelCubit.dart';
import '../../cubit/CarModelState.dart';
import '../../cubit/add_car_cubit.dart';
import '../../cubit/add_car_state.dart';
import '../../cubit/car_brand_cubit.dart';
import '../../cubit/car_brand_state.dart';
import 'image_picker.dart';
import 'nemra.dart';

class AddCar extends StatefulWidget {
  const AddCar({super.key});

  @override
  State<AddCar> createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  final TextEditingController arabicLettersController = TextEditingController();
  final TextEditingController arabicNumbersController = TextEditingController();
  final List<String> years = List.generate(
    50,
    (index) => (DateTime.now().year - index).toString(),
  );
  int selectedYearIndex = 0;
  int? _selectedCarBrandId;
  int? _selectedCarModelId;
  File? selectedCarDoc;

  String? selectedYear;

  final TextEditingController carNameController = TextEditingController();
  final TextEditingController kiloReadController = TextEditingController();

  String _digitsToEn(String input) {
    const Map<String, String> arabicIndic = {
      "٠": "0",
      "١": "1",
      "٢": "2",
      "٣": "3",
      "٤": "4",
      "٥": "5",
      "٦": "6",
      "٧": "7",
      "٨": "8",
      "٩": "9",
    };
    const Map<String, String> persianIndic = {
      "۰": "0",
      "۱": "1",
      "۲": "2",
      "۳": "3",
      "۴": "4",
      "۵": "5",
      "۶": "6",
      "۷": "7",
      "۸": "8",
      "۹": "9",
    };
    final buffer = StringBuffer();
    for (final ch in input.characters) {
      if (arabicIndic.containsKey(ch)) {
        buffer.write(arabicIndic[ch]);
      } else if (persianIndic.containsKey(ch)) {
        buffer.write(persianIndic[ch]);
      } else {
        buffer.write(ch);
      }
    }
    return buffer.toString();
  }

  String _cleanLetters(String input) {
    String s = input.trim();
    // إزالة أي شيء مش حرف عربي أساسي أو مسافة
    s = s.replaceAll(RegExp(r'[^\u0621-\u064A\s]'), '');
    // إزالة تكرار المسافات
    s = s.replaceAll(RegExp(r'\s+'), '');
    return s;
  }

  String _buildBoardNo({
    required String lettersRaw,
    required String numbersRaw,
  }) {
    final letters = _cleanLetters(lettersRaw);
    final lettersWithSpaces = letters.split('').join(' ');
    final numbersEn = _digitsToEn(numbersRaw.trim());
    return "$lettersWithSpaces $numbersEn".trim();
  }

  bool _validateInputs(BuildContext context) {
    if (_selectedCarBrandId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ من فضلك اختر ماركة السيارة")),
      );
      return false;
    }

    if (_selectedCarModelId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ من فضلك اختر موديل السيارة")),
      );
      return false;
    }

    final letters = _cleanLetters(arabicLettersController.text);
    final numbers = _digitsToEn(arabicNumbersController.text.trim());

    if (letters.isEmpty || numbers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ من فضلك أدخل رقم وحروف اللوحة")),
      );
      return false;
    }
    if (letters.length > 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ الحد الأقصى لعدد حروف اللوحة 4")),
      );
      return false;
    }
    if (numbers.length > 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ الحد الأقصى لعدد أرقام اللوحة 6")),
      );
      return false;
    }

    final kilo = _digitsToEn(kiloReadController.text.trim());
    if (kilo.isEmpty || int.tryParse(kilo) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ من فضلك أدخل ممشى السيارة بشكل صحيح")),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final isLight = Theme.of(context).brightness == Brightness.light;

    final bgColor = isLight ? Colors.white : Colors.black;
    final cardColor = isLight ? Colors.white : const Color(0xFF1E1E1E);
    final textColor = isLight ? Colors.black : Colors.white;
    final hintColor = isLight ? Colors.black54 : Colors.white54;
    final borderColor = isLight ? Colors.grey.shade300 : Colors.white24;
    final shadowColor = isLight ? Colors.black12 : Colors.transparent;

    return Scaffold(
      backgroundColor: isLight ? Color(0xFFEAEAEA) : Colors.black,
      appBar: CustomGradientAppBar(
        title_ar: "ضيف سيارتك",
        title_en: "Add Your Car",
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            textDirection:
                locale!.isDirectionRTL(context)
                    ? TextDirection.rtl
                    : TextDirection.ltr,
            children: [
              Align(
                alignment:
                    locale.isDirectionRTL(context)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                child: Text(
                  locale.isDirectionRTL(context)
                      ? 'رقم لوحة السيارة'
                      : 'Car plate number',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14.sp,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: Nemra(
                      arabicLettersController: arabicLettersController,
                      englishNumbersController: arabicNumbersController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),

              // --- الماركة ---
              SizedBox(height: 10.h),
              CarBrandWidget(
                titleAr: "ماركة السيارة",
                titleEn: "Car brand",
                selectedCarBrandId: _selectedCarBrandId,
                onBrandSelected: (id) {
                  setState(() {
                    _selectedCarBrandId = id;
                    _selectedCarModelId = null;
                  });

                  /// هنا نستدعي موديلات السيارة
                  context.read<CarModelCubit>().fetchCarModels(id);
                },
              ),
              SizedBox(height: 15.h),

              /// ---------------- الموديل ----------------
              CarModelWidget(
                titleAr: "موديل السيارة",
                titleEn: "Car model",
                selectedCarModelId: _selectedCarModelId,
                onModelSelected: (id) {
                  setState(() {
                    _selectedCarModelId = id;
                  });

                  /// هنا لو محتاج تجيب بيانات بناءً على الموديل
                },
              ),
              SizedBox(height: 15.h),

              // ---- اسم السيارة ----
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
                                ? 'اسم السيارة '
                                : 'Car name ',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14.sp,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text:
                            locale.isDirectionRTL(context)
                                ? '( اختياري )'
                                : '( Optional )',
                        style: TextStyle(
                          color: hintColor,
                          fontSize: 12.sp,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                decoration: ShapeDecoration(
                  color: cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                ),
                child: TextField(
                  controller: carNameController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText:
                        locale.isDirectionRTL(context)
                            ? "سيارة الدوام، سيارة العائلة..."
                            : "Work car, family car...",
                    hintStyle: TextStyle(color: hintColor),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
              SizedBox(height: 15.h),

              // ---- سنة الصنع ----
              Align(
                alignment:
                    locale.isDirectionRTL(context)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                child: Text(
                  locale.isDirectionRTL(context)
                      ? "سنة الصنع"
                      : "Year of manufacture",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 80.h,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 30.h,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() => selectedYearIndex = index);
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      if (index < 0 || index >= years.length) return null;
                      final isSelected = index == selectedYearIndex;
                      return Container(
                        color:
                            isSelected ? Color(0x3F006D92) : Colors.transparent,
                        child: Center(
                          child: Text(
                            years[index],
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? textColor : hintColor,
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: years.length,
                  ),
                ),
              ),
              SizedBox(height: 15.h),

              Align(
                alignment:
                    locale.isDirectionRTL(context)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                child: Text(
                  locale.isDirectionRTL(context)
                      ? "ممشى السياره"
                      : "Car counter",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: ShapeDecoration(
                  color: cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: DottedBorder(
                        color: borderColor,
                        strokeWidth: 1,
                        dashPattern: const [6, 3],
                        borderType: BorderType.RRect,
                        radius: Radius.circular(8.r),
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: TextField(
                          controller: kiloReadController,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            hintText: '0000000',
                            hintStyle: TextStyle(color: hintColor),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      locale.isDirectionRTL(context) ? 'كم' : 'KM',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),

              // ---- الاستمارة ----
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
                          color: textColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text:
                            locale.isDirectionRTL(context)
                                ? '( اختياري )'
                                : '( Optional )',
                        style: TextStyle(
                          color: hintColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
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
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: cardColor,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 6,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BlocConsumer<AddCarCubit, AddCarState>(
          listener: (context, state) {
            if (state is AddCarSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("✅ ${state.message}")));
              Navigator.pop(context, true);
            } else if (state is AddCarError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("حدث خطأ حاول مره اخرى ")));
            }
          },
          builder: (context, state) {
            if (state is AddCarLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SizedBox(
              height: 55.h,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  backgroundColor: buttonPrimaryBgColor(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 3,
                ),
                onPressed: () async {
                  if (!_validateInputs(context)) return;

                  final numbersRaw = arabicNumbersController.text;
                  final lettersRaw = arabicLettersController.text;



                  final prefs = await SharedPreferences.getInstance();
                  final token = prefs.getString('token');

                  if (token == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("⚠️ لا يوجد توكن محفوظ")),
                    );
                    return;
                  }

                  if (_selectedCarBrandId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("⚠️ من فضلك اختر ماركة السيارة"),
                      ),
                    );
                    return;
                  }
                  if (_selectedCarModelId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("⚠️ من فضلك اختر موديل السيارة"),
                      ),
                    );
                    return;
                  }

                  final cleanedLetters = _cleanLetters(lettersRaw);
                  final cleanedNumbers = _digitsToEn(numbersRaw.trim());

                  if (cleanedLetters.isEmpty || cleanedNumbers.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("⚠️ من فضلك أدخل رقم وحروف اللوحة"),
                      ),
                    );
                    return;
                  }

                  if (cleanedLetters.length > 4) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("⚠️ الحد الأقصى لعدد حروف اللوحة 4"),
                      ),
                    );
                    return;
                  }
                  if (cleanedNumbers.length > 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("⚠️ الحد الأقصى لعدد أرقام اللوحة 6"),
                      ),
                    );
                    return;
                  }

                  final boardNoFinal = _buildBoardNo(
                    lettersRaw: lettersRaw,
                    numbersRaw: numbersRaw,
                  );
                  final kilo = kiloReadController.text.trim();
                  final kiloEn = _digitsToEn(kilo);
                  final kiloInt = int.tryParse(kiloEn);
                  // final requestBody = {
                  //   "user_id": 1,
                  //   "car_brand_id": _selectedCarBrandId,
                  //   "car_model_id": _selectedCarModelId,
                  //   "creation_year": years[selectedYearIndex],
                  //   "board_no": boardNoFinal,
                  //   "name": carNameController.text.trim(),
                  //   "kilo_read": kiloInt,
                  // };

                  if (kiloInt == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("⚠️ من فضلك أدخل ممشى السيارة"),
                      ),
                    );
                    return;
                  }

                  context.read<AddCarCubit>().addCar(
                    carModelId: _selectedCarModelId!,
                    carBrandId: _selectedCarBrandId!,
                    token: token,
                    carCertificate: selectedCarDoc,
                    kilometre: kiloInt.toString(),
                    name:
                        carNameController.text.trim().isEmpty
                            ? null
                            : carNameController.text.trim(),
                    licencePlate: boardNoFinal,
                    year: years[selectedYearIndex],
                  );
                },
                child: Text(
                  Localizations.localeOf(context).languageCode == 'ar'
                      ? 'أضف سيارتي'
                      : 'Add My Car',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
