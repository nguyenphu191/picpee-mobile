import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/core/utils/service_hard_data.dart';
import 'package:picpee_mobile/widgets/profile_header.dart';
import 'package:picpee_mobile/widgets/sidebar.dart';
import 'package:picpee_mobile/screens/services-vendor/service-vendor-widget/custom_dropdown_field.dart';
import 'package:picpee_mobile/screens/services-vendor/service-vendor-widget/price_input_field.dart';
import 'package:picpee_mobile/screens/services-vendor/service-vendor-widget/checkbox_option_widget.dart';
import 'package:picpee_mobile/screens/services-vendor/service-vendor-widget/portfolio_section_widget.dart';

class ServiceDetailScreen extends StatefulWidget {
  final ServiceItem service;

  const ServiceDetailScreen({Key? key, required this.service})
    : super(key: key);

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  String selectedTurnaround = '12 hours';
  String selectedPhotoEdits = 'Up to 100';
  List<bool> selectedOptions = [];
  List<TextEditingController> optionPriceControllers = [];
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedOptions = List.filled(widget.service.options.length, false);
    _priceController.text = '0';
    optionPriceControllers = List.generate(
      widget.service.options.length,
      (index) => TextEditingController(text: '0'),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    // Dispose tất cả option price controllers
    for (var controller in optionPriceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      drawer: const SideBar(selectedIndex: 5),
      body: Stack(
        children: [
          Positioned(
            top: 80.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              margin: EdgeInsets.all(16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.arrow_back,
                            size: 22.h,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            widget.service.title,
                            style: TextStyle(
                              fontSize: 22.h,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),
                    // Verified Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                AppImages.VerifiedIcon,
                                height: 22.h,
                                width: 22.h,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Verified',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // Description
                    Text(
                      widget.service.description,
                      style: TextStyle(
                        fontSize: 14.h,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Base tier services
                    Text(
                      'Base tier services:',
                      style: TextStyle(
                        fontSize: 16.h,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Price Input Field
                    PriceInputField(
                      label: 'Price',
                      controller: _priceController,
                      suffix: 'per photo',
                    ),

                    SizedBox(height: 16.h),

                    // Turnaround time dropdown
                    CustomDropdownField(
                      label: 'Turnaround time',
                      value: selectedTurnaround,
                      items: ['12 hours', '24 hours', '48 hours', '72 hours'],
                      onChanged: (value) {
                        setState(() {
                          selectedTurnaround = value!;
                        });
                      },
                    ),

                    SizedBox(height: 16.h),

                    // Photo edits dropdown
                    CustomDropdownField(
                      label: 'Photo edits per 12 hours',
                      value: selectedPhotoEdits,
                      items: [
                        'Up to 50',
                        'Up to 100',
                        'Up to 200',
                        'Up to 500',
                        'Up to 1000',
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedPhotoEdits = value!;
                        });
                      },
                    ),

                    SizedBox(height: 24.h),

                    // Add-ons Section
                    if (widget.service.options.isNotEmpty) ...[
                      Text(
                        'Add-ons:',
                        style: TextStyle(
                          fontSize: 16.h,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Options List
                      ...widget.service.options.asMap().entries.map((entry) {
                        int index = entry.key;
                        OptionItem option = entry.value;

                        return CheckboxOptionWidget(
                          title: option.option,
                          value: selectedOptions[index],
                          index: index,
                          priceController: optionPriceControllers[index],
                          onChanged: (value) {
                            setState(() {
                              selectedOptions[index] = value!;
                              // Reset price to 0 when unchecked
                              if (!value) {
                                optionPriceControllers[index].text = '0';
                              }
                            });
                          },
                        );
                      }).toList(),
                    ],

                    SizedBox(height: 24.h),

                    // Portfolio Section
                    Text(
                      'Portfolio:',
                      style: TextStyle(
                        fontSize: 16.h,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    PortfolioSectionWidget(serviceTitle: widget.service.title),

                    SizedBox(height: 16.h),
                    // Save Button
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              List<Map<String, dynamic>> selectedOptionsData =
                                  [];
                              for (int i = 0; i < selectedOptions.length; i++) {
                                if (selectedOptions[i]) {
                                  selectedOptionsData.add({
                                    'option': widget.service.options[i].option,
                                    'price':
                                        double.tryParse(
                                          optionPriceControllers[i].text,
                                        ) ??
                                        0.0,
                                  });
                                }
                              }
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonGreen,
                              padding: EdgeInsets.symmetric(
                                vertical: 8.h,
                                horizontal: 12.w,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Save change',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.h,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ),

          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ProfileHeader(title: 'Overview'),
          ),
        ],
      ),
    );
  }
}
