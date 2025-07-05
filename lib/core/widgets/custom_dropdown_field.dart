import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String labelText;
  final String? value;
  final Map<String, String> options;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    super.key,
    required this.labelText,
    required this.value,
    required this.options,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final secondaryColor = const Color(0xFFBFBFBF);
    final double fontSize = 14; // you can use ResponsiveUtils if you want

    final double fieldHeight =
        56; // or use ResponsiveUtils.getInputFieldHeight(context)

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            labelText,
            style: TextStyle(
              fontSize: fontSize + 1,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        // Container to simulate background and shadow
        Container(
          height: fieldHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: DropdownButtonFormField<String>(
              value: value,
              items: options.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(
                    entry.value,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: fontSize),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              validator: validator,
              iconEnabledColor: Colors.blue, // adjust as you want
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                // no label here because we use the separate Text widget
                hintText: 'اختر من القائمة',
                hintStyle: TextStyle(color: secondaryColor, fontSize: fontSize),
              ),
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.black87,
              ),
              dropdownColor: Colors.white,
              isExpanded: true,
              // make dropdown open in RTL mode as well
              menuMaxHeight: 250,
              // align the dropdown menu to the right
              // Unfortunately, DropdownButtonFormField does not support RTL dropdown menus natively
            ),
          ),
        ),
      ],
    );
  }
}
