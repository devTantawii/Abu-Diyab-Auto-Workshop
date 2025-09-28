import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/language/locale.dart';
import '../../../services/widgets/Service-Custom-AppBar.dart';
import '../../Cubit/faqcubit/faq_cubit.dart';

class FrequentlyAskedQuestions extends StatefulWidget {
  const FrequentlyAskedQuestions({super.key});

  @override
  State<FrequentlyAskedQuestions> createState() =>
      _FrequentlyAskedQuestionsState();
}

class _FrequentlyAskedQuestionsState extends State<FrequentlyAskedQuestions> {
  final Map<int, bool> expanded = {};

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final isArabic = locale!.isDirectionRTL(context);

    return BlocProvider(
      create: (_) => FaqCubit()..fetchFaqs(),
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFD27A7A)
            : const Color(0xFF6F5252),
        appBar: CustomGradientAppBar(
          title_ar: "الأسئلة الشائعة",
          title_en: "Frequently Asked Questions",
          onBack: () => Navigator.pop(context),
        ),
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.sp),
              topRight: Radius.circular(15.sp),
            ),
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
          ),
          child: BlocBuilder<FaqCubit, FaqState>(
            builder: (context, state) {
              if (state is FaqLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is FaqLoaded) {
                return ListView.builder(
                  padding: EdgeInsets.all(20.w),
                  itemCount: state.faqs.length,
                  itemBuilder: (context, index) {
                    final faq = state.faqs[index];
                    final isOpen = expanded[index] ?? false;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.black,
                        border: Border.all(color: const Color(0xFFAFAFAF)),
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8.r,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            textDirection: isArabic
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            children: [
                              Expanded(
                                child: Text(
                                  faq.question,
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                        Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isOpen
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: const Color(0xFFBA1B1B),
                                  size: 24.sp,
                                ),
                                onPressed: () {
                                  setState(() {
                                    expanded[index] = !isOpen;
                                  });
                                },
                              ),
                            ],
                          ),
                          if (isOpen) ...[
                            SizedBox(height: 10.h),
                            Text(
                              faq.answer,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).brightness ==
                                    Brightness.light
                                    ? Colors.black.withOpacity(.6)
                                    : Colors.white.withOpacity(.7),
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ]
                        ],
                      ),
                    );
                  },
                );
              } else if (state is FaqError) {
                return Center(
                  child: Text(
                    state.message,
                    style: TextStyle(color: Colors.red, fontSize: 16.sp),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
