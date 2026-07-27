import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:team_space/core/helper/phone_validator.dart';
import 'package:team_space/core/shared/widgets/field_container_for_shad.dart';
import 'package:team_space/core/shared/widgets/field_label.dart';
import 'package:team_space/core/themes/app_colors.dart';
import 'package:team_space/core/themes/app_text_styles.dart';

class AppPhoneField extends StatelessWidget {
  final String hintText;
  final String label;
  final bool isRequired;
  final TextEditingController? controller;
  final String initialCountryCode;
  final ValueChanged<PhoneNumber>? onChanged;
  final Color? fillColor;

  /// Restrict the country picker to these ISO codes (e.g. `['LY']`). When set to
  /// a single country, no other flags are shown.
  final List<String>? allowedCountryCodes;

  /// Whether to show the dropdown arrow next to the flag.
  final bool showDropdownIcon;

  const AppPhoneField({
    super.key,
    required this.hintText,
    this.label = '',
    this.isRequired = false,
    this.controller,
    this.initialCountryCode = 'EG',
    this.onChanged,
    this.fillColor,
    this.allowedCountryCodes,
    this.showDropdownIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label: label, isRequired: isRequired),
        if (label.isNotEmpty) SizedBox(height: 4.h),

        FieldContainer(
          child: IntlPhoneField(
            controller: controller,
            initialCountryCode: initialCountryCode,
            flagsButtonPadding: EdgeInsets.symmetric(horizontal: 16.w),
            languageCode: context.locale.languageCode,
            invalidNumberMessage: 'signup.validation.invalidEgyptianPhone'.tr(),
            showDropdownIcon: showDropdownIcon,
            countries: allowedCountryCodes == null
                ? null
                : countries
                      .where((c) => allowedCountryCodes!.contains(c.code))
                      .toList(),
            // dropdownIconPosition: IconPosition.leading,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            pickerDialogStyle: PickerDialogStyle(backgroundColor: Colors.white),

            onChanged: (phone) {
              _handleChange(phone);
            },
            decoration: _buildDecoration(),
            validator: (value) {
              if (value == null || value.number.isEmpty) {
                return 'signup.validation.required'.tr();
              }
              final isValid = validatePhoneNumberForCountry(
                value.number,
                value,
              );
              return isValid
                  ? null
                  : 'signup.validation.invalidEgyptianPhone'.tr();
            },
          ),
        ),
      ],
    );
  }

  // دايمًا بيسلّم آخر قيمة للأب — التحقق مكانه الـ validator وقت الـ submit؛
  // البوابة القديمة (if isValid) كانت بتخبّي الرقم عن الـ cubit فيتبعت فاضي.
  void _handleChange(PhoneNumber phone) {
    onChanged?.call(phone);
  }

  InputDecoration _buildDecoration() {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.r),
      borderSide: const BorderSide(color: Color(0xffDDDDDD), width: 1),
    );
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.font15Regular.copyWith(
        color: AppColors.textHint,
      ),
      fillColor: fillColor ?? Colors.white,
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
      border: border,
      enabledBorder: border,
      focusedBorder: border,
    );
  }
}
