class TransactionRequest {
  final String transactionPaypalId;
  final String paymentMethod;
  final double price;
  final String type;
  final String? description;

  TransactionRequest({
    required this.transactionPaypalId,
    required this.paymentMethod,
    required this.price,
    required this.type,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'transactionPaypalId': transactionPaypalId,
      'paymentMethod': paymentMethod,
      'price': price,
      'type': type,
      if (description != null) 'description': description,
    };
  }
}

class TransactionResponse {
  final bool success;
  final String message;
  final TransactionData? data;

  TransactionResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? TransactionData.fromJson(json['data'])
          : null,
    );
  }
}

class TransactionData {
  final int id;
  final int userSourceId;
  final String userSourceEmail;
  final int userDestId;
  final String userDestEmail;
  final String code;
  final String paymentMethod;
  final int transactionTime;
  final double amount;
  final String currency;
  final String status;
  final String type;
  final String? description;
  final String transactionPaypalId;
  final String statusPartner;

  TransactionData({
    required this.id,
    required this.userSourceId,
    required this.userSourceEmail,
    required this.userDestId,
    required this.userDestEmail,
    required this.code,
    required this.paymentMethod,
    required this.transactionTime,
    required this.amount,
    required this.currency,
    required this.status,
    required this.type,
    this.description,
    required this.transactionPaypalId,
    required this.statusPartner,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      id: json['id'] ?? 0,
      userSourceId: json['userSourceId'] ?? 0,
      userSourceEmail: json['userSourceEmail'] ?? '',
      userDestId: json['userDestId'] ?? 0,
      userDestEmail: json['userDestEmail'] ?? '',
      code: json['code'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      transactionTime: json['transactionTime'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      status: json['status'] ?? '',
      type: json['type'] ?? '',
      description: json['description'],
      transactionPaypalId: json['transactionPaypalId'] ?? '',
      statusPartner: json['statusPartner'] ?? '',
    );
  }
}
