import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/language/locale.dart';
import '../../../widgets/navigation.dart';
import '../widgets/custom_app_bar.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}


class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    searchController.clear();
    context.read<SearchCubit>().resetSearch();
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.isNotEmpty) {
        context.read<SearchCubit>().search(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: scaffoldBackgroundColor(context),
        appBar: CustomGradientAppBar(
          title_ar: "العروض",
          title_en: "Offers",
          onBack: () => Navigator.pop(context),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor(context),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.sp),
              topRight: Radius.circular(20.sp),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.sp),
            child: Column(
              children: [
                 Container(
                  height: 52.h,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: ShapeDecoration(
                    color: buttonBgWhiteColor(context),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1.5,
                        color: buttonSecondaryBorderColor(context),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: locale?.isDirectionRTL(context) ?? true
                          ? 'ابحث عن الخدمات'
                          : 'Search about services',
                      hintStyle: TextStyle(
                        color: paragraphColor(context),
                        fontSize: 14.sp,
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(12.sp),
                        child: Image.asset(
                          "assets/icons/search_ai.png",
                          color: paragraphColor(context),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Search Results
                Expanded(
                  child: BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) {
                      if (state is SearchLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is SearchSuccess) {
                        final products = state.data.products;
                        final services = state.data.services;

                        if (products.isEmpty && services.isEmpty) {
                          return Center(
                            child: Text(
                              locale?.isDirectionRTL(context) ?? true
                                  ? 'لا توجد نتائج'
                                  : 'No results found',
                            ),
                          );
                        }

                        return ListView(
                          children: [
                            // Products Section
                            if (products.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: Text(
                                  locale?.isDirectionRTL(context) ?? true
                                      ? 'المنتجات'
                                      : 'Products',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ...products.map(
                                  (item) => GestureDetector(
                                onTap: () {
                                  navigateToServiceScreen(
                                    context,
                                    item.product.slug,
                                    item.product.name,
                                    item.product.description,
                                    item.product.icon,
                                    productId: item.id,                                );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 12.h),
                                  padding: EdgeInsets.all(16.sp),
                                  decoration: BoxDecoration(
                                    color: buttonBgWhiteColor(context),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: buttonSecondaryBorderColor(context),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Image.network(
                                              item.product.icon,
                                              width: 40.w,
                                              height: 40.h,
                                            ),
                                            SizedBox(width: 12.w),
                                            Expanded(
                                              child: Text(
                                                item.name,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        item.product.name,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: paragraphColor(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                )

                                  ),
                            ),

                            // Services Section
                            if (services.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: Text(
                                  locale?.isDirectionRTL(context) ?? true
                                      ? 'الخدمات'
                                      : 'Services',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ...services.map(
                                  (item) => GestureDetector(
                                onTap: () {
                                  navigateToServiceScreen(
                                    context,
                                    item.slug,
                                    item.name,
                                    item.description,
                                    item.icon,
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 12.h),
                                  padding: EdgeInsets.all(16.sp),
                                  decoration: BoxDecoration(
                                    color: buttonBgWhiteColor(context),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: buttonSecondaryBorderColor(context),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.network(
                                        item.icon,
                                        width: 40.w,
                                        height: 40.h,
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        item.name,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      if (state is SearchError) {
                        return Center(child: Text(state.message));
                      }

                      return Center(
                        child: Text(
                          locale?.isDirectionRTL(context) ?? true
                              ? 'ابدأ البحث'
                              : 'Start searching',
                        ),
                      );
                    },
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
