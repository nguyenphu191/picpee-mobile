// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// class PaymentHelper {
//   static const String _keyPaymentHistory = 'payment_history';

//   // Lưu lịch sử thanh toán
//   static Future<void> savePaymentHistory(
//     Map<String, dynamic> paymentData,
//   ) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       List<String> history = prefs.getStringList(_keyPaymentHistory) ?? [];

//       history.insert(0, json.encode(paymentData));

//       // Giới hạn chỉ lưu 50 giao dịch gần nhất
//       if (history.length > 50) {
//         history = history.take(50).toList();
//       }

//       await prefs.setStringList(_keyPaymentHistory, history);
//     } catch (e) {
//       print('Error saving payment history: $e');
//     }
//   }

//   // Lấy lịch sử thanh toán
//   static Future<List<Map<String, dynamic>>> getPaymentHistory() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       List<String> history = prefs.getStringList(_keyPaymentHistory) ?? [];

//       return history
//           .map((item) => json.decode(item) as Map<String, dynamic>)
//           .toList();
//     } catch (e) {
//       print('Error getting payment history: $e');
//       return [];
//     }
//   }

//   // Cập nhật số dư (tùy chọn - có thể lưu local hoặc sync với server)
//   static Future<void> updateBalance(double amount) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       double currentBalance = prefs.getDouble('current_balance') ?? 0.0;
//       double newBalance = currentBalance + amount;

//       await prefs.setDouble('current_balance', newBalance);
//       print('Balance updated: \$${newBalance.toStringAsFixed(2)}');
//     } catch (e) {
//       print('Error updating balance: $e');
//     }
//   }

//   // Lấy số dư hiện tại
//   static Future<double> getCurrentBalance() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getDouble('current_balance') ?? 0.0;
//     } catch (e) {
//       print('Error getting current balance: $e');
//       return 0.0;
//     }
//   }

//   // Tạo ID giao dịch duy nhất
//   static String generateTransactionId() {
//     return 'TXN-${DateTime.now().millisecondsSinceEpoch}';
//   }

//   // Định dạng tiền tệ
//   static String formatCurrency(double amount, {String symbol = '\$'}) {
//     return '$symbol${amount.toStringAsFixed(2)}';
//   }

//   // Xác thực số tiền hợp lệ
//   static bool isValidAmount(double amount) {
//     return amount > 0 && amount <= 10000; // Giới hạn tối đa 10,000
//   }

//   // Hiển thị loading dialog
//   static void showLoadingDialog(BuildContext context, {String? message}) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(height: 16),
//               Text(message ?? 'Processing payment...'),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // Đóng loading dialog
//   static void hideLoadingDialog(BuildContext context) {
//     Navigator.of(context).pop();
//   }

//   // Log giao dịch cho debug
//   static void logTransaction(Map<String, dynamic> transactionData) {
//     print('=== PAYMENT TRANSACTION ===');
//     print('Amount: ${transactionData['amount']}');
//     print('Status: ${transactionData['status']}');
//     print('Transaction ID: ${transactionData['transactionId']}');
//     print('Timestamp: ${transactionData['timestamp']}');
//     print('========================');
//   }
// }
