import 'package:abu_diyab_workshop/screens/my_car/model/all_cars_model.dart';
import 'package:abu_diyab_workshop/screens/reminds/screen/widget/add_remind_to_car.dart';
import 'package:abu_diyab_workshop/screens/reminds/screen/widget/card_note_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/language/locale.dart';
import '../../../widgets/app_bar_widget.dart';
import '../../main/cubit/services_cubit.dart';
import '../../main/cubit/services_state.dart';
import '../../my_car/screen/widget/details_item.dart';
import '../cubit/user_car_note_cubit.dart';
import '../cubit/user_car_note_state.dart';
import '../model/user_car_note_model.dart';


class RemindCarScreen extends StatefulWidget {
  final Car car;

  const RemindCarScreen({super.key, required this.car});

  @override
  State<RemindCarScreen> createState() => _RemindCarScreenState();
}

class _RemindCarScreenState extends State<RemindCarScreen> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Scaffold(
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
            decoration: buildAppBarDecoration(context),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
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
                        ? 'ملف السياره'
                        : 'Car Profiel',
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _carCard(
                context,
                widget.car,
                false,
                AppLocalizations.of(context)!,
              ),
            ),
            SizedBox(height: 20.h),
            BlocBuilder<ServicesCubit, ServicesState>(
              builder: (context, state) {
                if (state is ServicesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ServicesError) {
                  return Center(child: Text(state.message));
                } else if (state is ServicesLoaded) {
                  return BlocBuilder<UserNotesCubit, UserNotesState>(
                    builder: (context, notesState) {
                      List<UserNote> allNotes = [];
                      if (notesState is UserNotesLoaded) {
                        allNotes = notesState.notes;
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 165 / 150,
                            ),
                        itemCount: state.services.length,
                        itemBuilder: (context, index) {
                          final service = state.services[index];
                          final serviceNotes =
                              allNotes
                                  .where(
                                    (note) => note.service.id == service.id,
                                  )
                                  .toList();

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => AddRemindToCar(
                                        service: service,
                                        car: widget.car,
                                        // notes: serviceNotes,
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              width: 165.w,
                              height: 150.h,
                              decoration: ShapeDecoration(
                                color:
                                    Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.white
                                        : Color(0xff1D1D1D),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1.50,
                                    color: Color(0xFF9B9B9B),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: Color(0x3F000000),
                                    blurRadius: 8.sp,
                                    offset: Offset(0, 0),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            service.name,
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                            context,
                                                          ).brightness ==
                                                          Brightness.light
                                                      ? Colors.black
                                                      : Colors.white,
                                              fontSize: 14.sp,
                                              fontFamily: 'Graphik Arabic',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Image.network(
                                          service.icon,
                                          height: 18.h,
                                          width: 18.w,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(
                                                    Icons.broken_image,
                                                    size: 18.sp,
                                                    color: Colors.grey,
                                                  ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (serviceNotes.isNotEmpty)
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: serviceNotes.length,
                                        itemBuilder: (context, noteIndex) {
                                          final note = serviceNotes[noteIndex];
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 8.h),
                                                CardNotesDetails(
                                                  imagePath:
                                                      'assets/icons/attatch.png',
                                                  text: 'المرفقات 1',
                                                ),
                                                SizedBox(height: 8.h),
                                                CardNotesDetails(
                                                  imagePath:
                                                      'assets/icons/ui_calender.png',
                                                  text:
                                                      '${note.lastMaintenance}',
                                                ),
                                                const SizedBox(height: 8),
                                                CardNotesDetails(
                                                  imagePath:
                                                      'assets/icons/notific.png',
                                                  text: '${note.remindMe}',
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  else
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          '+ إضافة صيانة جديدة',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFFBA1B1B),
                                            fontSize: 14.sp,
                                            fontFamily: 'Graphik Arabic',
                                            fontWeight: FontWeight.w600,
                                            height: 1.60.h,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),

          ],
        ),
      ),
    );
  }

  Widget _carCard(
    BuildContext context,
    Car car,
    bool withEditNav,
    AppLocalizations locale,
  ) {
    return Container(
      width: double.infinity,
      height: 180.h,
      decoration: BoxDecoration(
        color:
            Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 12,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Stack(
        textDirection:
            locale.isDirectionRTL(context)
                ? TextDirection.rtl
                : TextDirection.ltr,
        children: [
          Column(
            children: [
              Expanded(
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 50.h,
                        left: 8.w,
                        right: 8.w,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 6.h),
                          DetailItem(
                            value: car.carBrand.name ?? '', labelAr: 'ماركــة السيـــارة:', labelEn: 'Car Brand',
                          ),
                          DetailItem(
                            value: car.carModel.name ?? '', labelAr: 'موديل السيـــارة:', labelEn: 'Car Model',
                          ),
                          DetailItem(

                            value: car.year?.toString() ?? '', labelAr: 'سنة الصنع:', labelEn: 'Year',
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Center(
                          child: Container(
                            width: 102.w,
                            height: 90.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              image: DecorationImage(
                                image: NetworkImage(car.carBrand.icon ?? ''),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 40.h,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFBA1B1B),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.r),
                    bottomRight: Radius.circular(12.r),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'رقم اللوحة:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 70.w),
                    Text(
                      car.licencePlate,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 105.w,
              height: 50.h,
              padding: EdgeInsets.all(10.w),
              decoration: ShapeDecoration(
                color: const Color(0xFFBA1B1B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.r),
                    bottomLeft: Radius.circular(12.r),
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  car.name ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
