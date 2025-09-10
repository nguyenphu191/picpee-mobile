import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isOtpSent = false;
  bool isPasswordReset = false;

  @override
  void dispose() {
    emailController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!isOtpSent && emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!isOtpSent && emailController.text.isNotEmpty) {
      // Simulate sending OTP
      setState(() {
        isOtpSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP sent to your email'),
          backgroundColor: Colors.green,
        ),
      );
      return;
    }

    if (isOtpSent && !isPasswordReset && otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the OTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (isOtpSent && !isPasswordReset && otpController.text.isNotEmpty) {
      // Simulate OTP verification
      setState(() {
        isPasswordReset = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP verified. Please set a new password.'),
          backgroundColor: Colors.green,
        ),
      );
      return;
    }

    if (isPasswordReset) {
      if (newPasswordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please enter both new password and confirm password',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (newPasswordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Simulate password reset
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Return to login screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(gradient: AppColors.bgGradient),
        child: Container(
          height: size.height,
          width: size.width,
          margin: EdgeInsets.all(20.r),
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 24.h,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Back to Login',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.h,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 100.h),
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28.r,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    isPasswordReset
                        ? 'Enter your new password and confirm it.'
                        : isOtpSent
                        ? 'Enter the OTP sent to your email.'
                        : 'Enter your email address, and we will send you an OTP code to reset your password.',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 30.h),

                  // Input Field
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      isPasswordReset
                          ? 'New Password'
                          : isOtpSent
                          ? 'OTP'
                          : 'Email',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  TextField(
                    controller: isPasswordReset
                        ? newPasswordController
                        : isOtpSent
                        ? otpController
                        : emailController,
                    obscureText: isPasswordReset,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: isPasswordReset
                          ? 'Input new password'
                          : isOtpSent
                          ? 'Input OTP'
                          : 'Input your email',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                  if (isPasswordReset) ...[
                    SizedBox(height: 16.h),
                    // Confirm Password Field
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Confirm Password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: 'Confirm new password',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 30.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonGreen,
                        shape: const RoundedRectangleBorder(),
                      ),
                      onPressed: _handleSubmit,
                      child: Text(
                        isPasswordReset
                            ? 'Reset Password'
                            : isOtpSent
                            ? 'Verify OTP'
                            : 'Send OTP',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 18.h,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
