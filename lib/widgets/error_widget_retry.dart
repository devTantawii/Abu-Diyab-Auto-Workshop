import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/constant/app_colors.dart';
import '../core/language/locale.dart';

import '../screens/auth/cubit/login_cubit.dart';
import '../screens/auth/screen/login.dart';

class ErrorWidgetWithRetry extends StatefulWidget {
  final String? message;
  final VoidCallback onRetry;

  const ErrorWidgetWithRetry({Key? key, this.message, required this.onRetry})
    : super(key: key);

  @override
  State<ErrorWidgetWithRetry> createState() => _ErrorWidgetWithRetryState();
}

class _ErrorWidgetWithRetryState extends State<ErrorWidgetWithRetry> {
  bool _hasToken = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    setState(() {
      _hasToken = token.isNotEmpty;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = AppLocalizations.of(context)!.isDirectionRTL(context);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final message =
        widget.message ??
        (_hasToken ? 'حدث خطأ أثناء تحميل البيانات' : 'الرجاء تسجيل الدخول');

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [


            const SizedBox(height: 24),

         //   Text(
         //     message,
         //     textAlign: TextAlign.center,
         //     style: TextStyle(
         //       color: Theme.of(context).colorScheme.onSurface,
         //       fontSize: 18,
         //       fontFamily: 'Graphik Arabic',
         //       fontWeight: FontWeight.w600,
         //     ),
         //   ),

            const SizedBox(height: 24),

            // الزرار (بـ GestureDetector بدل ElevatedButton)
            GestureDetector(
              onTap:
                  _hasToken
                      ? widget.onRetry
                      : () {
                        Future.delayed(const Duration(milliseconds: 100), () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder:
                                (context) => FractionallySizedBox(
                                  widthFactor: 1,
                                  child: BlocProvider(
                                    create: (_) => LoginCubit(dio: Dio()),
                                    child: const LoginBottomSheet(),
                                  ),
                                ),
                          );
                        });
                      },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 200,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color:
                      _hasToken
                          ? typographyMainColor(context)
                          : typographyMainColor(context),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(
                      _hasToken
                          ? (isRTL ? 'إعادة المحاولة' : 'Retry')
                          : (isRTL ? 'تسجيل الدخول' : 'Login'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
