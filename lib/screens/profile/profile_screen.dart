import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/widgets/profile_header.dart';
import 'package:picpee_mobile/widgets/sidebar.dart';
import 'profile_widget/avatar_section_widget.dart';
import 'profile_widget/custom_text_field.dart';
import 'profile_widget/password_field_widget.dart';
import 'profile_widget/custom_dropdown_field.dart';
import 'profile_widget/image_picker_options_dialog.dart';
import 'profile_widget/delete_account_dialog.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ImagePicker _picker = ImagePicker();
  Country? selectedCountry;

  // Avatar image
  File? _avatarImage;
  String _avatarInitial = 'L'; // Default initial

  // Form controllers
  final _firstNameController = TextEditingController(text: 'Lucas');
  final _lastNameController = TextEditingController(text: 'Taylor');
  final _businessNameController = TextEditingController(text: 'Lucas Taylor');
  final _companyDescriptionController = TextEditingController();
  final _teamSizeController = TextEditingController(text: '0');
  final _emailController = TextEditingController(
    text: 'lucastaylor23@gmail.com',
  );
  final _phoneController = TextEditingController(text: '547539853');

  // Password controllers
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Password visibility
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String _selectedCountry = 'American';
  String _selectedTimezone = 'America/Adak';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Listen to first name changes to update avatar initial
    _firstNameController.addListener(_updateAvatarInitial);
  }

  void _updateAvatarInitial() {
    setState(() {
      _avatarInitial = _firstNameController.text.isNotEmpty
          ? _firstNameController.text[0].toUpperCase()
          : 'L';
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _businessNameController.dispose();
    _companyDescriptionController.dispose();
    _teamSizeController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Show image picker options
  void _showImagePickerOptions() {
    ImagePickerOptionsDialog.show(
      context: context,
      currentAvatarImage: _avatarImage,
      onImageSourceSelected: _pickImage,
      onRemovePhoto: _removeAvatar,
    );
  }

  // Pick image from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _avatarImage = File(image.path);
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture updated successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to select image. Please try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  // Remove avatar
  void _removeAvatar() {
    setState(() {
      _avatarImage = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile picture removed'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFE8ECEF),
      drawer: const SideBar(selectedIndex: 1),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              margin: EdgeInsets.only(
                top: 95.h,
                left: 16.h,
                right: 16.h,
                bottom: 16.h,
              ),
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Tab Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.buttonGreen,
                            width: 1.5,
                          ),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey[600],
                        labelStyle: TextStyle(
                          fontSize: 14.h,
                          fontWeight: FontWeight.w500,
                        ),
                        tabs: [
                          Tab(
                            child: Container(
                              decoration: BoxDecoration(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person_outline, size: 20.h),
                                  SizedBox(width: 6.w),
                                  Text(
                                    "Profile",
                                    style: TextStyle(
                                      fontSize: 14.h,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.lock_outline, size: 20.h),
                                SizedBox(width: 6.w),
                                Text(
                                  "Password",
                                  style: TextStyle(
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // Delete account button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          _showDeleteAccountDialog();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 8.h,
                            horizontal: 12.w,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.red, width: 1.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.close, color: Colors.red, size: 20.h),
                              SizedBox(width: 6.w),
                              Text(
                                "Delete account",
                                style: TextStyle(
                                  fontSize: 14.h,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    height: MediaQuery.of(context).size.height - 285.h,
                    color: Colors.white,
                    child: TabBarView(
                      controller: _tabController,
                      children: [_buildProfileTab(), _buildPasswordTab()],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(top: 0, left: 0, right: 0, child: ProfileHeader()),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar Section
          AvatarSectionWidget(
            avatarImage: _avatarImage,
            avatarInitial: _avatarInitial,
            onImagePickerTap: _showImagePickerOptions,
          ),

          SizedBox(height: 32.h),

          Text(
            'General information',
            style: TextStyle(
              fontSize: 14.h,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16.h),

          CustomTextField(
            label: 'First name',
            controller: _firstNameController,
          ),
          SizedBox(height: 16.h),
          CustomTextField(label: 'Last name', controller: _lastNameController),
          SizedBox(height: 16.h),
          CustomTextField(
            label: 'Business name',
            controller: _businessNameController,
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            label: 'Which best describes your company?',
            controller: _companyDescriptionController,
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            label: 'What\'s your team size?',
            controller: _teamSizeController,
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            label: 'Primary business email',
            controller: _emailController,
          ),
          SizedBox(height: 16.h),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Phone number',
                style: TextStyle(fontSize: 14.h, color: Colors.black),
              ),
              SizedBox(height: 5.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey, width: 1.5),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: true,
                          countryListTheme: CountryListThemeData(
                            bottomSheetHeight: 500,
                          ),
                          onSelect: (Country country) {
                            setState(() {
                              selectedCountry = country;
                              _phoneController.text = '+${country.phoneCode}';
                            });
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Text(
                              selectedCountry?.flagEmoji ?? '🌐',
                              style: TextStyle(fontSize: 20.h),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 20.h,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          hintText: '+1 547539853',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          CustomDropdownField(
            label: 'Country',
            value: _selectedCountry,
            items: ['American', 'Canadian', 'British'],
            onChanged: (String? newValue) {
              setState(() {
                _selectedCountry = newValue!;
              });
            },
          ),
          SizedBox(height: 16.h),

          CustomDropdownField(
            label: 'Timezone',
            value: _selectedTimezone,
            items: ['America/Adak', 'America/New_York', 'America/Chicago'],
            onChanged: (String? newValue) {
              setState(() {
                _selectedTimezone = newValue!;
              });
            },
          ),
          SizedBox(height: 32.h),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: 16.w,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Save change',
                    style: TextStyle(
                      fontSize: 14.h,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!, width: 1.5),
                    padding: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: 16.w,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 14.h,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildPasswordTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password',
            style: TextStyle(
              fontSize: 14.h,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 24),

          Text(
            'Old password',
            style: TextStyle(
              fontSize: 14.h,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          PasswordFieldWidget(
            hint: 'Password',
            controller: _oldPasswordController,
            isVisible: _isOldPasswordVisible,
            toggleVisibility: () =>
                setState(() => _isOldPasswordVisible = !_isOldPasswordVisible),
          ),
          SizedBox(height: 16.h),

          Text(
            'New password',
            style: TextStyle(
              fontSize: 14.h,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          PasswordFieldWidget(
            hint: 'New Password',
            controller: _newPasswordController,
            isVisible: _isNewPasswordVisible,
            toggleVisibility: () =>
                setState(() => _isNewPasswordVisible = !_isNewPasswordVisible),
          ),
          SizedBox(height: 4),
          Text(
            'Minimum 8 characters',
            style: TextStyle(fontSize: 12.h, color: Colors.grey[600]),
          ),
          SizedBox(height: 16.h),

          // Confirm New Password
          Text(
            'Confirm new password',
            style: TextStyle(
              fontSize: 14.h,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          PasswordFieldWidget(
            hint: 'Confirm New Password',
            controller: _confirmPasswordController,
            isVisible: _isConfirmPasswordVisible,
            toggleVisibility: () => setState(
              () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Minimum 8 characters',
            style: TextStyle(fontSize: 12.h, color: Colors.grey[600]),
          ),
          SizedBox(height: 32.h),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 126.w,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonGreen,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: 8.w,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Save change',
                    style: TextStyle(
                      fontSize: 14.h,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                width: 126.w,
                color: Colors.grey[200],
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!, width: 1.5),
                    padding: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: 8.w,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14.h,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Show delete account confirmation dialog
  void _showDeleteAccountDialog() {
    DeleteAccountDialog.show(
      context: context,
      onConfirmDelete: () {
        // Handle delete account logic here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account deletion requested'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }
}
