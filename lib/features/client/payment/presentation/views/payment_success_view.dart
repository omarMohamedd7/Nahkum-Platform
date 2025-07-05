import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/widgets/custom_button.dart';

class PaymentSuccessView extends StatelessWidget {
  const PaymentSuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final amount = args['amount'] as double;
    final transactionId = args['transactionId'] as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تأكيد الدفع'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  color: AppColors.goldDark,
                  size: 80,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'تمت عملية الدفع بنجاح',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'تم دفع مبلغ $amount\$ بنجاح',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              _buildInfoRow('رقم المعاملة', transactionId),
              _buildInfoRow('المبلغ', '$amount ر.س'),
              _buildInfoRow('التاريخ', _formatDate(DateTime.now())),
              _buildInfoRow('الحالة', 'مكتمل'),
              const SizedBox(height: 30),
              CustomButton(
                text: 'العودة للرئيسية',
                onTap: () => Get.offAllNamed(Routes.HOME),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Get.snackbar(
                    'تم الحفظ',
                    'تم حفظ إيصال الدفع بنجاح',
                    backgroundColor: AppColors.primary,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.file_download_outlined,
                        color: AppColors.goldDark),
                    const SizedBox(width: 8),
                    Text('حفظ الإيصال',
                        style: TextStyle(color: AppColors.goldDark)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: AppColors.primary),
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
