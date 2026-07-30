import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'font_weight.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String _family = 'Cairo';

  static TextStyle _style(double size, FontWeight weight) => TextStyle(
        fontFamily: _family,
        fontSize: size.sp,
        fontWeight: weight,
      );

  static TextStyle get font32Bold => _style(32, FontWeightHelper.bold);
  static TextStyle get font32SemiBold => _style(32, FontWeightHelper.semiBold);

  static TextStyle get font28Bold => _style(28, FontWeightHelper.bold);
  static TextStyle get font28SemiBold => _style(28, FontWeightHelper.semiBold);

  static TextStyle get font25Bold => _style(25, FontWeightHelper.bold);
  static TextStyle get font25SemiBold => _style(25, FontWeightHelper.semiBold);
  static TextStyle get font25Medium => _style(25, FontWeightHelper.medium);
  static TextStyle get font25Regular => _style(25, FontWeightHelper.regular);

  static TextStyle get font24Bold => _style(24, FontWeightHelper.bold);
  static TextStyle get font24SemiBold => _style(24, FontWeightHelper.semiBold);
  static TextStyle get font24Medium => _style(24, FontWeightHelper.medium);
  static TextStyle get font24Regular => _style(24, FontWeightHelper.regular);

  static TextStyle get font22Bold => _style(22, FontWeightHelper.bold);
  static TextStyle get font22SemiBold => _style(22, FontWeightHelper.semiBold);
  static TextStyle get font22Medium => _style(22, FontWeightHelper.medium);
  static TextStyle get font22Regular => _style(22, FontWeightHelper.regular);

  static TextStyle get font20Bold => _style(20, FontWeightHelper.bold);
  static TextStyle get font20SemiBold => _style(20, FontWeightHelper.semiBold);
  static TextStyle get font20Medium => _style(20, FontWeightHelper.medium);
  static TextStyle get font20Regular => _style(20, FontWeightHelper.regular);

  static TextStyle get font18Bold => _style(18, FontWeightHelper.bold);
  static TextStyle get font18SemiBold => _style(18, FontWeightHelper.semiBold);
  static TextStyle get font18Medium => _style(18, FontWeightHelper.medium);
  static TextStyle get font18Regular => _style(18, FontWeightHelper.regular);

  static TextStyle get font17Bold => _style(17, FontWeightHelper.bold);
  static TextStyle get font17SemiBold => _style(17, FontWeightHelper.semiBold);
  static TextStyle get font17Medium => _style(17, FontWeightHelper.medium);
  static TextStyle get font17Regular => _style(17, FontWeightHelper.regular);

  static TextStyle get font16Bold => _style(16, FontWeightHelper.bold);
  static TextStyle get font16SemiBold => _style(16, FontWeightHelper.semiBold);
  static TextStyle get font16Medium => _style(16, FontWeightHelper.medium);
  static TextStyle get font16Regular => _style(16, FontWeightHelper.regular);

  static TextStyle get font15Bold => _style(15, FontWeightHelper.bold);
  static TextStyle get font15SemiBold => _style(15, FontWeightHelper.semiBold);
  static TextStyle get font15Medium => _style(15, FontWeightHelper.medium);
  static TextStyle get font15Regular => _style(15, FontWeightHelper.regular);

  static TextStyle get font14Bold => _style(14, FontWeightHelper.bold);
  static TextStyle get font14SemiBold => _style(14, FontWeightHelper.semiBold);
  static TextStyle get font14Medium => _style(14, FontWeightHelper.medium);
  static TextStyle get font14Regular => _style(14, FontWeightHelper.regular);

  static TextStyle get font13Bold => _style(13, FontWeightHelper.bold);
  static TextStyle get font13SemiBold => _style(13, FontWeightHelper.semiBold);
  static TextStyle get font13Medium => _style(13, FontWeightHelper.medium);
  static TextStyle get font13Regular => _style(13, FontWeightHelper.regular);

  static TextStyle get font12Bold => _style(12, FontWeightHelper.bold);
  static TextStyle get font12SemiBold => _style(12, FontWeightHelper.semiBold);
  static TextStyle get font12Medium => _style(12, FontWeightHelper.medium);
  static TextStyle get font12Regular => _style(12, FontWeightHelper.regular);

  static TextStyle get font11Medium => _style(11, FontWeightHelper.medium);
  static TextStyle get font11Regular => _style(11, FontWeightHelper.regular);

  static TextStyle get font10Medium => _style(10, FontWeightHelper.medium);
  static TextStyle get font10Regular => _style(10, FontWeightHelper.regular);
}
