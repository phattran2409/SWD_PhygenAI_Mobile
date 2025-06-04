import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  // Variable to toggle password visibility
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is AuthSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sign up successful!'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate to login or home page
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        builder: (context, state) {
          return Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE8D5FF), // Light purple
                  Color(0xFFC8A8FF), // Medium purple
                  Color(0xFF9C64FF), // Darker purple
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      SizedBox(height: 40.h),
                      // Back button
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      // Main content card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(32.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Title
                            Text(
                              'SIGN UP',
                              style: TextStyle(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF7B3AE8),
                                letterSpacing: 2,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'FOR YOUR ACCOUNT',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: const Color(0xFF7B3AE8),
                                letterSpacing: 1.5,
                              ),
                            ),
                            SizedBox(height: 40.h),

                            // Username field
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(76, 60, 60, 60),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: TextField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  hintText: 'username',
                                  hintStyle: TextStyle(
                                    color: const Color.fromARGB(255, 111, 111, 111).withOpacity(0.8),
                                    fontSize: 12.sp,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: const Color.fromARGB(
                                      255,
                                      255,
                                      255,
                                      255,
                                    ).withOpacity(0.8),
                                    size: 24.w,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 16.h,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 50, 50, 50),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),

                            // Email field
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(76, 60, 60, 60),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: 'someone@gmail.com',
                                  hintStyle: TextStyle(
                                    color: const Color.fromARGB(255, 111, 111, 111).withOpacity(0.8),
                                    fontSize: 12.sp,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.white.withOpacity(0.8),
                                    size: 24.w,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 16.h,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 50, 50, 50),
                                  fontSize: 16,
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            SizedBox(height: 20.h),

                            // Password field
                            Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(76, 60, 60, 60),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  hintText: 'Your Password',
                                  hintStyle: TextStyle(
                                    color:const Color.fromARGB(255, 111, 111, 111).withOpacity(0.8),
                                    fontSize: 12.sp,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.white.withOpacity(0.8),
                                    size: 24.w,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white.withOpacity(0.8),
                                      size: 24.w,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 16.h,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 50, 50, 50),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            // Confirm Password field
                            Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(76, 60, 60, 60),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: TextField(
                                controller: _confirmPasswordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  hintText: 'Confirm Password',
                                  hintStyle: TextStyle(
                                    color: const Color.fromARGB(255, 111, 111, 111).withOpacity(0.8),
                                    fontSize: 12.sp,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.white.withOpacity(0.8),
                                    size: 24.w,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white.withOpacity(0.8),
                                      size: 24.w,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 16.h,
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 50, 50, 50),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(height: 30.h),
                            // Sign up button
                            state is AuthLoadingState
                                ? const CircularProgressIndicator(
                                  color: Color(0xFF7B3AE8),
                                )
                                : SizedBox(
                                  width: double.infinity,
                                  height: 40.h,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_validateForm()) {
                                        context.read<AuthBloc>().add(
                                          AuthSignupEvent(
                                            email: _emailController.text.trim(),
                                            password: _passwordController.text,
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF7B3AE8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          25.r,
                                        ),
                                      ),
                                      elevation: 5,
                                    ),
                                    child: Text(
                                      'SIGN UP',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                            SizedBox(height: 24.h),

                            // Sign in option
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14.sp,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/login',
                                    );
                                  },
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: const Color(0xFF7B3AE8),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool _validateForm() {
    if (_usernameController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter a username');
      return false;
    }
    if (_emailController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter an email');
      return false;
    }
    if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(_emailController.text.trim())) {
      _showErrorSnackBar('Please enter a valid email');
      return false;
    }
    if (_passwordController.text.isEmpty) {
      _showErrorSnackBar('Please enter a password');
      return false;
    }
    if (_passwordController.text.length < 6) {
      _showErrorSnackBar('Password must be at least 6 characters');
      return false;
    }
    if (_confirmPasswordController.text.isEmpty) {
      _showErrorSnackBar('Please confirm your password');
      return false;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorSnackBar('Passwords do not match');
      return false;
    }
    return true;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
