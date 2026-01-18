import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';

import '../../../services/widgets/custom_app_bar.dart';
import '../../Cubit/static_pages_cubit.dart';

class Tax_Certificate extends StatelessWidget {
  const Tax_Certificate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomGradientAppBar(
        title_ar: "الشهادة الضريبية",
        title_en: "Tax certificate",
        onBack: () => Navigator.pop(context),
      ),

      body: BlocProvider(
        create: (context) => StaticPagesCubit()..fetchStaticPages(),
        child: BlocBuilder<StaticPagesCubit, StaticPagesState>(
          builder: (context, state) {
            if (state is StaticPagesLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (state is StaticPagesLoaded) {
              final taxCertificateUrl = state.pages.taxCertificate;

              return Scaffold(
                backgroundColor: Theme
                    .of(context)
                    .brightness == Brightness.light
                    ? const Color(0xFFEAEAEA)
                    : Colors.black,
                body: Container(
                  height: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  child: Center(
                    child: (taxCertificateUrl == null ||
                        taxCertificateUrl.isEmpty)
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 60.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "لا يوجد شهادة ضريبية حالياً",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                        : PhotoView(
                      imageProvider: NetworkImage(taxCertificateUrl),
                      backgroundDecoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? const Color(0xFFEAEAEA)
                            : Colors.black,
                      ),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 3,
                      loadingBuilder: (context, event) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Text(
                          "تعذر تحميل الصورة",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ),

                  ),
                ),
              );
            } else if (state is StaticPagesError) {
              return Scaffold(
                body: Center(
                  child: Text(
                    state.message,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16.sp,
                    ),
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
