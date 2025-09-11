import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InviteFriends extends StatefulWidget {
  const InviteFriends({super.key});

  @override
  State<InviteFriends> createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFBFFD0), Color(0xFFBA1B1B)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    Expanded(
                      child: Text(
                        'شارك التطبيق واربح معنا !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22.sp,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Material(
                      shape: const CircleBorder(),
                      elevation: 3,
                      color: Colors.white,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ادع أصدقائك وأحصل علي 20',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF474747),
                        fontSize: 14.sp,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4.w), // مسافة صغيرة بين النص والصورة
                    Image.asset(
                      "assets/icons/ryal.png",
                      color: const Color(0xFF474747),
                      width: 14.w,
                      height: 14.h,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _StepIcon(
                      icon: Icons.share,
                      label: "1. شارك الرابط",
                      imagePath: "assets/images/vector_down.png",
                    ),
                    _StepIcon(
                      icon: Icons.person_add,
                      label: "2. صديقك يسجل",
                      imagePath: "assets/images/vector_up.png",
                    ),
                    _StepIcon(icon: Icons.card_giftcard, label: "3. اربح مكافأت"),
                  ],
                ),
                SizedBox(height: 20.h),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1.5,
                        color: Color(0xFF9B9B9B),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// العنوان
                      const Text(
                        'كود الدعوة الخاص بك',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: size.height * 0.02),

                      /// الصف الأساسي (زر النسخ + الكود)
                      Row(
                        textDirection: TextDirection.ltr,

                        children: [
                          /// زر النسخ
                          Flexible(
                            flex: 2,
                            child: Container(
                              height: size.height * 0.06, // نسبة من ارتفاع الشاشة
                              decoration: ShapeDecoration(
                                color: const Color(0xFFBA1B1B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'نسخ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Graphik Arabic',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: size.width * 0.03),

                          /// الكود
                          Flexible(
                            flex: 6,
                            child: Container(
                              height: size.height * 0.06,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1,
                                    color: Color(0xFFBA1B1B),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'ABUDIYAB2025',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xFF474747),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFBA1B1B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'مشاركة الآن',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Image.asset(
                        "assets/icons/telegram.png",
                        width: 18,
                        height: 18,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                Container(
                  width: double.infinity,
                  height: 159,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1.50,
                        color: const Color(0xFFBA1B1B),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 12,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        SizedBox(height: 10.h,),
                        Text(
                          'رصيدك الحالي',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.sp,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w600,

                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '150',
                              style: TextStyle(
                                color: const Color(0xFFBA1B1B),
                                fontSize: 25.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Image.asset(
                              "assets/icons/ryal.png",
                              width: 20,
                              height: 22.h,
                            ),
                          ],
                        ),SizedBox(height: 15.h,),
                        Row(
                          children: [
                            Expanded(
                              flex: 2, // التلتين
                              child: Container(
                                height: 50,
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFBA1B1B),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child:Center(
                                  child: Text(
                                    'عدد الإحالات الخاصه بك',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                      fontFamily: 'Graphik Arabic',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 1, // التلت
                              child: Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 14),
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1.50,
                                      strokeAlign: BorderSide.strokeAlignOutside,
                                      color: const Color(0xFF9B9B9B),
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  '7',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.sp,
                                    fontFamily: 'Graphik Arabic',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                Row(
                  children: [
                    Text(
                      'سجل المكافأت',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height:  10.h),
            Container(
              width: 350,
              height: 239,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1.50,
                    color: const Color(0xFF9B9B9B),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3FFFFFFF),
                    blurRadius: 12,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? imagePath; // 👈 اختياري

  const _StepIcon({required this.icon, required this.label, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min, // 👈 يخلي الأيقونة والصورة لازقين
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              child: Icon(icon, size: 28, color: Color(0xFFBA1B1B)),
            ),
            if (imagePath != null) ...[
              const SizedBox(width: 6), // مسافة بسيطة بين الأيقونة والصورة
              Image.asset(imagePath!, width: 60.w),
              const SizedBox(width: 6),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: 'Graphik Arabic',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
