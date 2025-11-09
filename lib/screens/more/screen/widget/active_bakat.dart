import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/language/locale.dart';
import '../../cubit/bakat_cubit.dart';
import '../../cubit/bakat_state.dart';

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
    return BlocBuilder<BakatCubit, BakatState>(
      builder: (context, state) {
        if (state is BakatLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BakatSuccess) {
          final packages = state.packageResponse.first.data;
          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true, // 👈 ضروري داخل ListView آخر
                  physics: const NeverScrollableScrollPhysics(), // 👈 يمنع التمرير الداخلي
                  itemCount: packages.length,
                  itemBuilder: (context, index) {
                    final pkg = packages[index];
                    return


                      Padding(
                        padding:  EdgeInsets.symmetric(vertical: 15.h),
                        child: Container(

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
                                pkg.name,
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
                                    pkg.duration.toString(),
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
                                      text: pkg.description,

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
                        ),
                      );


                    //     Column(
                //     children: [
                //       Text(pkg.name),
                //       Text(pkg.title),
                //       Text(pkg.price),
                //       Text(pkg.type),
                //       Text(pkg.description),
                //       Text(pkg.duration.toString()),
                //     ],
                //   );
                  },
                ),

              ],
            ),
          );

        }
        else if (state is BakatError) {
          return  Center(child: Text('Failed to load packages.'));

        }
        return const SizedBox.shrink();
      },
    );

    /* Container(
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
 */
  }
}
