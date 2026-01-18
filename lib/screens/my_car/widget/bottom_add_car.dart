import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/language/locale.dart';
import '../../my_car/cubit/CarModelCubit.dart';
import '../../my_car/cubit/add_car_cubit.dart';
import '../../my_car/cubit/add_car_state.dart';
import '../../my_car/screen/widget/image_picker.dart';
import '../../my_car/screen/widget/nemra.dart';
import '../../services/widgets/car_brand_widget.dart';
import '../../services/widgets/car_model_widget.dart';

class AddCarBottomSheet extends StatefulWidget {
  const AddCarBottomSheet({super.key});

  @override
  State<AddCarBottomSheet> createState() => _AddCarBottomSheetState();
}

class _AddCarBottomSheetState extends State<AddCarBottomSheet> {
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
    s = s.replaceAll(RegExp(r'[^\u0621-\u064A\s]'), '');
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
    final locale = AppLocalizations.of(context);

    void showError(String messageAr, String messageEn) {
      final message = locale!.isDirectionRTL(context) ? messageAr : messageEn;

      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              content: Text(message, style: const TextStyle(fontSize: 16)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    locale.isDirectionRTL(context) ? "حسنًا" : "OK",
                    style: const TextStyle(color: Color(0xFF006D92)),
                  ),
                ),
              ],
            ),
      );
    }

    if (_selectedCarBrandId == null) {
      showError(
        "⚠️ من فضلك اختر ماركة السيارة",
        "⚠️ Please choose a car brand",
      );
      return false;
    }

    if (_selectedCarModelId == null) {
      showError(
        "⚠️ من فضلك اختر موديل السيارة",
        "⚠️ Please choose a car model",
      );
      return false;
    }

    final letters = _cleanLetters(arabicLettersController.text);
    final numbers = _digitsToEn(arabicNumbersController.text.trim());

    if (letters.isEmpty || numbers.isEmpty) {
      showError(
        "⚠️ من فضلك أدخل رقم وحروف اللوحة",
        "⚠️ Please enter plate letters and numbers",
      );
      return false;
    }

    if (letters.length > 4) {
      showError(
        "⚠️ الحد الأقصى لعدد حروف اللوحة 4",
        "⚠️ Maximum 4 letters for plate",
      );
      return false;
    }

    if (numbers.length > 6) {
      showError(
        "⚠️ الحد الأقصى لعدد أرقام اللوحة 6",
        "⚠️ Maximum 6 numbers for plate",
      );
      return false;
    }

    final kilo = _digitsToEn(kiloReadController.text.trim());
    if (kilo.isEmpty || int.tryParse(kilo) == null) {
      showError(
        "⚠️ من فضلك أدخل ممشى السيارة بشكل صحيح",
        "⚠️ Please enter a valid car mileage",
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

    return Container(
      padding: EdgeInsets.only(
        top: 20.h,
        left: 16.w,
        right: 16.w,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      decoration: BoxDecoration(
        color: backgroundColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SingleChildScrollView(
        child: GestureDetector(  onTap: () {
          FocusScope.of(context).unfocus();
        },
          child: Column(
            children: [
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, size: 18.sp),
                  ),
                  Text(
                    locale!.isDirectionRTL(context)
                        ? 'أضف سيارتك'
                        : 'Add Your Car',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: headingColor(context),
                    ),
                  ),
                  SizedBox(width: 24.w),
                ],
              ),
              SizedBox(height: 15.h),
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
                    color: headingColor(context),
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
              CarBrandWidget(
                titleAr: "اختر ماركة ",
                titleEn: "Choose a brand",
                selectedCarBrandId: _selectedCarBrandId,
                onBrandSelected: (id) {
                  setState(() {
                    _selectedCarBrandId = id;
                    _selectedCarModelId = null;
                  });
                  context.read<CarModelCubit>().fetchCarModels(id);
                },
              ),
              SizedBox(height: 15.h),
              CarModelWidget(
                titleAr: "اختر الموديل",
                titleEn: "Choose a  model",
                selectedCarModelId: _selectedCarModelId,
                onModelSelected: (id) {
                  setState(() {
                    _selectedCarModelId = id;
                  });
                },
              ),
              SizedBox(height: 15.h),
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
                          color: headingColor(context),
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
                          color: paragraphColor(context),
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
                    color: headingColor(context),
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
                              color:
                                  isSelected
                                      ? headingColor(context)
                                      : paragraphColor(context),
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
                  locale.isDirectionRTL(context) ? "ممشى السياره" : "Car counter",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: headingColor(context),
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
                        text:
                            locale.isDirectionRTL(context)
                                ? 'إستمارة السيارة '
                                : 'Car Registration ',
                        style: TextStyle(
                          color: headingColor(context),
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
                          color: paragraphColor(context),
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
              SizedBox(height: 20.h),
              BlocConsumer<AddCarCubit, AddCarState>(
                listener: (context, state) {
                  if (state is AddCarSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "✅ ${state.message}",
                          style: TextStyle(color: Colors.black),
                        ),
                        backgroundColor: Colors.white,
                      ),
                    );
                    Navigator.pop(context, true);
                  } else if (state is AddCarError) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Text(
                            "حدث خطأ حاول مره اخرى ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // content: Text(
                          //   state.message,
                          //   style: TextStyle(fontSize: 10.sp),
                          // ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "حسنًا",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AddCarLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: typographyMainColor(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onPressed: () async {
                        if (!_validateInputs(context)) return;

                        final numbersRaw = arabicNumbersController.text;
                        final lettersRaw = arabicLettersController.text;
                        final boardNoFinal = _buildBoardNo(
                          lettersRaw: lettersRaw,
                          numbersRaw: numbersRaw,
                        );

                        final prefs = await SharedPreferences.getInstance();
                        final token = prefs.getString('token');
                        if (token == null) return;

                        final kiloEn = _digitsToEn(
                          kiloReadController.text.trim(),
                        );
                        final kiloInt = int.tryParse(kiloEn);

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
                        locale.isDirectionRTL(context)
                            ? 'أضف سيارتي'
                            : 'Add My Car',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
