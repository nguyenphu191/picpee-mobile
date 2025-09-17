import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/widgets/profile_header.dart';
import 'package:picpee_mobile/widgets/sidebar.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
                top: 80.h,
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
                            width: 1.8,
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
                          // Handle delete account action
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 8.h,
                            horizontal: 12.w,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.red),
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
                    height: MediaQuery.of(context).size.height * 0.7,
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
          Text(
            'Avatar',
            style: TextStyle(
              fontSize: 14.h,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),

          Row(
            children: [
              Container(
                height: 60.h,
                width: 60.h,
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.circular(50),
                ),

                child: Center(
                  child: Text(
                    'L',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.h,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Text(
                          'Upload new image',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12.h,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'At least 800x800 px recommended.\nJPG or PNG and GIF is allowed',
                    style: TextStyle(fontSize: 11.h, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
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

          _buildTextField('First name', _firstNameController),
          SizedBox(height: 16.h),
          _buildTextField('Last name', _lastNameController),
          SizedBox(height: 16.h),
          _buildTextField('Business name', _businessNameController),
          SizedBox(height: 16.h),
          _buildTextField(
            'Which best describes your company?',
            _companyDescriptionController,
          ),
          SizedBox(height: 16.h),
          _buildTextField('What\'s your team size?', _teamSizeController),
          SizedBox(height: 16.h),
          _buildTextField('Primary business email', _emailController),
          SizedBox(height: 16.h),

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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 8.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 20.w,
                        height: 14.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Image.asset(
                          'assets/images/us_flag.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.blue,
                                child: Center(
                                  child: Text(
                                    'US',
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.keyboard_arrow_down, size: 16.h),
                    ],
                  ),
                ),
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
          SizedBox(height: 16),

          _buildDropdownField('Country', _selectedCountry, [
            'American',
            'Canadian',
            'British',
          ]),
          SizedBox(height: 16.h),

          _buildDropdownField('Timezone', _selectedTimezone, [
            'America/Adak',
            'America/New_York',
            'America/Chicago',
          ]),
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
          _buildPasswordField(
            'Password',
            _oldPasswordController,
            _isOldPasswordVisible,
            () =>
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
          _buildPasswordField(
            'New Password',
            _newPasswordController,
            _isNewPasswordVisible,
            () =>
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
          _buildPasswordField(
            'Confirm New Password',
            _confirmPasswordController,
            _isConfirmPasswordVisible,
            () => setState(
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.h,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 5.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey, width: 1.5),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 8.h,
                vertical: 8.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    String hint,
    TextEditingController controller,
    bool isVisible,
    VoidCallback toggleVisibility,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.grey[400],
            size: 20,
          ),
          suffixIcon: IconButton(
            onPressed: toggleVisibility,
            icon: Icon(
              isVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.grey[400],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.h, color: Colors.black),
        ),
        SizedBox(height: 5.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey, width: 1.5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down),
              items: items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  if (label == 'Country') {
                    _selectedCountry = newValue!;
                  } else {
                    _selectedTimezone = newValue!;
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
