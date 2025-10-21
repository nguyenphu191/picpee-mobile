import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:picpee_mobile/core/utils/encryption.dart';
import 'package:picpee_mobile/models/transaction_model.dart';
import 'package:picpee_mobile/core/utils/url.dart' show Url;

class TransactionService {
  final String baseUrl = Url.baseUrl;

  Future<TransactionResponse> createPayPalTransaction({
    required String transactionPaypalId,
    required double amount,
    required String type, // "DEPOSIT" or "WITHDRAW"
    required String jwtToken,
    String? description,
  }) async {
    try {
      // 1. Tạo request object
      final transactionReq = TransactionRequest(
        transactionPaypalId: transactionPaypalId,
        paymentMethod: 'PAYPAL',
        price: amount,
        type: type,
        description: description ?? 'Balance reload via PayPal',
      );

      // 2. Convert to JSON string
      final jsonString = jsonEncode(transactionReq.toJson());
      print('📝 Original JSON: $jsonString');

      // 3. Mã hóa dữ liệu
      final encryptedData = EncryptionUtil.encryptString(jsonString);
      print('🔒 Encrypted data: $encryptedData');

      // 4. Gọi API
      final response = await http.post(
        Uri.parse('$baseUrl/transaction/paypal'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode({'data': encryptedData}),
      );

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      // 5. Parse response
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return TransactionResponse.fromJson(responseData);
      } else {
        final errorData = jsonDecode(response.body);
        return TransactionResponse(
          success: false,
          message: errorData['message'] ?? 'Transaction failed',
        );
      }
    } catch (e) {
      print('❌ Error creating transaction: $e');
      return TransactionResponse(
        success: false,
        message: 'Error: ${e.toString()}',
      );
    }
  }

  Future<Map<String, dynamic>?> getPayPalPaymentInfo({
    required String paypalId,
    required String jwtToken,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/transaction/get-info-paypal-id/$paypalId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error getting PayPal payment info: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> checkTransactionStatus({
    required int transactionId,
    required String jwtToken,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/transaction/check-info/$transactionId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error checking transaction status: $e');
      return null;
    }
  }
}
