import 'package:abu_diyab_workshop/screens/services/widgets/payment_method_tile.dart';
import 'package:abu_diyab_workshop/screens/services/widgets/payment_terms_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/language/locale.dart';
import '../../../core/constant/app_colors.dart';
import '../../../widgets/progress_bar.dart';
import '../../more/screen/widget/terms and conditions.dart';
import '../../orders/model/payment_preview_model.dart';


class PaymentMethodModal extends StatefulWidget {
  final List<PaymentMethod> paymentMethods;
  final String? selectedMethod;
  final Function(String) onSelect;
  final VoidCallback onConfirm;

  const PaymentMethodModal({
    super.key,
    required this.paymentMethods,
    this.selectedMethod,
    required this.onSelect,
    required this.onConfirm,
  });

  @override
  State<PaymentMethodModal> createState() => _PaymentMethodModalState();
}

class _PaymentMethodModalState extends State<PaymentMethodModal> {
  late String? selected = widget.selectedMethod;
  bool agreeTerms = false;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.all(16.sp),
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: backgroundColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.sp)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(height: 15.h),
          _buildCard(context, locale),
          SizedBox(height: 16.h),
          _buildConfirmButton(locale!, context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:  [
        ProgressBar(),
        ProgressBar(),
        ProgressBar(active: true),
      ],
    );
  }

  Widget _buildCard(BuildContext context, AppLocalizations? locale) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: backgroundColor(context),
          borderRadius: BorderRadius.circular(16.sp),
          border: Border.all(color: Colors.grey, width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(locale!, context),
            SizedBox(height: 16.h),
            _buildPaymentList(context, locale),
            PaymentTermsCheckbox(
              value: agreeTerms,
              onChanged: (v) => setState(() => agreeTerms = v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(AppLocalizations locale, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.isDirectionRTL(context) ? "طريقة الدفع" : "Payment Options",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: headingColor(context),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          locale.isDirectionRTL(context)
              ? "برجاء إختيار طريقة الدفع المناسبة لك."
              : "Choose your preferred payment method.",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: paragraphColor(context),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentList(BuildContext context, AppLocalizations locale) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: widget.paymentMethods.map((method) {
            return PaymentMethodTile(
              method: method,
              selected: selected,
              locale: locale,
              onSelect: (key) {
                setState(() => selected = key);
                widget.onSelect(key);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(AppLocalizations locale, BuildContext context) {
    return ElevatedButton(
      onPressed: agreeTerms ? widget.onConfirm : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: typographyMainColor(context),
        minimumSize: Size(double.infinity, 50.sp),
      ),
      child: Text(
        locale.isDirectionRTL(context) ? "تأكيد الطلب" : "Confirm Order",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
