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
    required String type,
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
      print('📡 Calling API: $baseUrl/transaction/paypal');
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

        // Kiểm tra result field
        if (responseData['result'] == true) {
          return TransactionResponse.fromJson(responseData);
        } else {
          // Backend trả về result: false
          return TransactionResponse(
            result: false,
            code: responseData['code'] ?? -1,
            message: responseData['message'] ?? 'Transaction failed',
          );
        }
      } else if (response.statusCode == 400) {
        // Bad Request - Parse error message
        try {
          final errorData = jsonDecode(response.body);
          return TransactionResponse(
            result: false,
            code: errorData['code'] ?? 1002,
            message:
                errorData['message'] ??
                errorData['description'] ??
                'Transaction failed',
          );
        } catch (e) {
          return TransactionResponse(
            result: false,
            code: 400,
            message: 'Bad request: ${response.body}',
          );
        }
      } else if (response.statusCode == 401) {
        return TransactionResponse(
          result: false,
          code: 401,
          message: 'Unauthorized. Please login again.',
        );
      } else if (response.statusCode == 500) {
        return TransactionResponse(
          result: false,
          code: 500,
          message: 'Server error. Please try again later.',
        );
      } else {
        return TransactionResponse(
          result: false,
          code: response.statusCode,
          message: 'Unexpected error: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ Error creating transaction: $e');
      return TransactionResponse(
        result: false,
        code: -1,
        message: 'Network error: ${e.toString()}',
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

      print('📡 Get PayPal Info - Status: ${response.statusCode}');
      print('📡 Get PayPal Info - Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('❌ Error getting PayPal payment info: $e');
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

      print('📡 Check Status - Status: ${response.statusCode}');
      print('📡 Check Status - Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('❌ Error checking transaction status: $e');
      return null;
    }
  }
}
