import 'package:intl/intl.dart';

class PaymentModel {
  final int id;
  final String code;
  final String date;
  final double amount;
  final String type;

  PaymentModel({
    required this.id,
    required this.code,
    required this.date,
    required this.amount,
    required this.type,
  });

  DateTime get dateTime {
    return DateFormat('dd/MM/yyyy').parse(date);
  }
}
