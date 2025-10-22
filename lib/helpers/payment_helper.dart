class PayPalParser {
  /// Parse PayPal response và trích xuất các thông tin quan trọng
  static Map<String, String?> parsePaymentResponse(Map params) {
    String? paymentId;
    String? transactionId;
    String? saleId;
    String? authorizationId;
    String? payerId;
    String? payerEmail;
    String? state;
    String? amount;

    try {
      if (params.containsKey('data') && params['data'] is Map) {
        final data = params['data'] as Map;

        // Payment ID
        paymentId = data['id'] as String?;

        // Payment State
        state = data['state'] as String?;

        // Payer Information
        if (data.containsKey('payer') && data['payer'] is Map) {
          final payer = data['payer'] as Map;
          if (payer.containsKey('payer_info') && payer['payer_info'] is Map) {
            final payerInfo = payer['payer_info'] as Map;
            payerId = payerInfo['payer_id'] as String?;
            payerEmail = payerInfo['email'] as String?;
          }
        }

        // Transactions
        if (data.containsKey('transactions') && data['transactions'] is List) {
          final transactions = data['transactions'] as List;
          if (transactions.isNotEmpty && transactions[0] is Map) {
            final transaction = transactions[0] as Map;

            // Amount
            if (transaction.containsKey('amount') &&
                transaction['amount'] is Map) {
              final amountData = transaction['amount'] as Map;
              amount = amountData['total'] as String?;
            }

            // Related Resources (Transaction IDs)
            if (transaction.containsKey('related_resources') &&
                transaction['related_resources'] is List) {
              final resources = transaction['related_resources'] as List;
              if (resources.isNotEmpty && resources[0] is Map) {
                final resource = resources[0] as Map;

                // Sale ID (for completed payments)
                if (resource.containsKey('sale') && resource['sale'] is Map) {
                  final sale = resource['sale'] as Map;
                  saleId = sale['id'] as String?;
                  transactionId = saleId; // Use Sale ID as Transaction ID
                }
                // Authorization ID (for authorized but not captured)
                else if (resource.containsKey('authorization') &&
                    resource['authorization'] is Map) {
                  final authorization = resource['authorization'] as Map;
                  authorizationId = authorization['id'] as String?;
                  transactionId = authorizationId;
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print('❌ Error parsing PayPal response: $e');
    }

    return {
      'paymentId': paymentId,
      'transactionId': transactionId,
      'saleId': saleId,
      'authorizationId': authorizationId,
      'payerId': payerId,
      'payerEmail': payerEmail,
      'state': state,
      'amount': amount,
    };
  }

  /// Log chi tiết PayPal response
  static void logPayPalResponse(Map params) {
    print('=' * 70);
    print('📦 PAYPAL RESPONSE DETAILS');
    print('=' * 70);

    final parsed = parsePaymentResponse(params);

    print('\n🔑 Payment Information:');
    print('  Payment ID: ${parsed['paymentId'] ?? "NOT FOUND"}');
    print('  State: ${parsed['state'] ?? "NOT FOUND"}');
    print('  Amount: ${parsed['amount'] ?? "NOT FOUND"}');

    print('\n💳 Transaction Information:');
    print('  Transaction ID: ${parsed['transactionId'] ?? "NOT FOUND"}');
    print('  Sale ID: ${parsed['saleId'] ?? "NOT FOUND"}');
    print('  Authorization ID: ${parsed['authorizationId'] ?? "NOT FOUND"}');

    print('\n👤 Payer Information:');
    print('  Payer ID: ${parsed['payerId'] ?? "NOT FOUND"}');
    print('  Email: ${parsed['payerEmail'] ?? "NOT FOUND"}');

    print('\n' + '=' * 70);
  }
}
