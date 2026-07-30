import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_space/core/shared/widgets/setup_snack_bar_failure_state.dart';

class ImagePickerHelper {
  ImagePickerHelper._();

  static const int _maxBytes = 5 * 1024 * 1024;

  // `FilePicker` is a single shared native picker — guard against a second tap
  // opening it while one is already active (throws `already_active`).
  static bool _isPicking = false;

  static Future<File?> pickImage(BuildContext context) async {
    if (_isPicking) return null;
    _isPicking = true;
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['jpg', 'jpeg', 'png'],
      );
      final path = result?.files.single.path;
      if (path == null) return null;

      final file = File(path);
      if (await file.length() > _maxBytes) {
        if (context.mounted) {
          setupSnackbarForFailureState(
            context,
            'signup.validation.fileTooLarge'.tr(),
          );
        }
        return null;
      }
      return file;
    } on PlatformException catch (_) {
      // Picker already active / cancelled mid-flight — safe to ignore.
      return null;
    } finally {
      _isPicking = false;
    }
  }
}
