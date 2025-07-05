import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/widgets/custom_button.dart';
import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Add a post-frame callback to set the lawyer ID if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.lawyerId.isEmpty) {
        // Set a default lawyer ID for testing
        controller.setLawyerId('1');
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('الدفع'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildConsultationDetailsSection(),
                const SizedBox(height: 24),
                _buildPaymentMethodsSection(),
                const SizedBox(height: 24),
                _buildCardDetailsSection(),
                const SizedBox(height: 32),
                _buildPayButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConsultationDetailsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تفاصيل الاستشارة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (controller.consultationType.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('نوع الاستشارة:'),
                  Text(
                    controller.consultationType,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            if (controller.preferredDate.isNotEmpty)
              Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('التاريخ:'),
                      Text(
                        controller.preferredDate,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            if (controller.preferredTime.isNotEmpty)
              Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('الوقت:'),
                      Text(
                        controller.preferredTime,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('المبلغ الإجمالي:'),
                Text(
                  '${controller.amount} \$',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'اختر طريقة الدفع',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            _buildPaymentMethodTile(
              'بطاقة ائتمان',
              'credit_card',
              Icons.credit_card,
            ),
            _buildPaymentMethodTile(
              'محفظة إلكترونية',
              'wallet',
              Icons.account_balance_wallet,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethodTile(String title, String value, IconData icon) {
    return Obx(() => RadioListTile<String>(
          title: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 12),
              Text(title),
            ],
          ),
          value: value,
          groupValue: controller.selectedPaymentMethod.value,
          onChanged: (value) => controller.setPaymentMethod(value!),
          activeColor: AppColors.primary,
        ));
  }

  Widget _buildCardDetailsSection() {
    return Obx(() {
      final paymentMethod = controller.selectedPaymentMethod.value;
      if (paymentMethod == 'credit_card') {
        return _buildCreditCardForm();
      } else {
        return _buildWalletForm();
      }
    });
  }

  Widget _buildCreditCardForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'تفاصيل البطاقة',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.cardNumberController,
          decoration: const InputDecoration(
            labelText: 'رقم البطاقة',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.credit_card),
            hintText: '0000 0000 0000 0000',
            counterText: '', // إخفاء عداد الأحرف
          ),
          keyboardType: TextInputType.number,
          validator: controller.validateCardNumber,
          onChanged: (value) {
            if (value.isNotEmpty) {
              String rawNumber = value.replaceAll(RegExp(r'[^0-9]'), '');

              if (rawNumber.length > 16) {
                rawNumber = rawNumber.substring(0, 16);
              }

              String formattedNumber = '';
              for (int i = 0; i < rawNumber.length; i++) {
                if (i > 0 && i % 4 == 0) {
                  formattedNumber += ' ';
                }
                formattedNumber += rawNumber[i];
              }

              if (value != formattedNumber) {
                controller.cardNumberController.value = TextEditingValue(
                  text: formattedNumber,
                  selection:
                      TextSelection.collapsed(offset: formattedNumber.length),
                );
              }
            }
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.cardHolderController,
          decoration: const InputDecoration(
            labelText: 'اسم حامل البطاقة',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          validator: controller.validateCardHolder,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.expiryDateController,
                decoration: const InputDecoration(
                  labelText: 'تاريخ الانتهاء (MM/YY)',
                  border: OutlineInputBorder(),
                  hintText: '12/25',
                ),
                keyboardType: TextInputType.number,
                validator: controller.validateExpiryDate,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    String rawText = value.replaceAll(RegExp(r'[^0-9/]'), '');

                    String formattedText = '';

                    rawText = rawText.replaceAll('/', '');

                    if (rawText.length > 4) {
                      rawText = rawText.substring(0, 4);
                    }

                    if (rawText.length > 2) {
                      formattedText =
                          '${rawText.substring(0, 2)}/${rawText.substring(2)}';
                    } else {
                      formattedText = rawText;
                    }

                    if (value != formattedText) {
                      controller.expiryDateController.value = TextEditingValue(
                        text: formattedText,
                        selection: TextSelection.collapsed(
                            offset: formattedText.length),
                      );
                    }
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: controller.cvvController,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  border: OutlineInputBorder(),
                  hintText: '***',
                  counterText: '',
                ),
                obscureText: true,
                keyboardType: TextInputType.number,
                validator: controller.validateCVV,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    String rawText = value.replaceAll(RegExp(r'[^0-9]'), '');

                    if (rawText.length > 3) {
                      rawText = rawText.substring(0, 3);
                    }

                    if (value != rawText) {
                      controller.cvvController.value = TextEditingValue(
                        text: rawText,
                        selection:
                            TextSelection.collapsed(offset: rawText.length),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWalletForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'تفاصيل المحفظة الإلكترونية',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'البريد الإلكتروني / رقم الهاتف',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
        ),
      ],
    );
  }

  Widget _buildPayButton() {
    return Column(
      children: [
        // Payment button
        Obx(() {
          final isProcessing = controller.isProcessing.value;
          return CustomButton(
            text: isProcessing ? 'جاري المعالجة...' : 'إتمام الدفع',
            onTap: isProcessing ? () {} : controller.processPayment,
            isLoading: isProcessing,
          );
        }),

        // Debug button - remove in production
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            print('Debug button pressed');
            print('lawyerId: ${controller.lawyerId}');
            print('amount: ${controller.amount}');
            print('consultationType: ${controller.consultationType}');
            print('description: ${controller.description}');
            print('preferredDate: ${controller.preferredDate}');
            print('preferredTime: ${controller.preferredTime}');
            print('Card number: ${controller.cardNumberController.text}');
            print('Card holder: ${controller.cardHolderController.text}');
            print('Expiry date: ${controller.expiryDateController.text}');
            print('CVV: ${controller.cvvController.text}');
            print(
                'Selected payment method: ${controller.selectedPaymentMethod.value}');

            Get.snackbar(
              'Debug Info',
              'Check console for details',
              backgroundColor: Colors.blue,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
          child: const Text('Debug - Show Form Values'),
        ),

        // Set Lawyer ID button - remove in production
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            controller.setLawyerId('1');
            print('Explicitly set lawyer ID to: ${controller.lawyerId}');

            Get.snackbar(
              'Lawyer ID Set',
              'Lawyer ID has been set to 1',
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: const Text('Set Lawyer ID to 1'),
        ),
      ],
    );
  }
}
