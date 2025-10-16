import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/core/utils/service_hard_data.dart';
import 'package:picpee_mobile/models/designer_model.dart';
import 'package:picpee_mobile/models/skill_of_vendor_model.dart';
import 'package:picpee_mobile/models/top_notch_clipper.dart';
import 'package:picpee_mobile/providers/project_provider.dart';
import 'package:picpee_mobile/screens/order/order_widget/find_designer_dia.dart';
import 'package:provider/provider.dart';

class AddOrderCard extends StatefulWidget {
  const AddOrderCard({super.key, this.designer, this.skill});
  final DesignerModel? designer;
  final SkillOfVendorModel? skill;

  @override
  State<AddOrderCard> createState() => _AddOrderCardState();
}

class _AddOrderCardState extends State<AddOrderCard> {
  String? selectedService;
  String? selectedDesigner;
  DateTime? selectedDateTime;
  late TextEditingController _guidelinesController;
  late TextEditingController _sourceFilesController;
  late TextEditingController _finishLinksController;
  final List<ServiceItem> services = servicesData;
  final List<Map<String, String>> designerInProject = [
    {"id": "1", "name": "Designer 1", "image": AppImages.BackgroundReplaceIcon},
    {"id": "2", "name": "Designer 2", "image": AppImages.LawnReplacementIcon},
    {"id": "3", "name": "Designer 3", "image": AppImages.DiscountIcon},
  ];
  String _formatPrice(double price) {
    if (price == price.toInt()) {
      return price.toInt().toString();
    }
    String fixed = price.toStringAsFixed(2);
    if (fixed.endsWith('0')) {
      return price.toStringAsFixed(1);
    }
    return fixed;
  }
  @override
  void initState() {
    super.initState();
    // Khởi tạo với giá trị được truyền vào
    if (widget.designer != null) {
      selectedDesigner = widget.designer!.businessName;
    }
    if (widget.skill != null) {
      selectedService = widget.skill!.skillName;
    }
    selectedDateTime = null;
    _guidelinesController = TextEditingController();
    _sourceFilesController = TextEditingController();
    _finishLinksController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProjects();
    });
  }
  

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchProjects() async {
    final projectProvider = Provider.of<ProjectProvider>(
      context,
      listen: false,
    );
    final success = await projectProvider.fetchProjects();
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load projects'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: size.height * 0.8,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.transparent),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80.h,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.background3),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  border: Border.all(
                    color: const Color.fromARGB(255, 11, 121, 14),
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 16.w,
                      top: 16.h,
                      child: Text(
                        'New Order',
                        style: TextStyle(
                          fontSize: 14.h,
                          fontWeight: FontWeight.bold,
                          color: AppColors.buttonGreen,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16.h,
                      right: 16.w,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 24.h,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 20.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 52.h,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: TopNotchClipper(),
                child: Container(
                  height: size.height * 0.8 - 52.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),
                        Container(
                          width: double.infinity,
                          child: Text(
                            'Information',
                            style: TextStyle(
                              fontSize: 16.h,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Divider(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select a service',
                              style: TextStyle(
                                fontSize: 14.h,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            // Kiểm tra nếu skill đã được truyền vào
                            widget.skill != null
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 12.h,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(6),
                                      color: Colors.grey[100],
                                    ),
                                    child: Text(
                                      selectedService ?? '',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.h,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                : Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      underline: SizedBox(),
                                      hint: Text(
                                        selectedService ?? 'Select a service',
                                        style: TextStyle(
                                          color: selectedService != null
                                              ? Colors.black
                                              : Colors.grey,
                                          fontSize: 14.h,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontSize: 14.h,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      menuMaxHeight: 200.h,
                                      items: services
                                          .map(
                                            (
                                              ServiceItem service,
                                            ) => DropdownMenuItem<String>(
                                              value: service.title,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 30.w,
                                                    height: 30.h,
                                                    margin: EdgeInsets.only(
                                                      right: 8.w,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                          service.image,
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                    ),
                                                  ),
                                                  Text(service.title),
                                                ],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedService = value;
                                        });
                                      },
                                    ),
                                  ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choose a designer',
                              style: TextStyle(
                                fontSize: 14.h,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            // Kiểm tra nếu designer đã được truyền vào
                            widget.designer != null
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 12.h,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(6),
                                      color: Colors.grey[100],
                                    ),
                                    child: Text(
                                      selectedDesigner ?? '',
                                      style: TextStyle(
                                        fontSize: 14.h,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                : Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      underline: SizedBox(),
                                      hint: Text(
                                        selectedDesigner ?? 'Choose a designer',
                                        style: TextStyle(
                                          fontSize: 14.h,
                                          color: selectedDesigner != null
                                              ? Colors.black87
                                              : Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontSize: 14.h,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      menuMaxHeight: 200.h,
                                      items: [
                                        ...designerInProject
                                            .map(
                                              (
                                                designer,
                                              ) => DropdownMenuItem<String>(
                                                value: designer['name'],
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 30.w,
                                                      height: 30.h,
                                                      margin: EdgeInsets.only(
                                                        right: 8.w,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                            designer['image']!,
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                    ),
                                                    Text(designer['name']!),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        DropdownMenuItem<String>(
                                          value: "see_all",
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 30.w,
                                                height: 30.h,
                                                margin: EdgeInsets.only(
                                                  right: 8.w,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Icon(
                                                  Icons.more_horiz,
                                                  color: Colors.black,
                                                  size: 20.h,
                                                ),
                                              ),
                                              Text(
                                                "See All Designers",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                      onChanged: (value) async {
                                        if (value == "see_all") {
                                          final selectedDesignerData =
                                              await showDialog<
                                                Map<String, String>
                                              >(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        FindDesigner(),
                                              );

                                          if (selectedDesignerData != null) {
                                            setState(() {
                                              selectedDesigner =
                                                  selectedDesignerData['name'];
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            selectedDesigner = value;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                          ],
                        ),

                        SizedBox(height: 10.h),

                        Text(
                          'Due date',
                          style: TextStyle(
                            fontSize: 14.h,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            );

                            if (pickedDate != null) {
                              final int? selectedHour = await showDialog<int>(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Container(
                                      width: double.maxFinite,
                                      padding: EdgeInsets.all(16.h),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Select Hour',
                                            style: TextStyle(
                                              fontSize: 18.h,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 24.h),

                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 8.h,
                                                  horizontal: 12.w,
                                                ),

                                                child: Text(
                                                  'AM',
                                                  style: TextStyle(
                                                    fontSize: 16.h,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColors.buttonGreen,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 12.h),
                                              GridView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 4,
                                                      childAspectRatio: 1.5,
                                                      crossAxisSpacing: 8.w,
                                                      mainAxisSpacing: 8.h,
                                                    ),
                                                itemCount: 12,
                                                itemBuilder: (context, index) {
                                                  String displayHour = index
                                                      .toString();

                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.of(
                                                        context,
                                                      ).pop(index);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                        border: Border.all(
                                                          color:
                                                              Colors.grey[300]!,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                  0.05,
                                                                ),
                                                            spreadRadius: 1,
                                                            blurRadius: 2,
                                                            offset: Offset(
                                                              0,
                                                              1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '$displayHour AM',
                                                          style: TextStyle(
                                                            fontSize: 14.h,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 24.h),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 8.h,
                                                  horizontal: 12.w,
                                                ),

                                                child: Text(
                                                  'PM',
                                                  style: TextStyle(
                                                    fontSize: 16.h,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.orange[700],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 12.h),
                                              GridView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 4,
                                                      childAspectRatio: 1.5,
                                                      crossAxisSpacing: 8.w,
                                                      mainAxisSpacing: 8.h,
                                                    ),
                                                itemCount: 12,
                                                itemBuilder: (context, index) {
                                                  String displayHour = index
                                                      .toString();

                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.of(
                                                        context,
                                                      ).pop(index + 12);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                        border: Border.all(
                                                          color:
                                                              Colors.grey[300]!,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                  0.05,
                                                                ),
                                                            spreadRadius: 1,
                                                            blurRadius: 2,
                                                            offset: Offset(
                                                              0,
                                                              1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '$displayHour PM',
                                                          style: TextStyle(
                                                            fontSize: 14.h,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );

                              if (selectedHour != null) {
                                setState(() {
                                  selectedDateTime = DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    selectedHour,
                                    0,
                                  );
                                });
                              }
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    selectedDateTime != null
                                        ? '${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year} at ${selectedDateTime!.hour >= 12 ? (selectedDateTime!.hour - 12).toString() : selectedDateTime!.hour.toString()}:00 ${selectedDateTime!.hour >= 12 ? 'PM' : 'AM'}'
                                        : 'Choose the date you want to receive results',
                                    style: TextStyle(
                                      fontSize: 14.h,
                                      color: selectedDateTime != null
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(Icons.calendar_today, size: 18.h),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 10.h),

                        Text(
                          'Further guidelines',
                          style: TextStyle(
                            fontSize: 14.h,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextField(
                          maxLines: 2,
                          controller: _guidelinesController,
                          decoration: InputDecoration(
                            hintText:
                                'Optionally add some instructions or notes',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.h,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                          ),
                        ),

                        SizedBox(height: 16.h),

                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFFF3EBF7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: EdgeInsets.only(
                            top: 10.h,
                            bottom: 16.h,
                            left: 10.w,
                            right: 10.w,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Assets',
                                  style: TextStyle(
                                    fontSize: 16.h,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 10.h),

                              Text(
                                'Link to source files',
                                style: TextStyle(
                                  fontSize: 14.h,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextField(
                                controller: _sourceFilesController,

                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'http://example.com',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 8.h,
                                  ),
                                ),
                              ),
                              Text(
                                'The designer will download your files from this link.',
                                style: TextStyle(
                                  fontSize: 12.h,
                                  color: Colors.black54,
                                ),
                              ),

                              SizedBox(height: 10.h),

                              Text(
                                'Link for deliverable files upload',
                                style: TextStyle(
                                  fontSize: 14.h,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextField(
                                controller: _finishLinksController,
                                decoration: InputDecoration(
                                  hintText: 'http://example.com',
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.h,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 8.h,
                                  ),
                                ),
                              ),
                              Text(
                                'The designer will upload the final files to this folder.',
                                style: TextStyle(
                                  fontSize: 12.h,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16.h),

                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 12.w,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.lightGreenAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total',
                                        style: TextStyle(
                                          fontSize: 14.h,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'Qty: 0',
                                        style: TextStyle(
                                          fontSize: 12.h,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '\$24.00',
                                    style: TextStyle(
                                      fontSize: 16.h,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orangeAccent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Add to Cart',
                                      style: TextStyle(
                                        fontSize: 14.h,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.buttonGreen,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Order Now',
                                      style: TextStyle(
                                        fontSize: 14.h,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
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
            ),
          ],
        ),
      ),
    );
  }
}
