import 'package:flutter/material.dart';

void showPaymentSuccessDialog(BuildContext context, String paymentId) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Payment Successful'),
      content: Text('Payment ID: $paymentId'),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
    ),
  );
}

void showPaymentErrorDialog(BuildContext context, String code, String message) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Payment Failed'),
      content: Text('Error: $code\nMessage: $message'),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
    ),
  );
}