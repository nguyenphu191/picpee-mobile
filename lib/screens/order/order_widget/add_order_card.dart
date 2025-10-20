import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/designer_model.dart';
import 'package:picpee_mobile/models/project_model.dart';
import 'package:picpee_mobile/models/skill_of_vendor_model.dart';
import 'package:picpee_mobile/models/top_notch_clipper.dart';
import 'package:picpee_mobile/models/user_model.dart';
import 'package:picpee_mobile/models/video_setting.dart';
import 'package:picpee_mobile/providers/designer_provider.dart';
import 'package:picpee_mobile/providers/order_provider.dart';
import 'package:picpee_mobile/providers/project_provider.dart';
import 'package:picpee_mobile/providers/skill_provider.dart';
import 'package:picpee_mobile/providers/user_provider.dart';
import 'package:picpee_mobile/screens/order/order_widget/orientation_widget.dart';
import 'package:picpee_mobile/screens/order/order_widget/purchase_order_card.dart';
import 'package:picpee_mobile/screens/order/order_widget/video_setting_widget.dart';
import 'package:picpee_mobile/screens/project/project_widget/create_new_project.dart';
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
  int? selectedSkillId;
  String? selectedDesigner;
  int? selectedVendorId;
  SkillOfVendorModel? selectedSkillOfVendor;
  ProjectModel? selectedProject;
  DateTime? selectedDateTime;
  List<AddOnModel> selectedAddOns = [];
  late TextEditingController _guidelinesController;
  late TextEditingController _sourceFilesController;
  late TextEditingController _finishLinksController;

  int _quantity = 1;

  // Video Settings (for PROPERTY VIDEOS SERVICES)
  VideoSettings _videoSettings = VideoSettings();
  double get totalPrice {
    final double baseCost =
        selectedSkillOfVendor?.cost ?? widget.skill?.cost ?? 0.0;
    final double addOnsCost = selectedAddOns.fold(
      0.0,
      (sum, addOn) => sum + addOn.cost,
    );
    return (baseCost + addOnsCost) * _quantity;
  }

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
    if (widget.designer != null) {
      selectedDesigner = widget.designer!.businessName;
      selectedVendorId = widget.designer!.userId;
    }
    if (widget.skill != null) {
      selectedService = widget.skill!.skillName;
      selectedSkillId = widget.skill!.skillId;
      selectedSkillOfVendor = widget.skill;
    }
    selectedDateTime = null;
    _guidelinesController = TextEditingController();
    _sourceFilesController = TextEditingController();
    _finishLinksController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProjects();
      if (widget.skill != null) {
        _fetchAddOn();
      }
    });
  }

  @override
  void dispose() {
    _guidelinesController.dispose();
    _sourceFilesController.dispose();
    _finishLinksController.dispose();
    selectedAddOns.clear();
    selectedSkillOfVendor = null;
    selectedProject = null;

    super.dispose();
  }

  Future<void> _fetchProjects() async {
    final projectProvider = Provider.of<ProjectProvider>(
      context,
      listen: false,
    );
    final success = await projectProvider.fetchProjects();
    if (!success && mounted) {
      _showOverlaySnackBar(
        'Failed to load projects',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _fetchAddOn() async {
    if (selectedSkillOfVendor == null) return;

    final skillProject = Provider.of<SkillProvider>(context, listen: false);
    final success = await skillProject.fetchAddOns(
      selectedSkillOfVendor!.skillId,
      selectedSkillOfVendor!.userId,
    );
    if (!success && mounted) {
      _showOverlaySnackBar(
        'Failed to load add-ons',
        backgroundColor: Colors.red,
      );
    }
  }

  void _showOverlaySnackBar(
    String message, {
    Color backgroundColor = Colors.red,
  }) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 16.h,
        left: 16.w,
        right: 16.w,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.h,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(Duration(seconds: 2), () {
      entry.remove();
    });
  }

  bool isValidUrl(String url) {
    final pattern =
        r'^(https?:\/\/)?([a-zA-Z0-9.-]+)\.[a-zA-Z]{2,}(:\d+)?(\/\S*)?$';
    final regex = RegExp(pattern);
    return regex.hasMatch(url.trim());
  }

  bool _checkOrderDetails() {
    if (selectedService == null) {
      _showOverlaySnackBar('Please select a service');
      return false;
    }
    if (selectedDesigner == null) {
      _showOverlaySnackBar('Please select a designer');
      return false;
    }
    if (selectedSkillOfVendor == null) {
      _showOverlaySnackBar('Please wait for skill data to load');
      return false;
    }
    if (selectedProject == null) {
      _showOverlaySnackBar('Please select a project');
      return false;
    }
    if (_sourceFilesController.text == "" ||
        !isValidUrl(_sourceFilesController.text)) {
      _showOverlaySnackBar('Please provide a valid source files link');
      return false;
    }
    if (_finishLinksController.text == "" ||
        !isValidUrl(_finishLinksController.text)) {
      _showOverlaySnackBar('Please provide a valid finished links');
      return false;
    }
    return true;
  }

  Future<void> _addToCart(bool purchase) async {
    User? user = Provider.of<UserProvider>(context, listen: false).user;
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    if (user == null) {
      _showOverlaySnackBar('User not logged in');
      return;
    }
    if (selectedSkillOfVendor == null) {
      _showOverlaySnackBar('Skill data not available');
      return;
    }
    List<Map<String, int>> addons = selectedAddOns
        .map((addOn) => {"id": addOn.userAddonsId})
        .toList();

    Map<String, dynamic> orderData = {
      "cost": totalPrice,
      "customerId": user.id,
      "deliverableFilesLink": _finishLinksController.text.trim(),
      "projectId": selectedProject!.id,
      "quantity": _quantity,
      "skillId": selectedSkillOfVendor!.skillId,
      "sourceFilesLink": _sourceFilesController.text.trim(),
      "userAddons": addons,
      "vendorId": selectedSkillOfVendor!.userId,
    };
    print("Creating order with data: $orderData");
    final success = await orderProvider.createOrder(orderData);
    if (success) {
      _showOverlaySnackBar(
        'Order added to cart successfully',
        backgroundColor: Colors.green,
      );
      Navigator.of(context).pop();
      if (purchase) {
        showDialog(
          context: context,
          builder: (context) =>
              PurchaseOrderCard(order: orderProvider.currentOrder!),
        );
      }
    } else {
      _showOverlaySnackBar('Failed to add order to cart');
      return;
    }
  }

  Future<void> _refreshProjects() async {
    await _fetchProjects();
  }

  Future<void> fetchAllService() async {
    try {
      final skillProvider = Provider.of<SkillProvider>(context, listen: false);
      final success = await skillProvider.fetchAllSkills();
      if (!success && mounted) {
        _showOverlaySnackBar(
          'Failed to load skills',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      print("Error fetching all skills: $e");
    }
  }

  Future<void> _fetchVendor(int skillId) async {
    final designerProvider = Provider.of<DesignerProvider>(
      context,
      listen: false,
    );
    final res = await designerProvider.fetchAllVendorForSkill(skillId);
    if (!res && mounted) {
      _showOverlaySnackBar(
        'Failed to load vendors',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _fetchSkillOfVendor(int skillId, int vendorId) async {
    final skillProvider = Provider.of<SkillProvider>(context, listen: false);
    final succes = await skillProvider.fetchSkillsOfVendor(vendorId);
    if (succes) {
      setState(() {
        selectedSkillOfVendor = skillProvider.skillsOfVendor.firstWhere(
          (skill) => skill.skillId == skillId,
        );
      });
    } else if (mounted) {
      _showOverlaySnackBar(
        'Failed to load skill details',
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer3<ProjectProvider, SkillProvider, DesignerProvider>(
      builder: (context, projectProvider, skillProvider, designerProvider, child) {
        final projects = projectProvider.projects;
        final addOns = skillProvider.getAddOns;
        final allSkills = skillProvider.allSkills;
        final vendors = designerProvider.allVendorsForSkill;

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
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
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

                            // Service Selection
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
                                widget.skill != null
                                    ? Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 8.h,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
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
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: DropdownButton<int>(
                                          isExpanded: true,
                                          underline: SizedBox(),
                                          hint: Text(
                                            selectedService ??
                                                'Select a service',
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
                                          items: allSkills.map((skill) {
                                            return DropdownMenuItem<int>(
                                              value: skill.id,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 30.h,
                                                    height: 30.h,
                                                    margin: EdgeInsets.only(
                                                      right: 8.w,
                                                    ),
                                                    child: Image.network(
                                                      skill.urlImage.trim(),
                                                      fit: BoxFit.cover,
                                                      loadingBuilder:
                                                          (
                                                            context,
                                                            child,
                                                            loadingProgress,
                                                          ) {
                                                            if (loadingProgress ==
                                                                null)
                                                              return child;
                                                            return Center(
                                                              child: CircularProgressIndicator(
                                                                color: AppColors
                                                                    .buttonGreen,
                                                                value:
                                                                    loadingProgress
                                                                            .expectedTotalBytes !=
                                                                        null
                                                                    ? loadingProgress
                                                                              .cumulativeBytesLoaded /
                                                                          loadingProgress
                                                                              .expectedTotalBytes!
                                                                    : null,
                                                              ),
                                                            );
                                                          },
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) {
                                                            return Container(
                                                              color: Colors
                                                                  .grey[300],
                                                              child: const Icon(
                                                                Icons.person,
                                                                size: 20,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            );
                                                          },
                                                    ),
                                                  ),
                                                  Text(skill.name),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (int? skillId) async {
                                            if (skillId != null) {
                                              setState(() {
                                                selectedSkillId = skillId;
                                                selectedService = allSkills
                                                    .firstWhere(
                                                      (s) => s.id == skillId,
                                                    )
                                                    .name;
                                                selectedDesigner = null;
                                                selectedVendorId = null;
                                                selectedSkillOfVendor = null;
                                                selectedAddOns.clear();
                                              });
                                              await _fetchVendor(skillId);
                                            }
                                          },
                                          onTap: () {
                                            if (allSkills.isEmpty) {
                                              fetchAllService();
                                            }
                                          },
                                        ),
                                      ),
                              ],
                            ),

                            // Designer Selection
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
                                widget.designer != null
                                    ? Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 8.h,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
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
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: DropdownButton<int>(
                                          isExpanded: true,
                                          underline: SizedBox(),
                                          hint: Text(
                                            selectedDesigner ??
                                                'Choose a designer',
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
                                          items: vendors.map((vendor) {
                                            return DropdownMenuItem<int>(
                                              value: vendor.userId,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 30.h,
                                                    height: 30.h,
                                                    margin: EdgeInsets.only(
                                                      right: 8.w,
                                                    ),
                                                    child: ClipOval(
                                                      child: Image.network(
                                                        vendor.avatar.trim(),
                                                        height: 30.h,
                                                        width: 30.h,
                                                        fit: BoxFit.cover,
                                                        loadingBuilder:
                                                            (
                                                              context,
                                                              child,
                                                              loadingProgress,
                                                            ) {
                                                              if (loadingProgress ==
                                                                  null)
                                                                return child;
                                                              return Center(
                                                                child: CircularProgressIndicator(
                                                                  color: AppColors
                                                                      .buttonGreen,
                                                                  value:
                                                                      loadingProgress
                                                                              .expectedTotalBytes !=
                                                                          null
                                                                      ? loadingProgress.cumulativeBytesLoaded /
                                                                            loadingProgress.expectedTotalBytes!
                                                                      : null,
                                                                ),
                                                              );
                                                            },
                                                        errorBuilder:
                                                            (
                                                              context,
                                                              error,
                                                              stackTrace,
                                                            ) {
                                                              return Container(
                                                                color: Colors
                                                                    .grey[300],
                                                                child: const Icon(
                                                                  Icons.person,
                                                                  size: 20,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              );
                                                            },
                                                      ),
                                                    ),
                                                  ),
                                                  Text(vendor.businessName),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: selectedSkillId == null
                                              ? null
                                              : (int? vendorId) async {
                                                  if (vendorId != null &&
                                                      selectedSkillId != null) {
                                                    final vendor = vendors
                                                        .firstWhere(
                                                          (v) =>
                                                              v.userId ==
                                                              vendorId,
                                                        );
                                                    setState(() {
                                                      selectedVendorId =
                                                          vendorId;
                                                      selectedDesigner =
                                                          vendor.businessName;
                                                    });
                                                    await _fetchSkillOfVendor(
                                                      selectedSkillId!,
                                                      vendorId,
                                                    );

                                                    await _fetchAddOn();
                                                  }
                                                },
                                        ),
                                      ),
                                if (selectedSkillId == null &&
                                    widget.designer == null)
                                  Padding(
                                    padding: EdgeInsets.only(top: 4.h),
                                    child: Text(
                                      'Please select a service first',
                                      style: TextStyle(
                                        fontSize: 12.h,
                                        color: Colors.red,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            // Due Date
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
                                final DateTime? pickedDate =
                                    await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(
                                        Duration(days: 365),
                                      ),
                                    );

                                if (pickedDate != null) {
                                  final int?
                                  selectedHour = await showDialog<int>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 8.h,
                                                          horizontal: 12.w,
                                                        ),
                                                    child: Text(
                                                      'AM',
                                                      style: TextStyle(
                                                        fontSize: 16.h,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors
                                                            .buttonGreen,
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
                                                              color: Colors
                                                                  .grey[300]!,
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
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
                                                                    FontWeight
                                                                        .w500,
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 8.h,
                                                          horizontal: 12.w,
                                                        ),
                                                    child: Text(
                                                      'PM',
                                                      style: TextStyle(
                                                        fontSize: 16.h,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.orange[700],
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
                                                              color: Colors
                                                                  .grey[300]!,
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
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
                                                                    FontWeight
                                                                        .w500,
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
                                  vertical: 10.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                    Icon(
                                      Icons.calendar_today,
                                      size: 18.h,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Further Guidelines
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
                                  height: 1.4,
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

                            // Project Selection
                            SizedBox(height: 10.h),
                            Text(
                              'Belongs to the project',
                              style: TextStyle(
                                fontSize: 14.h,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                underline: SizedBox(),
                                hint: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 4.h,
                                      ),

                                      child: Text(
                                        selectedProject != null
                                            ? selectedProject!.name
                                            : 'Create new project',
                                        style: TextStyle(
                                          color: selectedProject != null
                                              ? Colors.black87
                                              : Colors.black54,
                                          fontSize: 14.h,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                style: TextStyle(
                                  fontSize: 14.h,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                                menuMaxHeight: 300.h,
                                items: [
                                  DropdownMenuItem<String>(
                                    value: "create_new",
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[50],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.add_circle_outline,
                                            color: Colors.black,
                                            size: 20.h,
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            'Create new project',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ...projects.map(
                                    (project) => DropdownMenuItem<String>(
                                      value: project.id.toString(),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 30.w,
                                            height: 30.h,
                                            margin: EdgeInsets.only(right: 8.w),

                                            child: Image.asset(
                                              AppImages.FolderIcon,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Text(
                                            project.name,
                                            style: TextStyle(
                                              fontSize: 14.h,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value == "create_new") {
                                    showDialog(
                                      context: context,
                                      builder: (context) => CreateNewProject(
                                        onProjectCreated: _refreshProjects,
                                      ),
                                    );
                                  } else {
                                    setState(() {
                                      selectedProject = projects.firstWhere(
                                        (project) =>
                                            project.id.toString() == value,
                                      );
                                    });
                                  }
                                },
                              ),
                            ),

                            SizedBox(height: 16.h),
                            addOns.isEmpty
                                ? SizedBox.shrink()
                                : Column(
                                    children: [
                                      Text(
                                        'Add - ons',
                                        style: TextStyle(
                                          fontSize: 16.h,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      ...addOns.map((addon) {
                                        return Container(
                                          margin: EdgeInsets.only(bottom: 8.h),
                                          padding: EdgeInsets.only(
                                            left: 2.w,
                                            top: 5.h,
                                            bottom: 5.h,
                                            right: 12.w,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey[400]!,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                value: selectedAddOns.contains(
                                                  addon,
                                                ),
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    if (value == true) {
                                                      selectedAddOns.add(addon);
                                                      print(
                                                        "Added addon: ${addon.userAddonsId}",
                                                      );
                                                    } else {
                                                      selectedAddOns.remove(
                                                        addon,
                                                      );
                                                    }
                                                  });
                                                },
                                              ),
                                              SizedBox(width: 2.w),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      addon.name,
                                                      style: TextStyle(
                                                        fontSize: 14.h,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black87,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 8.w),
                                              Text(
                                                '+\$${_formatPrice(addon.cost)}',
                                                style: TextStyle(
                                                  fontSize: 14.h,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ],
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
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
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
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
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

                            // VIDEO SETTINGS - Only show for PROPERTY VIDEOS SERVICES
                            if (selectedSkillOfVendor?.skillCategory ==
                                'PROPERTY_VIDEOS_SERVICES') ...[
                              SizedBox(height: 16.h),
                              VideoSettingsWidget(
                                settings: _videoSettings,
                                onChanged: (settings) {
                                  setState(() {
                                    _videoSettings = settings;
                                  });
                                },
                              ),
                              SizedBox(height: 16.h),
                              OrientationWidget(
                                selectedOrientation: _videoSettings.orientation,
                                onChanged: (orientation) {
                                  setState(() {
                                    _videoSettings.orientation = orientation;
                                  });
                                },
                              ),
                            ],

                            // Total Section
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
                                      Text(
                                        'Total',
                                        style: TextStyle(
                                          fontSize: 14.h,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '\$${_formatPrice(totalPrice)}',
                                        style: TextStyle(
                                          fontSize: 16.h,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Qty: ',
                                        style: TextStyle(
                                          fontSize: 14.h,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      InkWell(
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.black54,
                                          size: 20.h,
                                        ),
                                        onTap: () {
                                          if (_quantity > 1) {
                                            setState(() {
                                              _quantity--;
                                            });
                                          }
                                        },
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        '$_quantity',
                                        style: TextStyle(
                                          fontSize: 14.h,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      InkWell(
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.black54,
                                          size: 20.h,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _quantity++;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (_checkOrderDetails()) {
                                            _addToCart(false);
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.w,
                                            vertical: 8.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.orangeAccent,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (_checkOrderDetails()) {
                                            _addToCart(true);
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.w,
                                            vertical: 8.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.buttonGreen,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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
                if (projectProvider.loading || skillProvider.isLoading)
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black26,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.buttonGreen,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
