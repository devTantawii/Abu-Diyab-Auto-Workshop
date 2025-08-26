import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constant/api.dart';
import '../../../../core/language/locale.dart';
import '../../cubit/CarModelCubit.dart';
import '../../cubit/CarModelState.dart';
import '../../cubit/all_cars_state.dart';
import '../../cubit/car_brand_cubit.dart';
import '../../cubit/car_brand_state.dart';
import '../../cubit/all_cars_cubit.dart';
import 'image_picker.dart';
import 'nemra.dart';

class EditCar extends StatefulWidget {
  final int carId;

  const EditCar({super.key, required this.carId});

  @override
  State<EditCar> createState() => _EditCarState();
}

class _EditCarState extends State<EditCar> {
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

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCarData();
  }

  Future<void> fetchCarData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await Dio().get(
        '$mainApi/user-cars/${widget.carId}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept-Language': 'ar', // or "fr", "es", etc.
          },
        ),
      );

      final data = response.data;
      debugPrint("🚘 بيانات السيارة كاملة: $data");

      // تقسيم رقم اللوحة
      final boardParts = data['board_no']?.split(' ') ?? [];
      final letters =
          boardParts.length >= 2
              ? boardParts.sublist(0, boardParts.length - 1).join('')
              : '';
      final numbers = boardParts.isNotEmpty ? boardParts.last : '';

      final carYear =
          data['creation_year']?.toString() ?? DateTime.now().year.toString();
      final yearIndex = years.contains(carYear) ? years.indexOf(carYear) : 0;

      setState(() {
        carNameController.text = data['name'] ?? '';
        kiloReadController.text = data['kilo_read']?.toString() ?? '';
        arabicLettersController.text = letters;
        arabicNumbersController.text = numbers;

        // تأكد أن القيم صحيحة أو ضع قيمة افتراضية (مثلاً 0)
        _selectedCarBrandId = data['car_brand_id'] ?? 0;
        _selectedCarModelId = data['car_model_id'] ?? 0;

        selectedYearIndex = yearIndex;
        isLoading = false;
      });

      if (_selectedCarBrandId != null) {
        context.read<CarModelCubit>().fetchCarModels(_selectedCarBrandId!);
      }
    } catch (e) {
      debugPrint('Error fetching car data: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ حدث خطأ أثناء جلب بيانات السيارة")),
      );
    }
  }

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
      if (arabicIndic.containsKey(ch))
        buffer.write(arabicIndic[ch]);
      else if (persianIndic.containsKey(ch))
        buffer.write(persianIndic[ch]);
      else
        buffer.write(ch);
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

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    if (isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return BlocListener<CarCubit, CarState>(
      listener: (context, state) async {
        if (state is UpdateCarLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else {
          // إذا Dialog مفتوح، اغلقه
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }

          if (state is UpdateCarSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.pop(context); // العودة للشاشة السابقة
          } else if (state is UpdateCarError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEAEAEA),
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFBA1B1B), Color(0xFFD27A7A)],
                ),
              ),
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
                      locale.isDirectionRTL(context)
                          ? 'عدل سيارتك'
                          : 'Edit Your Car',
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            textDirection:
                locale.isDirectionRTL(context)
                    ? TextDirection.rtl
                    : TextDirection.ltr,
            children: [
              // رقم لوحة السيارة
              Align(
                alignment:
                    locale.isDirectionRTL(context)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                child: Text(
                  locale.isDirectionRTL(context)
                      ? 'رقم لوحة السيارة'
                      : 'Car plate number',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Nemra(
                    arabicLettersController: arabicLettersController,
                    englishNumbersController: arabicNumbersController,
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // ماركة السيارة
              Align(
                alignment:
                    locale.isDirectionRTL(context)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                child: Text(
                  locale.isDirectionRTL(context)
                      ? "ماركة السيارة"
                      : "Car brand",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              BlocBuilder<CarBrandCubit, CarBrandState>(
                builder: (context, state) {
                  if (state is CarBrandLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is CarBrandLoaded) {
                    return SizedBox(
                      height: 80, // عشان فيه صورة + اسم
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.brands.length,
                        itemBuilder: (context, index) {
                          final car = state.brands[index];
                          final isSelected = _selectedCarBrandId == car.id;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCarBrandId = car.id;
                                _selectedCarModelId = null;
                              });
                              context.read<CarModelCubit>().fetchCarModels(
                                car.id,
                              );
                            },
                            child: Container(
                              width: 70,
                              height: 70,
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Color(0xFFE19A9A)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? Color(0xFFBA1B1B)
                                          : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    car.image,
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.error, size: 20),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    car.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? Colors.black
                                              : Colors.grey,
                                      fontSize: 14.h,
                                      fontFamily: 'Graphik Arabic',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  if (state is CarBrandError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),

              SizedBox(height: 15.h),

              // موديل السيارة
              Align(
                alignment:
                    locale.isDirectionRTL(context)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                child: Text(
                  locale.isDirectionRTL(context)
                      ? "موديل السيارة"
                      : "Car model",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              BlocBuilder<CarModelCubit, CarModelState>(
                builder: (context, state) {
                  if (state is CarModelLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is CarModelLoaded) {
                    return SizedBox(
                      height: 30, // لأن المربع أصغر (70x30)
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.models.length,
                        itemBuilder: (context, index) {
                          final car = state.models[index];
                          final isSelected = _selectedCarModelId == car.id;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCarModelId = car.id;
                              });
                            },
                            child: Container(
                              width: 70,
                              height: 30,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Color(0xFFE19A9A)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? Color(0xFFBA1B1B)
                                          : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                car.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.black : Colors.grey,
                                  fontSize: 14.h,
                                  fontFamily: 'Graphik Arabic',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  if (state is CarModelError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),

              SizedBox(height: 15.h),

              // اسم السيارة
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
                          color: Colors.black,
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
                          color: const Color(0xFF4D4D4D),
                          fontSize: 12.sp,
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
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: TextField(
                  controller: carNameController,
                  decoration: InputDecoration(
                    hintText:
                        locale.isDirectionRTL(context)
                            ? "سيارة الدوام، سيارة العائلة، سيارة أحمد"
                            : "Work car, family car, Ahmed's car",
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15.h),

              // سنة الصنع
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
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                height: 80.h,
                child: ListWheelScrollView.useDelegate(
                  controller: FixedExtentScrollController(initialItem: selectedYearIndex), // 👈 يبدأ من السنة اللي جت من الـ API
                  itemExtent: 30.h,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) => setState(() => selectedYearIndex = index),
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      if (index < 0 || index >= years.length) return null;
                      final isSelected = index == selectedYearIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        color: isSelected ? const Color(0xFFBBBBBB) : Colors.transparent,
                        child: Center(
                          child: Text(
                            years[index],
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.black : const Color(0xFF5E5E5E),
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

              // ممشى السيارة
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
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: DottedBorder(
                        color: Colors.grey,
                        strokeWidth: 1,
                        dashPattern: const [6, 3],
                        borderType: BorderType.RRect,
                        radius: Radius.circular(8.r),
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: TextField(
                          controller: kiloReadController,
                          decoration: InputDecoration(
                            hintText: '0000000',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12.h,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      locale.isDirectionRTL(context) ? 'كم' : 'KM',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15.h),

              // استمارة السيارة
              Align(
                alignment:
                    locale.isDirectionRTL(context)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                child: Text(
                  locale.isDirectionRTL(context)
                      ? 'إستمارة السيارة ( أختياري )'
                      : 'Car Registration ( Optional )',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              UploadFormWidget(
                onImageSelected: (file) => selectedCarDoc = file,
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    backgroundColor: const Color(0xFFBA1B1B),
                    // لون أساسي متناسق مع الـ theme
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final token = prefs.getString('token') ?? '';

                    if (_selectedCarBrandId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("الرجاء اختيار ماركة السيارة"),
                        ),
                      );
                      return;
                    }

                    if (_selectedCarModelId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("الرجاء اختيار موديل السيارة"),
                        ),
                      );
                      return;
                    }

                    if (arabicLettersController.text.trim().isEmpty ||
                        arabicNumbersController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("الرجاء إدخال رقم اللوحة"),
                        ),
                      );
                      return;
                    }

                    final boardNoFinal = _buildBoardNo(
                      lettersRaw: arabicLettersController.text,
                      numbersRaw: arabicNumbersController.text,
                    );

                    final kiloRead =
                        int.tryParse(
                          _digitsToEn(kiloReadController.text.trim()),
                        ) ??
                        0;

                    await context.read<CarCubit>().updateCar(
                      carId: widget.carId,
                      token: token,
                      carBrandId: _selectedCarBrandId ?? 0,
                      carModelId: _selectedCarModelId ?? 0,
                      creationYear: years[selectedYearIndex],
                      boardNo: boardNoFinal,
                   //   translationName: carNameController.text.trim(),
                      kiloRead: kiloRead,
                      carDocs: selectedCarDoc,
                    );
                  },

                  child: Text(
                    locale.isDirectionRTL(context)
                        ? 'حفظ التعديلات'
                        : 'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Graphik Arabic',
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    backgroundColor: Colors.white, // خلفية الزر
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: const BorderSide(
                        color: Colors.grey,
                        width: 1.5,
                      ), // البوردر الجراي
                    ),
                  ),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final token = prefs.getString('token') ?? '';

                    bool confirm =
                        await showDialog(
                          context: context,
                          builder:
                              (_) => AlertDialog(
                                title: Text(
                                  locale.isDirectionRTL(context)
                                      ? 'تأكيد الحذف'
                                      : 'Confirm Delete',
                                ),
                                content: Text(
                                  locale.isDirectionRTL(context)
                                      ? 'هل أنت متأكد من حذف هذه السيارة؟'
                                      : 'Are you sure you want to delete this car?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                    child: Text(
                                      locale.isDirectionRTL(context)
                                          ? 'إلغاء'
                                          : 'Cancel',
                                    ),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                    child: Text(
                                      locale.isDirectionRTL(context)
                                          ? 'حذف'
                                          : 'Delete',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                        ) ??
                        false;

                    if (!confirm) return;

                    try {
                      final response = await Dio().delete(
                        '$mainApi/user-cars/${widget.carId}',
                        options: Options(
                          headers: {'Authorization': 'Bearer $token'},
                        ),
                      );

                      if (response.statusCode == 200 ||
                          response.statusCode == 204) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              locale.isDirectionRTL(context)
                                  ? 'تم حذف السيارة بنجاح'
                                  : 'Car deleted successfully',
                            ),
                          ),
                        );
                        Navigator.pop(
                          context,
                          'deleted',
                        ); // فقط Pop مرة واحدة مع النتيجة
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            locale.isDirectionRTL(context)
                                ? 'فشل الحذف'
                                : 'Failed to delete car',
                          ),
                        ),
                      );
                    }
                  },

                  child: Text(
                    locale.isDirectionRTL(context)
                        ? 'حذف السيارة'
                        : 'Delete Car',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
