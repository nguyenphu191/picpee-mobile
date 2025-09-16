import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlogDataTable extends StatelessWidget {
  final List<List<String>> data;
  final List<double>? columnWidths;
  final double? maxHeight;
  final bool enableVerticalScroll;

  const BlogDataTable({
    Key? key,
    required this.data,
    this.columnWidths,
    this.maxHeight,
    this.enableVerticalScroll = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return SizedBox.shrink();

    Widget tableWidget = _buildTable(context);

    if (maxHeight != null || enableVerticalScroll) {
      tableWidget = Container(
        height: maxHeight,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: tableWidget,
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: tableWidget,
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data.asMap().entries.map((entry) {
          final index = entry.key;
          final row = entry.value;
          final isHeader = index == 0;

          return Container(
            decoration: BoxDecoration(
              color: isHeader
                  ? const Color.fromARGB(255, 249, 250, 168)
                  : Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
            ),
            child: Row(
              children: row.asMap().entries.map((cellEntry) {
                final cellIndex = cellEntry.key;
                final cell = cellEntry.value;

                return Container(
                  height: isHeader ? 40.h : 66.h,
                  width: _getCellWidth(cellIndex, context),
                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5.h),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.grey, width: 1),
                      left: cellIndex == 0
                          ? BorderSide(color: Colors.grey, width: 1)
                          : BorderSide.none,
                    ),
                  ),
                  child: Text(
                    cell,
                    style: isHeader
                        ? TextStyle(
                            fontSize: 12.h,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          )
                        : TextStyle(fontSize: 11.h, color: Colors.black87),
                    textAlign: TextAlign.left,
                    maxLines: null,
                    overflow: TextOverflow.visible,
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }

  double _getCellWidth(int columnIndex, BuildContext context) {
    if (columnWidths != null && columnIndex < columnWidths!.length) {
      // Tính toán width dựa trên tỷ lệ
      final totalFlex = columnWidths!.reduce((a, b) => a + b);
      final availableWidth =
          MediaQuery.of(context).size.width - 80.h; // Trừ padding
      return (columnWidths![columnIndex] / totalFlex) * availableWidth;
    }

    // Default width nếu không có columnWidths
    final numColumns = data.isNotEmpty ? data[0].length : 1;
    return (MediaQuery.of(context).size.width - 80.h) / numColumns;
  }
}
