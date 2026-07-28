import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_space/core/shared/widgets/field_container_for_shad.dart';
import 'package:team_space/core/shared/widgets/field_label.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final String label;
  final bool isRequired;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLength;
  final int? maxLines;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatters;

  final EdgeInsetsGeometry? contentPadding;

  const AppTextField({
    super.key,
    required this.hintText,
    this.label = '',
    this.isRequired = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLength,
    this.maxLines,
    this.focusNode,
    this.onChanged,
    this.fillColor,
    this.inputFormatters,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label: label, isRequired: isRequired),
        if (label.isNotEmpty) SizedBox(height: 4.h),
        FieldContainer(
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            enabled: enabled,
            obscureText: obscureText,
            keyboardType: keyboardType,
            maxLines: maxLines ?? 1,
            maxLength: maxLength,
            onChanged: onChanged,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxLength ?? 1000),
              ...?inputFormatters,
            ],
            style: AppTextStyles.font16Medium,
            validator: (value) => validator?.call(value?.trim()),
            decoration: _buildDecoration(),
          ),
        ),
      ],
    );
  }

  // الشكل (border / fill / padding / hintStyle) جاي من
  // `AppTheme.light.inputDecorationTheme` — هنا بنمرّر المحتوى بس.
  InputDecoration _buildDecoration() {
    return InputDecoration(
      hintText: hintText,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      fillColor: fillColor,
      contentPadding: contentPadding,
      // الـ maxLength متطبّق بالـ inputFormatters، فالعدّاد تحت الحقل مالوش لزمة
      counterText: '',
    );
  }
}