import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../services/widgets/Custom-Button.dart';
import '../../services/widgets/custom_app_bar.dart';
import '../cubit/repair_card_cubit.dart';
import '../cubit/repair_card_state.dart';

class CheckResultScreen extends StatefulWidget {
  final int orderId;

  const CheckResultScreen({super.key, required this.orderId});

  @override
  State<CheckResultScreen> createState() => _CheckResultScreenState();
}

class _CheckResultScreenState extends State<CheckResultScreen> {
  late RepairCardsCubit cubit;
  final Set<int> selectedDetails = {}; // لحفظ العناصر المختارة

  @override
  void initState() {
    super.initState();
    cubit = RepairCardsCubit()..getRepairCards(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomGradientAppBar(
        title_ar: "نتيجة الفحص",
        title_en: "Check Result",
        onBack: () => Navigator.pop(context),
      ),
      body: BlocBuilder<RepairCardsCubit, RepairCardsState>(
        bloc: cubit,
        builder: (context, state) {
          if (state is RepairCardsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RepairCardsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          if (state is RepairCardsSuccess) {
            if (state.cards.isEmpty) {
              return const Center(child: Text("لا توجد نتائج."));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: state.cards.length,
              itemBuilder: (context, index) {
                final card = state.cards[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "تقرير سيارتك صار جاهز !",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text(
                          "يمكنك تحميل نتيجة الفحص من هنا >>",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // ===== INFO =====
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),

                            // ===== DETAILS =====
                            ...card.details.map((d) {
                              final isSelected = selectedDetails.contains(d.id);

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedDetails.remove(d.id);
                                    } else {
                                      selectedDetails.add(d.id);
                                    }
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? const Color(
                                              0xFFBA1B1B,
                                            ).withOpacity(0.08)
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? const Color(0xFFBA1B1B)
                                              : Colors.grey.shade300,
                                      width: 1.3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                     AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 250,
                                          ),
                                          height: 26,
                                          width: 26,
                                          margin: EdgeInsets.only(top: 4.h),
                                          decoration: BoxDecoration(
                                            color:
                                                isSelected
                                                    ? const Color(0xFFBA1B1B)
                                                    : Colors.transparent,
                                            border: Border.all(
                                              color:
                                                  isSelected
                                                      ? const Color(0xFFBA1B1B)
                                                      : Colors.grey.shade400,
                                              width: 2.w,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child:
                                              isSelected
                                                  ? Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 16.sp,
                                                  )
                                                  : null,
                                        ),

                                      SizedBox(width: 12.w),

                                      // ========= النصوص =========
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // 🔸 العنوان
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    d.title,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 15.sp,
                                                      color: Color(0xFFBA1B1B),
                                                    ),
                                                  ),
                                                  if (d.isUrgent)
                                                    SizedBox(width: 4.w),

                                                  if (d.isUrgent)
                                                    Text(
                                                      "(عاجل)",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 11.sp,
                                                        color: Color(0xFFBA1B1B),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Text(
                                                  " ${d.price}",
                                                  style: TextStyle(
                                                    color: Color(0xFFBA1B1B),
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Graphik Arabic',
                                                  ),
                                                ),
                                                SizedBox(width: 3.w),

                                                Image.asset(
                                                  'assets/icons/ryal.png',
                                                  width: 17.w,
                                                  height: 17.h,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.h),

                                            if (d.clauseDetails.isNotEmpty)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children:
                                                    d.clauseDetails.map((c) {
                                                      return Padding(
                                                        padding: EdgeInsets.only(
                                                          bottom: 2,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "${c.name} ",
                                                              style: TextStyle(
                                                                fontSize: 13.sp,
                                                                color:
                                                                    Colors
                                                                        .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    'Graphik Arabic',
                                                              ),
                                                            ),
                                                            SizedBox(width: 3.w),

                                                            Text(
                                                              "${c.price}",
                                                              style: TextStyle(
                                                                fontSize: 13.sp,
                                                                color:
                                                                    Colors
                                                                        .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'Graphik Arabic',
                                                              ),
                                                            ),
                                                            SizedBox(width: 3.w),

                                                            Image.asset(
                                                              'assets/icons/ryal.png',
                                                              width: 16.w,
                                                              height: 16.h,
                                                              color:
                                                                  Colors.black87,
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBA1B1B),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (cubit.state is RepairCardsSuccess) {
                    final stateSuccess = cubit.state as RepairCardsSuccess;

                    final Map<String, int> repairClauseMap = {};

                    for (var card in stateSuccess.cards) {
                      for (var detail in card.details) {
                        repairClauseMap["repair_clause[${detail.id}]"] =
                            selectedDetails.contains(detail.id) ? 1 : 0;
                      }
                    }

                    print("===== Data to be sent =====");
                    repairClauseMap.forEach((key, value) {
                      print("$key : $value");
                    });
                    print("===========================");

                    cubit.updateRepairCheck(widget.orderId, repairClauseMap);
                  }
                },
                child: const Text(
                  "تأكيد الطلب",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.black54),
                  ),
                ),
                onPressed: () {
                  if (cubit.state is RepairCardsSuccess) {
                    final stateSuccess = cubit.state as RepairCardsSuccess;

                    final Map<String, int> repairClauseMap = {};

                    for (var card in stateSuccess.cards) {
                      for (var detail in card.details) {
                        repairClauseMap["repair_clause[${detail.id}]"] = 0;
                      }
                    }

                    print("===== Reject All Data =====");
                    repairClauseMap.forEach((key, value) {
                      print("$key : $value");
                    });
                    print("===========================");

                    cubit.updateRepairCheck(widget.orderId, repairClauseMap);
                  }
                },
                child: const Text(
                  "رفض الكل",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrice(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          "$value ر.س",
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
