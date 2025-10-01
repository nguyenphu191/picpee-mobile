import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:picpee_mobile/config/paypal_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentResult {
  final bool success;
  final String? errorMessage;
  final Map<String, dynamic>? data;
  final String? transactionId;

  PaymentResult({
    required this.success,
    this.errorMessage,
    this.data,
    this.transactionId,
  });
}

class PaymentService {
  // Khởi tạo thanh toán PayPal với UI đăng nhập
  Future<PaymentResult> initiatePayPalPayment(
    BuildContext context,
    double amount,
  ) async {
    try {
      // Tạo PayPal checkout
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => PaypalCheckoutView(
            sandboxMode: PayPalConfig.sandboxMode,
            clientId: PayPalConfig.clientId,
            secretKey: PayPalConfig.secretKey,
            transactions: [
              {
                "amount": {
                  "total": amount.toStringAsFixed(2),
                  "currency": PayPalConfig.currency,
                },
                "description":
                    "Picpee Balance Reload - \$${amount.toStringAsFixed(2)}",
                "item_list": {
                  "items": [
                    {
                      "name": "Balance Reload",
                      "quantity": 1,
                      "price": amount.toStringAsFixed(2),
                      "currency": PayPalConfig.currency,
                    },
                  ],
                },
              },
            ],
            note: "Thank you for using Picpee!",
            onSuccess: (Map params) async {
              // Thanh toán thành công
              Navigator.pop(context);
              await _showSuccessDialog(context, amount, params);
            },
            onError: (error) {
              Navigator.pop(context);
              _showErrorDialog(context, "Payment Error: $error");
            },
            onCancel: () {
              Navigator.pop(context);
              _showInfoDialog(
                context,
                "Payment Cancelled",
                "You cancelled the payment process.",
              );
            },
          ),
        ),
      );

      return PaymentResult(success: true);
    } catch (e) {
      return PaymentResult(
        success: false,
        errorMessage: "Failed to initiate PayPal payment: ${e.toString()}",
      );
    }
  }

  // Xử lý thanh toán PayPal (method cũ để backward compatibility)
  Future<PaymentResult> processPayPalPayment(double amount) async {
    try {
      // Giả lập xử lý - trong thực tế sẽ gọi API backend
      await Future.delayed(Duration(seconds: 2));

      return PaymentResult(
        success: true,
        transactionId: 'PAY-${DateTime.now().millisecondsSinceEpoch}',
        data: {
          'transactionId': 'PAY-${DateTime.now().millisecondsSinceEpoch}',
          'amount': amount,
          'timestamp': DateTime.now().toIso8601String(),
          'currency': PayPalConfig.currency,
        },
      );
    } catch (e) {
      return PaymentResult(success: false, errorMessage: e.toString());
    }
  }

  // Lấy access token từ PayPal
  Future<String?> _getPayPalAccessToken() async {
    try {
      final String credentials = base64Encode(
        utf8.encode('${PayPalConfig.clientId}:${PayPalConfig.secretKey}'),
      );

      final response = await http.post(
        Uri.parse('${PayPalConfig.baseUrl}/v1/oauth2/token'),
        headers: {
          'Authorization': 'Basic $credentials',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'grant_type=client_credentials',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['access_token'];
      }
      return null;
    } catch (e) {
      print('Error getting PayPal access token: $e');
      return null;
    }
  }

  // Hiển thị dialog thành công
  Future<void> _showSuccessDialog(
    BuildContext context,
    double amount,
    Map params,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text('Payment Successful!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your balance has been reloaded successfully.'),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount: \$${amount.toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Transaction ID: ${params['paymentId'] ?? 'N/A'}'),
                    Text('Status: Completed'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to previous screen
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  // Hiển thị dialog lỗi
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red, size: 30),
              SizedBox(width: 10),
              Text('Payment Failed'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Try Again'),
            ),
          ],
        );
      },
    );
  }

  // Hiển thị dialog thông tin
  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Xác minh thanh toán với backend (tùy chọn)
  Future<bool> verifyPaymentWithBackend(
    String transactionId,
    double amount,
  ) async {
    try {
      // Gọi API backend để xác minh thanh toán
      // Thay thế bằng endpoint thực của bạn
      final response = await http.post(
        Uri.parse('https://your-api.com/verify-payment'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'transaction_id': transactionId,
          'amount': amount,
          'currency': PayPalConfig.currency,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error verifying payment: $e');
      return false;
    }
  }
}
