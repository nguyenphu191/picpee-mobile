import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:country_picker/country_picker.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/screens/home/home_screen.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:picpee_mobile/providers/auth_provider.dart';

class RegisterInforScreen extends StatefulWidget {
  const RegisterInforScreen({
    super.key,
    required this.email,
    required this.password,
    this.isGoogleSignUp = false,
  });

  final String email;
  final String password;
  final bool isGoogleSignUp;

  @override
  State<RegisterInforScreen> createState() => _RegisterInforScreenState();
}

class _RegisterInforScreenState extends State<RegisterInforScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _phoneController = TextEditingController();

  Country? _selectedCountry;
  String? _selectedTimezone;

  bool _agreeToTerms = false;
  bool _optInNews = false;

  List<String> _timezones = [];

  @override
  void initState() {
    super.initState();
    tz_data.initializeTimeZones();
    _loadTimezones();
  }

  void _loadTimezones() {
    _timezones = tz.timeZoneDatabase.locations.keys.toList();
    _timezones.sort();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _businessNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _businessNameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _selectedCountry == null ||
        _selectedTimezone == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You must agree to the Terms of Service.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final noExistBusiness = await authProvider.checkExistBusinessName(
        _businessNameController.text,
      );
      if (noExistBusiness) {
        final String status = await authProvider.register(
          email: widget.email,
          password: widget.password,
          firstname: _firstNameController.text,
          lastname: _lastNameController.text,
          businessName: _businessNameController.text,
          phone: _phoneController.text,
          country: _selectedCountry!.name,
          timezone: _selectedTimezone!,
          isReceiveNews: _optInNews,
          isTermService: _agreeToTerms,
          phoneCode: _selectedCountry!.phoneCode,
          countryCode: _selectedCountry!.countryCode,
        );
        if (mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        if (status == "200") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration failed with status code: $status'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        if (mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Business name already exists. Please choose another.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Hi Customers,',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.h,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Let's start with some information about your business",
              style: TextStyle(fontSize: 14.h, color: Colors.black54),
            ),
            SizedBox(height: 16.h),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('First name', style: TextStyle(fontSize: 14.h)),
                TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    hintText: 'Input your first name',
                    hintStyle: TextStyle(fontSize: 14.h, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.h,
                      vertical: 8.h,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Last name', style: TextStyle(fontSize: 14.h)),
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    hintText: 'Input your last name',
                    hintStyle: TextStyle(fontSize: 14.h, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.h,
                      vertical: 8.h,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            Text('Business name', style: TextStyle(fontSize: 14.h)),
            TextField(
              controller: _businessNameController,
              decoration: InputDecoration(
                hintText: 'Input your business name',
                hintStyle: TextStyle(fontSize: 14.h, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey, width: 1.5),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.h,
                  vertical: 8.h,
                ),
              ),
            ),
            SizedBox(height: 10.h),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Primary business email',
                  style: TextStyle(fontSize: 14.h),
                ),
                TextField(
                  controller: TextEditingController(text: widget.email),
                  keyboardType: TextInputType.emailAddress,
                  readOnly: true,
                  enabled: false,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 14.h, color: Colors.black87),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

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
                                _selectedCountry = country;
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
                                _selectedCountry?.flagEmoji ?? '🌐',
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
            SizedBox(height: 10.h),

            Text('Country', style: TextStyle(fontSize: 14.h)),
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
                      _selectedCountry = country;
                    });
                  },
                );
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCountry?.name ?? 'Select Country',
                      style: TextStyle(fontSize: 14.h),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),

            Text('Timezone', style: TextStyle(fontSize: 14.h)),
            GestureDetector(
              onTap: () async {
                final selectedValue = await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    String searchQuery = '';
                    List<String> filteredTimezones = List.from(_timezones);

                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: Text('Select Timezone'),
                          content: Container(
                            width: double.maxFinite,
                            height: 500,
                            child: Column(
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search timezones...',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14.h,
                                    ),
                                    prefixIcon: Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      searchQuery = value.toLowerCase();
                                      filteredTimezones = _timezones
                                          .where(
                                            (tz) => tz.toLowerCase().contains(
                                              searchQuery,
                                            ),
                                          )
                                          .toList();
                                    });
                                  },
                                ),
                                SizedBox(height: 10),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: filteredTimezones.length,
                                    itemBuilder: (context, index) {
                                      final timezone = filteredTimezones[index];
                                      return ListTile(
                                        title: Text(timezone),
                                        selected: _selectedTimezone == timezone,
                                        onTap: () {
                                          Navigator.of(context).pop(timezone);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Cancel'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );

                if (selectedValue != null) {
                  setState(() {
                    _selectedTimezone = selectedValue;
                  });
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedTimezone ?? 'Select Timezone',
                      style: TextStyle(fontSize: 14.h),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),

            Row(
              children: [
                Checkbox(
                  value: _agreeToTerms,
                  onChanged: (value) {
                    setState(() {
                      _agreeToTerms = value ?? false;
                    });
                  },
                  activeColor: Colors.green,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 14.h),
                      children: [
                        TextSpan(text: 'I agree to the '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            color: AppColors.linkBlue,
                            decoration: TextDecoration.none,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchURL('https://www.picpee.com/terms');
                            },
                        ),
                        TextSpan(text: ' for customers.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Checkbox(
                  value: _optInNews,
                  onChanged: (value) {
                    setState(() {
                      _optInNews = value ?? false;
                    });
                  },
                  activeColor: Colors.green,
                ),
                Expanded(
                  child: Text(
                    'Opt in to receive news and updates.',
                    style: TextStyle(fontSize: 14.h),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  _handleSignUp();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FF00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
