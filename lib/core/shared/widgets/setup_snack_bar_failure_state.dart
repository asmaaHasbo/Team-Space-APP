import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
setupSnackbarForFailureState(BuildContext context, String errMsg) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              errMsg,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              maxLines: 10,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red.shade700,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 4),
    ),
  );
}
