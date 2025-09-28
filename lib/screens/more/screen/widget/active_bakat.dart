import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/language/locale.dart';

class ActiveBakat extends StatefulWidget {
  const ActiveBakat({super.key});

  @override
  State<ActiveBakat> createState() => _ActiveBakatState();
}

List<bool> isCheckedList = [false, false, false];

class _ActiveBakatState extends State<ActiveBakat> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    String? selectedOption;
    final List<String> options = [
      'Option 1',
      'Option 2',
      'Option 3',
      'Option 4',
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: const Color(0xFFAFAFAF)),
          borderRadius: BorderRadius.circular(15.sp),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'باقة بريميوم 🔥',
            textAlign: TextAlign.right,
            style: TextStyle(
              color:Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              fontSize: 22.sp,
              fontFamily: 'Graphik Arabic',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h,),
          Row(
            children: [
              Text(
                'تنتهي في :',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color:Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                  fontSize: 16.sp,
                  fontFamily: 'Graphik Arabic',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                '25 يوليو 2026 (متبقي: 364 يوم)',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: const Color(0xFFBA1B1B),
                  fontSize: 14.sp,
                  fontFamily: 'Graphik Arabic',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                16, // عدد الشرطات
                (index) => Text(
                  "- ",
                  style: TextStyle(fontSize: 25.sp, color: Color(0xffAFAFAF)),
                ),
              ),
            ),
          ),
          Text(
            'خدماتك المشمولة في الباقة',
            textAlign: TextAlign.right,
            style: TextStyle(
              color:Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              fontSize: 14.sp,
              fontFamily: 'Graphik Arabic',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'هذا النص هو مثال لنص يمكن أن يستبدل في ',
                  style: TextStyle(
                    color:Theme.of(context).brightness == Brightness.light
                        ?Colors.black.withValues(alpha: 0.70)
                        : Colors.white,
                    fontSize: 12.sp,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: '( احجز الان )',
                  style: TextStyle(
                    color: const Color(0xFFBA1B1B),
                    fontSize: 12.sp,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            height: 4.h,
          ),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                16, // عدد الشرطات
                    (index) => Text(
                  "- ",
                  style: TextStyle(fontSize: 25.sp, color: Color(0xffAFAFAF)),
                ),
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 4.sp),
            decoration: BoxDecoration(
              color:
              Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey, width: 1.5.sp),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedOption,
                hint: Text(
                  'سجل إستخدام الباقة',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color:Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                    fontSize: 14.sp,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xffBA1B1B),
                  size: 26.sp,
                ),
                items:
                options.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(option,style: TextStyle(fontSize: 12.sp,  color:Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,),),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedOption = value;
                  });
                },
              ),
            ),
          ),

        ],
      ),
    );
  }
}

/*

Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Service name row
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'باقة بريميوم :fire:',
                        style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                          fontSize: 22.sp,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w500,
                          height: 1.47,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            SizedBox(height: 3),
            // Status and order number row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'تنتهي في : ',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                        fontSize: 16.sp,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '25 يوليو 2026',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: const Color(0xFFBA1B1B),
                        fontSize: 16.h,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  30, // عدد الشرطات
                  (index) => Text(
                    "- ",
                    style: TextStyle(fontSize: 25, color: Color(0xffAFAFAF)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Text(
                  'خدماتك المشمولة في الباقة',
                  textAlign: TextAlign.right,
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
              ],
            ),
            SizedBox(height: 10.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isCheckedList[0] =
                              !isCheckedList[0]; // :point_left: بدلنا isChecked ب isCheckedList[0]
                        });
                      },
                      child: Transform.scale(
                        scale: 1.sp,
                        child: Checkbox(
                          value: isCheckedList[0],
                          onChanged: (value) {
                            setState(() {
                              isCheckedList[0] = value!; // :point_left: هنا برضو
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          side: const BorderSide(
                            color: Color(0xFF474747),
                            width: 2,
                          ),
                          checkColor: Colors.white,
                          activeColor: Colors.red,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      ' النص هو مثال لنص يمكن أن يستبدل في ',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13.h,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                        height: 1.69,
                      ),
                    ),
                    Text(
                      ' (احجز الان) ',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: const Color(0xFFBA1B1B),
                        fontSize: 13.h,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                        height: 1.69,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 9.h),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isCheckedList[1] =
                              !isCheckedList[1]; // :point_left: التاني
                        });
                      },
                      child: Transform.scale(
                        scale: 1.sp,
                        child: Checkbox(
                          value: isCheckedList[1],

                          // :point_left: هنا برضو التاني
                          onChanged: (value) {
                            setState(() {
                              isCheckedList[1] =
                                  value!; // :point_left: نفس الكلام
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          side: const BorderSide(
                            color: Color(0xFF474747),
                            width: 2,
                          ),
                          checkColor: Colors.white,
                          activeColor: Colors.red,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      ' النص هو مثال لنص يمكن أن يستبدل في ',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13.h,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                        height: 1.69,
                      ),
                    ),
                    Text(
                      ' (احجز الان) ',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: const Color(0xFFBA1B1B),
                        fontSize: 13.h,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                        height: 1.69,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 9.h),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isCheckedList[2] =
                              !isCheckedList[2]; // :point_left: التالت
                        });
                      },
                      child: Transform.scale(
                        scale: 1.sp,
                        child: Checkbox(
                          value: isCheckedList[2],
                          // :point_left: هنا التالت
                          onChanged: (value) {
                            setState(() {
                              isCheckedList[2] =
                                  value!; // :point_left: هنا برضو التالت
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          side: const BorderSide(
                            color: Color(0xFF474747),
                            width: 2,
                          ),
                          checkColor: Colors.white,
                          activeColor: Colors.red,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      ' النص هو مثال لنص يمكن أن يستبدل في ',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13.h,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                        height: 1.69,
                      ),
                    ),
                    Text(
                      ' (احجز الان) ',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: const Color(0xFFBA1B1B),
                        fontSize: 13.h,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                        height: 1.69,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  30,
                  (index) => Text(
                    "- ",
                    style: TextStyle(fontSize: 25, color: Color(0xffAFAFAF)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedOption,
                  hint: Text(
                    'سجل استخدام الباقات',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  isExpanded: true,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xffBA1B1B),
                    size: 16.sp,
                  ),
                  items:
                      options.map((option) {
                        return DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),



*/
