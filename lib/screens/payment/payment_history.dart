import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:picpee_mobile/core/utils/payment_data.dart';
import 'package:picpee_mobile/models/payment_model.dart';

class PaymentHistoryScreen extends StatefulWidget {
  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  String selectedType = 'All';
  DateTime? selectedDate;
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  List<PaymentModel> payments = defaulPayments;
  List<PaymentModel> get filteredPayments {
    List<PaymentModel> filtered = payments;

    // Filter by type
    if (selectedType != 'All') {
      filtered = filtered
          .where((payment) => payment.type == selectedType)
          .toList();
    }

    // Filter by date
    if (selectedDate != null) {
      String selectedDateStr = dateFormat.format(selectedDate!);
      filtered = filtered
          .where((payment) => payment.date == selectedDateStr)
          .toList();
    }

    return filtered;
  }

  void _showPaymentDetails(PaymentModel payment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Details'),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('ID', payment.id.toString()),
                _buildDetailRow('Transaction Code', payment.code),
                _buildDetailRow('Date', payment.date),
                _buildDetailRow(
                  'Amount',
                  payment.amount > 0
                      ? '+\$${payment.amount.toStringAsFixed(2)}'
                      : '-\$${payment.amount.abs().toStringAsFixed(2)}',
                ),
                _buildDetailRow('Type', payment.type),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Payment History',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18.h,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!, width: 1.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: TextEditingController(
                        text: selectedDate != null
                            ? dateFormat.format(selectedDate!)
                            : '',
                      ),
                      decoration: InputDecoration(
                        hintText: 'Date',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        suffixIcon: selectedDate != null
                            ? IconButton(
                                icon: Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    selectedDate = null;
                                  });
                                },
                              )
                            : Icon(Icons.calendar_today, color: Colors.grey),
                      ),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      readOnly: true,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!, width: 1.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                      ),
                      items: ['All', 'Order payment', 'Deposit'].map((
                        String type,
                      ) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedType = newValue!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Header Row
          Container(
            color: Color(0xFFE8E3F3),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Date',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Amount',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Type',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Payment List
          Expanded(
            child: ListView.builder(
              itemCount: filteredPayments.length,
              itemBuilder: (context, index) {
                final payment = filteredPayments[index];
                return GestureDetector(
                  onTap: () => _showPaymentDetails(payment),
                  child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: 1),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            payment.date,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            payment.amount > 0
                                ? '+\$${payment.amount.toStringAsFixed(2)}'
                                : '-\$${payment.amount.abs().toStringAsFixed(2)}',
                            style: TextStyle(
                              color: payment.amount > 0
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            payment.type,
                            style: TextStyle(
                              color: payment.amount > 0
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
