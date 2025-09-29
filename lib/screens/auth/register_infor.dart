import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:country_picker/country_picker.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class RegisterInforScreen extends StatefulWidget {
  const RegisterInforScreen({
    super.key,
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  State<RegisterInforScreen> createState() => _RegisterInforScreenState();
}

class _RegisterInforScreenState extends State<RegisterInforScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedCountry = 'Afghanistan';
  String? _selectedTimezone;

  bool _agreeToTerms = false;
  bool _optInNews = false;

  final List<String> _companyTypes = [
    'Startup',
    'Small Business',
    'Enterprise',
    'Agency',
    'Freelancer',
  ];

  final List<String> _countries = [
    'British, UK',
    'United States',
    'Vietnam',
    'Afghanistan',
    'Canada',
  ];

  List<String> _timezones = [];

  // Add this map to your class for flag emoji mapping
  Map<String, String> countryToEmoji = {
    'Afghanistan': '🇦🇫',
    'United Kingdom': '🇬🇧',
    'United States': '🇺🇸',
    'Vietnam': '🇻🇳',
    'Canada': '🇨🇦',
    // Add more countries as needed
  };

  // Add this map for country codes
  Map<String, String> countryToDial = {
    'Afghanistan': '+93',
    'United Kingdom': '+44',
    'United States': '+1',
    'Vietnam': '+84',
    'Canada': '+1',
    // Add more as needed
  };

  @override
  void initState() {
    super.initState();
    // Initialize timezone database
    tz_data.initializeTimeZones();
    _loadTimezones();
  }

  // Load all available timezones
  void _loadTimezones() {
    // Get all timezone locations
    _timezones = tz.timeZoneDatabase.locations.keys.toList();
    _timezones.sort(); // Sort alphabetically

    // Set default timezone based on selected country or use a default
    setState(() {
      _selectedTimezone = _getDefaultTimezoneForCountry(
        _selectedCountry ?? 'Afghanistan',
      );
    });
  }

  // Helper function to get appropriate timezone for a country
  String _getDefaultTimezoneForCountry(String country) {
    // Map countries to their common timezones
    Map<String, String> countryToTimezone = {
      'Afghanistan': 'Asia/Kabul',
      'British, UK': 'Europe/London',
      'United States': 'America/New_York',
      'Vietnam': 'Asia/Ho_Chi_Minh',
      'Canada': 'America/Toronto',
      // Add more as needed
    };

    return countryToTimezone[country] ?? 'UTC';
  }

  // Update timezone when country changes
  void _updateTimezoneForCountry(String? country) {
    if (country != null) {
      setState(() {
        _selectedTimezone = _getDefaultTimezoneForCountry(country);
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _businessNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      // Xử lý đăng ký
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đăng ký thành công!')));
    } else if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đồng ý với điều khoản dịch vụ')),
      );
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
        child: Form(
          key: _formKey,
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

              // Business name
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
              // Email and Phone
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
                      hintStyle: TextStyle(
                        fontSize: 14.h,
                        color: Colors.black87,
                      ),
                      hintText: 'henryjackson8000@gmail.com',
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
                  Text('Phone number', style: TextStyle(fontSize: 14.h)),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            showPhoneCode: false,
                            onSelect: (Country country) {
                              setState(() {
                                _selectedCountry = country.name;
                                _phoneController.text =
                                    '+${country.countryCode}'; // Clear phone input
                              });
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1.5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Text(
                                countryToEmoji[_selectedCountry!] ?? '🌐',
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

                      // Phone number input field
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: '(xxx) xxx-xxxx',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            // Show the country code as a prefix
                            prefixText: _selectedCountry != null
                                ? '${countryToDial[_selectedCountry!]} '
                                : '',
                            prefixStyle: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // Remove any country code the user might try to enter manually
                          onChanged: (value) {
                            if (value.startsWith('+')) {
                              final parts = value.split(' ');
                              if (parts.length > 1) {
                                _phoneController.text = parts
                                    .sublist(1)
                                    .join(' ');
                                _phoneController.selection =
                                    TextSelection.fromPosition(
                                      TextPosition(
                                        offset: _phoneController.text.length,
                                      ),
                                    );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              // Country
              Text('Country', style: TextStyle(fontSize: 14.h)),
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                items: _countries.map((country) {
                  return DropdownMenuItem(value: country, child: Text(country));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value;

                    // Update timezone when country changes
                    _updateTimezoneForCountry(value);
                  });
                },
              ),
              const SizedBox(height: 20),

              // Timezone
              const Text('Timezone', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  // Show a dialog with search functionality
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
                              height: 400,
                              child: Column(
                                children: [
                                  // Search field
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Search timezones...',
                                      prefixIcon: Icon(Icons.search),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
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

                                  // Timezone list
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: filteredTimezones.length,
                                      itemBuilder: (context, index) {
                                        final timezone =
                                            filteredTimezones[index];
                                        return ListTile(
                                          title: Text(timezone),
                                          selected:
                                              _selectedTimezone == timezone,
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
                      Text(_selectedTimezone ?? 'Select Timezone'),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Terms checkbox
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
                      text: const TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        children: [
                          TextSpan(text: 'I agree to the '),
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(text: ' for customers.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // News checkbox
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
                  const Expanded(
                    child: Text(
                      'Opt in to receive news and updates.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sign Up button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleSignUp,
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
            ],
          ),
        ),
      ),
    );
  }
}
