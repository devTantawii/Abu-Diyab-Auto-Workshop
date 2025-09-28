import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Cubit/static_pages_cubit.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StaticPagesCubit()..fetchStaticPages(),
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFEAEAEA)
            : Colors.black,
        body: BlocBuilder<StaticPagesCubit, StaticPagesState>(
          builder: (context, state) {
            if (state is StaticPagesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StaticPagesLoaded) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Text(
                  state.pages.termsAndConditions ?? "",
                  style: TextStyle(
                    fontSize: 16.sp,
                    height: 1.6,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                  textAlign: TextAlign.start,
                ),
              );
            } else if (state is StaticPagesError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16.sp,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
