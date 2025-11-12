import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/language/locale.dart';
import '../../services/widgets/custom_app_bar.dart';
import '../cubit/contact-us/contact_us_cubit.dart';
import '../cubit/contact-us/contact_us_state.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  // Controllers for form fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  // Regular expressions for validation
  final RegExp _emailRegExp =
  RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$'); // Basic email validation
  final RegExp _phoneRegExp = RegExp(r'^[0-9]+$'); // Digits only

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final isRTL = locale!.isDirectionRTL(context);

    return BlocProvider(
      create: (_) => ContactUsCubit(),
      child: BlocConsumer<ContactUsCubit, ContactUsState>(
        listener: (context, state) {
          if (state is ContactUsSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    isRTL ? 'تم إرسال الشكوى بنجاح' : 'Complaint sent successfully'),
                backgroundColor: Colors.green,
              ),
            );
            _nameController.clear();
            _emailController.clear();
            _phoneController.clear();
            _messageController.clear();
          } else if (state is ContactUsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<ContactUsCubit>();

          return Scaffold(
            appBar: CustomGradientAppBar(
              title_ar: "الشكاوي",
              title_en: " Complaints",
              onBack: () => Navigator.pop(context),
            ),            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      hint: isRTL ? "الاسم بالكامل" : "Full name",
                      icon: 'assets/icons/profilee.png',
                      isRTL: isRTL,
                    ),
                    _buildTextField(
                      controller: _emailController,
                      hint: isRTL ? "عنوان البريد الإلكتروني" : "Email address",
                      icon: 'assets/icons/email.png',
                      isRTL: isRTL,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _buildTextField(
                      controller: _phoneController,
                      hint: isRTL ? "رقم الجوال" : "Mobile number",
                      icon: 'assets/icons/call.png',
                      isRTL: isRTL,
                      keyboardType: TextInputType.number,
                    ),
                    _buildTextField(
                      controller: _messageController,
                      hint: isRTL
                          ? "أكتب اللي في خاطرك ......"
                          : "Write what's on your mind...",
                      isMultiline: true,
                      isRTL: isRTL,
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: state is ContactUsLoading
                          ? null
                          : () {
                        if (_nameController.text.isEmpty ||
                            _emailController.text.isEmpty ||
                            _phoneController.text.isEmpty ||
                            _messageController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isRTL
                                  ? 'الرجاء تعبئة جميع الحقول'
                                  : 'Please fill all fields'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        // ✅ Email validation
                        if (!_emailRegExp
                            .hasMatch(_emailController.text.trim())) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isRTL
                                  ? 'الرجاء إدخال بريد إلكتروني صحيح'
                                  : 'Please enter a valid email address'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        // ✅ Phone number validation
                        if (!_phoneRegExp
                            .hasMatch(_phoneController.text.trim())) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isRTL
                                  ? 'رقم الجوال يجب أن يحتوي على أرقام فقط'
                                  : 'Phone number must contain only digits'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        cubit.sendMessage(
                          name: _nameController.text.trim(),
                          email: _emailController.text.trim(),
                          phone: _phoneController.text.trim(),
                          message: _messageController.text.trim(),
                        );
                      },
                      child: Container(
                        width: 226.w,
                        height: 45.h,
                        decoration: ShapeDecoration(
                          color: typographyMainColor(context),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: state is ContactUsLoading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : Text(
                          isRTL ? "إرسال" : "Send",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.h,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isRTL,
    String? icon,
    bool isMultiline = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        keyboardType:
        isMultiline ? TextInputType.multiline : keyboardType ?? TextInputType.text,
        maxLines: isMultiline ? null : 1,
        minLines: isMultiline ? 4 : 1,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: isRTL && icon != null
              ? Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(icon, height: 18.h, width: 18.w,color:  typographyMainColor(context)),
          )
              : null,
          suffixIcon: !isRTL && icon != null
              ? Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(icon, height: 18.h, width: 18.w,color:  typographyMainColor(context)),
          )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:  BorderSide(color:  typographyMainColor(context)),
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
