import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/models/user_model.dart';
import 'package:picpee_mobile/providers/auth_provider.dart';
import 'package:picpee_mobile/providers/upload_provider.dart';
import 'package:picpee_mobile/providers/user_provider.dart';
import 'package:picpee_mobile/widgets/profile_header.dart';
import 'package:picpee_mobile/widgets/sidebar.dart';
import 'package:provider/provider.dart';
import 'profile_widget/avatar_section_widget.dart';
import 'profile_widget/custom_text_field.dart';
import 'profile_widget/password_field_widget.dart';
import 'profile_widget/image_picker_options_dialog.dart';
import 'profile_widget/delete_account_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ImagePicker _picker = ImagePicker();

  // Country objects for different purposes
  Country? selectedPhoneCountry;
  Country? selectedCountry;
  Country? selectedTimezoneCountry;

  // Avatar image
  File? _avatarImage;
  String? _uploadedAvatarUrl;
  // Form controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _companyDescriptionController = TextEditingController();
  final _teamSizeController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Password controllers
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Password visibility
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    setData();
  }

  void setData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    User user = userProvider.user!;

    setState(() {
      _firstNameController.text = user.firstname ?? '';
      _lastNameController.text = user.lastname ?? '';
      _businessNameController.text = user.businessName ?? '';
      _companyDescriptionController.text = user.descriptionCompany ?? '';
      _teamSizeController.text = (user.teamSize ?? 0).toString();
      _emailController.text = user.email ?? '';
      _phoneController.text = user.phone ?? '';

      // Set phone country from countryCode
      if (user.phoneCode != null && user.phoneCode!.isNotEmpty) {
        try {
          selectedPhoneCountry = Country.tryParse(user.phoneCode!);
        } catch (e) {
          selectedPhoneCountry = null;
        }
      }

      // Set country from countryName
      if (user.countryName != null && user.countryName!.isNotEmpty) {
        try {
          selectedCountry = Country.tryParse(user.countryName!);
        } catch (e) {
          selectedCountry = null;
        }
      }

      // Set timezone country from timezone string
      if (user.timezone != null && user.timezone!.isNotEmpty) {
        try {
          selectedTimezoneCountry = Country.tryParse(user.timezone!);
        } catch (e) {
          selectedTimezoneCountry = null;
        }
      }
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

  // Pick image from camera or gallery and upload
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

        // Upload avatar immediately after selection
        await _uploadAvatar();
      }
    } catch (e) {
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

  Future<void> _uploadAvatar() async {
    if (_avatarImage == null) return;

    final uploadProvider = Provider.of<UploadProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      // Upload file and get URL
      final avatarUrl = await uploadProvider.uploadAvatar(
        file: _avatarImage!,
        token: authProvider.token,
      );

      if (avatarUrl != null) {
        setState(() {
          _uploadedAvatarUrl = avatarUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture uploaded successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      } else {
        // Show error from provider if available
        final error = uploadProvider.errorMessage ?? 'Failed to upload avatar';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload error: $e'),
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
      _uploadedAvatarUrl = null;
    });
  }

  Future<void> updateProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userdata = userProvider.user?.updateJson();
    if (userdata == null) return;
    userdata['firstname'] = _firstNameController.text;
    userdata['lastname'] = _lastNameController.text;
    userdata['businessName'] = _businessNameController.text;
    userdata['descriptionCompany'] = _companyDescriptionController.text;
    userdata['teamSize'] = int.tryParse(_teamSizeController.text) ?? 0;
    userdata['username'] = _emailController.text;
    userdata['phone'] = _phoneController.text;
    if (_uploadedAvatarUrl != null) {
      userdata['avatar'] = _uploadedAvatarUrl;
    }
    if (selectedPhoneCountry != null) {
      userdata['phoneCode'] = selectedPhoneCountry!.countryCode;
    }
    if (selectedCountry != null) {
      userdata['countryName'] = selectedCountry!.name;
      userdata['countryCode'] = selectedCountry!.countryCode;
    }
    if (selectedTimezoneCountry != null) {
      userdata['timezone'] = selectedTimezoneCountry!.countryCode;
    }
    try {
      bool success = await userProvider.updateUserProfile(
        userProvider.user!.id!,
        userdata,
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;
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
                  padding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 12.w,
                  ),
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
                                border: Border.all(
                                  color: Colors.red,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 20.h,
                                  ),
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
                          children: [
                            _buildProfileTab(user!),
                            _buildPasswordTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(top: 0, left: 0, right: 0, child: ProfileHeader()),
              if (userProvider.isLoading)
                Container(
                  height: size.height,
                  width: size.width,
                  color: Colors.black.withOpacity(0.3),
                ),
              if (userProvider.isLoading)
                Center(
                  child: Container(
                    padding: EdgeInsets.all(20.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10.r,
                          offset: Offset(0, 5.h),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: AppColors.buttonGreen),
                        SizedBox(height: 8.h),
                        Text(
                          "Loading...",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileTab(User user) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar Section
          AvatarSectionWidget(
            avatar: _uploadedAvatarUrl ?? user.avatar ?? '',
            avatarImage: _avatarImage,
            onImagePickerTap: _showImagePickerOptions,
            name: user.businessName ?? "",
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

          // Phone number with country picker
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
                              selectedPhoneCountry = country;
                              // Option: auto-fill phone code
                              // _phoneController.text = '+${country.phoneCode}';
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
                              selectedPhoneCountry?.flagEmoji ?? '🌐',
                              style: TextStyle(fontSize: 20.h),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              selectedPhoneCountry != null
                                  ? '+${selectedPhoneCountry!.phoneCode}'
                                  : '',
                              style: TextStyle(
                                fontSize: 14.h,
                                color: Colors.black87,
                              ),
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
                          hintText: 'Phone number',
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
          SizedBox(height: 16.h),

          // Country picker
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Country',
                style: TextStyle(
                  fontSize: 14.h,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              InkWell(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: false,
                    countryListTheme: CountryListThemeData(
                      bottomSheetHeight: 500,
                    ),
                    onSelect: (Country country) {
                      setState(() {
                        selectedCountry = country;
                      });
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey, width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            selectedCountry?.flagEmoji ?? '🌐',
                            style: TextStyle(fontSize: 20.h),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            selectedCountry?.name ?? 'Select country',
                            style: TextStyle(
                              fontSize: 14.h,
                              color: selectedCountry != null
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Timezone picker (stored as countryCode, displayed as timezone)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Timezone',
                style: TextStyle(
                  fontSize: 14.h,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              InkWell(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: false,
                    countryListTheme: CountryListThemeData(
                      bottomSheetHeight: 500,
                    ),
                    onSelect: (Country country) {
                      setState(() {
                        selectedTimezoneCountry = country;
                      });
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey, width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            selectedTimezoneCountry?.flagEmoji ?? '🌐',
                            style: TextStyle(fontSize: 20.h),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            selectedTimezoneCountry != null
                                ? '${selectedTimezoneCountry!.name} (${selectedTimezoneCountry!.countryCode})'
                                : 'Select timezone',
                            style: TextStyle(
                              fontSize: 14.h,
                              color: selectedTimezoneCountry != null
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 32.h),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    updateProfile();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonGreen,
                    foregroundColor: Colors.black,
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
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Changes cancelled'),
                        backgroundColor: Colors.grey,
                      ),
                    );
                  },
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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 126.w,
                child: ElevatedButton(
                  onPressed: () {
                    String oldPassword = _oldPasswordController.text;
                    String newPassword = _newPasswordController.text;
                    String confirmPassword = _confirmPasswordController.text;

                    if (oldPassword.isEmpty ||
                        newPassword.isEmpty ||
                        confirmPassword.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill all fields'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (newPassword != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Passwords do not match'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (newPassword.length < 8) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Password must be at least 8 characters',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Password changed successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
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
                  onPressed: () {
                    _oldPasswordController.clear();
                    _newPasswordController.clear();
                    _confirmPasswordController.clear();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Changes cancelled'),
                        backgroundColor: Colors.grey,
                      ),
                    );
                  },
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

  void _showDeleteAccountDialog() {
    DeleteAccountDialog.show(
      context: context,
      onConfirmDelete: () {
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
