import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';

extension RedactedHelper on Widget {
  Widget redactedHelper({
    required BuildContext context,
    required bool isLoading,
  }) {
    return redacted(context: context, redact: isLoading);
  }
}
