import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import '../controllers/publish_case_controller.dart';

class CityDropdown extends GetView<PublishCaseController> {
  const CityDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'المدينة المستهدفة',
          style: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
            ),
          ),
          child: Obx(() => DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: controller.targetCity.value.isNotEmpty
                      ? controller.targetCity.value
                      : null,
                  hint: const Text(
                    'اختر المدينة المستهدفة',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 14,
                      color: Color(0xFFAAAAAA),
                    ),
                  ),
                  items: controller.cities.map((String city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(
                        city,
                        style: const TextStyle(
                          fontFamily: 'Almarai',
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    );
                  }).toList(),
                  onChanged: controller.setTargetCity,
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: AppColors.primary),
                  elevation: 2,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontFamily: 'Almarai',
                  ),
                  dropdownColor: Colors.white,
                ),
              )),
        ),
      ],
    );
  }
}
