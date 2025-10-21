import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:picpee_mobile/config/paypal_config.dart';
import 'package:picpee_mobile/services/transaction_service.dart';

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
  final TransactionService _transactionService = TransactionService();

  // Khởi tạo thanh toán PayPal với error handling
  Future<PaymentResult> initiatePayPalPayment(
    BuildContext context,
    double amount,
    String jwtToken,
  ) async {
    try {
      // Validate input
      if (amount <= 0) {
        _showErrorDialog(context, "Invalid amount");
        return PaymentResult(
          success: false,
          errorMessage: "Amount must be greater than 0",
        );
      }

      if (jwtToken.isEmpty) {
        _showErrorDialog(context, "Authentication required");
        return PaymentResult(
          success: false,
          errorMessage: "Please login first",
        );
      }

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
                  "details": {
                    "subtotal": amount.toStringAsFixed(2),
                    "shipping": "0.00",
                    "shipping_discount": 0,
                  },
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
              print('✅ PayPal onSuccess called');
              print('📦 Params: $params');

              // FIXED: Check if context is still mounted
              if (!context.mounted) {
                print('⚠️ Context is not mounted, skipping navigation');
                return;
              }

              Navigator.pop(context);

              if (params.isEmpty) {
                if (context.mounted) {
                  _showErrorDialog(context, "Invalid PayPal response");
                }
                return;
              }

              String? paymentId;
              String? payerId;

              try {
                if (params.containsKey('data') && params['data'] is Map) {
                  final data = params['data'] as Map;

                  if (data.containsKey('id')) {
                    paymentId = data['id'] as String?;
                  }

                  if (data.containsKey('payer') && data['payer'] is Map) {
                    final payer = data['payer'] as Map;
                    if (payer.containsKey('payer_info') &&
                        payer['payer_info'] is Map) {
                      final payerInfo = payer['payer_info'] as Map;
                      if (payerInfo.containsKey('payer_id')) {
                        payerId = payerInfo['payer_id'] as String?;
                      }
                    }
                  }
                }

                if (paymentId == null) {
                  if (params.containsKey('paymentId')) {
                    paymentId = params['paymentId'] as String?;
                  } else if (params.containsKey('id')) {
                    paymentId = params['id'] as String?;
                  }
                }

                if (payerId == null && params.containsKey('payerID')) {
                  payerId = params['payerID'] as String?;
                }
              } catch (e) {
                print('❌ Error parsing PayPal response: $e');
              }

              print('💳 Payment ID: $paymentId');
              print('👤 Payer ID: $payerId');

              if (paymentId != null && paymentId.isNotEmpty) {
                // FIXED: Check context before processing
                if (context.mounted) {
                  await _processBackendTransaction(
                    context,
                    paymentId,
                    amount,
                    jwtToken,
                    payerId: payerId,
                  );
                }
              } else {
                print('❌ Payment ID not found in params');
                if (context.mounted) {
                  _showErrorDialog(
                    context,
                    'Payment completed but ID not found.',
                  );
                }
              }
            },
            onError: (error) {
              print('❌ PayPal onError: $error');
              if (context.mounted) {
                Navigator.pop(context);
                _showErrorDialog(context, "Payment Error: ${error.toString()}");
              }
            },
            onCancel: () {
              print('⚠️ PayPal onCancel');
              if (context.mounted) {
                Navigator.pop(context);
                _showInfoDialog(
                  context,
                  "Payment Cancelled",
                  "You cancelled the payment process.",
                );
              }
            },
          ),
        ),
      );

      return PaymentResult(success: true);
    } catch (e) {
      print('❌ Exception in initiatePayPalPayment: $e');
      return PaymentResult(
        success: false,
        errorMessage: "Failed to initiate PayPal payment: ${e.toString()}",
      );
    }
  }

  // Xử lý transaction với backend
  Future<void> _processBackendTransaction(
    BuildContext context,
    String paymentId,
    double amount,
    String jwtToken, {
    String? payerId,
  }) async {
    // FIXED: Check context before showing dialog
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Processing payment...', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      print('🔄 Processing backend transaction...');
      print('💳 Payment ID: $paymentId');
      print('💰 Amount: \$${amount.toStringAsFixed(2)}');

      // Gọi API backend
      final result = await _transactionService.createPayPalTransaction(
        transactionPaypalId: paymentId,
        amount: amount,
        type: 'DEPOSIT',
        jwtToken: jwtToken,
        description: 'Balance reload via PayPal',
      );

      print('📡 Backend response: ${result.success}');
      print('📝 Message: ${result.message}');

      // FIXED: Check context before closing dialog
      if (!context.mounted) return;
      Navigator.pop(context);

      if (result.success && result.data != null) {
        // Thành công
        print('✅ Transaction successful!');
        if (context.mounted) {
          await _showSuccessDialog(context, amount, result.data!);
        }
      } else {
        // Thất bại
        print('❌ Transaction failed: ${result.message}');
        if (context.mounted) {
          _showErrorDialog(
            context,
            result.message.isNotEmpty
                ? result.message
                : 'Transaction failed. Please contact support.',
          );
        }
      }
    } catch (e) {
      print('❌ Exception in _processBackendTransaction: $e');
      if (context.mounted) {
        Navigator.pop(context);
        _showErrorDialog(
          context,
          'Error processing transaction: ${e.toString()}',
        );
      }
    }
  }

  // Hiển thị dialog thành công
  Future<void> _showSuccessDialog(
    BuildContext context,
    double amount,
    dynamic transactionData,
  ) async {
    if (!context.mounted) return;

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
              Expanded(child: Text('Payment Successful!')),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      if (transactionData.code != null)
                        Text(
                          'Transaction Code: ${transactionData.code}',
                          style: TextStyle(fontSize: 14),
                        ),
                      if (transactionData.status != null)
                        Text(
                          'Status: ${transactionData.status}',
                          style: TextStyle(fontSize: 14, color: Colors.green),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (context.mounted) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Continue', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  // Hiển thị dialog lỗi
  void _showErrorDialog(BuildContext context, String message) {
    if (!context.mounted) return;

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
              Expanded(child: Text('Payment Failed')),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.length > 150
                      ? '${message.substring(0, 150)}...'
                      : message,
                ),
                SizedBox(height: 12),
                Text(
                  'If this issue persists, please contact our support team.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (context.mounted) Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Hiển thị dialog thông tin
  void _showInfoDialog(BuildContext context, String title, String message) {
    if (!context.mounted) return;

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
              onPressed: () {
                if (context.mounted) Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
