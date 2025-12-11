import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/language/locale.dart';
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
  final Set<int> selectedDetails = {}; // To store selected items

  @override
  void initState() {
    super.initState();
    cubit = RepairCardsCubit()..getRepairCards(widget.orderId);
  }

  Future<void> downloadMedia(String url) async {
    try {
      final dio = Dio();

      final dir = await getApplicationDocumentsDirectory();

      String fileName = url.split('/').last;

      String savePath = "${dir.path}/$fileName";

      await dio.download(url, savePath);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("تم التحميل بنجاح")));

      OpenFile.open(savePath).then((result) {
        print("OpenFile result: ${result.message}");
      });
    } catch (e) {
      print("❌ ERROR in downloadMedia:");
      print(e.toString());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("حدث خطأ أثناء التحميل")));
    }

    print("=== End Download Function ===");
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.light
              ? Colors.grey[100]
              : Colors.black,
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
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemCount: state.cards.length,
              itemBuilder: (context, index) {
                final card = state.cards[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale!.isDirectionRTL(context)
                          ? 'تقرير سيارتك صار جاهز !'
                          : 'Your car report is ready!',
                      style: TextStyle(
                        color:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          locale!.isDirectionRTL(context)
                              ? 'يمكنك تحميل نتيجة الفحص من هنا >>  '
                              : 'download check results >>  ',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: paragraphColor(context),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            final mediaUrl = state.cards[index].media;

                            if (mediaUrl.isNotEmpty) {
                              downloadMedia(mediaUrl);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("لا يوجد ملف للتحميل")),
                              );
                            }
                          },
                          child: Container(
                            //  width: 85.w,
                            height: 30.h,
                            decoration: ShapeDecoration(
                              color: buttonPrimaryBgColor(context),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.file_copy_sharp,
                                    color: Colors.white,
                                    size: 15.sp,
                                  ),
                                  Text(
                                    locale!.isDirectionRTL(context)
                                        ? "تحميل"
                                        : "download",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Container(
                      decoration: ShapeDecoration(
                        color: buttonBgWhiteColor(context),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1.50.w,
                            color: strokeGrayColor(context),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              locale!.isDirectionRTL(context)
                                  ? 'من فضلك أختر القطع المراد إصلاحها.'
                                  : 'Please select the parts you want to repair.',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: paragraphColor(context),
                                fontSize: 12.sp,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // ===== INFO =====
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                // ===== DETAILS =====
                                ...card.details.map((d) {
                                  final isSelected = selectedDetails.contains(
                                    d.id,
                                  );

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
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        //   color: typographyMainColor(context),
                                        color:
                                            isSelected
                                                ? typographyMainColor(
                                                  context,
                                                ).withOpacity(0.08)
                                                : Theme.of(
                                                      context,
                                                    ).brightness ==
                                                    Brightness.light
                                                ? Colors.white
                                                : const Color(0xFF1A1A1A),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? typographyMainColor(context)
                                                  : strokeGrayColor(context),

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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 250,
                                            ),
                                            height: 26.h,
                                            width: 26.w,
                                            margin: EdgeInsets.only(top: 4.h),
                                            decoration: BoxDecoration(
                                              color:
                                                  isSelected
                                                      ? typographyMainColor(
                                                        context,
                                                      )
                                                      : Colors.transparent,
                                              border: Border.all(
                                                color:
                                                    isSelected
                                                        ? typographyMainColor(
                                                          context,
                                                        )
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
                                                // العنوان
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        d.title,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 15.sp,
                                                          color:
                                                              typographyMainColor(
                                                                context,
                                                              ),
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
                                                            color:
                                                                typographyMainColor(
                                                                  context,
                                                                ),
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
                                                        color:
                                                            typographyMainColor(
                                                              context,
                                                            ),
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                            'Graphik Arabic',
                                                      ),
                                                    ),
                                                    SizedBox(width: 3.w),
                                                    Image.asset(
                                                      'assets/icons/ryal.png',
                                                      width: 17.w,
                                                      height: 17.h,
                                                      color:
                                                          typographyMainColor(
                                                            context,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10.h),
                                                if (d.clauseDetails.isNotEmpty)
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children:
                                                        d.clauseDetails.map((
                                                          c,
                                                        ) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  bottom: 2,
                                                                ),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "${c.name} ",
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        13.sp,
                                                                    color:
                                                                        Theme.of(context).brightness ==
                                                                                Brightness.light
                                                                            ? Colors.black87
                                                                            : Colors.white70,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontFamily:
                                                                        'Graphik Arabic',
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 3.w,
                                                                ),
                                                                Text(
                                                                  "${c.price}",
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        13.sp,
                                                                    color:
                                                                        Theme.of(context).brightness ==
                                                                                Brightness.light
                                                                            ? Colors.black87
                                                                            : Colors.white70,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontFamily:
                                                                        'Graphik Arabic',
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 3.w,
                                                                ),
                                                                Image.asset(
                                                                  'assets/icons/ryal.png',
                                                                  width: 16.w,
                                                                  height: 16.h,
                                                                  color:
                                                                      typographyMainColor(
                                                                        context,
                                                                      ),
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
                    ),
                  ],
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color:
              Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : const Color(0xFF1A1A1A),
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
                  backgroundColor: typographyMainColor(context),

                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
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
                child: Text(
                  locale!.isDirectionRTL(context)
                      ? "تأكيد الطلب"
                      : "Confirm Order",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : const Color(0xFF1A1A1A),
                  foregroundColor:
                      Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.black54
                              : Colors.white54,
                    ),
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
                child: Text(
                  locale!.isDirectionRTL(context) ? "رفض الكل" : "Reject All",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
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
