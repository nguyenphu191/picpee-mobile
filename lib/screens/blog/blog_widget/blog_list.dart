import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlogBulletList extends StatelessWidget {
  final List<Map<String, String>> items;
  final String titleKey;
  final String descriptionKey;
  final Color bulletColor;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final double spacing;
  final double bulletSize;
  final EdgeInsets? bulletMargin;
  final TextAlign textAlign;

  const BlogBulletList({
    Key? key,
    required this.items,
    required this.titleKey,
    required this.descriptionKey,
    this.bulletColor = Colors.black87,
    this.titleStyle,
    this.descriptionStyle,
    this.spacing = 16.0,
    this.bulletSize = 6.0,
    this.bulletMargin,
    this.textAlign = TextAlign.justify,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: bulletMargin ?? EdgeInsets.only(top: 6.h, right: 12.w),
                width: bulletSize,
                height: bulletSize,
                decoration: BoxDecoration(
                  color: bulletColor,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: RichText(
                  textAlign: textAlign,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: item[titleKey] ?? '',
                        style:
                            titleStyle ??
                            TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              height: 1.6,
                            ),
                      ),
                      TextSpan(
                        text: ' ${item[descriptionKey] ?? ''}',
                        style:
                            descriptionStyle ??
                            TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black87,
                              height: 1.6,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class SimpleBlogBulletList extends StatelessWidget {
  final List<String> items;
  final Color bulletColor;
  final TextStyle? textStyle;
  final double spacing;
  final double bulletSize;
  final EdgeInsets? bulletMargin;
  final TextAlign textAlign;

  const SimpleBlogBulletList({
    Key? key,
    required this.items,
    this.bulletColor = Colors.black87,
    this.textStyle,
    this.spacing = 12.0,
    this.bulletSize = 6.0,
    this.bulletMargin,
    this.textAlign = TextAlign.justify,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: bulletMargin ?? EdgeInsets.only(top: 6.h, right: 12.w),
                width: bulletSize,
                height: bulletSize,
                decoration: BoxDecoration(
                  color: bulletColor,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  item,
                  style:
                      textStyle ??
                      TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                  textAlign: textAlign,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
