import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/Custom-Button.dart';

class FinalReview extends StatelessWidget {
  const FinalReview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor:
          Theme.of(context).brightness == Brightness.light
              ? Color(0xFFEAEAEA)
              : Colors.black12,
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 12.h),
                Center(
                  child: Text(
                    "مراجعة الطلب",
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                      //                    "غسيل ونظافة 🚗",
                Row(
                  children: [
                    Text(
                      "غسيل ونظافة 🚗",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(Icons.edit, color: Colors.red, size: 14.sp),
                        Text(
                          " تعديل",
                          style: TextStyle(fontSize: 10.sp, color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 4.h),

                Row(
                  children: [
                    Text(
                      "حماية كامل الكبوت PPF (بالمركز)",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(18, (index) {
                    return Container(
                      width: 18.w,
                      height: 2.h,
                      decoration: BoxDecoration(color: Colors.grey),
                    );
                  }),
                ),
                SizedBox(height: 12.h),
                //        "السياره",
                Row(
                  children: [
                    Text(
                      "السياره",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(Icons.edit, color: Colors.red, size: 14.sp),
                        Text(
                          " تعديل",
                          style: TextStyle(fontSize: 10.sp, color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Container(
                  decoration: BoxDecoration(
                      color:Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          :  Color(0xFF1D1D1D),


                  border: Border.all(color: Colors.grey, width: 1.5.w),
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  padding: EdgeInsets.all(8.sp),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          color:Theme.of(context).brightness == Brightness.light
                              ? Colors.white
                              :  Color(0xFF1D1D1D),
                          borderRadius: BorderRadius.circular(12.sp),
                        ),
                        child: Padding(
                          padding:  EdgeInsets.all(8.sp),
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "الموديل:",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Theme.of(context).brightness == Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                Text(
                                  " جيلي امجراند 2023",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h), // بدل Spacer عشان يكون الحجم مرن
                            Row(
                              children: [
                                Text(
                                  "رقم اللوحة:",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Theme.of(context).brightness == Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                Text(
                                  " ب ن ط / 3567",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              children: [
                                Text(
                                  "الممشى:",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Theme.of(context).brightness == Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                Text(
                                  " 2350 كم",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.red,
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
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Text(
                      "تفاصيل الموعد ",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(Icons.edit, color: Colors.red, size: 14.sp),
                        Text(
                          " تعديل",
                          style: TextStyle(fontSize: 10.sp, color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color:Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        :  Color(0xFF1D1D1D),
                  border: Border.all(color: Colors.grey, width: 1.5.w),
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  padding: EdgeInsets.all(8.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.local_shipping,
                            size: 25.sp,
                            color: Colors.red,
                          ),
                          SizedBox(width: 8.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "طريقه التوصيل ",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).brightness == Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                ),
                              ),
                              Text(
                                "في موقعك ",
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.grey
                                          : Color(0xffCFCFCF)
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 25.sp,
                          ),
                          SizedBox(width: 8.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "العنوان",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).brightness == Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              Text(
                                "الملك عبد الله , الرياض",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).brightness == Brightness.light
                                      ? Colors.grey
                                      : Color(0xffCFCFCF)
                                ),
                              ),
                            ],
                          )

                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.red,size: 25.sp,),
                          SizedBox(width: 8.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "الوقت ",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                ),
                              ),
                              Text(
                                "3:20 - 4:20 م",
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.grey
                                          : Color(0xffCFCFCF)
                                ),
                              ),
                              Text(
                                "الخميس 31 يوليو",
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color:
                                  Theme.of(context).brightness ==
                                      Brightness.light
                                      ? Colors.grey
                                      : Color(0xffCFCFCF)
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Text(
                      "استخدم رصيدك المالي ",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color:
                        Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      " رصيدك: 195",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color:
                        Theme.of(context).brightness == Brightness.light
                            ? Colors.grey
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Container(
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.sp),
                border: Border.all(color: Colors.grey.shade400),
                  color:Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Color(0xff1D1D1D),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        textAlign: TextAlign.right,
                        decoration:  InputDecoration(
                          border: InputBorder.none,
                          hintText: 'ادخل رصيدك',
                          hintStyle: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500
                          ),                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: double.infinity,
                    decoration:  BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10.sp),
                        bottomLeft: Radius.circular(10.sp),
                        topLeft: Radius.circular(10.sp),
                      ),

                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'تطبيق',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                ],
              ),
            ),
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    " يمكنك إستخدام رصيد محفظتك في دفع رسوم الخدمة ",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.grey
                          : Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                GestureDetector(
              onTap: () {
                print("تم الضغط على البانر");
              },
              child: Container(
                height: 50.h,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFBA1B1B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Text(
                      'وفر أكثر مع باقات أبوذياب',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ],
                ),
              ),
            ),




              ],
            ),
          ),
        ),

      ),      bottomNavigationBar: CustomBottomButton(
      textAr: "مراجعة الطلب",
      textEn: "Review Order",
      onPressed: () {
       },
    ),

    );
  }
}
