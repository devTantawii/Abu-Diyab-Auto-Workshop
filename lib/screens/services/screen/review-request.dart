import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/language/locale.dart';
import '../widgets/Custom-Button.dart';
import '../widgets/custom_app_bar.dart';
import 'final-review.dart';

class Review_Request_page extends StatefulWidget {
  const Review_Request_page({super.key});

  @override
  State<Review_Request_page> createState() => _Review_Request_pageState();
}

class _Review_Request_pageState extends State<Review_Request_page> {
  int selectedDeliveryMethod = 0;
  int selectedDayIndex = -1;
  int selectedTimeIndex = -1;   final times = [
    "11 - 12:00 م : 20",
    "11 - 12:00 م : 20",
    "11 - 12:00 م : 20",
    "11 - 12:00 م : 20",
  ];
  final List<String> days = [
    "الأحد",
    "الاثنين",
    "الثلاثاء",
    "الأربعاء",
  ];
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.light
              ? Color(0xFFD27A7A)
              : const Color(0xFF6F5252),

      appBar: CustomGradientAppBar(
        title_ar: "جدولة الطلب",
        title_en: "My Orders",
        onBack: () => Navigator.pop(context),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.sp),
            topRight: Radius.circular(15.sp),
          ),
          color:
              Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
        ),

        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.sp),
                    child: Text(
                      // هنا هنحط اسم الخدمه الي اتباصت من الصفحه الي قبلها
                      "غسيل ونظافة 🚗",
                      style: TextStyle(
                        color:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              Row(
                children: [
                  Text(
                    "اختر السياره ",
                    style: TextStyle(
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),

                  GestureDetector(
                    onTap: () {
                      print("+ إضافة ✅");
                    },
                    child: Center(
                      child: Text(
                        "+ إضافة",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),

              SizedBox(height: 8.h),

              Container(
                height: 107.h,
                decoration: BoxDecoration(
                  color:  Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Color(0xff1D1D1D),
                  border: Border.all(color: Colors.grey, width: 1.5.w),
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                padding: EdgeInsets.all(8.sp),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: double.infinity,
                      width: 100.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            "assets/images/main_pack.png",
                            height: 60.h,
                            width: 60.w,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "الموديل:",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color:
                                      Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                " جيلي امجراند 2023",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Colors.red,
                                    size: 14.sp,
                                  ),
                                  Text(
                                    " تعديل",
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Text(
                                "رقم اللوحة:",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color:
                                      Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                " ب ن ط / 3567",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Text(
                                "الممشى: ",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color:
                                      Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                " 2350 كم",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10.h),

              Row(
                children: [
                  Text(
                    "العنوان",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      print("+ إضافة عنوان جديد ✅");
                    },
                    child: Center(
                        child: Text(
                          "+ إضافة عنوان جديد",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 4.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey, width: 1.5.w),
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Color(0xff1D1D1D),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "الملك عبد الله، الرياض",
                        style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          print("✈ تعديل العنوان ✅");
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 6.w),
                            Text(
                              "✈ تعديل العنوان",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "طريقة التوصيل",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 165.w,
                    height: 45.h,
                    child: ChoiceChip(
                      label: Text(
                        "سطحة",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: selectedDeliveryMethod == 1 ? Colors.red : Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      selected: selectedDeliveryMethod == 1,
                      selectedColor:Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Color(0xff1D1D1D),
                shape: StadiumBorder(
                        side: BorderSide(
                          color: selectedDeliveryMethod == 1 ? Colors.red : Colors.grey,
                          width: 2.sp,
                        ),
                      ),
                      onSelected: (value) {
                        setState(() {
                          selectedDeliveryMethod = 1;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(

                    width: 165.w,
                    height: 45.h,
                    child: ChoiceChip(
                      label: Text(
                        "في المركز",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: selectedDeliveryMethod == 0 ? Colors.red : Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                          fontWeight: FontWeight.w500,


                        ),
                      ),
                      selected: selectedDeliveryMethod == 0,
                      selectedColor: Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : Color(0xff1D1D1D),
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: selectedDeliveryMethod == 0 ? Colors.red :Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                          width: 2.sp,
                        ),
                      ),
                      onSelected: (value) {
                        setState(() {
                          selectedDeliveryMethod = 0;
                        });
                      },
                    ),
                  ),
                ],
              ),
               SizedBox(height: 12.h),
      Text(
        "اليوم",
        style: TextStyle(
            color:
            Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            fontSize: 14.sp,
            fontWeight:FontWeight.w600
        ),),
              SizedBox(height: 8.h),

              Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: List.generate(days.length, (index) {
            final isSelected = selectedDayIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDayIndex = index;
                });
              },
              child: Container(
                width: 80.w,
                height: 90.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Color(0xff1D1D1D),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected ? Colors.red : Colors.grey,
                    width: 2.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  days[index],
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isSelected ? Colors.red : Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }),),
              SizedBox(height: 8.h),

              Text(
                "الوقت",
                 style: TextStyle(
                   color:
                   Theme.of(context).brightness == Brightness.light
                       ? Colors.black
                       : Colors.white,
                   fontSize: 14.sp,
                   fontWeight:FontWeight.w600
                 ),
              ),
               SizedBox(height: 8.h),
    Wrap(
    spacing: 12.w,
      runSpacing: 12.h,
      children: List.generate(times.length, (index) {
        final isSelected = selectedTimeIndex == index;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedTimeIndex = index;
            });
          },
          child: Container(
            width: 165.w,
            height: 45.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Color(0xff1D1D1D),
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(
                color: isSelected ? Colors.red : Colors.grey,
                width: 2.sp,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8.sp,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              times[index],
              style: TextStyle(
                fontSize: 14.sp,
                color: isSelected ? Colors.red : Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }),
    ),
               SizedBox(height: 16.h),

               SizedBox(height: 20.h),

            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomButton(
        textAr: "مراجعة الطلب",
        textEn: "Review Order",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FinalReview(),
            ),
          );
        },
      ),
    );
  }
}
