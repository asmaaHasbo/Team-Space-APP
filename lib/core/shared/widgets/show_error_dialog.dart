import 'package:flutter/material.dart';

/// عرض Dialog للأخطاء (أفضل للرسائل الطويلة)
void showErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700, size: 28),
          const SizedBox(width: 12),
          const Text(
            'Error',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Text(
          errorMessage,
          style: const TextStyle(
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'OK',
            style: TextStyle(
              color: Colors.red.shade700,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}
